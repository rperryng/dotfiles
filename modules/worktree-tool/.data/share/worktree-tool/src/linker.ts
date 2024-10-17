import * as log from '@std/log';
import { existsSync } from '@std/fs';
import { join } from '@std/path';
import * as colors from '@std/fmt/colors';
import { WORKTREE_DIR } from './git/index.ts';
import { indent } from './string-utils.ts';

export interface SymlinkSource {
  workingDirectory: string;
  filepaths: string[];
}

export async function linkTargets(options: {
  source: SymlinkSource;
  targets: string[];
}): Promise<void> {
  for (const targetDirectory of options.targets) {
    await linkTarget(options.source, targetDirectory);
  }
}

async function linkTarget(
  source: SymlinkSource,
  targetDirectory: string,
): Promise<void> {
  const friendlyName = targetDirectory.replace(WORKTREE_DIR, '');
  log.info(`${colors.cyan(friendlyName)}`);
  const info = (s: string) => {
    log.info(indent(s));
  };

  for (const path of source.filepaths) {
    const desiredSource = join(source.workingDirectory, path);
    const fullTargetPath = join(targetDirectory, path);

    if (!existsSync(fullTargetPath)) {
      info(indent(`creating ${colors.magenta(path)}`));
      await Deno.symlink(desiredSource, fullTargetPath);
      continue;
    }

    const fileInfo = await Deno.lstat(fullTargetPath);
    if (!fileInfo.isSymlink) {
      const shouldDeleteFile = confirm(
        `${
          colors.magenta(path)
        } already exists but is not a symlink...\nDelete file and recreate symlink?`,
      );
      if (shouldDeleteFile) {
        await Deno.remove(fullTargetPath);
        await Deno.symlink(desiredSource, fullTargetPath);
      } else {
        info('Skipping file');
        continue;
      }
    }

    const actualSource = await Deno.readLink(fullTargetPath);
    if (actualSource !== desiredSource) {
      const shouldDeleteFile = confirm(
        `${colors.magenta(path)} already exists but points to ${
          colors.magenta(actualSource)
        } instead of ${
          colors.magenta(desiredSource)
        }\nDelete file and recreate symlink?`,
      );
      if (shouldDeleteFile) {
        await Deno.remove(fullTargetPath);
        await Deno.symlink(desiredSource, fullTargetPath);
        info(`Deleted ${colors.magenta(path)} and replaced with new symlink`);
        continue;
      } else {
        info(`Skipping file ${colors.magenta(path)}`);
        continue;
      }
    }

    info(`${colors.magenta(path)} already exists and matches desired source`);
  }
}
