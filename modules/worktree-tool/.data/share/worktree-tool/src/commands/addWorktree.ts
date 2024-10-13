#!/usr/bin/env -S deno run --allow-env --allow-run --allow-read --allow-write

import * as log from '../log.ts';
log.setup();

import { getLogger } from '@std/log';
import { parseArgs } from '@std/cli';
import chalk from 'chalk';
import { forEachRef, Ref } from '../git.ts';
import { compareAsc, compareDesc } from 'date-fns';

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


  const list: Ref[] = (await forEachRef()).toSorted((a, b) => {
  });

  logger.debug(`allBranches: ${chalk.blue(JSON.stringify(list, null, 2))}`);
}

// TODO: single entrypoint?
main().catch((error) => {
  logger.critical(error);
  logger.info('destroying handlers');
  Deno.exit(1);
});
