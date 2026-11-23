import type { Meta, StoryObj } from '@storybook/react-vite';
import { Icon } from './icon';

// One story per entry of STATES (R3), named by the state.
const meta = { title: 'Icon', component: Icon } satisfies Meta<typeof Icon>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = { args: { name: 'cart' } };
export const Sm: Story = { args: { name: 'cart', size: 'sm' } };
export const Md: Story = { args: { name: 'cart', size: 'md' } };
export const Lg: Story = { args: { name: 'cart', size: 'lg' } };
export const Labelled: Story = { args: { name: 'cart', label: 'السلة' } };
// `back` points to the start: right in RTL (§9.4).
export const Mirrored: Story = { args: { name: 'back', label: 'رجوع' } };
