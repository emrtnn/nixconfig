-- Caelus: warm cream on near-black with a saturated orange accent.
-- Hand-written copy of home/themes/caelus.nix (keep in sync).
local lexers = vis.lexers

-- Start from the default theme for lexer-specific keys, then override.
dofile(package.searchpath("themes/default", package.path))

local c = {
	bg = "#0f0f0f",
	gray0 = "#141514", -- sunken: status/tab bars
	gray1 = "#1e1f1e", -- raised: cursor line
	gray2 = "#272a28",
	gray3 = "#3b403c", -- selection, borders
	gray4 = "#585f5b", -- line numbers
	gray5 = "#6c756f", -- disabled text
	gray6 = "#888e7b", -- comments
	gray7 = "#9a9c8b",
	gray8 = "#b6b69a", -- operators, punctuation
	gray9 = "#d9cdb5",
	fg = "#f4decd",

	orange = "#ef934d",
	orangeLight = "#f4b585",
	yellow = "#efbf71",
	red = "#f16e65",
	redLight = "#ef968f",
	green = "#72ca68",
	cyan = "#7ec9a3",
	blue = "#71b4d6",
	blueLight = "#b0d4e8",
	magenta = "#e28dc6",
}


local function fg(color, ...)
	return table.concat({ "fore:" .. color, ... }, ",")
end

lexers.STYLE_DEFAULT = fg(c.fg)
lexers.STYLE_NOTHING = ""
lexers.STYLE_IDENTIFIER = ""
lexers.STYLE_WHITESPACE = fg(c.gray2)
lexers.STYLE_ATTRIBUTE = fg(c.cyan)
lexers.STYLE_CLASS = fg(c.cyan)
lexers.STYLE_COMMENT = fg(c.gray6, "italics")
lexers.STYLE_CONSTANT = fg(c.magenta)
lexers.STYLE_CONSTANT_BUILTIN = fg(c.magenta, "bold")
lexers.STYLE_DEFINITION = fg(c.yellow)
lexers.STYLE_ERROR = fg(c.red)
lexers.STYLE_FUNCTION = fg(c.yellow)
lexers.STYLE_FUNCTION_BUILTIN = fg(c.yellow, "italics")
lexers.STYLE_FUNCTION_METHOD = fg(c.yellow)
lexers.STYLE_HEADING = fg(c.orange, "bold")
lexers.STYLE_KEYWORD = fg(c.orange)
lexers.STYLE_LABEL = fg(c.orange)
lexers.STYLE_NUMBER = fg(c.magenta)
lexers.STYLE_OPERATOR = fg(c.gray8)
lexers.STYLE_REGEX = fg(c.orangeLight)
lexers.STYLE_STRING = fg(c.green)
lexers.STYLE_PREPROCESSOR = fg(c.orangeLight)
lexers.STYLE_TAG = fg(c.orange)
lexers.STYLE_TYPE = fg(c.cyan)
lexers.STYLE_TYPE_BUILTIN = fg(c.cyan, "italics")
lexers.STYLE_VARIABLE = fg(c.fg)
lexers.STYLE_VARIABLE_BUILTIN = fg(c.redLight)
lexers.STYLE_EMBEDDED = fg(c.orangeLight)
lexers.STYLE_ANNOTATION = fg(c.cyan)

-- UI
lexers.STYLE_LINENUMBER = fg(c.gray4)
lexers.STYLE_LINENUMBER_CURSOR = fg(c.orange, "bold")
lexers.STYLE_CURSOR = fg(c.bg, "back:" .. c.gray8)
lexers.STYLE_CURSOR_PRIMARY = fg(c.bg, "back:" .. c.orange)
lexers.STYLE_CURSOR_LINE = "back:" .. c.gray1
lexers.STYLE_COLOR_COLUMN = "back:" .. c.gray1
lexers.STYLE_SELECTION = "back:" .. c.gray3
lexers.STYLE_STATUS = fg(c.gray5, "back:" .. c.gray0)
lexers.STYLE_STATUS_FOCUSED = fg(c.gray9, "back:" .. c.gray0)
lexers.STYLE_SEPARATOR = fg(c.gray3)
lexers.STYLE_INFO = fg(c.fg, "bold")
lexers.STYLE_EOF = fg(c.gray3)

-- Diff
lexers.STYLE_ADDITION = fg(c.green)
lexers.STYLE_DELETION = fg(c.red)
lexers.STYLE_CHANGE = fg(c.yellow)

-- Keys the default theme derives from the core styles above
lexers.STYLE_PROPERTY = fg(c.blueLight)
lexers.STYLE_TAG_UNKNOWN = lexers.STYLE_TAG .. ",italics"
lexers.STYLE_TAG_SINGLE = lexers.STYLE_TAG
lexers.STYLE_TAG_DOCTYPE = lexers.STYLE_TAG .. ",bold"
lexers.STYLE_ATTRIBUTE_UNKNOWN = lexers.STYLE_ATTRIBUTE .. ",italics"
lexers.STYLE_COMMAND = lexers.STYLE_KEYWORD
lexers.STYLE_COMMAND_SECTION = lexers.STYLE_CLASS
lexers.STYLE_ENVIRONMENT = lexers.STYLE_TYPE
lexers.STYLE_ENVIRONMENT_MATH = lexers.STYLE_NUMBER
for i = 1, 6 do
	lexers["STYLE_HEADING_H" .. i] = lexers.STYLE_HEADING
end
lexers.STYLE_LIST = fg(c.orange)
lexers.STYLE_LINK = fg(c.blue, "underlined")
lexers.STYLE_REFERENCE = fg(c.blueLight)
lexers.STYLE_CODE = fg(c.green)
lexers.STYLE_MODULE = fg(c.blue)
