// The entry of the Design System bundle: the components, plus React and
// ReactDOM so a canvas can mount them (`libraries` is empty in the index).
import * as React from 'react';
import * as ReactDOM from 'react-dom/client';
import {
  Button,
  Checkbox,
  CodeField,
  Field,
  Icon,
  PhoneField,
  QuantityStepper,
  RadioGroup,
  SearchField,
  Select,
  Switch,
  TextArea,
  TextField,
} from '../src/index.ts';
import './bundle.css';

const api = {
  Button,
  Icon,
  Field,
  TextField,
  TextArea,
  SearchField,
  PhoneField,
  CodeField,
  Select,
  Checkbox,
  RadioGroup,
  Switch,
  QuantityStepper,
  React,
  ReactDOM,
};

// A page that already loaded its own React keeps it.
const page = window as unknown as Record<string, unknown>;
page['React'] ??= React;
page['ReactDOM'] ??= ReactDOM;
page['FoxDrop'] = api;

export default api;
