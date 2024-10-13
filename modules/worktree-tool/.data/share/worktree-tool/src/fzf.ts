import { assert } from '@std/assert';
import { Table } from '@cliffy/table';

export interface FzfOpts {
  extraArgs?: string[];
}

export async function fzfLines(input: string[], opts?: FzfOpts): Promise<string[]> {
  assert(input?.length > 0, `fzfExec input must be a non-empty array`);

  const command = new Deno.Command('fzf', {
    args: ['--reverse', '--multi', ...(opts?.extraArgs || [])],
    stdin: 'piped',
    stdout: 'piped',
  });

  const process = command.spawn();
  const writer = process.stdin.getWriter();
  writer.write(new TextEncoder().encode(input.join('\n')));
  writer.releaseLock();
  await process.stdin.close();
  const result = await process.output();
  return (new TextDecoder().decode(result.stdout)).split('\n').filter((entry) =>
    entry !== ''
  );
}

export async function fzfTable(input: string[][], opts?: FzfOpts): Promise<string[]> {
  const table = new Table(...input);
  return await fzfLines(table.toString().split('\n'), opts);
}
