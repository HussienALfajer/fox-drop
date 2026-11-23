import type { Meta, StoryObj } from '@storybook/react-vite';
import { useState } from 'react';
import { Button, type ButtonProps, type ButtonVariant } from './button';

// One story per entry of STATES for each variant (R3), named <Variant><State>:
// PrimaryHover, GhostCompact. The Hover, Focus and Pressed stories are the
// plain button: the Playwright gate drives them with the pointer and the
// keyboard (e2e/), so they stay interactive and the component has no state prop.
const meta = { title: 'Button', component: Button } satisfies Meta<typeof Button>;
export default meta;
type Story = StoryObj<typeof meta>;

const SAMPLE: Record<ButtonVariant, string> = {
  primary: 'اطلب الآن',
  secondary: 'عرض القائمة',
  danger: 'إلغاء الطلب',
  ghost: 'تخطي',
};

const make = (
  variant: ButtonVariant,
  args: Pick<ButtonProps, 'disabled' | 'loading' | 'density'> = {},
): Story => ({
  args: { variant, children: SAMPLE[variant], ...args },
});

export const PrimaryDefault = make('primary');
export const PrimaryHover = make('primary');
export const PrimaryFocus = make('primary');
export const PrimaryPressed = make('primary');
export const PrimaryDisabled = make('primary', { disabled: true });
export const PrimaryLoading = make('primary', { loading: true });
export const PrimaryComfortable = make('primary', { density: 'comfortable' });
export const PrimaryCompact = make('primary', { density: 'compact' });

export const SecondaryDefault = make('secondary');
export const SecondaryHover = make('secondary');
export const SecondaryFocus = make('secondary');
export const SecondaryPressed = make('secondary');
export const SecondaryDisabled = make('secondary', { disabled: true });
export const SecondaryLoading = make('secondary', { loading: true });
export const SecondaryComfortable = make('secondary', { density: 'comfortable' });
export const SecondaryCompact = make('secondary', { density: 'compact' });

export const DangerDefault = make('danger');
export const DangerHover = make('danger');
export const DangerFocus = make('danger');
export const DangerPressed = make('danger');
export const DangerDisabled = make('danger', { disabled: true });
export const DangerLoading = make('danger', { loading: true });
export const DangerComfortable = make('danger', { density: 'comfortable' });
export const DangerCompact = make('danger', { density: 'compact' });

export const GhostDefault = make('ghost');
export const GhostHover = make('ghost');
export const GhostFocus = make('ghost');
export const GhostPressed = make('ghost');
export const GhostDisabled = make('ghost', { disabled: true });
export const GhostLoading = make('ghost', { loading: true });
export const GhostComfortable = make('ghost', { density: 'comfortable' });
export const GhostCompact = make('ghost', { density: 'compact' });

// Icons at the start (right in RTL) and the end; `back` mirrors.
export const WithIconStart: Story = { args: { icon: 'cart', children: 'أضف إلى السلة' } };
export const WithIconBack: Story = {
  args: { variant: 'secondary', icon: 'back', children: 'رجوع' },
};
export const WithIconEnd: Story = { args: { iconEnd: 'confirm', children: 'تأكيد الطلب' } };
export const WithBothIcons: Story = {
  args: { variant: 'secondary', icon: 'phone', iconEnd: 'confirm', children: 'اتصل بالمطعم' },
};
export const CompactWithIcon: Story = {
  args: { variant: 'secondary', density: 'compact', icon: 'filter', children: 'تصفية' },
};

// The keyboard gate (e2e/rtl.spec.ts) presses these and reads the count that
// the button's `onClick` produced.
function Presses(props: ButtonProps) {
  const [count, setCount] = useState(0);
  return (
    <div className="flex items-center gap-md">
      <Button {...props} onClick={() => setCount((value) => value + 1)} />
      <output aria-label="عدد الضغطات">{count}</output>
    </div>
  );
}
const presses = (args: Pick<ButtonProps, 'disabled' | 'loading'> = {}): Story => ({
  args: { children: 'اضغط', ...args },
  render: (props) => <Presses {...props} />,
});
export const Presseable = presses();
export const PresseableDisabled = presses({ disabled: true });
export const PresseableLoading = presses({ loading: true });

// An icon alone is a circle of the control height; its label is the accessible name.
export const IconOnly: Story = { args: { icon: 'add', label: 'إضافة' } };
export const IconOnlySecondary: Story = {
  args: { variant: 'secondary', icon: 'close', label: 'إغلاق' },
};
export const IconOnlyBack: Story = { args: { variant: 'secondary', icon: 'back', label: 'رجوع' } };
export const IconOnlyGhost: Story = { args: { variant: 'ghost', icon: 'more', label: 'المزيد' } };
export const IconOnlyDanger: Story = { args: { variant: 'danger', icon: 'delete', label: 'حذف' } };
export const IconOnlyCompact: Story = {
  args: { variant: 'secondary', density: 'compact', icon: 'close', label: 'إغلاق' },
};
