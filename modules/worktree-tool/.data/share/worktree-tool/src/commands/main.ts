#!/usr/bin/env -S deno run --allow-env --allow-run --allow-read --allow-write

import { Command } from '@cliffy/command';
import { setup as setupLogs } from '../log.ts';
import * as log from '@std/log';

import { addWorktreeCommand } from './addWorktree.ts';
import { linkWorktreeCommand } from './link.ts';

await new Command()
  .name('ryans-worktree-tool')
  .version('0.0.1')
  .description('Utility tool for working with Git Worktrees.')
  .globalOption("-d, --debug", "Enable debug output.")
  .globalAction((options, ...args) => {
    const debug = options.debug ?? true;
    setupLogs({ debug });
    log.debug(`options: ${JSON.stringify(options)}`);
    log.debug(`args: ${JSON.stringify({args})}`);
  })
  .command('add', addWorktreeCommand)
  .command('link', linkWorktreeCommand)
  .parse(Deno.args);
