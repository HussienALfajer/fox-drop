import rootConfig from '../../eslint.config.mjs';
import { webAppConfig } from '../../eslint.web.mjs';

export default [...rootConfig, ...webAppConfig];
