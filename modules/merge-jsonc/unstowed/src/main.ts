import { parse as parseJsonc } from "@std/jsonc";
import { expandGlob } from "@std/fs";
import { resolve } from "@std/path";
import { mergeAll, type JsonValue } from "./merge.ts";

/**
 * Expands tilde (~) in paths to HOME directory
 */
function expandTilde(path: string): string {
  if (path.startsWith("~/")) {
    const home = Deno.env.get("HOME");
    if (!home) {
      throw new Error("HOME environment variable not set");
    }
    return path.replace("~", home);
  }
  return path;
}

/**
 * Reads and parses all .jsonc files from a directory
 */
async function loadJsoncFiles(directory: string): Promise<JsonValue[]> {
  const absoluteDir = resolve(expandTilde(directory));

  // Verify directory exists
  try {
    const stat = await Deno.stat(absoluteDir);
    if (!stat.isDirectory) {
      throw new Error(`${absoluteDir} is not a directory`);
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    throw new Error(`Cannot access directory ${absoluteDir}: ${message}`);
  }

  // Discover .jsonc files
  const files: Array<{ path: string; name: string }> = [];

  try {
    for await (const entry of expandGlob(`${absoluteDir}/*.jsonc`)) {
      if (entry.isFile) {
        files.push({
          path: entry.path,
          name: entry.name,
        });
      }
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    throw new Error(`Error reading directory ${absoluteDir}: ${message}`);
  }

  if (files.length === 0) {
    throw new Error(`No .jsonc files found in ${absoluteDir}`);
  }

  // Sort files lexicographically
  files.sort((a, b) => a.name.localeCompare(b.name));

  console.error(`Found ${files.length} file(s):`);
  files.forEach((f) => console.error(`  - ${f.name}`));

  // Parse each file
  const parsed: JsonValue[] = [];

  for (const file of files) {
    try {
      const content = await Deno.readTextFile(file.path);
      const data = parseJsonc(content) as JsonValue;
      parsed.push(data);
      console.error(`✓ Parsed ${file.name}`);
    } catch (error) {
      console.error(`✗ Error parsing ${file.name}:`);
      console.error(`   File: ${file.path}`);
      const message = error instanceof Error ? error.message : String(error);
      console.error(`   ${message}`);
      throw error;
    }
  }

  return parsed;
}

/**
 * Main CLI entrypoint
 */
async function main() {
  if (Deno.args.length !== 1) {
    console.error("Usage: merge-jsonc <directory>");
    console.error("Example: merge-jsonc ~/.config/settings");
    Deno.exit(1);
  }

  const inputDir = Deno.args[0];

  try {
    console.error(`Reading JSONC files from: ${inputDir}`);

    const values = await loadJsoncFiles(inputDir);
    const merged = mergeAll(values);

    console.error(`✓ Merged ${values.length} file(s)`);

    // Validate and output
    const output = JSON.stringify(merged, null, 2);
    console.log(output);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`\nError: ${message}`);
    Deno.exit(1);
  }
}

// Run if this is the main module
if (import.meta.main) {
  main();
}
