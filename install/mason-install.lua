-- Headless installer used by `make lsp`:
--   nvim --headless -u vimrc -l install/mason-install.lua pkg1 pkg2 ...
local registry = require("mason-registry")

local refreshed, refresh_ok, refresh_err = false, false, nil
registry.refresh(function(ok, result)
  refreshed, refresh_ok, refresh_err = true, ok, result
end)
vim.wait(60000, function() return refreshed end, 100)
if not refresh_ok then
  print("could not load the Mason registry (network / GitHub API access?): " .. vim.inspect(refresh_err))
  os.exit(1)
end

local handles, failed = {}, {}
for _, name in ipairs(_G.arg) do
  local ok, pkg = pcall(registry.get_package, name)
  if not ok then
    failed[#failed + 1] = name .. " (unknown package)"
  elseif pkg:is_installed() then
    print("already installed: " .. name)
  else
    print("installing: " .. name)
    handles[name] = pkg:install()
  end
end

vim.wait(600000, function()
  for _, h in pairs(handles) do
    if not h:is_closed() then return false end
  end
  return true
end, 200)

for name in pairs(handles) do
  local ok, pkg = pcall(registry.get_package, name)
  if ok and not pkg:is_installed() then failed[#failed + 1] = name end
end
if #failed > 0 then
  print("failed: " .. table.concat(failed, ", "))
  os.exit(1)
end
print("all language servers installed")
