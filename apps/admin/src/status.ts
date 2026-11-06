import { useQuery } from '@tanstack/react-query';
import { api } from './api.js';

// Whether the panel reaches the server.
export function useServerStatus() {
  return useQuery({
    queryKey: ['status'],
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/status');
      if (!data) throw new Error('The status request failed.');
      return data;
    },
  });
}
