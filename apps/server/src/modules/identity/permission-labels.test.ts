import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { adminPermissions } from './permissions.js';

// «فريق الإدارة»'s role matrix (AP §9.15, §6; slice 2.38b) names every
// permission in Arabic from the panel's translations (AP §4.7), so a new
// permission fails here until it has its words.
const ar = JSON.parse(
  readFileSync(new URL('../../../../admin/src/locales/ar.json', import.meta.url), 'utf8'),
) as { team: { permission: Record<string, string> } };

describe('the panel names every permission', () => {
  it('has a name for each, and none for a permission gone', () => {
    expect(Object.keys(ar.team.permission).sort()).toEqual([...adminPermissions].sort());
  });
});
