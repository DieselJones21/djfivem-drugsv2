#!/usr/bin/env node
/**
 * Automated NUI tests using Playwright.
 * Run: npx playwright install chromium && node tests/ui_test.mjs
 */
import { chromium } from 'playwright';
import { createServer } from 'http';
import { readFileSync, statSync } from 'fs';
import { join, extname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = fileURLToPath(new URL('.', import.meta.url));
const ROOT = join(__dirname, '..');
const HTML_DIR = join(ROOT, 'html');

const MIME = { '.html': 'text/html', '.js': 'application/javascript', '.css': 'text/css' };

function startServer(port = 8765) {
    return new Promise((resolve) => {
        const server = createServer((req, res) => {
            let file = req.url === '/' ? '/test.html' : req.url.split('?')[0];
            const path = join(HTML_DIR, file.replace(/^\//, ''));
            try {
                const data = readFileSync(path);
                res.writeHead(200, { 'Content-Type': MIME[extname(path)] || 'text/plain' });
                res.end(data);
            } catch {
                res.writeHead(404);
                res.end('Not found');
            }
        });
        server.listen(port, () => resolve({ server, port }));
    });
}

let passed = 0;
let failed = 0;

function assert(cond, msg) {
    if (cond) {
        passed++;
        console.log(`  ✓ ${msg}`);
    } else {
        failed++;
        console.error(`  ✗ ${msg}`);
    }
}

async function main() {
    const { server, port } = await startServer();
    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();
    page.setDefaultTimeout(5000);

    console.log('\n=== NUI Automated Tests ===\n');

    await page.goto(`http://localhost:${port}/test.html`);
    await page.waitForTimeout(500);

    const frame = page.frameLocator('#nui');

    // Inject mocks into iframe
    await page.evaluate(() => {
        const f = document.getElementById('nui').contentWindow;
        f.GetParentResourceName = () => 'djfivem-drugsv2';
        f._nuiCalls = [];
        f.fetch = async (url, opts) => {
            f._nuiCalls.push({ url, body: JSON.parse(opts.body || '{}') });
            return { ok: true, json: async () => ({}) };
        };
    });

    const send = async (action, data) => {
        await page.evaluate(({ action, data }) => {
            document.getElementById('nui').contentWindow.postMessage({ action, data }, '*');
        }, { action, data });
        await page.waitForTimeout(150);
    };

    const mockBoard = {
        mine: { name: 'Alex Reyes', label: 'Vice Hustler', place: 3, sold: 412, earned: 185000, currentSold: 250, remaining: 388, nextLabel: 'Ocean Plug', nextSold: 800, maxed: false },
        top: [
            { place: 1, name: 'Carlos M.', label: '305 Kingpin', sold: 5200, earned: 2400000 },
            { place: 2, name: 'Maria S.', label: 'Neon Trap Star', sold: 3100, earned: 980000 },
        ],
        totalSellers: 2,
    };

    const mockBoost = {
        sell: { multiplier: 3, remaining: 1847 },
        harvest: { multiplier: 2, remaining: 900 },
    };

    const mockOffer = {
        label: '305 Heat', quantity: 3, priceEach: 720, total: 2160,
        minPrice: 550, maxPrice: 900, attempts: 0, maxAttempts: 2,
        haggleEnabled: true, boostMultiplier: 2,
    };

    // Leaderboard
    await send('openLeaderboard', mockBoard);
    assert(await frame.locator('#leaderboard').isVisible(), 'Leaderboard panel visible');
    assert((await frame.locator('#lb-player-name').textContent()) === 'Alex Reyes', 'Player name rendered');
    assert((await frame.locator('#lb-rank').textContent()) === '#3', 'Rank place rendered');
    assert(await frame.locator('.lb-row').count() === 2, 'Leaderboard rows rendered');
    const progressWidth = await frame.locator('#lb-progress-fill').evaluate(el => el.style.width);
    assert(parseFloat(progressWidth) > 0, 'Progress bar has width');

    // Empty leaderboard
    await send('openLeaderboard', { mine: mockBoard.mine, top: [], totalSellers: 0 });
    assert(await frame.locator('.empty-state').isVisible(), 'Empty state shown');

    // XSS escape
    await send('openLeaderboard', {
        mine: mockBoard.mine,
        top: [{ place: 1, name: '<script>alert(1)</script>', label: 'Test', sold: 1, earned: 100 }],
        totalSellers: 1,
    });
    const nameHtml = await frame.locator('.lb-name').innerHTML();
    assert(!nameHtml.includes('<script>'), 'Player names are HTML-escaped');

    // Boost panel
    await send('openBoost', mockBoost);
    assert(await frame.locator('#boost-panel').isVisible(), 'Boost panel visible');
    assert((await frame.locator('#boost-sell-mult').textContent()) === '3x', 'Sell boost multiplier shown');

    // Boost HUD
    await send('updateBoost', mockBoost);
    assert(await frame.locator('#boost-hud').isVisible(), 'Boost HUD visible when events active');
    assert(await frame.locator('#boost-sell-pill').isVisible(), 'Sell boost pill visible');

    // Boost HUD hidden when inactive
    await send('updateBoost', { sell: null, harvest: null });
    assert(await frame.locator('#boost-hud').isHidden(), 'Boost HUD hidden when no events');

    // Sell mini
    await send('openSell', mockOffer);
    assert(await frame.locator('#sell-mini').isVisible(), 'Sell mini visible');
    assert((await frame.locator('#sell-total').textContent()) === '$2,160', 'Sell total formatted correctly');
    assert(await frame.locator('#sell-haggle-soft').isVisible(), 'Haggle buttons visible');

    // Sell no haggle
    await send('openSell', { ...mockOffer, haggleEnabled: false });
    assert(await frame.locator('#sell-haggle-soft').isHidden(), 'Haggle hidden when disabled');

    // Accept button
    await page.evaluate(() => { document.getElementById('nui').contentWindow._nuiCalls = []; });
    await frame.locator('#sell-accept').click();
    await page.waitForTimeout(100);
    const calls = await page.evaluate(() => document.getElementById('nui').contentWindow._nuiCalls);
    assert(calls.some(c => c.url.includes('sellAction') && c.body.action === 'accept'), 'Accept posts sellAction callback');

    // Boost start
    await page.evaluate(() => { document.getElementById('nui').contentWindow._nuiCalls = []; });
    await send('openBoost', {});
    await frame.locator('.boost-card[data-kind="sell"][data-mult="3"]').click();
    await page.waitForTimeout(100);
    const boostCalls = await page.evaluate(() => document.getElementById('nui').contentWindow._nuiCalls);
    assert(boostCalls.some(c => c.url.includes('boostAction') && c.body.multiplier === 3), 'Boost start posts boostAction');

    // Duration selection
    await frame.locator('.duration-btn[data-seconds="7200"]').click();
    await page.evaluate(() => { document.getElementById('nui').contentWindow._nuiCalls = []; });
    await frame.locator('.boost-card[data-kind="harvest"][data-mult="2"]').click();
    await page.waitForTimeout(100);
    const durCalls = await page.evaluate(() => document.getElementById('nui').contentWindow._nuiCalls);
    assert(durCalls[0]?.body.duration === 7200, 'Selected duration sent with boost action');

    // Close button
    await send('openLeaderboard', mockBoard);
    await page.evaluate(() => { document.getElementById('nui').contentWindow._nuiCalls = []; });
    await frame.locator('[data-close]').first().click();
    await page.waitForTimeout(100);
    assert(await frame.locator('#leaderboard').isHidden(), 'Close button hides panel');
    const closeCalls = await page.evaluate(() => document.getElementById('nui').contentWindow._nuiCalls);
    assert(closeCalls.some(c => c.url.includes('close')), 'Close button posts close callback');

    // ESC closes panel
    await send('openBoost', {});
    await frame.locator('body').press('Escape');
    await page.waitForTimeout(100);
    assert(await frame.locator('#boost-panel').isHidden(), 'ESC closes boost panel');

    // ESC on sell mini declines
    await send('openSell', mockOffer);
    await page.evaluate(() => { document.getElementById('nui').contentWindow._nuiCalls = []; });
    await frame.locator('body').press('Escape');
    await page.waitForTimeout(100);
    assert(await frame.locator('#sell-mini').isHidden(), 'ESC closes sell mini');
    const escCalls = await page.evaluate(() => document.getElementById('nui').contentWindow._nuiCalls);
    assert(escCalls.some(c => c.body.action === 'decline'), 'ESC on sell mini posts decline');

    // closeAll no loop
    await page.evaluate(() => { document.getElementById('nui').contentWindow._nuiCalls = []; });
    await send('closeAll');
    await page.waitForTimeout(200);
    const loopCalls = await page.evaluate(() => document.getElementById('nui').contentWindow._nuiCalls);
    assert(loopCalls.filter(c => c.url.includes('close')).length === 0, 'closeAll does not post close callback (no loop)');

    // 4x both boost button exists
    await send('openBoost', {});
    assert(await frame.locator('.boost-card[data-kind="both"][data-mult="4"]').count() === 1, '4x both boost button exists');

    console.log(`\n=== Results: ${passed} passed, ${failed} failed ===\n`);

    await browser.close();
    server.close();
    process.exit(failed > 0 ? 1 : 0);
}

main().catch((err) => {
    console.error(err);
    process.exit(1);
});
