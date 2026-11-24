import '@testing-library/jest-dom/vitest';
import { cleanup } from '@testing-library/react';
import { afterEach } from 'vitest';

// Testing Library only cleans up by itself when the test globals are on.
afterEach(cleanup);

// jsdom has no Web Animations: the UI SDK's popups ask an element for its
// running animations before they close, and there are none to wait for.
if (!('getAnimations' in Element.prototype)) {
  Object.defineProperty(Element.prototype, 'getAnimations', { value: () => [] });
}

// jsdom has no top layer either: an element with `popover` stays display none
// and has no showPopover. The UI SDK's dialogs, drawers, menus and tooltips
// (D.10) open in the top layer, so a shown popover is drawn as a block here,
// as the browser does.
if (!('showPopover' in HTMLElement.prototype)) {
  Object.defineProperties(HTMLElement.prototype, {
    showPopover: {
      value(this: HTMLElement) {
        this.style.setProperty('display', 'block');
      },
    },
    hidePopover: {
      value(this: HTMLElement) {
        this.style.removeProperty('display');
      },
    },
    togglePopover: {
      value(this: HTMLElement, force?: boolean) {
        const open = force ?? this.style.getPropertyValue('display') !== 'block';
        if (open) this.style.setProperty('display', 'block');
        else this.style.removeProperty('display');
        return open;
      },
    },
  });
}

// jsdom has no ResizeObserver; the UI SDK's drawer measures its content with one.
if (!('ResizeObserver' in globalThis)) {
  globalThis.ResizeObserver = class {
    observe() {}
    unobserve() {}
    disconnect() {}
  };
}

// jsdom does not lay out, so it has no scrollIntoView; the SDK's menus and tabs
// scroll the highlighted item into view.
if (!('scrollIntoView' in Element.prototype)) {
  Object.defineProperty(Element.prototype, 'scrollIntoView', { value: () => undefined });
}
