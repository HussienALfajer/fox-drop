import { postJournal } from '../ledger/post-journal.js';

export function deliver(): void {
  postJournal();
}
