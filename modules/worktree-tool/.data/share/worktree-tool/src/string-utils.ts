export function indent(s: string, opts?: {
  char?: string;
  size?: number;
}): string {
  const char = opts?.char ?? ' ';
  const size = opts?.size ?? 2;
  const indent = Array(size).fill(char).join('');
  return s.split('\n').map((line) => `${indent}${line}`).join('');
}
