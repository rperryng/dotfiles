const { Command } = Deno;

type CommandOptions = ConstructorParameters<typeof Command>[1];

export async function execOutput(
  cmd: string,
  options?: CommandOptions,
): Promise<string> {
  const cmdOptions: CommandOptions = {
    stdout: "piped",
    stderr: "piped",
    ...options,
  };

  const command = new Command(cmd, cmdOptions);
  const result = await command.output();

  if (!result.success) {
    console.error();
    throw new Error([
      `Failed to run command: ${[cmd, ...(cmdOptions?.args || [])].join(" ")}`,
      new TextDecoder().decode(result.stderr),
    ].join("\n"));
  }

  return new TextDecoder().decode(result.stdout);
}

export async function execLines(
  cmd: string,
  options?: CommandOptions,
): Promise<string[]> {
  return (await execOutput(cmd, options))
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line !== "");
}
