-- Marginalia: a printed page and one ultramarine pen.
--
-- All code is plain text in one colour. Keywords are bold.
-- The pen (blue) marks only comments, the cursor and links.
-- Red is for errors. Green and yellow appear only where a tool needs them:
-- diffs, git signs and warnings.

local M = {}

local function groups(p)
  local pen = { fg = p.accent, italic = true }
  local text = { fg = p.foreground }
  local bold = { fg = p.foreground, bold = true }

  return {
    -- Editor --------------------------------------------------------------
    Normal = { fg = p.foreground, bg = p.background },
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
    CursorLineNr = { fg = p.foreground, bold = true },
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
    TabLineSel = { fg = p.foreground, bg = p.background, bold = true },
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

    -- Syntax: one colour, keywords bold ---------------------------------
    Comment = pen,
    Constant = text,
    String = text,
    Character = text,
    Number = text,
    Boolean = text,
    Float = text,
    Identifier = text,
    Function = text,
    Statement = bold,
    Conditional = bold,
    Repeat = bold,
    Label = bold,
    Operator = text,
    Keyword = bold,
    Exception = bold,
    PreProc = bold,
    Include = bold,
    Define = bold,
    Macro = text,
    PreCondit = bold,
    Type = text,
    StorageClass = bold,
    Structure = bold,
    Typedef = bold,
    Special = text,
    SpecialChar = text,
    Tag = text,
    Delimiter = text,
    SpecialComment = pen,
    Debug = text,
    Underlined = { fg = p.accent, underline = true },
    Ignore = { fg = p.faint },
    Error = { fg = p.error },
    Todo = { fg = p.accent, bold = true, italic = true },

    -- Treesitter: most groups link to the syntax groups above by default.
    ["@variable"] = text,
    ["@variable.builtin"] = text,
    ["@constant.builtin"] = text,
    ["@module"] = text,
    ["@property"] = text,
    ["@punctuation"] = text,
    ["@keyword"] = bold,
    ["@keyword.function"] = bold,
    ["@keyword.return"] = bold,
    ["@keyword.operator"] = bold,
    ["@type.builtin"] = text,
    ["@function.builtin"] = text,
    ["@constructor"] = text,
    ["@tag"] = text,
    ["@tag.attribute"] = text,
    ["@tag.delimiter"] = text,
    ["@string.documentation"] = pen,
    ["@comment"] = pen,
    ["@comment.documentation"] = pen,
    ["@comment.todo"] = { fg = p.accent, bold = true, italic = true },
    ["@comment.note"] = { fg = p.accent, bold = true, italic = true },
    ["@comment.warning"] = { fg = p.warning, bold = true },
    ["@comment.error"] = { fg = p.error, bold = true },

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

    -- LSP semantic tokens bring their own colours otherwise.
    ["@lsp.type.comment"] = {},
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
