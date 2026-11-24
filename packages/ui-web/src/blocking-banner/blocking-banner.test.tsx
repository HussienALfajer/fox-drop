import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { BlockingBanner } from './blocking-banner';

// D.10, AP §7.3: browsers block audio until the user interacts, so after
// sign-in the panel blocks the page with «اضغط لتفعيل صوت التنبيهات» until
// sound is enabled. Escape and outside presses cannot dismiss it.

function setup(onEnable = vi.fn()) {
  render(
    <>
      <button type="button">زر في الصفحة</button>
      <BlockingBanner
        open
        text="اضغط لتفعيل صوت التنبيهات"
        actionLabel="تفعيل الصوت"
        onEnable={onEnable}
      />
    </>,
  );
  return onEnable;
}

describe('BlockingBanner', () => {
  it('blocks the page as an alert dialog named by its text, focus on its button', async () => {
    setup();
    const dialog = await screen.findByRole('alertdialog', { name: 'اضغط لتفعيل صوت التنبيهات' });
    expect(dialog).toBeInTheDocument();
    await waitFor(() => expect(screen.getByRole('button', { name: 'تفعيل الصوت' })).toHaveFocus());
  });

  it('cannot be dismissed with Escape', async () => {
    const onEnable = setup();
    await screen.findByRole('alertdialog');
    await userEvent.keyboard('{Escape}');
    expect(screen.getByRole('alertdialog')).toBeInTheDocument();
    expect(onEnable).not.toHaveBeenCalled();
  });

  it('enables the sound from the press itself', async () => {
    const onEnable = vi.fn();
    setup(onEnable);
    await userEvent.click(await screen.findByRole('button', { name: 'تفعيل الصوت' }));
    expect(onEnable).toHaveBeenCalledOnce();
  });
});
