import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Button } from './button';

describe('Button', () => {
  it('fires onClick on a click', async () => {
    const onClick = vi.fn();
    render(<Button onClick={onClick}>اطلب</Button>);
    await userEvent.click(screen.getByRole('button', { name: 'اطلب' }));
    expect(onClick).toHaveBeenCalledOnce();
  });

  it.each(['{Enter}', ' '])('activates with the keyboard (%s)', async (key) => {
    const onClick = vi.fn();
    render(<Button onClick={onClick}>اطلب</Button>);
    await userEvent.tab();
    expect(screen.getByRole('button')).toHaveFocus();
    await userEvent.keyboard(key);
    expect(onClick).toHaveBeenCalledOnce();
  });

  it('does nothing when disabled', async () => {
    const onClick = vi.fn();
    render(
      <Button disabled onClick={onClick}>
        اطلب
      </Button>,
    );
    const button = screen.getByRole('button');
    await userEvent.click(button);
    button.focus();
    await userEvent.keyboard('{Enter}');
    expect(onClick).not.toHaveBeenCalled();
    expect(button).toBeDisabled();
  });

  it('is busy and not activatable while loading, keeping its label', async () => {
    const onClick = vi.fn();
    render(
      <Button loading onClick={onClick}>
        اطلب
      </Button>,
    );
    const button = screen.getByRole('button', { name: 'اطلب' });
    expect(button.getAttribute('aria-busy')).toBe('true');
    await userEvent.click(button);
    button.focus();
    await userEvent.keyboard('{Enter}');
    await userEvent.keyboard(' ');
    expect(onClick).not.toHaveBeenCalled();
    // The mark-filling loader replaced the 270° arc (D.11b).
    expect(button.querySelector('[data-drop-loader]')).not.toBeNull();
    expect(button.querySelector('path[d="M12 3a9 9 0 1 0 9 9"]')).toBeNull();
  });

  it('keeps its width while loading: the label stays in the flow, hidden', () => {
    render(<Button loading>اطلب</Button>);
    const label = screen.getByText('اطلب');
    expect(label.closest('span')!.className).toMatch(/(^| )opacity-0( |$)/);
  });

  it('shows the loading label beside the loader, and is named by it', () => {
    render(
      <Button loading loadingLabel="جارٍ إرسال الرمز…">
        أرسل الرمز
      </Button>,
    );
    const button = screen.getByRole('button', { name: 'جارٍ إرسال الرمز…' });
    expect(button).toHaveAttribute('aria-busy', 'true');
    const loading = screen.getByText('جارٍ إرسال الرمز…');
    expect(loading.parentElement!.querySelector('[data-drop-loader]')).not.toBeNull();
  });

  it('draws the loader on orange inside the primary button only', () => {
    const { rerender } = render(<Button loading>اطلب</Button>);
    expect(document.querySelector('[data-drop-loader]')).toHaveAttribute('data-on-primary', '');
    rerender(
      <Button loading variant="secondary">
        اطلب
      </Button>,
    );
    expect(document.querySelector('[data-drop-loader]')).not.toHaveAttribute('data-on-primary');
  });

  it('does not submit a form by default, only with type submit', async () => {
    const onSubmit = vi.fn((event: { preventDefault: () => void }) => event.preventDefault());
    render(
      <form onSubmit={onSubmit}>
        <Button>اطلب</Button>
        <Button type="submit">أرسل</Button>
      </form>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'اطلب' }));
    expect(onSubmit).not.toHaveBeenCalled();
    await userEvent.click(screen.getByRole('button', { name: 'أرسل' }));
    expect(onSubmit).toHaveBeenCalledOnce();
  });

  it('keeps the font size class next to the label colour class', () => {
    const { rerender } = render(<Button>اطلب</Button>);
    expect(screen.getByRole('button').className).toContain('text-phone-subtitle');
    expect(screen.getByRole('button').className).toContain(
      'text-(color:--fd-button-primary-label)',
    );
    rerender(<Button density="compact">اطلب</Button>);
    expect(screen.getByRole('button').className).toContain('text-panel-subtitle');
  });

  it('is not busy when idle', () => {
    render(<Button>اطلب</Button>);
    expect(screen.getByRole('button').hasAttribute('aria-busy')).toBe(false);
  });

  it('names an icon-only button by its label', () => {
    render(<Button icon="close" label="إغلاق" />);
    const button = screen.getByRole('button', { name: 'إغلاق' });
    expect(button.querySelector('svg')).not.toBeNull();
    expect(button.textContent).toBe('');
  });

  it('draws the start icon before the label and the end icon after it', () => {
    render(
      <Button icon="cart" iconEnd="confirm">
        أضف
      </Button>,
    );
    const nodes = [...screen.getByRole('button').firstElementChild!.childNodes];
    expect(nodes.map((n) => (n.nodeType === 1 ? (n as Element).tagName : n.textContent))).toEqual([
      'svg',
      'أضف',
      'svg',
    ]);
  });

  it('uses the control height by density and a smaller icon when compact', () => {
    const { rerender } = render(<Button icon="cart">أضف</Button>);
    const classes = () => screen.getByRole('button').className;
    expect(classes()).toContain('min-h-(--fd-button-height)');
    expect(screen.getByRole('button').querySelector('svg')!.getAttribute('class')).toContain(
      'size-(--fd-size-icon-md)',
    );
    rerender(
      <Button icon="cart" density="compact">
        أضف
      </Button>,
    );
    expect(classes()).toContain('min-h-(--fd-button-compact-height)');
    expect(screen.getByRole('button').querySelector('svg')!.getAttribute('class')).toContain(
      'size-(--fd-size-icon-sm)',
    );
  });
});
