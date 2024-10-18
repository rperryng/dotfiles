#!/usr/bin/env -S deno run --allow-env --allow-run --allow-read --allow-write

import { setup as setupLogger } from '../log.ts';
setupLogger();

import * as log from '@std/log';
import { parseArgs } from '@std/cli';
import { blue, cyan, gray, italic, magenta, yellow } from '@std/fmt/colors';
import { forEachRef, getOwnerRepo, Ref } from '../git/index.ts';
import { compareDesc, format } from 'date-fns';
import { fzfTable } from '../fzf.ts';
import { ICONS } from '../icons.ts';
import { execOutput } from '../exec.ts';
import { assert } from '@std/assert';
import { join } from '@std/path';
import { WORKTREE_DIR } from '../git/index.ts';
import { truncateString } from '../string-utils.ts';

interface CliArgs {
  branchName?: string;
  b?: string;
}

async function main() {
  const args = parseArgs<CliArgs>(Deno.args);
  let branchName = args.b ?? args.branchName;
  log.debug(`args: ${JSON.stringify(args)}`);

  const refs: Ref[] = (await forEachRef()).toSorted(refComparator);
  const selection = await fzfTable(refs, {
    extraArgs: ['--ansi'],
    header: ['', 'Branch', 'Author', 'Email', 'Message', 'When'],
    serializeToRow,
  });
  assert(selection.length === 1, `No ref was selected`);
  const ref = selection[0];
  log.debug(`selected: ${JSON.stringify(ref, null, 2)}`);

  if (!branchName) {
    branchName = getBranchName({
      ref,
      existingRefs: refs,
    });
  }
  log.debug(`Creating worktree with branch name ${magenta(branchName)}`);

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
  log.info(
    `New worktree created at ${cyan(newWorktreePath)} (points to ${
      magenta(
        ref.friendlyName,
      )
    })`,
  );
}

function getBranchName(opts: {
  branchName?: string;
  ref: Ref;
  existingRefs: Ref[];
}): string {
  const { ref, existingRefs } = opts;
  let branchName: string | undefined | null = opts?.branchName;
  const branchCheckedOut = (branch: string): boolean => {
    return existingRefs.some((r) => r.refName === `refs/heads/${branch}`);
  };

  if (!branchName && ref.refType === 'remote_branch') {
    branchName = ref.friendlyName.match(/^(?:[^/]+)\/(?<remoteBranchName>.+)/)
      ?.groups
      ?.remoteBranchName;
    assert(
      branchName,
      `Failed to parse branch name from remote ref: ${ref.friendlyName}`,
    );

    if (!branchCheckedOut(branchName)) {
      return branchName;
    } else {
      log.error(
        `the branch ${
          magenta(branchName)
        } is already checked out somewhere else`,
      );
      branchName = null;
    }
  }

  while (!branchName) {
    branchName = prompt(
      `Enter a new branch name for this working tree to checkout:`,
    );
    if (!branchName) {
      log.error(
        `Since ${
          magenta(
            ref.friendlyName,
          )
        } is already checked out, creating a new worktree based on this ref must have a different branch name`,
      );
      continue;
    }

    if (!branchCheckedOut(branchName)) {
      return branchName;
    } else {
      log.error(
        `the branch ${
          magenta(branchName)
        } is already checked out somewhere else`,
      );
      branchName = undefined;
    }
  }

  return branchName;
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
    truncateString(ref.friendlyName, { length: 50 }),
    blue(ref.author),
    `(${cyan(ref.email)})`,
    gray(truncateString(ref.message)),
    italic(gray(format(ref.committerDate, 'yyyy-MM-dd'))),
  ];
}

// TODO: single entrypoint?
main().catch((error) => {
  log.error(error);
  Deno.exit(1);
});
