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
