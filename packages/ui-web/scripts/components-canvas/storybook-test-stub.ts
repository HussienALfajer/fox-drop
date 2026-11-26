// Stands in for `storybook/test` while the canvas generator reads the stories
// (stories.ts): a story's `play` is never run there, only noticed.
export const waitFor = (): Promise<void> => Promise.resolve();
