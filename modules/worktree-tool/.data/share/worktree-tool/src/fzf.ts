export async function fzfExec(input: string[]): Promise<string[]> {
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
  return (new TextDecoder().decode(result.stdout)).split('\n');
}
