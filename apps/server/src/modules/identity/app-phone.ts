// CU §5.2 item 1: the apps take a Syrian (+963 9…, 9 digits) or Turkish
// (+90 5…, 10 digits) mobile in E.164. A restaurant user's number follows it
// too, or the user could never sign in.
export const APP_PHONE_PATTERN = /^(\+9639\d{8}|\+905\d{9})$/;
