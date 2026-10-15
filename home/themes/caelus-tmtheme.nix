{pkgs}:
# TextMate theme generated from the shared palette, with the same syntax roles
# as dotfiles/nvim/colors/caelus.lua. Reused by bat, Yazi previews and tuicr.
let
  inherit (pkgs) lib;
  c = import ./caelus.nix;
  esc = lib.escapeXML;

  # [scope settings] pairs, applied in order (later rules win on ties).
  rules = [
    [
      "comment, punctuation.definition.comment"
      {
        foreground = c.gray6;
        fontStyle = "italic";
      }
    ]
    ["string, punctuation.definition.string" {foreground = c.green;}]
    ["string.regexp, constant.character.escape, constant.other.placeholder" {foreground = c.orangeLight;}]
    ["constant.numeric, constant.language, constant.character, constant.other, support.constant" {foreground = c.magenta;}]
    ["keyword, storage, storage.type, storage.modifier, keyword.control" {foreground = c.orange;}]
    ["keyword.operator, punctuation.separator, punctuation.terminator, punctuation.accessor" {foreground = c.gray8;}]
    ["keyword.operator.word, keyword.operator.new, keyword.operator.logical.python" {foreground = c.orange;}]
    ["punctuation, meta.brace, punctuation.section, punctuation.definition.block" {foreground = c.gray8;}]
    ["entity.name.function, support.function, meta.function-call entity.name.function, variable.function" {foreground = c.yellow;}]
    ["entity.name.type, entity.name.class, entity.name.struct, entity.name.enum, entity.other.inherited-class, support.type, support.class, storage.type.primitive" {foreground = c.cyan;}]
    ["entity.name.namespace, entity.name.module, support.module, meta.import entity.name" {foreground = c.blue;}]
    [
      "variable.parameter, meta.parameter variable"
      {
        foreground = c.gray9;
        fontStyle = "italic";
      }
    ]
    ["variable.language, support.variable, variable.other.constant.builtin" {foreground = c.redLight;}]
    ["variable.other.member, variable.other.property, meta.property-name, support.type.property-name, entity.name.label" {foreground = c.blueLight;}]
    ["variable.other.constant, entity.name.constant" {foreground = c.magenta;}]
    ["entity.name.tag" {foreground = c.orange;}]
    ["entity.other.attribute-name" {foreground = c.yellow;}]
    ["meta.decorator, meta.annotation, entity.name.function.decorator, punctuation.decorator" {foreground = c.cyan;}]
    ["entity.name.function.preprocessor, meta.preprocessor, keyword.control.import, keyword.control.directive" {foreground = c.orangeLight;}]
    [
      "markup.heading, entity.name.section, punctuation.definition.heading"
      {
        foreground = c.orange;
        fontStyle = "bold";
      }
    ]
    ["markup.bold" {fontStyle = "bold";}]
    ["markup.italic" {fontStyle = "italic";}]
    ["markup.underline.link, string.other.link, markup.link" {foreground = c.blue;}]
    ["markup.raw, markup.inline.raw, markup.fenced_code" {foreground = c.green;}]
    [
      "markup.quote"
      {
        foreground = c.gray7;
        fontStyle = "italic";
      }
    ]
    ["markup.list punctuation.definition.list" {foreground = c.orange;}]
    ["markup.inserted, meta.diff.header.to-file, punctuation.definition.inserted" {foreground = c.green;}]
    ["markup.deleted, meta.diff.header.from-file, punctuation.definition.deleted" {foreground = c.red;}]
    ["markup.changed, punctuation.definition.changed" {foreground = c.yellow;}]
    ["meta.diff.range, meta.diff.header" {foreground = c.blue;}]
    [
      "invalid, invalid.illegal"
      {
        foreground = c.red;
        fontStyle = "underline";
      }
    ]
    [
      "invalid.deprecated"
      {
        foreground = c.yellow;
        fontStyle = "underline";
      }
    ]
  ];

  dict = attrs:
    "<dict>"
    + lib.concatStrings (lib.mapAttrsToList (k: v: "<key>${esc k}</key><string>${esc v}</string>") attrs)
    + "</dict>";
  rule = r: "<dict><key>scope</key><string>${esc (builtins.elemAt r 0)}</string><key>settings</key>${dict (builtins.elemAt r 1)}</dict>";
in
  pkgs.writeText "caelus.tmTheme" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0"><dict>
    <key>name</key><string>Caelus</string>
    <key>semanticClass</key><string>theme.dark.caelus</string>
    <key>settings</key><array>
    <dict><key>settings</key>${dict {
      background = c.bg;
      foreground = c.fg;
      caret = c.orange;
      selection = c.gray3;
      lineHighlight = c.gray1;
      gutter = c.bg;
      gutterForeground = c.gray4;
      findHighlight = c.orangeTint;
      invisibles = c.gray3;
    }}</dict>
    ${lib.concatMapStringsSep "\n" rule rules}
    </array></dict></plist>
  ''
