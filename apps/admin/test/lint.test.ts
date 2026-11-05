import { ESLint } from 'eslint';
import { beforeAll, describe, expect, it } from 'vitest';

// Proves the web lint rules of eslint.web.mjs fire (AP §4.7).
const eslint = new ESLint({ cwd: `${import.meta.dirname}/..` });

async function errors(code: string) {
  const [result] = await eslint.lintText(code, { filePath: 'src/fixture.tsx' });
  return result!.messages.map((message) => message.message);
}

describe('web lint rules', () => {
  // The first lint loads the config and the TypeScript program, which can
  // take longer than a test's 5 seconds when every package tests at once.
  beforeAll(() => errors(''), 60_000);

  it.each([
    ['text in JSX', 'export const X = () => <p>نص</p>;'],
    ['a literal in braces', "export function X() { return <p>{'نص'}</p>; }"],
    ['a template literal in braces', 'export function X() { return <p>{`نص`}</p>; }'],
    ['a label attribute', 'export function X() { return <img alt="صورة" />; }'],
    ['a label attribute in braces', "export function X() { return <i title={'نص'} />; }"],
    ['Intl in plain Arabic', "export const f = new Intl.NumberFormat('ar');"],
    ['toLocaleString in Arabic', "export const s = (1).toLocaleString('ar-SY');"],
  ])('fails %s', async (_, code) => {
    expect(await errors(code)).toHaveLength(1);
  });

  it('passes translated text and Western digits', async () => {
    const code = [
      "import { useTranslation } from 'react-i18next';",
      "export const f = new Intl.NumberFormat('ar-u-nu-latn');",
      'export function X() {',
      '  const { t } = useTranslation();',
      "  return <p title={t('notFound')}>{t('notFound')} </p>;",
      '}',
    ].join('\n');
    expect(await errors(code)).toEqual([]);
  });
});
