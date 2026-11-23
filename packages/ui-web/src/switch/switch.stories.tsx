import type { Meta, StoryObj } from '@storybook/react-vite';
import { Switch, type SwitchProps } from './switch';

const meta = {
  title: 'Switch',
  component: Switch,
  args: { label: 'إشعارات الطلبات' },
} satisfies Meta<typeof Switch>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<SwitchProps> = {}): Story => ({ args });

export const Default = make();
export const Hover = make();
export const Focus = make();
export const Pressed = make();
export const On = make({ defaultChecked: true });
export const Disabled = make({ disabled: true });
export const DisabledOn = make({ disabled: true, defaultChecked: true });
