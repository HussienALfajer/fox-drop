// A name as typed and as stored, compared without case or diacritics, with
// «ة/ه», «ى/ي» and the alefs alike (as the customers' search, CU §8.3).
export function folded(text: string): string {
  return text
    .toLowerCase()
    .normalize('NFKD')
    .replace(/[ً-ٰٟ̀-ͯ]/g, '')
    .replace(/[ً-ٰٟ̀-ͯ]/g, '')
    .replace(/ة/g, 'ه')
    .replace(/ى/g, 'ي');
}

// The reads of each row, LIST_CONCURRENCY rows at a time, so a long list
// never takes the whole pool from the customers' and captains' requests.
const LIST_CONCURRENCY = 4;

export async function inTurns<T, R>(
  items: readonly T[],
  read: (item: T) => Promise<R>,
): Promise<R[]> {
  const answers: R[] = [];
  for (let start = 0; start < items.length; start += LIST_CONCURRENCY) {
    answers.push(...(await Promise.all(items.slice(start, start + LIST_CONCURRENCY).map(read))));
  }
  return answers;
}
