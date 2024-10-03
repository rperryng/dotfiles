#!/usr/bin/env -S deno run --allow-run --allow-write --allow-env --allow-read

import { existsSync } from '@std/fs';
import { execLines } from './exec.ts';

const { Command } = Deno;

const XDG_CONFIG_HOME = Deno.env.get('XDG_CONFIG_HOME') ||
  `${Deno.env.get('HOME')}/.config`;
const WORKTREE_SYMLINKS_IGNORE_PATH =
  `${XDG_CONFIG_HOME}/.worktree-symlinks-ignore`;

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

async function main() {
  await checkGitRoot();

  const gitTrackedSet = new Set(await gitTrackedFiles());
  const allFiles = await findAllNonIgnoredFiles();
  const fileSuggestions = allFiles.filter((file) => !gitTrackedSet.has(file));

  // Output the untracked files
  fileSuggestions.forEach((file) => console.log(file));

  await Deno.writeTextFile(
    '/tmp/git_tracked_set',
    (Array.from(gitTrackedSet)).join('\n'),
  );
  await Deno.writeTextFile('/tmp/fd_files', (Array.from(allFiles)).join('\n'));
  await Deno.writeTextFile('/tmp/output', fileSuggestions.join('\n'));
}

main().catch((error) => {
  console.error('An unexpected error occurred:', error);
  Deno.exit(1);
});
