import { assert } from '@std/assert';
import { Table } from '@cliffy/table';

// Special invisible unicode character to use as field delimiter with fzf
const EN_SPACE = '\u2002';

/**
 * Common options for fzf-related functions
 *
 * @param extraArgs - Extra arguments to pass to the `fzf` process.  Check `man fzf` for available options.
 */
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
  return new TextDecoder()
    .decode(result.stdout)
    .split('\n')
    .filter((entry) => entry !== '');
}

/**
 * Options for `fzfTably`
 *
 * @param serializeToRow - Function to convert an entry to a row
 * @param header - Header to pass to FZF.  This should have as many values as there are "columns" from the serializeToRow function.
 */
type FzfOptsTable<T> = FzfOpts & {
  serializeToRow: (r: T) => string[];
  header?: string[];
};

/**
 * Utility function to present entries in a table and pick one with FZF
 *
 * @param entries - the list of entries to pass to FZF
 * @returns The selected item(s) chosen via FZF.
 */
export async function fzfTable<T>(
  entries: T[],
  opts: FzfOptsTable<T>,
): Promise<T[]> {
  const rows = entries.map(opts.serializeToRow).map((row, rowIndex) =>
    // prepend line with row index
    [rowIndex.toString(), ...row].map((value, index) => {
      // delimit fields with special space token
      return index === 0 ? value : `${EN_SPACE}${value}`;
    })
  );

  const table = new Table(...rows);
  if (opts.header) {
    table.header(['index', ...opts.header.map((m) => `${EN_SPACE}${m}`)]);
  }

  const extraArgs = opts?.extraArgs || [];
  extraArgs.push(
    ...[
      `--delimiter`,
      EN_SPACE,
      `--with-nth=2..`,
      ...(opts?.header ? ['--header-lines=1'] : []),
    ],
  );
  const lines = table.toString().split('\n');
  const selectedLines = await fzfLines(lines, { extraArgs });

  const selectedEntries: T[] = selectedLines.map((line) => {
    const indexStr = line.match(/^(?<index>\d+)/)?.groups?.index;
    assert(indexStr);
    const index = parseInt(indexStr);
    return entries[index];
  });

  return selectedEntries;
}
