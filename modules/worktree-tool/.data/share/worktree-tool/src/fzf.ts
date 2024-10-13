import { assert } from '@std/assert';

export async function fzfExec(input: string[]): Promise<string[]> {
  assert(input?.length > 0, `fzfExec input must be a non-empty array`);

  const command = new Deno.Command('fzf', {
    args: ['--reverse', '--multi'],
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
