# 5. Access and security

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

## 5.1 Sign-in

1. The user enters their email or phone number and a password. The password must be at least `admin.password_min_length` (10) characters.
2. The user enters the 6-digit TOTP code from Google Authenticator, or any TOTP app that follows RFC 6238. TOTP is mandatory for every panel user.
3. **First sign-in:** the user sets their password from a one-time setup link (valid 24 hours, fixed), then enrols TOTP by scanning a QR code. The panel shows 10 single-use backup codes once (fixed).
4. **Failed attempts:** after `admin.login_max_attempts` (5) failures, the account is locked for `admin.lockout_min` (15) minutes.

## 5.2 Sessions

- A session ends after `admin.session_idle_min` (30) minutes of inactivity, and in any case after `admin.session_max_hours` (12) hours.
- Each session records its device, browser, IP address, sign-in time and last activity.
- OWN can see every open session and can force a user to sign out of all sessions.

## 5.3 Account administration (OWN)

- Create a user and generate a setup link. The owner shares the link with the person; no email infrastructure is needed.
- Change a user's roles.
- Disable a user. This takes effect immediately and ends all of their sessions.
- Reset a user's TOTP. The user must enrol again at their next sign-in.
- The first OWN account is created by a server command or seed during deployment, never from the UI.

## 5.4 Sensitive data

- **Customer phone numbers** are masked by default, as in `0944 *** 123`. The «إظهار الرقم» (show number) button and the call action appear only for OWN, OPS and SUP, and every reveal is logged (D3).
- **Provider keys** (WhatsApp sending-number sessions, maps and similar) are stored on the server only. The panel never displays a stored secret. OWN can replace a key, which is write-only.
- Exports that contain phone numbers are available only to OWN, OPS and SUP, and each export is logged.
