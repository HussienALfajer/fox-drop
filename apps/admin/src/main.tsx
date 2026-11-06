import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { RouterProvider } from '@tanstack/react-router';
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { I18nextProvider } from 'react-i18next';
import { whenSessionEnds } from './api.js';
import { i18n } from './i18n.js';
import { createAppRouter } from './router.js';
import { forgetSession } from './session.js';

document.title = i18n.t('app.name');

const queryClient = new QueryClient();
const router = createAppRouter(queryClient);

// AP §5.2: a session that ended (idle, maximum lifetime, forced sign-out)
// returns the panel to the sign-in page.
whenSessionEnds(() => {
  forgetSession(queryClient);
  void router.navigate({ to: '/sign-in' });
});

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <I18nextProvider i18n={i18n}>
      <QueryClientProvider client={queryClient}>
        <RouterProvider router={router} />
      </QueryClientProvider>
    </I18nextProvider>
  </StrictMode>,
);
