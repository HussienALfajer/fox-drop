import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { touchedComponents } from './parity-report.mjs';

const BUTTON = { name: 'Button', web: 'Button', flutter: 'FoxButton', golden: 'FoxButton.png' };
const FIELD = {
  name: 'TextField',
  web: 'TextField',
  flutter: 'FoxTextField',
  golden: 'FoxTextField.png',
};
const HERO = {
  name: 'SignInHero',
  web: null,
  flutter: 'FoxSignInHero',
  golden: 'FoxSignInHero.png',
};
const ALL = [BUTTON, FIELD, HERO];
const DIRS = {
  FoxButton: 'packages/core_ui/lib/src/button',
  FoxTextField: 'packages/core_ui/lib/src/text_field',
  FoxSignInHero: 'packages/core_ui/lib/src/sign_in_hero',
};
const names = (files) => touchedComponents(ALL, files, DIRS).map((c) => c.name);

describe('the parity report picks the components a change touches', () => {
  it('by their web folder, Flutter folder, screenshots or golden', () => {
    assert.deepEqual(names(['packages/ui-web/src/text-field/text-field.tsx']), ['TextField']);
    assert.deepEqual(names(['packages/core_ui/lib/src/button/fox_button.dart']), ['Button']);
    assert.deepEqual(
      names(['packages/ui-web/e2e/__screenshots__/button--primary-default-phone.png']),
      ['Button'],
    );
    assert.deepEqual(
      names(['packages/core_ui/test/golden/goldens/design-system/FoxSignInHero.png']),
      ['SignInHero'],
    );
  });

  it('none for a change elsewhere', () => {
    assert.deepEqual(names(['apps/server/src/main.ts', 'docs/roadmap.md']), []);
    // A neighbour's folder does not count: text-field-x is not text-field.
    assert.deepEqual(names(['packages/ui-web/src/text-field-x/a.tsx']), []);
  });

  it('every one after a token, registry or theme change', () => {
    for (const file of [
      'packages/design-tokens/tokens/component/button.json',
      'packages/design-tokens/generated/tokens.css',
      'packages/design-tokens/components.json',
      'packages/ui-web/src/theme.css',
      'packages/core_ui/lib/src/theme/fox_theme.dart',
    ])
      assert.deepEqual(names([file]), ['Button', 'TextField', 'SignInHero'], file);
  });
});
