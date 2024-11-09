import { assert } from '@std/assert';
import { existsSync } from '@std/fs';
import { join } from '@std/path';
import { execOutput } from '../lib/exec.ts';

const HOME = Deno.env.get('HOME');
assert(HOME);
export const WORKTREE_DIR = join(HOME, 'code-worktrees');

export interface Worktree {
  path: string;
  head: string;
  friendlyName: string;
  branch: string | undefined;
  type: 'clone' | 'worktree';
}

export async function listWorktrees(): Promise<Worktree[]> {
  const worktreesOutput = await execOutput('git', {
    args: ['worktree', 'list', '--porcelain'],
  });

  const worktrees: Worktree[] = [];
  const worktreeBlobs = worktreesOutput
    .split('\n\n')
    .filter((blob) => blob != '');
  for (const blob of worktreeBlobs) {
    const path = /^worktree (?<path>[^\n]+)$/m.exec(blob)?.groups?.path;
    const head = /^HEAD (?<head>[\w]+)$/m.exec(blob)?.groups?.head;
    const branch = /^branch (?<branch>[^\n]+)$/m.exec(blob)?.groups?.branch;

    assert(path, `failed to parse path from worktree output:\n${blob}`);
    assert(head, `failed to parse HEAD ref from worktree output:\n${blob}`);
    if (!branch) {
      assert(
        /^detached$/m.test(blob),
        `worktree did not have "branch" value, and also did not indicated it was detached \n${blob}`,
      );
    }

    const dotGitPath = join(path, '.git');
    if (!existsSync(dotGitPath)) {
      throw new Error(
        `${dotGitPath} does not exist - can't determine type of worktree`,
      );
    }
    const info = await Deno.stat(dotGitPath);
    const type = info.isDirectory ? 'clone' : 'worktree';

    const friendlyName = path.replace(WORKTREE_DIR, '');

    worktrees.push({
      path,
      friendlyName,
      head,
      branch,
      type,
    });
  }

  return worktrees;
}
