{ lib }:

let
  # Each letter maps to a list of 6 strings (one per row).
  # Every row within a letter is the same visual width, padded with trailing spaces.
  alphabet = {
    "A" = [
      " █████╗ "
      "██╔══██╗"
      "███████║"
      "██╔══██║"
      "██║  ██║"
      "╚═╝  ╚═╝"
    ];
    "B" = [
      "██████╗ "
      "██╔══██╗"
      "██████╔╝"
      "██╔══██╗"
      "██████╔╝"
      "╚═════╝ "
    ];
    "C" = [
      " ██████╗"
      "██╔════╝"
      "██║     "
      "██║     "
      "╚██████╗"
      " ╚═════╝"
    ];
    "D" = [
      "██████╗ "
      "██╔══██╗"
      "██║  ██║"
      "██║  ██║"
      "██████╔╝"
      "╚═════╝ "
    ];
    "E" = [
      "███████╗"
      "██╔════╝"
      "█████╗  "
      "██╔══╝  "
      "███████╗"
      "╚══════╝"
    ];
    "F" = [
      "███████╗"
      "██╔════╝"
      "█████╗  "
      "██╔══╝  "
      "██║     "
      "╚═╝     "
    ];
    "G" = [
      " ██████╗ "
      "██╔════╝ "
      "██║  ███╗"
      "██║   ██║"
      "╚██████╔╝"
      " ╚═════╝ "
    ];
    "H" = [
      "██╗  ██╗"
      "██║  ██║"
      "███████║"
      "██╔══██║"
      "██║  ██║"
      "╚═╝  ╚═╝"
    ];
    "I" = [
      "██╗"
      "██║"
      "██║"
      "██║"
      "██║"
      "╚═╝"
    ];
    "J" = [
      "     ██╗"
      "     ██║"
      "     ██║"
      "██   ██║"
      "╚█████╔╝"
      " ╚════╝ "
    ];
    "K" = [
      "██╗  ██╗"
      "██║ ██╔╝"
      "█████╔╝ "
      "██╔═██╗ "
      "██║  ██╗"
      "╚═╝  ╚═╝"
    ];
    "L" = [
      "██╗     "
      "██║     "
      "██║     "
      "██║     "
      "███████╗"
      "╚══════╝"
    ];
    "M" = [
      "███╗   ███╗"
      "████╗ ████║"
      "██╔████╔██║"
      "██║╚██╔╝██║"
      "██║ ╚═╝ ██║"
      "╚═╝     ╚═╝"
    ];
    "N" = [
      "███╗   ██╗"
      "████╗  ██║"
      "██╔██╗ ██║"
      "██║╚██╗██║"
      "██║ ╚████║"
      "╚═╝  ╚═══╝"
    ];
    "O" = [
      " ██████╗ "
      "██╔═══██╗"
      "██║   ██║"
      "██║   ██║"
      "╚██████╔╝"
      " ╚═════╝ "
    ];
    "P" = [
      "██████╗ "
      "██╔══██╗"
      "██████╔╝"
      "██╔═══╝ "
      "██║     "
      "╚═╝     "
    ];
    "Q" = [
      " ██████╗ "
      "██╔═══██╗"
      "██║   ██║"
      "██║▄▄ ██║"
      "╚██████╔╝"
      " ╚══▀▀═╝ "
    ];
    "R" = [
      "██████╗ "
      "██╔══██╗"
      "██████╔╝"
      "██╔══██╗"
      "██║  ██║"
      "╚═╝  ╚═╝"
    ];
    "S" = [
      "███████╗"
      "██╔════╝"
      "███████╗"
      "╚════██║"
      "███████║"
      "╚══════╝"
    ];
    "T" = [
      "████████╗"
      "╚══██╔══╝"
      "   ██║   "
      "   ██║   "
      "   ██║   "
      "   ╚═╝   "
    ];
    "U" = [
      "██╗   ██╗"
      "██║   ██║"
      "██║   ██║"
      "██║   ██║"
      "╚██████╔╝"
      " ╚═════╝ "
    ];
    "V" = [
      "██╗   ██╗"
      "██║   ██║"
      "██║   ██║"
      "╚██╗ ██╔╝"
      " ╚████╔╝ "
      "  ╚═══╝  "
    ];
    "W" = [
      "██╗    ██╗"
      "██║    ██║"
      "██║ █╗ ██║"
      "██║███╗██║"
      "╚███╔███╔╝"
      " ╚══╝╚══╝ "
    ];
    "X" = [
      "██╗  ██╗"
      "╚██╗██╔╝"
      " ╚███╔╝ "
      " ██╔██╗ "
      "██╔╝ ██╗"
      "╚═╝  ╚═╝"
    ];
    "Y" = [
      "██╗   ██╗"
      "╚██╗ ██╔╝"
      " ╚████╔╝ "
      "  ╚██╔╝  "
      "   ██║   "
      "   ╚═╝   "
    ];
    "Z" = [
      "███████╗"
      "╚══███╔╝"
      "  ███╔╝ "
      " ███╔╝  "
      "███████╗"
      "╚══════╝"
    ];
    " " = [
      "   "
      "   "
      "   "
      "   "
      "   "
      "   "
    ];
  };

  trimRight =
    s:
    let
      m = builtins.match "(.*[^ ]) *" s;
    in
    if m == null then "" else builtins.head m;

  # Compute visual (display) width of a string by replacing all known
  # multi-byte characters with single-byte stand-ins.
  visualWidth =
    s:
    builtins.stringLength (
      builtins.replaceStrings
        [
          "█"
          "═"
          "║"
          "╔"
          "╗"
          "╚"
          "╝"
          "▀"
          "▄"
          "·"
        ]
        [
          "_"
          "_"
          "_"
          "_"
          "_"
          "_"
          "_"
          "_"
          "_"
          "_"
        ]
        s
    );

  rows = [
    0
    1
    2
    3
    4
    5
  ];

  renderBanner =
    {
      name,
      subtitle ? null,
    }:
    let
      upper = lib.toUpper name;
      chars = lib.stringToCharacters upper;

      glyphs = builtins.map (
        c:
        alphabet.${c}
          or (throw "ascii-banner: unsupported character '${c}' — only A-Z and space are supported")
      ) chars;

      composedRows = builtins.map (
        row: trimRight (lib.concatStrings (builtins.map (g: builtins.elemAt g row) glyphs))
      ) rows;

      artWidth = builtins.foldl' (
        acc: row:
        let
          w = visualWidth row;
        in
        if w > acc then w else acc
      ) 0 composedRows;

      subtitleLines =
        if subtitle == null then
          [ ]
        else
          let
            subtitleWidth = visualWidth subtitle;
            totalPadding = if artWidth > subtitleWidth then artWidth - subtitleWidth else 0;
            leftPad = totalPadding / 2;
            padding = lib.concatStrings (builtins.genList (_: " ") leftPad);
          in
          [ (padding + subtitle) ];

      allLines = composedRows ++ subtitleLines;
    in
    assert artWidth <= 72;
    lib.concatStringsSep "\n" allLines;
in
{
  inherit renderBanner;
}
