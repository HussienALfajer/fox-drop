import { describe, expect, it } from 'vitest';
import { formTv, SIZES } from './styles';

// tailwind-merge took our `text-<surface>-<role>` sizes for colours and dropped
// the colour beside them (the Timer's text inherited a dark page's white).
describe('formTv', () => {
  it.each(SIZES)('keeps a colour beside text-%s', (size) => {
    const classes = formTv({ base: `text-${size} text-on-surface` })();
    expect(classes).toContain(`text-${size}`);
    expect(classes).toContain('text-on-surface');
  });
});
