// Type definitions for JSON values
export type JsonValue = string | number | boolean | null | JsonObject | JsonArray;
export type JsonObject = { [key: string]: JsonValue };
export type JsonArray = JsonValue[];

/**
 * Deep merges two JSON values with the following rules:
 * - Arrays: concatenate (target + source)
 * - Objects: merge recursively
 * - Primitives: source overwrites target
 */
export function deepMerge(target: JsonValue, source: JsonValue): JsonValue {
  // Both are arrays: concatenate
  if (Array.isArray(target) && Array.isArray(source)) {
    return [...target, ...source];
  }

  // Source is not an object: source wins
  if (
    source === null ||
    typeof source !== "object" ||
    Array.isArray(source)
  ) {
    return source;
  }

  // Target is not an object: source replaces it
  if (
    target === null ||
    typeof target !== "object" ||
    Array.isArray(target)
  ) {
    return source;
  }

  // Both are objects: merge recursively
  const result: JsonObject = { ...target };

  for (const key in source) {
    if (key in result) {
      result[key] = deepMerge(result[key], (source as JsonObject)[key]);
    } else {
      result[key] = (source as JsonObject)[key];
    }
  }

  return result;
}

/**
 * Merges multiple JSON values in order (left to right)
 */
export function mergeAll(values: JsonValue[]): JsonValue {
  return values.reduce((acc, val) => deepMerge(acc, val), {});
}
