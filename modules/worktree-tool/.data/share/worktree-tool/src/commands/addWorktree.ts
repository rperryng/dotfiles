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

const ELLIPSIS = '…';

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
    branchName = getBranchName(ref, refs);
  }
  log.debug(`Creating worktree with branch name ${branchName}`);

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

function getBranchName(
  ref: Ref,
  existingRefs: Ref[],
): string {
  let suggestedBranchName: string | null = null;
  log.info(`new worktree will be based on ${magenta(ref.friendlyName)}`);

  if (ref.refType === 'remote_branch') {
    suggestedBranchName =
      ref.friendlyName.match(/^(?:[^/]+)\/(?<remoteBranchName>.+)/)?.groups
        ?.remoteBranchName ?? null;
    assert(
      suggestedBranchName,
      `Failed to parse branch name from remote ref: ${ref.friendlyName}`,
    );

    const suggestedBranchAlreadyCheckedOut = existingRefs.some(
      (r) => r.refName === `refs/heads/${suggestedBranchName}`,
    );
    if (!suggestedBranchAlreadyCheckedOut) {
      return suggestedBranchName;
    } else {
      log.error(
        `the branch ${
          magenta(suggestedBranchName)
        } is already checked out somewhere else`,
      );
      suggestedBranchName = null;
    }
  }

  while (suggestedBranchName === null) {
    suggestedBranchName = prompt(
      `Enter a new branch name for this working tree to checkout:`,
    );
    if (!suggestedBranchName) {
      log.error(
        `Since ${
          yellow(
            ref.friendlyName,
          )
        } is already checked out, creating a new worktree based on this ref must have a different branch name`,
      );
      continue;
    }

    const branchAlreadyCheckedOut = existingRefs.some(
      (r) => r.refName === `refs/heads/${suggestedBranchName}`,
    );
    if (branchAlreadyCheckedOut) {
      log.error(
        `the branch ${
          magenta(suggestedBranchName)
        } is already checked out somewhere else`,
      );
      suggestedBranchName = null;
      continue;
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

  function truncateString(s: string, length = 60): string {
    if (s.length < length) {
      return s;
    }
    return `${s.slice(0, length - 1)}${ELLIPSIS}`;
  }

  return [
    icon,
    truncateString(ref.friendlyName, 50),
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
