import * as log from '@std/log';
import { z } from 'zod';

const LogLevelSchema = z.enum([
  'DEBUG',
  'INFO',
  'WARN',
  'ERROR',
  'CRITICAL',
]);
const logLevelValue = Deno.env.get('LOG_LEVEL') ?? 'DEBUG';
const levelName = LogLevelSchema.parse(logLevelValue);

export function setup() {
  log.setup({
    handlers: {
      default: new log.ConsoleHandler(levelName),
    },
    loggers: {
      default: {
        level: levelName,
        handlers: ['default'],
      }
    }
  });
}
