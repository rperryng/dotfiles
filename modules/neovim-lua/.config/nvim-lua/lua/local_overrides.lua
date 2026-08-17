-- Machine-local overrides not tracked in this repo.
--
-- Any *.lua file dropped in <config>-local/ (e.g. ~/.config/nvim-lua-local/)
-- is sourced here, letting a single machine extend the config without
-- committing anything. Missing dir => no-op.
--
-- This lives outside the auto-loaded `local/` dir on purpose so it can be
-- required explicitly as the LAST thing in init.lua — after plugins and all
-- `local/` modules — so overrides can safely reference anything above them.

for _, file in
  ipairs(vim.fn.glob(vim.fn.stdpath('config') .. '-local/*.lua', false, true))
do
  local ok, err = pcall(dofile, file)
  if not ok then
    vim.notify(
      'Error loading local override ' .. file .. ':\n' .. err,
      vim.log.levels.ERROR
    )
  end
end
