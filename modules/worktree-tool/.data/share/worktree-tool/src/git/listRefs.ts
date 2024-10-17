import { execLines, execOutput } from '../exec.ts';
import { assert } from '@std/assert';
import { z } from 'zod';

// unique space character to use as delimiter
const EN_SPACE = '\u2002';

// Values are field name expressions (see 'FIELD NAMES' in 'man git-for-each-ref')
const GIT_REF_FIELDNAME_BY_PROPERTYNAME: Record<string, string> = {
  refName: 'refname',
  objectType: 'objecttype',
  sha: 'objectname',
  head: 'HEAD',
  author: 'authorname',
  email: 'authoremail',
  committerDate: 'committerdate:iso8601',
  message: 'subject',
};
const GIT_FOR_EACH_REF_FORMAT: string = Object.entries(
  GIT_REF_FIELDNAME_BY_PROPERTYNAME,
)
  .map(([propName, gitFieldName]) => {
    return `@@@${propName}:%(${gitFieldName})@@@`;
  })
  .join(EN_SPACE);

const GIT_FOR_EACH_REF_PATTERN: RegExp = Object.entries(
  GIT_REF_FIELDNAME_BY_PROPERTYNAME,
)
  .map(([propName]) => {
    return new RegExp(`@@@${propName}:(?<${propName}>.+)@@@`);
  })
  .reduce((acc, fieldRegex) =>
    new RegExp(acc.source + '\u{2002}' + fieldRegex.source, 'u')
  );

export const RefTypeEnum = z.enum(['local_branch', 'remote_branch', 'tag']);
export type RefType = z.infer<typeof RefTypeEnum>;

const GitRefSchema = z.object({
  refName: z.string(),
  friendlyName: z.string(),
  sha: z.string(),
  refType: RefTypeEnum,
  objectType: z.string(),
  author: z.string(),
  email: z.string(),
  committerDate: z.coerce.date(),
  message: z.string(),
});
export type Ref = z.infer<typeof GitRefSchema>;

function parseRef(line: string): Ref {
  const match = GIT_FOR_EACH_REF_PATTERN.exec(line)?.groups;
  assert(match, `Failed to parse git "for-each-ref" output: ${line}`);

  const { refName } = match;
  let refType: RefType;
  let friendlyName: string;
  if (refName.startsWith('refs/heads/')) {
    refType = 'local_branch';
    friendlyName = refName.replace('refs/heads/', '');
  } else if (refName.startsWith('refs/remotes/')) {
    refType = 'remote_branch';
    friendlyName = refName.replace('refs/remotes/', '');
  } else if (refName.startsWith('refs/tags')) {
    refType = 'tag';
    friendlyName = refName;
  } else {
    throw new Error(`Failed to parse refType from refName: ${refName}`);
  }

  return GitRefSchema.parse({
    ...match,
    refType,
    friendlyName,
  });
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

  const refs: Ref[] = lines
    .filter((line) => {
      // TODO Make this smarter
      return !line.includes('refs/remotes/fork') && !line.includes('refs/stash');
    })
    .map(parseRef);
  return refs;
}
