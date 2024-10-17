import { assert } from '@std/assert';
import { execOutput } from '../exec.ts';

export async function getRemote(): Promise<string> {
  return await execOutput('git', {
    args: ['ls-remote', '--get-url', 'origin'],
  });
}

export interface OwnerRepo {
  owner: string;
  repo: string;
}

export async function getOwnerRepo(): Promise<OwnerRepo> {
  const remote = await getRemote();
  const { owner, repo } = remote.match(/git@github\.com:(?<owner>[\w\-_]+)\/(?<repo>[\w\-_]+)\.git/)
    ?.groups ?? {};
  assert(
    owner && repo,
    `Failed to parse owner and repo from remote url: ${remote}`
  );
  return {
    owner,
    repo,
  };
}

