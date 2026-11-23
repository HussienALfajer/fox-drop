import type { Meta, StoryObj } from '@storybook/react-vite';
import { TextField, type TextFieldProps } from './text-field';

// One story per state (R3). Hover and focus are the plain field: the Playwright
// gate drives them with the pointer and the keyboard.
const meta = {
  title: 'TextField',
  component: TextField,
  args: { label: 'الاسم', placeholder: 'اكتب اسمك' },
} satisfies Meta<typeof TextField>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<TextFieldProps> = {}): Story => ({ args });

export const Default = make({ hint: 'كما يظهر في الهوية' });
export const Hover = make();
export const Focus = make();
export const Filled = make({ defaultValue: 'محمد الأحمد' });
export const Invalid = make({ defaultValue: 'محمد', error: 'اكتب الاسم كما في الهوية' });
export const Disabled = make({ disabled: true });
export const Comfortable = make({ density: 'comfortable' });
export const Compact = make({ density: 'compact', label: 'اسم المطعم' });
export const Optional = make({ optionalLabel: '(اختياري)', label: 'الكنية' });
