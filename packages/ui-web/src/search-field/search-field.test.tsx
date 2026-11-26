import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { SearchField } from './search-field';

const props = { label: 'ابحث', clearLabel: 'مسح' };

describe('SearchField', () => {
  it('is a search box named by its label', () => {
    render(<SearchField {...props} />);
    expect(screen.getByRole('searchbox', { name: 'ابحث' })).toBeInTheDocument();
  });

  it('shows the clear button only while there is text, and clears and refocuses', async () => {
    const onValueChange = vi.fn();
    render(<SearchField {...props} onValueChange={onValueChange} />);
    expect(screen.queryByRole('button', { name: 'مسح' })).not.toBeInTheDocument();
    await userEvent.type(screen.getByRole('searchbox'), 'شاورما');
    await userEvent.click(screen.getByRole('button', { name: 'مسح' }));
    expect(onValueChange).toHaveBeenLastCalledWith('');
    expect(screen.getByRole('searchbox')).toHaveValue('');
    expect(screen.getByRole('searchbox')).toHaveFocus();
  });

  // Parity gap (D.W3a): the D.8 sheet draws the clear button as a 32 circle
  // on `surface` at rest; the web left it transparent until hovered.
  it('draws the clear button as the sheet’s circle on its own tokens', async () => {
    render(<SearchField {...props} />);
    await userEvent.type(screen.getByRole('searchbox'), 'شاورما');
    const { className } = screen.getByRole('button', { name: 'مسح' });
    expect(className).toContain('size-(--fd-input-clear-size)');
    expect(className).toContain('bg-(--fd-input-clear-color-background)');
    expect(className).toContain('hover:bg-(--fd-input-clear-color-background-hover)');
  });

  it('is busy and swaps the clear button for a spinner while loading', () => {
    render(<SearchField {...props} defaultValue="شاورما" loading />);
    expect(screen.getByRole('searchbox')).toHaveAttribute('aria-busy', 'true');
    expect(screen.queryByRole('button', { name: 'مسح' })).not.toBeInTheDocument();
    expect(document.querySelector('[data-drop-loader]')).not.toBeNull();
    expect(document.querySelector('.animate-spin')).toBeNull();
  });

  it('is disabled as a whole', () => {
    render(<SearchField {...props} disabled />);
    expect(screen.getByRole('searchbox')).toBeDisabled();
  });
});
