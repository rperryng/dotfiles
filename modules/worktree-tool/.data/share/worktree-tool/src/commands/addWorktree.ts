import * as log from '@std/log';
import { blue, cyan, gray, italic, magenta, yellow } from '@std/fmt/colors';
import { Command } from '@cliffy/command';
import { ICONS } from '../icons.ts';
import { WORKTREE_DIR } from '../git/index.ts';
import { assert } from '@std/assert';
import { compareDesc, format } from 'date-fns';
import { execOutput } from '../exec.ts';
import { forEachRef, getOwnerRepo, Ref } from '../git/index.ts';
import { fzfTable } from '../fzf.ts';
import { join } from '@std/path';
import { truncateString } from '../string-utils.ts';

export const addWorktreeCommand = new Command()
  .description('Add a new worktree')
  .option('-b, --branch <val:string>', 'Specify the new branch name to checkout')
  .action((options) => {
    log.debug(`add options: ${JSON.stringify(options)}`);
    main({ branchName: options.branch })
  });

async function main(opts?: {
  branchName?: string;
}) {
  let branchName = opts?.branchName;

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
  branch?: string;
  ref: Ref;
  existingRefs: Ref[];
}): string {
  const { ref, existingRefs } = opts;
  const branch: string | undefined | null = opts?.branch;

  function validateBranchName(
    b: string | undefined | null,
    opts?: { silent?: boolean },
  ): boolean {
    const silent = opts?.silent ?? true;
    const elog = (message: string) => {
      if (silent) {
        return;
      }
      log.error(message);
    };

    if (!b) {
      elog('branch name can not be empty');
      return false;
    }

    if (b.toUpperCase() === 'HEAD') {
      elog(`HEAD is not a valid branch name`);
      return false;
    }

    const branchCheckedOut = existingRefs.some((r) =>
      r.refName === `refs/heads/${b}`
    );
    if (branchCheckedOut) {
      elog(`${yellow(b)} already checked out`);
      return false;
    }

    return true;
  }

  if (branch && validateBranchName(branch, { silent: true })) {
    return branch;
  }

  if (!branch && ref.refType === 'remote_branch') {
    const b = ref.friendlyName.match(/^(?:[^/]+)\/(?<remoteBranchName>.+)/)
      ?.groups
      ?.remoteBranchName;
    assert(
      b,
      `Failed to parse branch name from remote ref: ${ref.friendlyName}`,
    );

    if (validateBranchName(b)) {
      return b;
    }
  }

  while (true) {
    const b = prompt(
      `Enter a new branch name for this working tree to checkout:`,
    );

    if (validateBranchName(b)) {
      assert(b);
      return b;
    }
  }
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

// TODO: Remove once command is hooked up
if (import.meta.main) {
  main().catch((error) => {
    log.error(error);
    Deno.exit(1);
  });
}
