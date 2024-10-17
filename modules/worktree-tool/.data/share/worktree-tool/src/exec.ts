const { Command } = Deno;
import * as _ from '@es-toolkit';
import { indent } from './string-utils.ts';

type CommandOptions = ConstructorParameters<typeof Command>[1];

export async function execOutput(
  cmd: string,
  options?: CommandOptions,
): Promise<string> {
  const cmdOptions: CommandOptions = {
    stdout: 'piped',
    stderr: 'piped',
    ...options,
  };

  const command = new Command(cmd, cmdOptions);
  const result = await command.output();
  const stdout = new TextDecoder().decode(result.stdout).trim();

  if (!result.success) {
    const stderr = new TextDecoder().decode(result.stderr).trim();
    const fullCommand = [cmd, ...(cmdOptions?.args || [])].join(' ');
    const errorMessage = [
      `Failed to run command: ${fullCommand}`,
      `stdout:`,
      indent(stdout),
      `stderr:`,
      indent(stderr),
    ].join('\n');
    throw new Error(errorMessage);
  }

  return (new TextDecoder().decode(result.stdout)).trim();
}

export async function execLines(
  cmd: string,
  options?: CommandOptions,
): Promise<string[]> {
  return (await execOutput(cmd, options))
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => line !== '');
}
