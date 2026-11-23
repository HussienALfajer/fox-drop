import type { Meta, StoryObj } from '@storybook/react-vite';
import { CodeField, type CodeFieldProps } from './code-field';

const meta = {
  title: 'CodeField',
  component: CodeField,
  args: { label: 'رمز التحقق', hint: 'أرسلنا الرمز إلى واتساب' },
} satisfies Meta<typeof CodeField>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<CodeFieldProps> = {}): Story => ({ args });

export const Default = make();
export const Focus = make();
export const Typing = make({ defaultValue: '482' });
export const Invalid = make({ defaultValue: '482913', error: 'الرمز غير صحيح' });
export const Done = make({ defaultValue: '482913', done: true });
export const Disabled = make({ disabled: true });
