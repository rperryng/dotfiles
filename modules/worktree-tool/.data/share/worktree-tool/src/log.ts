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

// Use stderr so that stdout is easy to pipe
class StderrHandler extends log.ConsoleHandler {
  override log(msg: string): void {
    console.error(msg);
  }
}

export function setup() {
  log.setup({
    handlers: {
      stderr: new StderrHandler(levelName, {
        useColors: false,
      }),
    },
    loggers: {
      default: {
        level: levelName,
        handlers: ['stderr'],
      }
    }
  });
}
