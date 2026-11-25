import assert from 'node:assert/strict';
import { describe, it } from 'node:test';

import { flutterCases, pairRows, pngSize, renderSheet, sheetPath, shotPath } from './parity.mjs';

// A PNG's signature and IHDR chunk: enough for pngSize, and for the sheet to inline.
function png(width, height) {
  const bytes = Buffer.alloc(24);
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]).copy(bytes, 0);
  bytes.writeUInt32BE(13, 8);
  bytes.write('IHDR', 12, 'ascii');
  bytes.writeUInt32BE(width, 16);
  bytes.writeUInt32BE(height, 20);
  return bytes;
}

describe('parity sheet', () => {
  it('finds the Flutter cases by their story ids, in file order', () => {
    const source = `
      parityCase('button--primary-default', () => const FoxButton());
      parityCase(
        'button--primary-hover',
        () => const FoxButton(),
      );
      parityCase("chip--default", () => const FoxChip());
    `;
    assert.deepEqual(flutterCases([source], 'button'), [
      'button--primary-default',
      'button--primary-hover',
    ]);
    assert.deepEqual(flutterCases([source]), [
      'button--primary-default',
      'button--primary-hover',
      'chip--default',
    ]);
  });

  it('pairs stories with cases: story order, phone then captain, missing pairs marked', () => {
    const rows = pairRows(
      ['button--primary-default', 'button--primary-compact'],
      ['button--primary-default', 'button--icon-only-legacy'],
    );
    assert.deepEqual(rows, [
      { id: 'button--primary-default', surface: 'phone', web: true, flutter: true },
      { id: 'button--primary-default', surface: 'captain', web: true, flutter: true },
      { id: 'button--primary-compact', surface: 'phone', web: true, flutter: false },
      { id: 'button--primary-compact', surface: 'captain', web: true, flutter: false },
      { id: 'button--icon-only-legacy', surface: 'phone', web: false, flutter: true },
      { id: 'button--icon-only-legacy', surface: 'captain', web: false, flutter: true },
    ]);
  });

  it('reads the size of a PNG', () => {
    assert.deepEqual(pngSize(png(720, 100)), { width: 720, height: 100 });
    assert.throws(() => pngSize(Buffer.from('not a png')));
  });

  it('writes and reads only under .parity/', () => {
    assert.equal(
      shotPath('web', 'button--primary-default', 'phone'),
      '.parity/web/button--primary-default-phone.png',
    );
    assert.equal(
      shotPath('flutter', 'button--primary-default', 'captain'),
      '.parity/flutter/button--primary-default-captain.png',
    );
    assert.equal(sheetPath('Button'), '.parity/Button.html');
  });

  it('renders one row per pair, web at the start, each image inlined with its size', () => {
    const images = {
      '.parity/web/button--primary-default-phone.png': png(720, 100),
      '.parity/flutter/button--primary-default-phone.png': png(720, 104),
    };
    const html = renderSheet(
      'Button',
      [
        { id: 'button--primary-default', surface: 'phone', web: true, flutter: true },
        { id: 'button--primary-compact', surface: 'phone', web: true, flutter: false },
        { id: 'button--icon-only-legacy', surface: 'phone', web: false, flutter: true },
      ],
      (file) => images[file] ?? null,
    );
    assert.match(html, /<html lang="ar" dir="rtl">/);
    const rows = html.match(/<tr data-id="[^"]+"[^>]*>[\s\S]*?<\/tr>/g);
    assert.equal(rows.length, 3);
    assert.match(rows[0], /data-id="button--primary-default" data-surface="phone"/);
    // Web first (the start side in RTL), then Flutter.
    const web = rows[0].indexOf('720 × 100');
    const flutter = rows[0].indexOf('720 × 104');
    assert.ok(web > 0 && flutter > web, 'the web image comes before the Flutter one');
    assert.equal(rows[0].match(/src="data:image\/png;base64,/g).length, 2);
    // Natural size: the image is drawn at its CSS pixels (pixel ratio 2), never stretched.
    assert.match(rows[0], /width="360" height="50"/);
    assert.match(rows[1], /no Flutter case/);
    assert.match(rows[2], /no story/);
  });

  it('marks a pair whose image was not written', () => {
    const html = renderSheet(
      'Button',
      [{ id: 'button--primary-default', surface: 'captain', web: true, flutter: true }],
      () => null,
    );
    assert.equal(html.match(/no image/g).length, 2);
  });
});
