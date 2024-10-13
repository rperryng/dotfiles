#!/usr/bin/env -S deno run --allow-env --allow-run --allow-read --allow-write

import * as log from '../log.ts';
log.setup();

import { getLogger } from '@std/log';
import { parseArgs } from '@std/cli';
import chalk from 'chalk';
import { blue, yellow, green, magenta, cyan, inverse } from '@std/fmt/colors';
import { forEachRef, Ref } from '../git.ts';
import { compareDesc } from 'date-fns';
import { fzfExec } from '../fzf.ts';
import { ICONS } from '../icons.ts';

const logger = getLogger();

// list refs
//   - local branches first (sorted by recent)
//   - remote branches (sorted by recent)
//   - refs

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
      return -1
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

  const currentDate = new Date();
  const formattedLines = refs.map((ref) => {
    return `${blue(ref.committerDate.toISOString())}`
  });
  //logger.debug(formattedLines.join('\n'));
  logger.debug(JSON.stringify(refs, null, 2));

  //const selection = await fzfExec();

  //logger.debug(`allBranches: ${chalk.blue(JSON.stringify(list, null, 2))}`);
}

// TODO: single entrypoint?
main().catch((error) => {
  logger.critical(error);
  Deno.exit(1);
});
