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
    expect(
      button.querySelector('svg[aria-hidden="true"] path[d="M12 3a9 9 0 1 0 9 9"]'),
    ).not.toBeNull();
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
