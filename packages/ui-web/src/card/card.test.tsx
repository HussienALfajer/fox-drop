import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Card } from './card';

describe('Card', () => {
  it('is a plain container by default, outlined', () => {
    render(<Card>محتوى</Card>);
    const card = screen.getByText('محتوى');
    expect(card.tagName).toBe('DIV');
    expect(card).toHaveAttribute('data-elevation', 'outline');
  });

  it('draws the Figma offset shadow for the customer app', () => {
    render(<Card elevation="offset">محتوى</Card>);
    expect(screen.getByText('محتوى').className).toContain('shadow-offset');
  });

  it('is one button when the whole card opens something', async () => {
    const onPress = vi.fn();
    render(
      <Card onPress={onPress} label="طلب 10423">
        محتوى
      </Card>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'طلب 10423' }));
    expect(onPress).toHaveBeenCalledOnce();
  });

  it('turns red for a late order', () => {
    render(<Card tone="danger">محتوى</Card>);
    const card = screen.getByText('محتوى');
    expect(card.className).toContain('bg-(--fd-card-danger-background)');
    expect(card.className).toContain('inset-ring-(--fd-card-danger-border)');
  });
});
