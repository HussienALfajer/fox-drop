import rootConfig from '../../eslint.config.mjs';
import { uiWebConfig } from '../../eslint.web.mjs';

export default [...rootConfig, ...uiWebConfig];
