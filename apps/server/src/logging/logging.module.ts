import { Module } from '@nestjs/common';
import { LoggerModule } from 'nestjs-pino';
import { loggerOptions } from './logger-options.js';

@Module({
  imports: [LoggerModule.forRoot({ pinoHttp: loggerOptions() })],
})
export class LoggingModule {}
