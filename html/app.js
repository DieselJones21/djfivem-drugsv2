if (typeof GetParentResourceName !== 'function') {
    window.GetParentResourceName = () => 'djfivem-drugsv2';
}

const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => document.querySelectorAll(sel);

let selectedDuration = 1800;
let currentPanel = null;

function formatMoney(n) {
    return '$' + Math.floor(n || 0).toLocaleString('en-US');
}

function formatTime(seconds) {
    seconds = Math.max(0, seconds || 0);
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    if (m >= 60) {
        const h = Math.floor(m / 60);
        return `${h}h ${m % 60}m`;
    }
    return m > 0 ? `${m}m ${s}s` : `${s}s`;
}

function post(action, data = {}) {
    return fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    }).catch(() => {});
}

function escapeHtml(str) {
    return String(str ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function showPanel(id) {
    hideAllPanels();
    const el = $(`#${id}`);
    if (el) {
        el.classList.remove('hidden');
        currentPanel = id;
    }
}

function hideAllPanels() {
    $$('.panel').forEach((p) => p.classList.add('hidden'));
    currentPanel = null;
}

function closeUI(notifyLua = true) {
    hideAllPanels();
    $('#sell-mini').classList.add('hidden');
    if (notifyLua) {
        post('close');
    }
}

/* ── Leaderboard ── */
function renderLeaderboard(data) {
    if (!data) return;

    const me = data.mine || {};
    $('#lb-player-name').textContent = me.name || 'Player';
    $('#lb-player-rank').textContent = me.label || 'Street Runner';
    $('#lb-rank').textContent = me.place ? `#${me.place}` : '—';
    $('#lb-sold').textContent = (me.sold || 0).toLocaleString();
    $('#lb-earned').textContent = formatMoney(me.earned);

    if (me.maxed) {
        $('#lb-progress-label').textContent = 'Max rank — 305 Kingpin';
        $('#lb-progress-fill').style.width = '100%';
    } else if (me.nextSold != null && me.sold != null) {
        const prev = me.currentSold != null ? me.currentSold : 0;
        const span = me.nextSold - prev;
        const pct = span > 0 ? Math.min(100, ((me.sold - prev) / span) * 100) : 0;
        $('#lb-progress-label').textContent = `${(me.remaining || 0).toLocaleString()} more units to ${me.nextLabel || 'next rank'}`;
        $('#lb-progress-fill').style.width = `${pct}%`;
    }

    const list = $('#lb-list');
    list.innerHTML = '';

    if (!data.top || data.top.length === 0) {
        list.innerHTML = '<div class="empty-state">No sales recorded yet — be the first trapper on the board.</div>';
        return;
    }

    data.top.forEach((row, i) => {
        const div = document.createElement('div');
        div.className = 'lb-row' + (i === 0 ? ' lb-gold' : '');
        div.innerHTML = `
            <div class="lb-place">${escapeHtml(row.place)}</div>
            <div class="lb-info">
                <div class="lb-name">${escapeHtml(row.name)}</div>
                <div class="lb-rank-label">${escapeHtml(row.label)}</div>
            </div>
            <div class="lb-stats">
                <div class="lb-sold">${escapeHtml((row.sold || 0).toLocaleString())} sold</div>
                <div class="lb-earned">${escapeHtml(formatMoney(row.earned))}</div>
            </div>
        `;
        list.appendChild(div);
    });
}

/* ── Boost Panel ── */
function renderBoostState(state) {
    const sell = state && state.sell;
    const harvest = state && state.harvest;

    if (sell) {
        $('#boost-sell-mult').textContent = `${sell.multiplier}x`;
        $('#boost-sell-remaining').textContent = formatTime(sell.remaining);
        $('#boost-sell-pill').classList.remove('hidden');
        $('#boost-sell-text').textContent = `SELL ${sell.multiplier}x`;
        $('#boost-sell-time').textContent = formatTime(sell.remaining);
    } else {
        $('#boost-sell-mult').textContent = 'OFF';
        $('#boost-sell-remaining').textContent = 'Inactive';
        $('#boost-sell-pill').classList.add('hidden');
    }

    if (harvest) {
        $('#boost-harvest-mult').textContent = `${harvest.multiplier}x`;
        $('#boost-harvest-remaining').textContent = formatTime(harvest.remaining);
        $('#boost-harvest-pill').classList.remove('hidden');
        $('#boost-harvest-text').textContent = `HARVEST ${harvest.multiplier}x`;
        $('#boost-harvest-time').textContent = formatTime(harvest.remaining);
    } else {
        $('#boost-harvest-mult').textContent = 'OFF';
        $('#boost-harvest-remaining').textContent = 'Inactive';
        $('#boost-harvest-pill').classList.add('hidden');
    }

    const hud = $('#boost-hud');
    if (sell || harvest) {
        hud.classList.remove('hidden');
    } else {
        hud.classList.add('hidden');
    }
}

/* ── Mini Sell ── */
function renderSellMini(offer) {
    if (!offer) {
        $('#sell-mini').classList.add('hidden');
        return;
    }

    $('#sell-drug-name').textContent = offer.label || 'Product';
    $('#sell-qty').textContent = `${offer.quantity}x @ ${formatMoney(offer.priceEach)} each`;
    $('#sell-total').textContent = formatMoney(offer.total);

    let range = `Range ${formatMoney(offer.minPrice)}–${formatMoney(offer.maxPrice)}`;
    if (offer.boostMultiplier > 1) range += ` • ${offer.boostMultiplier}x BOOST`;
    $('#sell-range').textContent = range;

    const canHaggle = offer.haggleEnabled
        && (offer.attempts || 0) < (offer.maxAttempts || 0)
        && offer.priceEach < offer.maxPrice;

    $('#sell-haggle-soft').style.display = canHaggle ? '' : 'none';
    $('#sell-haggle-hard').style.display = canHaggle ? '' : 'none';

    $('#sell-mini').classList.remove('hidden');
}

/* ── Event Listeners ── */
window.addEventListener('message', (event) => {
    const { action, data } = event.data || {};

    switch (action) {
        case 'openLeaderboard':
            renderLeaderboard(data);
            showPanel('leaderboard');
            break;
        case 'openBoost':
            renderBoostState(data);
            showPanel('boost-panel');
            break;
        case 'updateBoost':
            renderBoostState(data);
            break;
        case 'openSell':
            renderSellMini(data);
            break;
        case 'updateSell':
            renderSellMini(data);
            break;
        case 'closeSell':
            $('#sell-mini').classList.add('hidden');
            break;
        case 'closeAll':
            closeUI(false);
            break;
    }
});

document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;

    if (currentPanel) {
        closeUI(true);
        return;
    }

    const sellMini = $('#sell-mini');
    if (sellMini && !sellMini.classList.contains('hidden')) {
        post('sellAction', { action: 'decline' });
        sellMini.classList.add('hidden');
    }
});

