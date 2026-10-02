{pkgs}:
# Community TextMate port linked by the upstream Oxocarbon ports catalog.
# Reused by bat, Yazi previews and tuicr syntax highlighting.
pkgs.fetchurl {
  url = "https://gitlab.com/boydkelly/carbonizer/-/raw/09876beded0ff8b2769c86fc9940864e1c3224a5/bat/oxocarbon-dark.tmTheme";
  hash = "sha256-izx0Niy+6f8ERmQcScsbmymro4AnsU0bCRLvG/bdMy8=";
}
