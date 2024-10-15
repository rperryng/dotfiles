import { execLines, execOutput } from './exec.ts';
import { assert } from '@std/assert';
import { z } from 'zod';

// see: `man git-for-each-ref` (FIELD NAMES)
const GIT_FOR_EACH_REF_FORMAT =
  `%(refname) @objecttype:%(objecttype)@ @sha:%(objectname)@ @author:%(authorname)@ @email:%(authoremail)@ @committerdate:%(committerdate:iso8601)@ %(objecttype)`;
const GIT_FOR_EACH_REF_REGEX =
  /^(?<refName>[\w\/\-_]+) @objecttype:(?<objectType>.+)@ @sha:(?<sha>.+)@ @author:(?<author>.+)@ @email:<(?<email>.+)>@ @committerdate:(?<committerDate>.+)@/;

export const RefTypeEnum = z.enum(['local_branch', 'remote_branch', 'tag']);
export type RefType = z.infer<typeof RefTypeEnum>;
export interface Ref {
  sha: string;
  objectType: string;
  refType: RefType;
  refName: string;
  friendlyName: string;
  author: string;
  email: string;
  committerDate: Date;
}

export async function forEachRef(options?: {
  refPattern?: string;
}): Promise<Ref[]> {
  const refPattern = options?.refPattern;
  const lines = await execLines('git', {
    args: [
      'for-each-ref',
      `--format=${GIT_FOR_EACH_REF_FORMAT}`,
      ...(refPattern ? [refPattern] : []),
    ],
  });

  const refs: Ref[] = lines.map((line) => {
    const { refName, sha, objectType, author, email, committerDate } =
      line.match(GIT_FOR_EACH_REF_REGEX)?.groups ?? {};
    assert(
      refName && sha && objectType && author && email && committerDate,
      `Failed to parse fields for: ${line}`,
    );

    const match = refName.match(
      /^(?<refPrefix>refs\/heads\/|refs\/remotes\/|refs\/tags\/)(?<friendlyName>.+)/,
    );
    assert(match && match.groups, `Failed to parse refName: ${refName}`);
    const { refPrefix, friendlyName } = match.groups;
    let refType: RefType;
    if (refPrefix === 'refs/heads/') {
      refType = 'local_branch';
    } else if (refPrefix === 'refs/remotes/') {
      refType = 'remote_branch';
    } else if (refPrefix === 'refs/tags/') {
      refType = 'tag';
    } else {
      throw new Error(`Failed to parse refType from refName: ${refName}`);
    }

    return {
      sha,
      refName,
      refType,
      friendlyName,
      objectType,
      author,
      email,
      committerDate: new Date(committerDate),
    };
  });
  return refs;
}

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
  const { owner, repo } =
    remote.match(/git@github\.com:(?<owner>[\w\-_]+)\/(?<repo>[\w\-_]+)\.git/)
      ?.groups ?? {};
  assert(
    owner && repo,
    `Failed to parse owner and repo from remote url: ${remote}`,
  );
  return {
    owner,
    repo,
  };
}