$$('[data-close]').forEach((btn) => {
    btn.addEventListener('click', () => closeUI());
});

/* Sell actions */
$('#sell-accept').addEventListener('click', () => post('sellAction', { action: 'accept' }));
$('#sell-haggle-soft').addEventListener('click', () => post('sellAction', { action: 'haggle', askId: 'soft' }));
$('#sell-haggle-hard').addEventListener('click', () => post('sellAction', { action: 'haggle', askId: 'hard' }));
$('#sell-decline').addEventListener('click', () => post('sellAction', { action: 'decline' }));

/* Boost actions */
$$('.boost-card[data-action="start"]').forEach((btn) => {
    btn.addEventListener('click', () => {
        post('boostAction', {
            action: 'start',
            kind: btn.dataset.kind,
            multiplier: parseInt(btn.dataset.mult, 10),
            duration: selectedDuration,
        });
    });
});

$$('.btn-stop[data-action="stop"]').forEach((btn) => {
    btn.addEventListener('click', () => {
        post('boostAction', { action: 'stop', kind: btn.dataset.kind });
    });
});

$$('.duration-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
        $$('.duration-btn').forEach((b) => b.classList.remove('active'));
        btn.classList.add('active');
        selectedDuration = parseInt(btn.dataset.seconds, 10);
    });
});
