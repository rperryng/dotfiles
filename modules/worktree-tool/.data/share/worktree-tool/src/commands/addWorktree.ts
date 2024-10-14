#!/usr/bin/env -S deno run --allow-env --allow-run --allow-read --allow-write

import * as log from '../log.ts';
log.setup();

import { getLogger } from '@std/log';
import { parseArgs } from '@std/cli';
import { blue, cyan, gray, magenta, white, yellow } from '@std/fmt/colors';
import { forEachRef, Ref } from '../git.ts';
import { compareDesc, formatRelative } from 'date-fns';
import { fzfTable } from '../fzf.ts';
import { ICONS } from '../icons.ts';

const logger = getLogger();

interface CliArgs {
  branch?: string;
  b?: string;
}

async function main() {
  const args = parseArgs<CliArgs>(Deno.args);
  const branch = args.b ?? args.branch;
  logger.debug(`args: ${JSON.stringify(args)}`);

  const refs: Ref[] = (await forEachRef()).toSorted((a, b) => {
    if (a.refType === undefined && b.refType !== undefined) {
      return -1;
    } else if (a.refType !== undefined && b.refType === undefined) {
      return 1;
    }

    if (a.refType === 'local_branch' && b.refType === 'remote_branch') {
      return -1;
    } else if (a.refType === 'remote_branch' && b.refType === 'local_branch') {
      return 1;
    }

    return compareDesc(a.committerDate, b.committerDate);
  });

  const selection = await fzfTable(refs, {
    extraArgs: ['--ansi'],
    serializeToRow,
  });
  logger.debug(`selection: ${JSON.stringify(selection, null, 2)}`);
}

function serializeToRow(ref: Ref) {
  let icon;
  switch (ref.refType) {
    case 'local_branch': {
      icon = blue(ICONS.DIR);
      break;
    }
    case 'remote_branch': {
      icon = yellow(ICONS.GITHUB);
      break;
    }
    case 'tag': {
      icon = magenta(ICONS.TAG);
      break;
    }
    default: {
      const unknown: never = ref.refType;
      icon = unknown;
    }
  }

  return [
    icon,
    ref.friendlyName,
    blue(ref.author),
    `(${cyan(ref.email)})`,
    gray(formatRelative(ref.committerDate, new Date())),
  ];
}

// TODO: single entrypoint?
main().catch((error) => {
  logger.critical(error);
  Deno.exit(1);
});
