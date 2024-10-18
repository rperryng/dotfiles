export function indent(s: string, opts?: {
  char?: string;
  size?: number;
}): string {
  const char = opts?.char ?? ' ';
  const size = opts?.size ?? 2;
  const indent = Array(size).fill(char).join('');
  return s.split('\n').map((line) => `${indent}${line}`).join('');
}

const ELLIPSIS = '…';
export function truncateString(s: string, opts?: {
  length?: number;
  trailingCharacter?: string;
}): string {
  const length = opts?.length ?? 60;
  const trailingCharacter = opts?.trailingCharacter ?? ELLIPSIS;
  if (s.length < length) {
    return s;
  }
  return `${s.slice(0, length - 1)}${trailingCharacter}`;
}
