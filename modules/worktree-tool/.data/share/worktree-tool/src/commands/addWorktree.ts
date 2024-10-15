#!/usr/bin/env -S deno run --allow-env --allow-run --allow-read --allow-write

import * as log from '../log.ts';
log.setup();
const logger = getLogger();

import { getLogger } from '@std/log';
import { parseArgs } from '@std/cli';
import { blue, cyan, gray, magenta, yellow } from '@std/fmt/colors';
import { forEachRef, getOwnerRepo, Ref } from '../git.ts';
import { compareDesc, formatRelative } from 'date-fns';
import { fzfTable } from '../fzf.ts';
import { ICONS } from '../icons.ts';
import { execOutput } from '../exec.ts';
import { assert } from '@std/assert';
import { join } from '@std/path';

const HOME = Deno.env.get('XDG_CONFIG_HOME') ||
  `${Deno.env.get('HOME')}/.config`;
const WORKTREE_DIR = join(HOME, 'code-worktrees');

interface CliArgs {
  branchName?: string;
  b?: string;
}

async function main() {
  const args = parseArgs<CliArgs>(Deno.args);
  let branchName = args.b ?? args.branchName;
  logger.debug(`args: ${JSON.stringify(args)}`);

  const refs: Ref[] = (await forEachRef()).toSorted(refComparator);
  const selection = await fzfTable(refs, {
    extraArgs: ['--ansi'],
    serializeToRow,
  });
  assert(selection.length === 1, `No ref was selected`);
  const ref = selection[0];
  logger.debug(`selected: ${JSON.stringify(ref, null, 2)}`);

  if (!branchName) {
    branchName = getBranchName(ref);
  }
  logger.debug(`Creating worktree with branch name ${branchName}`);

  const { owner, repo } = await getOwnerRepo();
  const newWorktreePath = join(WORKTREE_DIR, owner, repo, branchName);
  await execOutput('git', {
    args: [
      'worktree',
      'add',
      '-b',
      branchName,
      newWorktreePath,
      ref.friendlyName,
    ],
  });
  logger.info(`New worktree created at ${cyan(newWorktreePath)} (points to ${magenta(ref.friendlyName)})`);

  // todo: prompt `wt-link` if `.worktree-symlinks` file is present
}

function getBranchName(ref: Ref): string {
  let suggestedBranchName: string | null = null;
  logger.info(`new worktree will be based on ${yellow(ref.friendlyName)}`);

  switch (ref.refType) {
    case 'local_branch': {
      while (!suggestedBranchName) {
        suggestedBranchName = prompt(
          `Enter a new branch name for this working tree to checkout:`,
        );
        if (!suggestedBranchName) {
          logger.error(
            `Since ${
              yellow(ref.friendlyName)
            } is already checked out, creating a new worktree based on this ref must have a different branch name`,
          );
        }
      }
      break;
    }
    case 'remote_branch': {
      // TODO: prompt again if suggestedBranchName is already checked out
      suggestedBranchName = ref.friendlyName.match(
        /^(?:[^/]+)\/(?<remoteBranchName>.+)/,
      )?.groups?.remoteBranchName ?? null;
      assert(
        suggestedBranchName,
        `Failed to parse branch name from remote ref: ${ref.friendlyName}`,
      );
      while (suggestedBranchName === 'HEAD') {
        logger.error(`${magenta('HEAD')} is not a valid branch name`);
        suggestedBranchName = prompt(
          `Enter a new branch name for this working tree to checkout`
        );
      }

      break;
    }
    case 'tag': {
      suggestedBranchName = ref.friendlyName;
      break;
    }
    default: {
      const unknown: never = ref.refType;
      throw new Error(
        `Failed to get branch name due to unrecognized ref type: ${unknown}`,
      );
    }
  }

  return suggestedBranchName;
}

function refComparator(a: Ref, b: Ref): number {
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
}

function serializeToRow(ref: Ref): string[] {
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
