import { ESLint } from 'eslint';
import { beforeAll, describe, expect, it } from 'vitest';

// Proves the design rules of eslint.web.mjs fire in ui-web (architecture §9.5
// R1, R3, R5) and that ui-web may import the UI SDK, but not its agent entry.
const eslint = new ESLint({ cwd: `${import.meta.dirname}/..` });

async function errors(code: string, filePath = 'src/fixture.tsx') {
  const [result] = await eslint.lintText(code, { filePath });
  return result!.messages.map((message) => message.message);
}

describe('ui-web lint rules', () => {
  // The first lint loads the config and the TypeScript program.
  beforeAll(() => errors(''), 60_000);

  it.each([
    ['an arbitrary value', 'export const c = "w-[13px]";'],
    ['an arbitrary colour', 'export const c = `bg-[var(--fd-x)] p-2`;'],
    ['a hex colour', 'export const c = "#ff6e31";'],
    ['a style prop', 'export const X = () => <i style={{ color: "red" }} />;'],
    ['ml-', 'export const c = "flex ml-2";'],
    ['pr- under a variant', 'export const c = "md:pr-4";'],
    ['text-right', 'export const c = "text-right";'],
    ['rounded-tl', 'export const c = "rounded-tl-lg";'],
    ['border-r', 'export const c = "border-r";'],
    ['left-', 'export const c = "absolute left-0";'],
    ['float-left', 'export const c = "float-left";'],
  ])('fails %s', async (_, code) => {
    expect(await errors(code)).toHaveLength(1);
  });

  it('passes tokens as variables and logical directions', async () => {
    const code = [
      'export const c =',
      '  "bg-(--fd-button-primary-background) ms-2 pe-4 start-0 text-start rounded-s-lg border-e";',
      'export const d = `ps-${1}`;',
    ].join('\n');
    expect(await errors(code)).toEqual([]);
  });

  it('allows the UI SDK but not its agent entry', async () => {
    const ok = 'import { Button } from "@ui-sdk/react/button";\nexport const B = Button;';
    expect(await errors(ok)).toEqual([]);
    const agent = 'import { Agent } from "@ui-sdk/react/agent";\nexport const A = Agent;';
    expect(await errors(agent)).toHaveLength(1);
  });

  it('keeps stories out of the translation rule', async () => {
    const code = 'export const X = () => <p>نص</p>;';
    expect(await errors(code, 'src/x.stories.tsx')).toEqual([]);
    expect(await errors(code)).toHaveLength(1);
  });
});
