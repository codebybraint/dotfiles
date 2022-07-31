local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

local tabnine_status_ok, _ = pcall(require, "user.tabnine")
if not tabnine_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()


--local check_backspace = function()
  --local col = vim.fn.col "." - 1
  --return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
--end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "text ",
  Method = "methhod m",
  Function = "function ",
  Constructor = "constructor ",
  Field = "field ",
  Variable = "variable ",
  Class = "class ",
  Interface = "interface ",
  Module = "module ",
  Property = "property ",
  Unit = "unit ",
  Value = "value ",
  Enum = "enum ",
  Keyword = "keyword ",
  Snippet = "snippet ",
  Color = "color ",
  File = "file ",
  Reference = "reference ",
  Folder = "folder ",
  EnumMember = "enum member ",
  Constant = "constant ",
  Struct = "struct ",
  Event = "event ",
  Operator = "operator ",
  TypeParameter = "type parameter ",
}

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      -- NOTE: order matters
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        vim_item.menu = ({
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
                cmp_tabnine = "[tN]",
                copilot = "[copilot]",
            })
        [entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "crates", group_index = 1 },
    {
      name = "nvim_lsp",
      filter = function(entry, ctx)
        -- vim.pretty_print()
        local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
                -- vim.bo.filetype
        if kind == "Snippet" and ctx.prev_context.filetype == "java" then
          return true
        end
      end,
      group_index = 2,
    },
    { name = "nvim_lua", group_index = 2 },
    { name = "copilot", keyword_length = 1, group_index = 2 },
    { name = "luasnip", group_index = 2 },
    { name = "buffer", keyword_length = 5, group_index = 2 },
    { name = "cmp_tabnine", group_index = 2 },
    { name = "path", group_index = 2 },
    { name = "emoji", group_index = 2 },
    { name = "lab.quick_data", keyword_length = 4, group_index = 2 },
  },
  sorting = {
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = false,
    completion = {
      border = "rounded",
      winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  experimental = {
    ghost_text = true,
  },
}

