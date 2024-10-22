return {
  { 'tpope/vim-rsi' },
  { 'tpope/vim-eunuch' },
  {
    'tpope/vim-projectionist',
    config = function()
      vim.keymap.set('n', '<space>A', function()
        vim.cmd('A')
      end, { desc = 'Open alternate file'} )
    end,
    init = function()
      vim.g.projectionist_heuristics = {
        ['Gemfile.lock|*.gemspec'] = {
          ['*.rb'] = {
            type = 'source',
            alternate = 'spec/{}_spec.rb',
          },
          ['spec/*_spec.rb'] = {
            alternate = '{}.rb',
            type = 'test',
          },
        },
        ['package.json|deno.json|deno.jsonc'] = {
          ['package.json'] = {
            type = 'package',
            alternate = { 'yarn.lock', 'package-lock.json' },
          },
          ['package-lock.json'] = {
            alternate = 'package.json',
          },
          ['yarn.lock'] = {
            alternate = 'package.json',
          },
          ['deno.json|deno.jsonc'] = {
            type = 'package',
            alternate = 'deno.lock',
          },
          ['deno.lock'] = {
            alternate = { 'deno.jsonc', 'deno.json' },
          },
          ['src/*.ts'] = {
            type = 'source',
            alternate = {
              'src/{}.test.ts',
              'src/{}_test.ts',
              'src/{}.spec.ts',
              'test/{}.test.ts',
              'test/{}.spec.ts',
            },
          },
          ['src/*.test.ts'] = {
            type = 'test',
            alternate = { 'src/{}.ts' },
          },
          ['src/*_test.ts'] = {
            type = 'test',
            alternate = { 'src/{}.ts' },
          },
          ['src/*.spec.ts'] = {
            type = 'test',
            alternate = 'src/{}.ts',
          },
          ['src/*.tsx'] = {
            type = 'source',
            alternate = {
              'src/{}.test.tsx',
              'src/{}.spec.tsx',
              'test/{}.test.tsx',
              'test/{}.spec.tsx',
            },
          },
          ['src/*.test.tsx'] = {
            type = 'test',
            alternate = 'src/{}.tsx',
          },
          ['src/*.spec.tsx'] = {
            type = 'test',
            alternate = 'src/{}.tsx',
          },
        },
        ['pom.xml'] = {
          ['src/main/java/*.java'] = {
            type = 'source',
            alternate = 'src/test/java/{}Test.java',
          },
          ['src/test/java/*Test.java'] = {
            type = 'test',
            alternate = 'src/main/java/{}.java',
          },
          ['src/main/kotlin/*.kt'] = {
            type = 'source',
            alternate = 'src/test/kotlin/{}Test.kt',
          },
          ['src/test/kotlin/*Test.kt'] = {
            type = 'test',
            alternate = 'src/main/kotlin/{}.kt',
          },
        },
      }
    end,
  },
}
