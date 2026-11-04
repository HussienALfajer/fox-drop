import { postJournal } from '../ledger/index.js';
import { placeOrder } from './place-order.js';

export function deliver(): void {
  placeOrder();
  postJournal();
}
