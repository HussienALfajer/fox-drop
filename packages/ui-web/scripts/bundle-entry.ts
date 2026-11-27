// The entry of the Design System bundle: the components, plus React and
// ReactDOM so a canvas can mount them (`libraries` is empty in the index).
import * as React from 'react';
import * as ReactDOM from 'react-dom/client';
import './bundle.css';

// Every component the bundle exposes, in the order of COMPONENTS in
// scripts/bundle.ts. Empty since D.R1 (2026-11-27): components are rebuilt
// one approved screen at a time (architecture §9.9).
const components: Record<string, React.ComponentType<object>> = {};

// The bridge to a page that renders with another React (the Design canvas
// runs React 18; the components need 19, as the UI SDK does). Each export
// checks who renders it: under the bundle's own React it renders the real
// component directly; under the page's React it renders an empty host element
// and mounts the real component in it with the bundle's ReactDOM, turning the
// page's elements in its props and children into the bundle's.
const page = window as unknown as Record<string, unknown>;
const HOST_ELEMENT = Symbol.for('react.element');
const HOST_FRAGMENT = Symbol.for('react.fragment');
const innerOf = new WeakMap<object, React.ElementType>();

interface HostElement {
  $$typeof: symbol;
  type: unknown;
  key: string | null;
  props: Record<string, unknown>;
}

type HostReact = {
  createElement: (type: string, props: Record<string, unknown>) => unknown;
  useRef: <T>(value: T) => { current: T };
  useLayoutEffect: (effect: () => void | (() => void), deps?: unknown[]) => void;
};

function isHostElement(node: unknown): node is HostElement {
  return (
    typeof node === 'object' && node !== null && (node as HostElement).$$typeof === HOST_ELEMENT
  );
}

// A function prop (a table cell, a render prop) may return the page's
// elements: its result crosses the bridge too. Cached, so it keeps its identity.
const wrapped = new WeakMap<object, unknown>();

function isPlainObject(node: unknown): node is Record<string, unknown> {
  return (
    typeof node === 'object' &&
    node !== null &&
    !('$$typeof' in node) &&
    Object.getPrototypeOf(node) === Object.prototype
  );
}

/** The page's elements as the bundle's, in arrays, plain objects and function results too. */
function toInner(node: unknown): unknown {
  if (Array.isArray(node)) return node.map(toInner);
  if (typeof node === 'function') {
    const fn = node as (...args: unknown[]) => unknown;
    if (!wrapped.has(fn)) wrapped.set(fn, (...args: unknown[]) => toInner(fn(...args)));
    return wrapped.get(fn);
  }
  if (isPlainObject(node)) return innerProps(node);
  if (!isHostElement(node)) return node;
  const type =
    typeof node.type === 'string'
      ? node.type
      : node.type === HOST_FRAGMENT
        ? React.Fragment
        : innerOf.get(node.type as object);
  // A component of the page alone cannot cross into the bundle's tree.
  if (type === undefined) return null;
  return React.createElement(type, { ...innerProps(node.props), key: node.key ?? undefined });
}

function innerProps(props: Record<string, unknown>): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  for (const [name, value] of Object.entries(props)) out[name] = toInner(value);
  return out;
}

// Which React is calling a bridged component: the dispatcher of the bundle's
// React answers a hook only while that React renders (between renders it keeps
// one that throws; before the first render there is none). Asked first and on
// every render by the bundle's React, so the hook order stays the same.
const internals = (React as unknown as Record<string, { H?: unknown } | undefined>)[
  '__CLIENT_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE'
];

function renderedByBundle(): boolean {
  const dispatcher = internals?.H as { useRef?: (value: null) => unknown } | null | undefined;
  if (!dispatcher?.useRef) return false;
  try {
    dispatcher.useRef(null);
    return true;
  } catch {
    return false;
  }
}

function bridge<P extends object>(
  Inner: React.ComponentType<P>,
  name: string,
): React.ComponentType<P> {
  function Bridged(props: P) {
    const host = page['React'] as HostReact | undefined;
    // Rendered by the bundle's own React (FoxDrop.React, a card's preview):
    // straight through, whatever React the page also carries.
    if (!host || (host as unknown) === React || renderedByBundle())
      return React.createElement(Inner, props);
    // Rendered by the page's React: only its hooks are allowed here.
    const slot = host.useRef<HTMLElement | null>(null);
    const root = host.useRef<ReactDOM.Root | null>(null);
    host.useLayoutEffect(() => {
      const mounted = ReactDOM.createRoot(slot.current!);
      root.current = mounted;
      return () => {
        root.current = null;
        setTimeout(() => mounted.unmount());
      };
    }, []);
    host.useLayoutEffect(() => {
      root.current?.render(
        React.createElement(Inner, innerProps(props as Record<string, unknown>) as P),
      );
    });
    return host.createElement('div', {
      ref: slot,
      style: { display: 'contents' },
    }) as React.ReactElement;
  }
  Bridged.displayName = name;
  innerOf.set(Bridged, Inner);
  // Parts such as Skeleton.Block cross the bridge too.
  for (const [part, value] of Object.entries(Inner).filter(([key]) => /^[A-Z]/.test(key))) {
    if (
      typeof value === 'function' ||
      (typeof value === 'object' && value !== null && '$$typeof' in value)
    ) {
      (Bridged as unknown as Record<string, unknown>)[part] = bridge(
        value as React.ComponentType<object>,
        `${name}.${part}`,
      );
    }
  }
  return Bridged;
}

const api: Record<string, unknown> = { React, ReactDOM };
for (const [name, component] of Object.entries(components)) {
  api[name] = bridge(component as React.ComponentType<object>, name);
}

// A page that already loaded its own React keeps it.
page['React'] ??= React;
page['ReactDOM'] ??= ReactDOM;
page['FoxDrop'] = api;

export default api;
