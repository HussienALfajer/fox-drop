import react from '@vitejs/plugin-react';
import { defineConfig } from 'vitest/config';

// The panel calls the API on its own origin under /v1 (owner decision
// 2026-11-05): in development Vite forwards /v1 to the local server, so the
// __Host- session cookie works without CORS, and Centrifugo's WebSocket to the
// local Centrifugo (compose.yaml allows these origins). The images come from
// imgproxy under /media, and uploads go to the storage under /public-media
// with the Host unchanged, since the server signs them for this origin
// (ADMIN_PANEL_URL, architecture §5.8). In production the edge does all four.
const api = {
  '/v1': 'http://localhost:3000',
  '/connection/websocket': { target: 'ws://localhost:8000', ws: true },
  '/media': 'http://localhost:8088',
  // Vite's short form would rewrite the Host, which the signature covers.
  '/public-media': { target: 'http://localhost:3900', changeOrigin: false },
};

export default defineConfig({
  plugins: [react()],
  server: { port: 5173, strictPort: true, proxy: api },
  preview: { port: 4173, strictPort: true, proxy: api },
  // e2e/ holds the Playwright tests.
  test: { include: ['src/**/*.test.ts', 'test/**/*.test.ts'] },
});
