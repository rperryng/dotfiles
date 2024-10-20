#!/usr/bin/env -S deno run --allow-env --allow-run --allow-read --allow-write

import { Command } from '@cliffy/command';
import { setup as setupLogs } from '../log.ts';
import * as log from '@std/log';

await new Command()
  .name('ryans-worktree-tool')
  .version('0.0.1')
  .description('Utility tool for working with Git Worktrees.')
  .globalOption("-d, --debug", "Enable debug output.")
  .action((options, ...args) => {
    const debug = options.debug ?? true;
    setupLogs({ debug });
    log.debug(options)
    log.debug(args)
  })
  .parse(Deno.args);
