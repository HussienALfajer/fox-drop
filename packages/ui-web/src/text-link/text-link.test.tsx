import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { TextLink } from './text-link';

describe('TextLink', () => {
  it('is a link that calls back on a click and on Enter', async () => {
    const onClick = vi.fn();
    render(<TextLink onClick={onClick}>تعديل الرقم</TextLink>);
    const link = screen.getByRole('link', { name: 'تعديل الرقم' });
    await userEvent.click(link);
    link.focus();
    await userEvent.keyboard('{Enter}');
    expect(onClick).toHaveBeenCalledTimes(2);
  });

  it('goes to its address when given one', () => {
    render(<TextLink href="/terms">الشروط</TextLink>);
    expect(screen.getByRole('link', { name: 'الشروط' })).toHaveAttribute('href', '/terms');
  });

  it('keeps a 48 target, underlined primary ink with its hover and pressed tokens', () => {
    render(<TextLink onClick={() => {}}>الشروط</TextLink>);
    const classes = screen.getByRole('link').className;
    expect(classes).toContain('min-h-(--fd-size-touch-target)');
    expect(classes).toContain('min-w-(--fd-size-touch-target)');
    expect(classes).toContain('underline');
    expect(classes).toContain('text-(--fd-color-primary)');
    expect(classes).toContain('hover:text-(--fd-color-primary-hover)');
    expect(classes).toContain('active:text-(--fd-color-primary-pressed)');
    expect(classes).toContain('focus-visible:');
  });
});
