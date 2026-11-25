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
    ['an arbitrary colour', 'export const c = `bg-[var(--fd-x)] p-sm`;'],
    ['a numeric spacing utility', 'export const c = "absolute inset-0";'],
    ['a numeric padding under a variant', 'export const c = "md:px-0";'],
    ['a hex colour', 'export const c = "#ff6e31";'],
    ['a style prop', 'export const X = () => <i style={{ color: "red" }} />;'],
    ['ml-', 'export const c = "flex ml-2";'],
    ['pr- under a variant', 'export const c = "md:pr-4";'],
    ['text-right', 'export const c = "text-right";'],
    ['rounded-tl', 'export const c = "rounded-tl-lg";'],
    ['border-r', 'export const c = "border-r";'],
    ['a numeric gap', 'export const c = "gap-2";'],
    ['a decimal width', 'export const c = "w-0.5";'],
    ['an important numeric padding', 'export const c = "p-4!";'],
    ['a numeric min width', 'export const c = "min-w-0";'],
    ['left-', 'export const c = "absolute left-0";'],
    ['float-left', 'export const c = "float-left";'],
  ])('fails %s', async (_, code) => {
    expect(await errors(code)).toHaveLength(1);
  });

  it('passes tokens as variables and logical directions', async () => {
    const code = [
      'export const c =',
      '  "bg-(--fd-button-primary-background) ms-xs pe-md start-none text-start rounded-s-lg border-e";',
      'export const d = `ps-${1}`;',
    ].join('\n');
    expect(await errors(code)).toEqual([]);
  });

  it('passes the named spacing steps that start with a digit', async () => {
    const code = 'export const c = "gap-2xs p-2xs w-2xl h-3xl md:min-w-2xl";';
    expect(await errors(code)).toEqual([]);
  });

  it('allows the UI SDK but not its agent entry', async () => {
    const ok = 'import { Button } from "@ui-sdk/react/button";\nexport const B = Button;';
    expect(await errors(ok)).toEqual([]);
    const agent = 'import { Agent } from "@ui-sdk/react/agent";\nexport const A = Agent;';
    expect(await errors(agent)).toHaveLength(1);
  });

  // Slice D.W1: the numeric classes Tailwind still builds from a bare number.
  it.each([
    ['a numeric duration', 'export const c = "transition duration-150";'],
    ['a numeric delay', 'export const c = "delay-75";'],
    ['a numeric opacity under a variant', 'export const c = "hover:opacity-50";'],
    ['a numeric line height', 'export const c = "leading-6";'],
    ['a numeric letter spacing', 'export const c = "tracking-1";'],
    ['a numeric font size', 'export const c = "text-14";'],
    ['a numeric radius', 'export const c = "rounded-4";'],
    ['a numeric side radius', 'export const c = "rounded-s-8";'],
    ['a numeric stroke', 'export const c = "stroke-2";'],
    ['a numeric border', 'export const c = "border-2";'],
    ['a numeric side border', 'export const c = "border-s-4";'],
    ['a numeric border, important', 'export const c = "border-t-2!";'],
  ])('fails %s', async (_, code) => {
    expect(await errors(code)).toEqual([expect.stringMatching(/numeric value/i)]);
  });

  it('passes the token form of those classes, and 0', async () => {
    const code = [
      'export const c =',
      '  "duration-(--fd-duration-base) opacity-0 data-starting-style:opacity-0 border-b-0 border-t-(length:--fd-border-width-thick) rounded-(--fd-button-radius) text-phone-body leading-none stroke-(--fd-x) border-dashed";',
    ].join('\n');
    expect(await errors(code)).toEqual([]);
  });

  it('keeps stories out of the translation rule', async () => {
    const code = 'export const X = () => <p>نص</p>;';
    expect(await errors(code, 'src/x.stories.tsx')).toEqual([]);
    expect(await errors(code)).toHaveLength(1);
  });
});
