import * as log from '@std/log';
import { z } from 'zod';
import { blue, bold, gray, red, yellow } from '@std/fmt/colors';
import type { LogRecord } from '@std/log';

const LogLevelSchema = z.enum([
  'DEBUG',
  'INFO',
  'WARN',
  'ERROR',
  'CRITICAL',
]);
const logLevelValue = Deno.env.get('LOG_LEVEL') ?? 'DEBUG';
const levelName = LogLevelSchema.parse(logLevelValue);

function formattedLogLevel(levelName: log.LevelName): string {
  let coloredLevelName = `[${levelName}]`;
  switch (levelName) {
    case 'DEBUG':
      coloredLevelName = gray(coloredLevelName);
      break;
    case 'INFO':
      coloredLevelName = blue(coloredLevelName);
      break;
    case 'WARN':
      coloredLevelName = yellow(coloredLevelName);
      break;
    case 'ERROR':
      coloredLevelName = red(coloredLevelName);
      break;
    case 'CRITICAL':
      coloredLevelName = bold(red(coloredLevelName));
      break;
    default:
      break;
  }

  return coloredLevelName;
}
class StderrHandler extends log.BaseHandler {
  constructor(levelName: log.LevelName) {
    super(
      levelName,
      {
        formatter: (logRecord: LogRecord) => {
          const level = formattedLogLevel(logRecord.levelName as log.LevelName);
          return `${level} ${logRecord.msg}`;
        },
      },
    );
  }

  override log(msg: string): void {
    console.error(msg);
  }
}

export function setup() {
  log.setup({
    handlers: {
      stderr: new StderrHandler(levelName),
    },
    loggers: {
      default: {
        level: levelName,
        handlers: ['stderr'],
      },
    },
  });
}
