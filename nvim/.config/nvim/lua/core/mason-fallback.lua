-- M.install(pkg_name, on_ready)
--   Ensures a Mason package is installed, then calls on_ready() (scheduled).
--   No-op with a warning if the package name is unknown to Mason.
local M = {}
function M.install(pkg_name, on_ready)
  local reg = require("mason-registry")
  reg.refresh(function()
    if not reg.has_package(pkg_name) then
      vim.notify(("Mason: no package '%s'"):format(pkg_name), vim.log.levels.WARN)
      return
    end
    local pkg = reg.get_package(pkg_name)
    if pkg:is_installed() then
      vim.schedule(on_ready)
      return
    end
    vim.notify(("Mason: installing '%s'…"):format(pkg_name), vim.log.levels.INFO)
    pkg:install({}, function(success)
      vim.schedule(function()
        if success then
          vim.notify(("Mason: '%s' installed"):format(pkg_name), vim.log.levels.INFO)
          on_ready()
        else
          vim.notify(("Mason: '%s' install failed"):format(pkg_name), vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end
return M
