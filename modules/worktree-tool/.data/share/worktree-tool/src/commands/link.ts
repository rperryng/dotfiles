import { Command } from '@cliffy/command';
import * as log from '@std/log';
import { existsSync } from '@std/fs';
import { execLines } from '../exec.ts';
import { fzfLines } from '../fzf.ts';
import { linkTargets } from '../linker.ts';
import { listWorktrees } from '../git/index.ts';

const XDG_CONFIG_HOME = Deno.env.get('XDG_CONFIG_HOME') ||
  `${Deno.env.get('HOME')}/.config`;
const WORKTREE_SYMLINKS_IGNORE_PATH =
  `${XDG_CONFIG_HOME}/.worktree-symlinks-ignore`;
const WORKTREE_SYMLINKS_FILENAME = '.worktree-symlinks';

export const linkWorktreeCommand = new Command()
  .description('Symlink files from the git base to all worktrees')
  .action(main);

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

// Ensure the working directory is set to root directory of the Git worktree
// that has the main `.git` folder in it.
async function chdirGitRoot(): Promise<void> {
  const gitRootCommand = new Deno.Command('git', {
    args: ['rev-parse', '--show-toplevel'],
    stdout: 'piped',
    stderr: 'piped',
  });
  const gitRootResult = await gitRootCommand.output();

  if (!gitRootResult.success) {
    const errorString = new TextDecoder().decode(gitRootResult.stderr);
    log.error('Error: This directory is not part of a Git repository.');
    log.error(errorString);
    Deno.exit(1);
  }

  const gitRootPath = new TextDecoder().decode(gitRootResult.stdout).trim();
  if (Deno.cwd() !== gitRootPath) {
    log.info(
      `Changing working directory from ${Deno.cwd()} to ${gitRootPath}`,
    );
    Deno.chdir(gitRootPath);
  }

  // Switch to the main worktree
  const worktrees = await listWorktrees();
  const mainWorktree = worktrees.find((w) => w.type === 'clone');
  if (!mainWorktree) {
    throw new Error("Couldn't find main worktree");
  }
  if (Deno.cwd() !== mainWorktree.path) {
    Deno.chdir(mainWorktree.path);
  }
}

async function fzfFileSuggestions(): Promise<string[]> {
  const gitTrackedSet = new Set(await gitTrackedFiles());
  const allFiles = await findAllNonIgnoredFiles();
  const fileSuggestions = allFiles
    .filter((file) =>
      !gitTrackedSet.has(file) && !file.endsWith(WORKTREE_SYMLINKS_FILENAME) &&
      file !== ''
    );

  if (fileSuggestions.length === 0) {
    throw new Error(
      'No file suggestions available - are there any untracked files to be found?',
    );
  }

  const selection = await fzfLines(fileSuggestions, { extraArgs: ['--multi'] });
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
      .filter((line) =>
        line !== '' && !line.endsWith(WORKTREE_SYMLINKS_FILENAME)
      );

    if (symlinkFiles.length !== 0) {
      return symlinkFiles;
    }
  }

  const symlinkFiles = await fzfFileSuggestions();
  log.debug(`Saving selection to path: ${worktreeSymlinksFilePath}`);
  await Deno.writeTextFile(worktreeSymlinksFilePath, symlinkFiles.join('\n'));
  return symlinkFiles;
}

async function main() {
  await chdirGitRoot();

  const worktreeSymlinkFiles = await getWorktreeSymlinkFiles();
  const worktrees = await listWorktrees();
  const otherWorktreePaths = worktrees
    .map((w) => w.path)
    .filter((p) => p !== Deno.cwd());

  await linkTargets({
    source: {
      workingDirectory: Deno.cwd(),
      filepaths: worktreeSymlinkFiles,
    },
    targets: otherWorktreePaths,
  });
}
