import { assertEquals } from "@std/assert";
import { deepMerge, mergeAll, type JsonValue } from "./merge.ts";

Deno.test("deepMerge - merges simple objects", () => {
  const target = { a: 1, b: 2 };
  const source = { b: 3, c: 4 };
  const result = deepMerge(target, source);

  assertEquals(result, { a: 1, b: 3, c: 4 });
});

Deno.test("deepMerge - merges nested objects", () => {
  const target = { a: 1, b: { c: 2, d: 3 } };
  const source = { b: { d: 4, e: 5 }, f: 6 };
  const result = deepMerge(target, source);

  assertEquals(result, { a: 1, b: { c: 2, d: 4, e: 5 }, f: 6 });
});

Deno.test("deepMerge - concatenates arrays", () => {
  const target = { items: [1, 2, 3] };
  const source = { items: [4, 5, 6] };
  const result = deepMerge(target, source);

  assertEquals(result, { items: [1, 2, 3, 4, 5, 6] });
});

Deno.test("deepMerge - primitive values: source wins", () => {
  const target = { value: 10, name: "original" };
  const source = { value: 20 };
  const result = deepMerge(target, source);

  assertEquals(result, { value: 20, name: "original" });
});

Deno.test("deepMerge - null values", () => {
  const target = { a: 1, b: null };
  const source = { b: 2, c: null };
  const result = deepMerge(target, source);

  assertEquals(result, { a: 1, b: 2, c: null });
});

Deno.test("deepMerge - array replaces non-array", () => {
  const target = { value: 10 };
  const source = { value: [1, 2, 3] };
  const result = deepMerge(target, source);

  assertEquals(result, { value: [1, 2, 3] });
});

Deno.test("deepMerge - object replaces array", () => {
  const target = { value: [1, 2, 3] };
  const source = { value: { a: 1 } };
  const result = deepMerge(target, source);

  assertEquals(result, { value: { a: 1 } });
});

Deno.test("mergeAll - merges multiple values in order", () => {
  const values: JsonValue[] = [
    { a: 1, b: { c: 2 } },
    { b: { d: 3 }, e: 4 },
    { e: 5, f: 6 },
  ];
  const result = mergeAll(values);

  assertEquals(result, { a: 1, b: { c: 2, d: 3 }, e: 5, f: 6 });
});

Deno.test("mergeAll - handles empty array", () => {
  const result = mergeAll([]);

  assertEquals(result, {});
});

Deno.test("mergeAll - concatenates arrays across multiple objects", () => {
  const values: JsonValue[] = [
    { items: [1, 2] },
    { items: [3, 4] },
    { items: [5, 6] },
  ];
  const result = mergeAll(values);

  assertEquals(result, { items: [1, 2, 3, 4, 5, 6] });
});
