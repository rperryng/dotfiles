# merge-jsonc

A Deno-based CLI tool for deep-merging multiple JSONC files from a directory into a single JSON output.

## Features

- **Deep merge**: Recursively merges nested objects
- **Array concatenation**: Arrays from multiple files are concatenated in order
- **Lexicographic ordering**: Files are processed in sorted order by filename
- **JSONC support**: Supports comments and trailing commas
- **Validation**: Validates output is valid JSON before writing
- **Clear errors**: Fails loudly with context on parse errors

## Installation

The tool is distributed as a compiled binary with no runtime dependencies.

Add the `.local/bin/` directory to your PATH, or invoke directly:

```bash
./modules/merge-jsonc/.local/bin/merge-jsonc <directory>
```

**Note:** The binary must be compiled first (see Development section).

## Usage

```bash
merge-jsonc <directory>
```

Reads all `*.jsonc` files from `<directory>` (sorted), deep merges them, and outputs JSON to stdout.

### Example

```bash
# Directory structure:
# config/
#   01-base.jsonc
#   02-overrides.jsonc

merge-jsonc config/ > merged.json
```

## Merge Behavior

- **Objects**: Merged recursively (keys from later files override/extend)
- **Arrays**: Concatenated (all elements from all files, in order)
- **Primitives**: Later files win (overwrite earlier values)

### Examples

**Object merging:**
```jsonc
// 01.jsonc
{"a": 1, "b": {"c": 2}}

// 02.jsonc
{"b": {"d": 3}, "e": 4}

// Result
{"a": 1, "b": {"c": 2, "d": 3}, "e": 4}
```

**Array concatenation:**
```jsonc
// 01.jsonc
{"items": [1, 2]}

// 02.jsonc
{"items": [3, 4]}

// Result
{"items": [1, 2, 3, 4]}
```

**Primitive override:**
```jsonc
// 01.jsonc
{"port": 3000, "host": "localhost"}

// 02.jsonc
{"port": 8080}

// Result
{"port": 8080, "host": "localhost"}
```

## Development

Built with Deno.

**Run tests:**
```bash
cd modules/merge-jsonc/unstowed
deno task test
```

**Compile binary:**
```bash
cd modules/merge-jsonc/unstowed
deno task compile
```

This creates a standalone executable at `modules/merge-jsonc/.local/bin/merge-jsonc`.

## Requirements

- **Runtime**: None (standalone binary)
- **Development**: Deno 1.40+
