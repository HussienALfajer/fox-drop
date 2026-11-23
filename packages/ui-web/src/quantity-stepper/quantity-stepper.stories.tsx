import type { Meta, StoryObj } from '@storybook/react-vite';
import { useState } from 'react';
import { QuantityStepper, type QuantityStepperProps } from './quantity-stepper';

const meta = {
  title: 'QuantityStepper',
  component: QuantityStepper,
  args: { label: 'الكمية', increaseLabel: 'زيادة', decreaseLabel: 'تقليل', removeLabel: 'حذف' },
} satisfies Meta<typeof QuantityStepper>;
export default meta;
type Story = StoryObj<typeof meta>;

// The count and its group name move together, as an app would write them.
function Counting(props: QuantityStepperProps) {
  const [count, setCount] = useState(props.defaultValue ?? 1);
  return <QuantityStepper {...props} value={count} onValueChange={setCount} />;
}
const make = (args: Partial<QuantityStepperProps> = {}): Story => ({
  args,
  render: (props) => <Counting {...props} />,
});

export const Default = make({ defaultValue: 2, onRemove: () => undefined });
export const Hover = make({ defaultValue: 2 });
export const Focus = make({ defaultValue: 2 });
export const Pressed = make({ defaultValue: 2 });
// At the minimum «−» becomes the delete icon.
export const Minimum = make({ defaultValue: 1, onRemove: () => undefined });
export const Maximum = make({ defaultValue: 5, max: 5 });
export const Disabled = make({ defaultValue: 2, disabled: true });
