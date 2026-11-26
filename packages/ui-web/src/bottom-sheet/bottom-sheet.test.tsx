import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { Button } from '../button/button';
import { BottomSheet } from './bottom-sheet';

// The sheet's content is a keyboard stop only while it scrolls (axe:
// scrollable-region-focusable), so it never takes the first focus from the
// controls inside a short sheet (D.W4c).

async function open() {
  render(
    <BottomSheet title="وجبة كريسبي" closeLabel="إغلاق" sCurve trigger={<Button>اختر</Button>}>
      <p>بالثوم</p>
    </BottomSheet>,
  );
  await userEvent.click(screen.getByRole('button', { name: 'اختر' }));
  return screen.getByText('بالثوم').parentElement!;
}

afterEach(() => vi.restoreAllMocks());

describe('BottomSheet content', () => {
  it('is no keyboard stop when it fits', async () => {
    expect(await open()).not.toHaveAttribute('tabindex');
  });

  it('is a keyboard stop when it overflows', async () => {
    vi.spyOn(HTMLElement.prototype, 'scrollHeight', 'get').mockReturnValue(500);
    vi.spyOn(HTMLElement.prototype, 'clientHeight', 'get').mockReturnValue(200);
    expect(await open()).toHaveAttribute('tabindex', '0');
  });
});
