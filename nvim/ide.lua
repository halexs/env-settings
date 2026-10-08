-- env-settings: Neovim IDE layer (Neovim 0.11+), loaded from vimrc after the
-- plugins are on the runtimepath. Everything is wrapped in pcall, so a plugin
-- that has not been installed yet (`make vim-plugins`) never breaks startup.

local function setup(name, opts)
  local ok, mod = pcall(require, name)
  if ok and type(mod.setup) == "function" then mod.setup(opts or {}) end
  return ok
end

-- ---------------------------------------------------------------------------
-- Language servers
-- ---------------------------------------------------------------------------
-- mason.nvim downloads servers (`make lsp`); nvim-lspconfig supplies the
-- per-server defaults; vim.lsp.enable() turns each one on when its binary exists.
setup("mason")

local servers = {
  "lua_ls", "pyright", "ruff", "ts_ls", "bashls", "jsonls", "yamlls", "html", "cssls",
}

vim.lsp.config("*", { root_markers = { ".git" } })
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } }, telemetry = { enable = false } } },
})

for _, name in ipairs(servers) do
  local cfg = vim.lsp.config[name]
  local cmd = cfg and cfg.cmd
  if type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1 then
    vim.lsp.enable(name)
  end
end

vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.INFO] = "i",
      [vim.diagnostic.severity.HINT] = "·",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("EnvLsp", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "References")
    map("gi", vim.lsp.buf.implementation, "Implementation")
    map("K", vim.lsp.buf.hover, "Hover docs")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
    map("<leader>x", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
    map("<leader>dd", vim.diagnostic.open_float, "Line diagnostics")
    map("<leader>dl", vim.diagnostic.setloclist, "Diagnostics to location list")
    map("[e", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
    map("]e", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
    -- Built-in completion popup, triggered while typing; <C-Space> forces it.
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      map("<C-Space>", vim.lsp.completion.get, "Trigger completion", "i")
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Claude Code (coder/claudecode.nvim): the same protocol the VS Code extension
-- uses, so Claude sees your open file/selection and proposes edits as diffs.
-- Needs the `claude` CLI on PATH (`make claude`).
-- ---------------------------------------------------------------------------
setup("snacks", { terminal = { enabled = true } })
setup("claudecode", {
  terminal = {
    split_side = "right",
    split_width_percentage = 0.40,
  },
  diff_opts = { vertical_split = true },
})

local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { desc = desc }) end
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", "Claude: toggle")
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", "Claude: focus")
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", "Claude: resume")
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", "Claude: continue")
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", "Claude: select model")
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", "Claude: add current buffer")
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", "Claude: send selection")
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", "Claude: accept diff")
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", "Claude: deny diff")
-- NERDTree: add the file under the cursor to Claude's context.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nerdtree",
  callback = function(ev)
    vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",
      { buffer = ev.buf, desc = "Claude: add file" })
  end,
})

-- ---------------------------------------------------------------------------
-- Discoverability: press <Space> and wait to see what is available.
-- ---------------------------------------------------------------------------
if setup("which-key", { delay = 400 }) then
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({
      { "<leader>a", group = "Claude / AI" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>w", group = "windows" },
      { "<leader>d", group = "diagnostics" },
    })
  end
end
