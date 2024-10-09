import { existsSync } from 'jsr:@std/fs@^1.0.4/exists';

interface SymlinkSource {
  workingDirectory: string;
  filepaths: string[];
}

export async function linkTargets(options: {
  source: SymlinkSource,
  targets: string[],
}): Promise<void> {
  for (const target of options.targets) {
    await linkTarget(options.source, target);
  }
}

async function linkTarget(source: SymlinkSource, target: string): Promise<void> {
  for (const path of source.filepaths) {
    const fullTargetPath = [target, path].join('/');

    if (existsSync(fullTargetPath)) {

    }
  }
}
