import type { Meta, StoryObj } from '@storybook/react-vite';
import { Input } from '@ui-sdk/react/input';
import { Field, type FieldProps } from './field';
import { InputBox } from './input-box';
import { inputClass } from './styles';

// The wrapper alone, around a plain input: the label, the hint, the error and
// «(اختياري)». Hover and focus stay interactive; the gate drives them.
const meta = { title: 'Field', component: Field } satisfies Meta<typeof Field>;
export default meta;
type Story = StoryObj<typeof meta>;

type Extra = { value?: string; invalid?: boolean; disabled?: boolean };
const make = (args: Partial<FieldProps> & Extra = {}): Story => {
  const { value, ...field } = args;
  return {
    args: { label: 'الاسم', hint: 'كما يظهر في الهوية', ...field, children: null },
    render: (props) => (
      <Field {...props}>
        <InputBox
          {...(props.density && { density: props.density })}
          {...(props.disabled && { disabled: true })}
          {...(props.error && { invalid: true })}
        >
          <Input
            className={inputClass()}
            placeholder="اكتب اسمك"
            {...(value && { defaultValue: value })}
          />
        </InputBox>
      </Field>
    ),
  };
};

export const Default = make();
export const Hover = make();
export const Focus = make();
export const Filled = make({ value: 'محمد الأحمد', optionalLabel: '(اختياري)' });
export const Invalid = make({ value: 'محمد', error: 'اكتب الاسم كما في الهوية' });
export const Disabled = make({ disabled: true });
export const Comfortable = make({ density: 'comfortable' });
export const Compact = make({ density: 'compact' });
