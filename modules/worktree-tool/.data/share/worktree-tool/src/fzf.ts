import { assert } from '@std/assert';
import { Table } from '@cliffy/table';

// Special invisible unicode character to use as field delimiter with fzf
const EN_SPACE = '\u2002';

export interface FzfOpts {
  extraArgs?: string[];
}

export interface IconLine {
  icon: string;
  line: string;
}
export async function fzfLines(
  input: string[],
  opts?: FzfOpts,
): Promise<string[]> {
  assert(input?.length > 0, `fzfExec input must be a non-empty array`);

  const command = new Deno.Command('fzf', {
    args: ['--reverse', ...(opts?.extraArgs || [])],
    stdin: 'piped',
    stdout: 'piped',
  });

  const process = command.spawn();
  const writer = process.stdin.getWriter();
  writer.write(new TextEncoder().encode(input.join('\n')));
  writer.releaseLock();
  await process.stdin.close();
  const result = await process.output();
  return (new TextDecoder().decode(result.stdout))
    .split('\n')
    .filter((entry) => entry !== '');
}

export async function fzfTable<T>(
  entries: T[],
  opts: FzfOpts & {
    serializeToRow: (r: T) => string[];
  },
): Promise<T[]> {
  const rows = entries
    .map(opts.serializeToRow)
    .map((row, rowIndex) =>
      // prepend line with row index
      [rowIndex.toString(), ...row].map((value, index) => {
        // delimit fields with special space token
        return index === 0 ? value : `${EN_SPACE}${value}`;
      })
    );

  const table = new Table(...rows);

  const extraArgs = opts?.extraArgs || [];
  extraArgs.push(...[
    `--delimiter`,
    EN_SPACE,
    '--nth=2..',
    `--with-nth=2..`,
  ]);
  const lines = table.toString().split('\n');
  const selectedLines = await fzfLines(lines, { extraArgs });

  const selectedEntries: T[] = selectedLines.map(
    (line) => {
      const indexStr = line.match(/^(?<index>\d+)/)?.groups?.index;
      assert(indexStr);
      const index = parseInt(indexStr);
      return entries[index];
    },
  );

  return selectedEntries;
}

const ICON_LINE_PATTERN = /^(?<icon>[^\s+]) (?<restOfLine>.+)$/;
export function parseIconLine(selection: string[]): IconLine[] {
  const processedLines = selection.map((line) => {
    const { icon, restOfLine } = line.match(ICON_LINE_PATTERN)?.groups ?? {};
    assert(icon && restOfLine, `Couldn't uniconify line: ${line}`);
    return {
      icon,
      line: restOfLine,
    };
  });
  return processedLines;
}
