#!/usr/bin/env node
/**
 * Capture Rebel NUI screenshots for visual review.
 * Run: node tests/screenshot_ui.mjs
 */
import { chromium } from 'playwright';
import { createServer } from 'http';
import { readFileSync, mkdirSync } from 'fs';
import { join, extname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = fileURLToPath(new URL('.', import.meta.url));
const ROOT = join(__dirname, '..');
const HTML_DIR = join(ROOT, 'html');
const OUT_DIR = '/opt/cursor/artifacts/screenshots';

const MIME = {
    '.html': 'text/html',
    '.js': 'application/javascript',
    '.css': 'text/css',
    '.png': 'image/png',
};

function startServer(port = 8766) {
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

async function main() {
    mkdirSync(OUT_DIR, { recursive: true });
    const { server, port } = await startServer();
    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
    page.setDefaultTimeout(8000);

    await page.goto(`http://localhost:${port}/test.html`);
    await page.waitForTimeout(400);

    await page.evaluate(() => {
        const f = document.getElementById('nui').contentWindow;
        f.GetParentResourceName = () => 'djfivem-drugsv2';
        f.fetch = async () => ({ ok: true, json: async () => ({}) });
        document.getElementById('harness').style.display = 'none';
        document.getElementById('log').style.display = 'none';
        const iframe = document.getElementById('nui');
        iframe.style.top = '0';
        iframe.style.height = '100vh';
    });

    const send = async (action, data) => {
        await page.evaluate(({ action, data }) => {
            document.getElementById('nui').contentWindow.postMessage({ action, data }, '*');
        }, { action, data });
        await page.waitForTimeout(250);
    };

    const mockBoard = {
        mine: { name: 'Alex Reyes', label: 'Outlaw', place: 3, sold: 412, earned: 185000, currentSold: 250, remaining: 388, nextLabel: 'Road Captain', nextSold: 800, maxed: false },
        top: [
            { place: 1, name: 'Carlos M.', label: 'Rebel Kingpin', sold: 5200, earned: 2400000 },
            { place: 2, name: 'Maria S.', label: 'Shot Caller', sold: 3100, earned: 980000 },
            { place: 3, name: 'Alex Reyes', label: 'Outlaw', sold: 412, earned: 185000 },
        ],
        totalSellers: 3,
    };

    const mockBoost = {
        sell: { multiplier: 3, remaining: 1847 },
        harvest: { multiplier: 2, remaining: 900 },
    };

    const mockOffer = {
        label: 'Truck Juice', quantity: 3, priceEach: 720, total: 2160,
        minPrice: 550, maxPrice: 900, attempts: 0, maxAttempts: 2,
        haggleEnabled: true, boostMultiplier: 2,
    };

    await send('closeAll', {});
    await send('openLeaderboard', mockBoard);
    await page.screenshot({ path: join(OUT_DIR, 'rebel-leaderboard.png'), fullPage: false });

    await send('closeAll', {});
    await send('openBoost', mockBoost);
    await page.screenshot({ path: join(OUT_DIR, 'rebel-boost.png'), fullPage: false });

    await send('closeAll', {});
    await send('updateBoost', mockBoost);
    await send('openSell', mockOffer);
    await page.screenshot({ path: join(OUT_DIR, 'rebel-street-deal.png'), fullPage: false });

    await send('closeAll', {});
    await send('openLeaderboard', mockBoard);
    await send('updateBoost', mockBoost);
    await send('openSell', mockOffer);
    await page.screenshot({ path: join(OUT_DIR, 'rebel-all-layers.png'), fullPage: false });

    await browser.close();
    server.close();
    console.log('Wrote screenshots to', OUT_DIR);
}

main().catch((err) => {
    console.error(err);
    process.exit(1);
});
