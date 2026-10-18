-- Marginalia: a printed page and one ultramarine pen.
--
-- Code is plain text. Colour goes only to what is easy to miss:
-- the pen (blue) marks comments, the cursor and links; strings are green;
-- numbers and constants are violet. Definitions are bold. Red is for errors.

local M = {}

---@class marginalia.Config
---@field transparent? boolean No background in the editor, so the terminal background shows through. Floating windows keep theirs.
local config = {
  transparent = false,
}

---@param opts? marginalia.Config
function M.setup(opts)
  config = vim.tbl_extend("force", config, opts or {})
end

local function groups(p)
  -- nil leaves the background empty.
  local page = not config.transparent and p.background or nil

  local pen = { fg = p.accent, italic = true }
  local text = { fg = p.foreground }
  local bold = { fg = p.foreground, bold = true }
  local def = bold
  local str = { fg = p.string }
  local const = { fg = p.constant }
  local punct = { fg = p.muted }

  return {
    -- Editor --------------------------------------------------------------
    Normal = { fg = p.foreground, bg = page },
    NormalNC = { link = "Normal" },
    NormalFloat = { fg = p.foreground, bg = p.surface },
    FloatBorder = { fg = p.border, bg = p.surface },
    FloatTitle = { fg = p.foreground, bg = p.surface, bold = true },
    Cursor = { fg = p.background, bg = p.accent },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { link = "Cursor" },
    CursorLine = { bg = p.surface },
    CursorColumn = { bg = p.surface },
    ColorColumn = { bg = p.surface },
    -- The pen marks the line you are on, so cursorlineopt = "number" is enough.
    CursorLineNr = { fg = p.accent, bold = true },
    LineNr = { fg = p.faint },
    SignColumn = {},
    FoldColumn = { fg = p.faint },
    Folded = { fg = p.muted, bg = p.surface },
    NonText = { fg = p.faint },
    Whitespace = { fg = p.border },
    EndOfBuffer = { fg = p.background },
    Conceal = { fg = p.muted },
    WinSeparator = { fg = p.border },
    VertSplit = { link = "WinSeparator" },
    StatusLine = { fg = p.foreground, bg = p.surface },
    StatusLineNC = { fg = p.muted, bg = p.surface },
    WinBar = { fg = p.foreground, bold = true },
    WinBarNC = { fg = p.muted },
    TabLine = { fg = p.muted, bg = p.surface },
    TabLineFill = { bg = p.surface },
    TabLineSel = { fg = p.foreground, bg = page, bold = true },
    Title = bold,
    Directory = { fg = p.accent },
    Visual = { bg = p.selection },
    VisualNOS = { link = "Visual" },
    Search = { fg = p.foreground, bg = p.search },
    CurSearch = { fg = p.foreground, bg = p.search_current },
    IncSearch = { link = "CurSearch" },
    Substitute = { link = "CurSearch" },
    MatchParen = { bg = p.selection, bold = true },
    QuickFixLine = { bg = p.selection },

    Pmenu = { fg = p.foreground, bg = p.surface },
    PmenuSel = { bg = p.selection },
    PmenuKind = { fg = p.muted, bg = p.surface },
    PmenuExtra = { fg = p.muted, bg = p.surface },
    PmenuSbar = { bg = p.surface },
    PmenuThumb = { bg = p.border },
    PmenuMatch = { fg = p.accent, bg = p.surface, bold = true },
    PmenuMatchSel = { fg = p.accent, bg = p.selection, bold = true },
    WildMenu = { link = "PmenuSel" },

    ModeMsg = { fg = p.foreground, bold = true },
    MsgArea = text,
    MoreMsg = { fg = p.accent },
    Question = { fg = p.accent },
    ErrorMsg = { fg = p.error },
    WarningMsg = { fg = p.warning },

    SpellBad = { undercurl = true, sp = p.error },
    SpellCap = { undercurl = true, sp = p.warning },
    SpellLocal = { undercurl = true, sp = p.accent },
    SpellRare = { undercurl = true, sp = p.accent },

    -- Syntax -------------------------------------------------------------
    -- Colour only what is easy to miss: comments, strings, constants.
    -- Keywords stay plain: their shape is enough. Definitions are bold,
    -- so the structure of a file shows. Punctuation steps back.
    Comment = pen,
    SpecialComment = pen,
    Todo = { fg = p.accent, bold = true, italic = true },
    String = str,
    Character = str,
    Constant = const,
    Number = const,
    Boolean = const,
    Float = const,
    Identifier = text,
    Function = text,
    Statement = text,
    Conditional = text,
    Repeat = text,
    Label = text,
    Operator = text,
    Keyword = text,
    Exception = text,
    PreProc = text,
    Include = text,
    Define = text,
    Macro = text,
    PreCondit = text,
    Type = text,
    StorageClass = text,
    Structure = text,
    Typedef = text,
    Special = text,
    SpecialChar = str,
    Tag = text,
    Delimiter = punct,
    Debug = text,
    Underlined = { fg = p.accent, underline = true },
    Ignore = { fg = p.faint },
    Error = { fg = p.error },

    -- Treesitter: most groups link to the syntax groups above by default.
    ["@comment"] = pen,
    ["@comment.documentation"] = pen,
    ["@string.documentation"] = pen,
    ["@comment.todo"] = { fg = p.accent, bold = true, italic = true },
    ["@comment.note"] = { fg = p.accent, bold = true, italic = true },
    ["@comment.warning"] = { fg = p.warning, bold = true },
    ["@comment.error"] = { fg = p.error, bold = true },

    ["@string"] = str,
    ["@string.escape"] = str,
    ["@string.regexp"] = str,
    ["@string.special"] = str,
    ["@string.special.url"] = { fg = p.accent, underline = true },
    ["@character"] = str,

    -- Only values are violet. A name in capitals is still a name.
    ["@constant"] = text,
    ["@constant.builtin"] = const,
    ["@number"] = const,
    ["@number.float"] = const,
    ["@boolean"] = const,

    -- @function is a definition; calls have their own groups.
    ["@function"] = def,
    ["@function.method"] = def,
    ["@function.call"] = text,
    ["@function.method.call"] = text,
    ["@function.builtin"] = text,
    ["@function.macro"] = text,
    ["@constructor"] = text,
    ["@type.definition"] = def,
    ["@type"] = text,
    ["@type.builtin"] = text,

    ["@variable"] = text,
    ["@variable.builtin"] = text,
    ["@variable.parameter"] = text,
    ["@variable.member"] = text,
    ["@property"] = text,
    ["@module"] = text,
    ["@label"] = text,
    ["@keyword"] = text,
    ["@operator"] = text,
    ["@punctuation"] = punct,
    ["@punctuation.bracket"] = punct,
    ["@punctuation.delimiter"] = punct,
    ["@punctuation.special"] = punct,

    ["@tag"] = text,
    ["@tag.builtin"] = text,
    ["@tag.attribute"] = text,
    ["@tag.delimiter"] = punct,

    ["@markup.heading"] = bold,
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.quote"] = { fg = p.muted, italic = true },
    ["@markup.raw"] = text,
    ["@markup.list"] = text,
    ["@markup.link"] = { fg = p.accent },
    ["@markup.link.url"] = { fg = p.accent, underline = true },
    ["@markup.link.label"] = { fg = p.accent },

    ["@diff.plus"] = { fg = p.success },
    ["@diff.minus"] = { fg = p.error },
    ["@diff.delta"] = { fg = p.warning },

    -- LSP semantic tokens link to the treesitter groups by default. Clear the
    -- ones that would make every call bold or hide treesitter comments.
    ["@lsp.type.comment"] = {},
    ["@lsp.type.function"] = {},
    ["@lsp.type.method"] = {},
    LspReferenceText = { bg = p.surface },
    LspReferenceRead = { bg = p.surface },
    LspReferenceWrite = { bg = p.surface, underline = true },
    LspInlayHint = { fg = p.muted },
    LspSignatureActiveParameter = { bold = true, underline = true },
    LspCodeLens = { fg = p.muted },

    -- Diagnostics ---------------------------------------------------------
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warning },
    DiagnosticInfo = { fg = p.accent },
    DiagnosticHint = { fg = p.muted },
    DiagnosticOk = { fg = p.success },
    DiagnosticUnderlineError = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.warning },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.accent },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.muted },
    DiagnosticUnderlineOk = { undercurl = true, sp = p.success },
    DiagnosticUnnecessary = { fg = p.muted },
    DiagnosticDeprecated = { strikethrough = true },

    -- Diff and git ----------------------------------------------------------
    DiffAdd = { bg = p.diff_added },
    DiffDelete = { fg = p.error, bg = p.diff_removed },
    DiffChange = { bg = p.diff_changed },
    DiffText = { bg = p.diff_text },
    Added = { fg = p.success },
    Changed = { fg = p.warning },
    Removed = { fg = p.error },
    diffAdded = { link = "Added" },
    diffChanged = { link = "Changed" },
    diffRemoved = { link = "Removed" },
    GitSignsAdd = { link = "Added" },
    GitSignsChange = { link = "Changed" },
    GitSignsDelete = { link = "Removed" },
  }
end

function M.load()
  local p = require("marginalia.palette")[vim.o.background == "light" and "light" or "dark"]

  vim.cmd("highlight clear")
  if vim.g.syntax_on then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "marginalia"

  for name, spec in pairs(groups(p)) do
    vim.api.nvim_set_hl(0, name, spec)
  end

  for i, c in ipairs(p.ansi) do
    vim.g["terminal_color_" .. (i - 1)] = c
  end
end

return M
