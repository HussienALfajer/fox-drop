// The setup page of the panel, with the token in the fragment: browsers never
// send a fragment, so the token stays out of server and proxy logs. The page
// posts it in a request body.
export function setupLinkUrl(panelUrl: string, token: string): string {
  return `${panelUrl.replace(/\/+$/, '')}/setup#token=${token}`;
}
