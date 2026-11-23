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

  it('is busy and swaps the clear button for a spinner while loading', () => {
    render(<SearchField {...props} defaultValue="شاورما" loading />);
    expect(screen.getByRole('searchbox')).toHaveAttribute('aria-busy', 'true');
    expect(screen.queryByRole('button', { name: 'مسح' })).not.toBeInTheDocument();
  });

  it('is disabled as a whole', () => {
    render(<SearchField {...props} disabled />);
    expect(screen.getByRole('searchbox')).toBeDisabled();
  });
});
