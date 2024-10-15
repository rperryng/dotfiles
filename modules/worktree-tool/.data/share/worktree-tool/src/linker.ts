import * as log from '@std/log';
import { existsSync } from '@std/fs';
import { join } from '@std/path';

// TODO: colors?

export interface SymlinkSource {
  workingDirectory: string;
  filepaths: string[];
}

const logger = log.getLogger();

export async function linkTargets(options: {
  source: SymlinkSource;
  targets: string[];
}): Promise<void> {
  for (const targetDirectory of options.targets) {
    logger.info(`Analyzing target directory: ${targetDirectory}`);
    await linkTarget(options.source, targetDirectory);
  }
}

async function linkTarget(
  source: SymlinkSource,
  targetDirectory: string,
): Promise<void> {
  for (const path of source.filepaths) {
    logger.info(`checking ${path}`);
    const desiredSource = join(source.workingDirectory, path);
    const fullTargetPath = join(targetDirectory, path);

    if (!existsSync(fullTargetPath)) {
      logger.info(`target does not exist yet, creating ${fullTargetPath}`);
      await Deno.symlink(desiredSource, fullTargetPath);
      continue;
    }

    const fileInfo = await Deno.lstat(fullTargetPath);
    if (!fileInfo.isSymlink) {
      const shouldDeleteFile = confirm(
        `${fullTargetPath} already exists but is not a symlink...\nDelete file and recreate symlink?`,
      );
      if (shouldDeleteFile) {
        await Deno.remove(fullTargetPath);
        await Deno.symlink(desiredSource, fullTargetPath);
      } else {
        logger.info('Skipping file');
        continue;
      }
    }

    const actualSource = await Deno.readLink(fullTargetPath);
    if (actualSource !== desiredSource) {
      const shouldDeleteFile = confirm(
        `${fullTargetPath} already exists but points to ${actualSource} instead of ${desiredSource}\nDelete file and recreate symlink?`,
      );
      if (shouldDeleteFile) {
        await Deno.remove(fullTargetPath);
        await Deno.symlink(desiredSource, fullTargetPath);
        console.log(`Deleted ${fullTargetPath} and replaced with new symlink`);
        continue;
      } else {
        logger.info(`Skipping file ${fullTargetPath}`);
        continue;
      }
    }

    logger.info('Symlink already exists and matches desired source');
  }
}
