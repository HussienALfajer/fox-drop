// The entry of the Design System bundle: the components, plus React and
// ReactDOM so a canvas can mount them (`libraries` is empty in the index).
import * as React from 'react';
import * as ReactDOM from 'react-dom/client';
import {
  AmountsSummary,
  Button,
  Card,
  Checkbox,
  CodeField,
  CountBadge,
  DataTable,
  EmptyState,
  Field,
  Icon,
  ListRow,
  Money,
  OrderCard,
  PhoneField,
  QuantityStepper,
  RadioGroup,
  SearchField,
  Select,
  Skeleton,
  StatusChip,
  Switch,
  TextArea,
  TextField,
  Timer,
  Dialog,
  ConfirmDialog,
  Drawer,
  Toaster,
  Banner,
  BannerStack,
  BlockingBanner,
  Menu,
  Tooltip,
  Tabs,
  TopBar,
  Sidebar,
  useToast,
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
  Money,
  StatusChip,
  CountBadge,
  Card,
  ListRow,
  Timer,
  OrderCard,
  AmountsSummary,
  Skeleton,
  EmptyState,
  DataTable,
  Dialog,
  ConfirmDialog,
  Drawer,
  Toaster,
  Banner,
  BannerStack,
  BlockingBanner,
  Menu,
  Tooltip,
  Tabs,
  TopBar,
  Sidebar,
  useToast,
  React,
  ReactDOM,
};

// A page that already loaded its own React keeps it.
const page = window as unknown as Record<string, unknown>;
page['React'] ??= React;
page['ReactDOM'] ??= ReactDOM;
page['FoxDrop'] = api;

export default api;
