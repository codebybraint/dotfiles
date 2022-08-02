local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

-- local tabnine_status_ok, _ = pcall(require, "user.tabnine")
-- if not tabnine_status_ok then
--   return
-- end

local lspkind_status_ok, lspkind = pcall(require, "lspkind")
if not lspkind_status_ok then
    return
end
require("luasnip/loaders/from_vscode").lazy_load()

local compare = require "cmp.config.compare"

local check_backspace = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = " ",
  Method = " m",
  Function = " ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = " ",
  Interface = " ",
  Module = " ",
  Property = " ",
  Unit = " ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
}

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	-- cmp_tabnine = "[TN]",
	path = "[Path]",
}

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
-- vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

cmp.setup {
    snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },

    mapping = cmp.mapping.preset.insert {
        -- ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        -- ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }), --currently i use Ctrl+j for split pane
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif check_backspace() then
            -- cmp.complete()
            fallback()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),  
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    -- format = function(entry, vim_item)
    --   -- NOTE: order matters
    --     vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
    --     vim_item.menu = ({
    --             buffer = "[buf]",
    --             nvim_lsp = "[LSP]",
    --             nvim_lua = "[api]",
    --             path = "[path]",
    --             luasnip = "[snip]",
    --             cmp_tabnine = "[tN]",
    --             copilot = "[copilot]",
    --         })
    --     [entry.source.name]
    --   return vim_item
    -- end,
    format = lspkind.cmp_format({
      mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
      maxwidth = 40, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      before = function(entry, vim_item)
        vim_item.kind = string.format("%s %s", vim_item.kind, kind_icons[vim_item.kind])
        local menu = source_mapping[entry.source.name]
        if entry.source.name == "cmp_tabnine" then
          if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
            menu = entry.completion_item.data.detail .. " " .. menu
          end
          vim_item.kind = ""
        end
        vim_item.menu = menu

        return vim_item
      end,
    }),
  },
  sources = {
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
    },
    { name = "cmp_tabnine" },
    { name = "nvim_lua" },
    { name = "luasnip", group_index = 2 },
    { name = "buffer", keyword_length = 5, group_index = 2 },
    { name = "path", group_index = 2 },
    { name = "emoji", group_index = 2 },
    { name = "lab.quick_data", keyword_length = 4, group_index = 2 },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
          compare.offset,
          compare.exact,
          compare.score,
          compare.recently_used,
          compare.locality,
          compare.sort_text,
          compare.length,
          compare.order,
    },
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

