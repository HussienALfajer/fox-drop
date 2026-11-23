import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it } from 'vitest';
import { TextArea } from './text-area';

describe('TextArea', () => {
  it('starts at three lines and names the textarea by its label', () => {
    render(<TextArea label="ملاحظات" />);
    const area = screen.getByRole('textbox', { name: 'ملاحظات' });
    expect(area).toHaveAttribute('rows', '3');
  });

  it('counts the characters against the limit', async () => {
    render(<TextArea label="ملاحظات" maxLength={20} />);
    expect(screen.getByText('0/20')).toBeInTheDocument();
    await userEvent.type(screen.getByRole('textbox'), 'شكراً');
    expect(screen.getByText('5/20')).toBeInTheDocument();
  });

  it('shows the error as the description and marks the area invalid', () => {
    render(<TextArea label="ملاحظات" error="قصيرة" />);
    expect(screen.getByRole('textbox')).toHaveAccessibleDescription('قصيرة');
    expect(screen.getByRole('textbox')).toBeInvalid();
  });

  it('uses the area radius, not the pill', () => {
    const { container } = render(<TextArea label="ملاحظات" />);
    expect(container.innerHTML).toContain('rounded-(--fd-input-area-radius)');
  });
});
