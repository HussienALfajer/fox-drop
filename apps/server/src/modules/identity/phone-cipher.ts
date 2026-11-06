import { Inject, Injectable } from '@nestjs/common';
import { IDENTITY_SECRETS, type IdentitySecrets } from './secrets.js';

// Architecture §15.3: another module that keeps a phone number, such as a
// customer address's contact number (CU §7.3), keeps it encrypted with the
// identity module's key.
@Injectable()
export class PhoneCipher {
  constructor(@Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets) {}

  encrypt(phone: string): string {
    return this.secrets.encrypt(phone);
  }

  decrypt(encrypted: string): string {
    return this.secrets.decrypt(encrypted);
  }
}
