import { execLines } from './exec.ts';
import { assert } from '@std/assert';
import { z } from 'zod';
import * as log from '@std/log';

// see: `man git-for-each-ref` (FIELD NAMES)
const GIT_FOR_EACH_REF_FORMAT =
  `%(refname) @objecttype:%(objecttype)@ @sha:%(objectname)@ @author:%(authorname)@ @email:%(authoremail)@ @committerdate:%(committerdate:iso8601)@ %(objecttype)`;
const GIT_FOR_EACH_REF_REGEX =
  /^(?<refName>[\w\/\-_]+) @objecttype:(?<objectType>.+)@ @sha:(?<sha>.+)@ @author:(?<author>.+)@ @email:<(?<email>.+)>@ @committerdate:(?<committerDate>.+)@/;

export const RefTypeEnum = z.enum(['local', 'remote']);
export type RefType = z.infer<typeof RefTypeEnum> | undefined;
export interface Ref {
  sha: string;
  objectType: string,
  type: string;
  refName: string;
  refType: RefType;
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
  log.debug(`got line:\n${lines.join('\n')}`);

  const refs: Ref[] = lines.map((line) => {
    const { refName, sha, objectType, author, email, committerDate } =
      line.match(GIT_FOR_EACH_REF_REGEX)?.groups ?? {};
    assert(
      refName && sha && objectType && author && email && committerDate,
      `Failed to parse fields for: ${line}`,
    );

    let refType: RefType = undefined;
    if (refName.startsWith('refs/heads')) {
      refType = 'local';
    } else if (refName.startsWith('refs/remote')) {
      refType = 'remote';
    }

    return {
      sha,
      refName,
      objectType,
      author,
      email,
      refType,
      committerDate: new Date(committerDate),
    };
  });
  return refs;
}
