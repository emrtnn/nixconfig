;;; config.el -*- lexical-binding: t; -*-

;; Personal settings. Reload with `M-x doom/reload' (SPC h r r).

(setq doom-theme 'caelus              ; themes/caelus-theme.el
      doom-font (font-spec :family "Iosevka Nerd Font Mono" :size 18)
      display-line-numbers-type 'relative)

;; Cursor color per evil state, matching the modeline indicator.
(setq evil-normal-state-cursor   '(box "#ef934d")
      evil-insert-state-cursor   '(bar "#72ca68")
      evil-visual-state-cursor   '(box "#e28dc6")
      evil-replace-state-cursor  '(hbar "#f16e65")
      evil-operator-state-cursor '(hollow "#efbf71"))

;;; Editing
(setq scroll-margin 8
      evil-want-fine-undo t)

;;; LSP
(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable t
        lsp-inlay-hint-enable t
        lsp-enable-file-watchers nil)   ; big node_modules trees

  ;; Python: basedpyright (installed by Nix) instead of pyright.
  (setq lsp-pyright-langserver-command "basedpyright")

  ;; Solidity: vscode-solidity-server (Juan Blanco's, includes Solhint).
  (add-to-list 'lsp-language-id-configuration '(solidity-mode . "solidity"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("vscode-solidity-server" "--stdio"))
    :activation-fn (lsp-activate-on "solidity")
    :priority 1
    :server-id 'vscode-solidity)))

(add-hook 'solidity-mode-local-vars-hook #'lsp! 'append)

;;; Formatters (apheleia): same tools as nvim's conform.nvim
(after! apheleia
  (setf (alist-get 'biome apheleia-formatters)
        '("biome" "format" "--stdin-file-path" filepath))
  (dolist (mode '(js-ts-mode typescript-ts-mode tsx-ts-mode json-ts-mode css-ts-mode))
    (setf (alist-get mode apheleia-mode-alist) 'biome))
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'alejandra
        (alist-get 'nix-ts-mode apheleia-mode-alist) 'alejandra
        (alist-get 'alejandra apheleia-formatters) '("alejandra" "-q" "-")
        (alist-get 'solidity-mode apheleia-mode-alist) 'forge-fmt
        (alist-get 'forge-fmt apheleia-formatters) '("forge" "fmt" "--raw" "-")
        (alist-get 'python-mode apheleia-mode-alist) 'ruff
        (alist-get 'python-ts-mode apheleia-mode-alist) 'ruff))
