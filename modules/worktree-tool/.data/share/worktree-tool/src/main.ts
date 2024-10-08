#!/usr/bin/env -S deno run --allow-run --allow-write --allow-env --allow-read

import { existsSync } from '@std/fs';
import { execLines, execOutput } from './exec.ts';
import { fzfExec } from './fzf.ts';
import { assert } from '@std/assert';

const { Command } = Deno;

const XDG_CONFIG_HOME = Deno.env.get('XDG_CONFIG_HOME') ||
  `${Deno.env.get('HOME')}/.config`;
const WORKTREE_SYMLINKS_IGNORE_PATH =
  `${XDG_CONFIG_HOME}/.worktree-symlinks-ignore`;
const WORKTREE_SYMLINKS_FILENAME = '.worktree-symlinks';

function stripTrailingSlash(string: string): string {
  return string.replace(/\/$/, '');
}

async function ignorePatterns(): Promise<string[]> {
  if (!existsSync(WORKTREE_SYMLINKS_IGNORE_PATH)) {
    return [];
  }

  const ignoreFileContent = await Deno.readTextFile(
    WORKTREE_SYMLINKS_IGNORE_PATH,
  );
  return ignoreFileContent
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => line !== '' && !line.startsWith('# '));
}

async function findAllNonIgnoredFiles(): Promise<string[]> {
  const fdArgs = ['--hidden', '--no-ignore'];
  (await ignorePatterns()).forEach((pattern) => {
    fdArgs.push('--exclude', pattern);
  });

  return (await execLines('fd', { args: fdArgs })).map(stripTrailingSlash);
}

async function gitTrackedFiles(): Promise<string[]> {
  const directories = await execLines('git', {
    args: ['ls-tree', '-d', '-r', '--name-only', 'HEAD'],
  });
  const files = await execLines('git', { args: ['ls-files'] });
  return [
    ...(directories.map(stripTrailingSlash)),
    ...files,
  ];
}

async function checkGitRoot(): Promise<void> {
  const gitRootCommand = new Command('git', {
    args: ['rev-parse', '--show-toplevel'],
    stdout: 'piped',
    stderr: 'piped',
  });
  const gitRootResult = await gitRootCommand.output();

  if (!gitRootResult.success) {
    const errorString = new TextDecoder().decode(gitRootResult.stderr);
    console.error('Error: This directory is not part of a Git repository.');
    console.error(errorString);
    Deno.exit(1);
  }
}

interface Worktree {
  path: string;
  head: string;
  branch: string | undefined;
}
async function listWorktrees(): Promise<Worktree[]> {
  const worktreesOutput = await execOutput('git', {
    args: ['worktree', 'list', '--porcelain'],
  });

  return worktreesOutput
    .split('\n\n')
    .filter((blob) => blob != '')
    .map((blob) => {
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

      return {
        path,
        head,
        branch,
      };
    });
}

async function fzfFileSuggestions(): Promise<string[]> {
  const gitTrackedSet = new Set(await gitTrackedFiles());
  const allFiles = await findAllNonIgnoredFiles();
  const fileSuggestions = allFiles
    .filter((file) => !gitTrackedSet.has(file) && !file.endsWith(WORKTREE_SYMLINKS_FILENAME) && file !== '');

  if (fileSuggestions.length === 0) {
    throw new Error(
      'No file suggestions available - are there any untracked files to be found?',
    );
  }

  const selection = await fzfExec(fileSuggestions);
  if (selection.length === 0) {
    throw new Error('No files selected. Aborting.');
  }

  return selection;
}

async function getWorktreeSymlinkFiles(): Promise<string[]> {
  const worktreeSymlinksFilePath = [Deno.cwd(), WORKTREE_SYMLINKS_FILENAME]
    .join('/');

  if (existsSync(worktreeSymlinksFilePath)) {
    const symlinkFiles = (await Deno.readTextFile(worktreeSymlinksFilePath))
      .split('\n')
      .filter((line) => line !== '' && !line.endsWith(WORKTREE_SYMLINKS_FILENAME));

    if (symlinkFiles.length !== 0) {
      return symlinkFiles;
    }
  }

  const symlinkFiles = await fzfFileSuggestions();
  await Deno.writeTextFile(worktreeSymlinksFilePath, symlinkFiles.join('\n'));
  return symlinkFiles;
}

async function main() {
  await checkGitRoot();

  console.log(await getWorktreeSymlinkFiles());

  // Iterate worktrees
  // raise error if file exists (and is not a symlink)
  // add symlink if none exists (use stow?...)
  const worktrees = await listWorktrees();
  console.log(JSON.stringify(worktrees, null, 2));
}

main().catch((error) => {
  console.error('An unexpected error occurred:', error);
  Deno.exit(1);
});
