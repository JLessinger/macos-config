(package-initialize)
(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)


(use-package try)

(use-package which-key
  :config (which-key-mode))

(setq inhibit-startup-message t)
(setq indent-tabs-mode nil)
(setq x-select-enable t)
(global-linum-mode 1)
(delete-selection-mode t)
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(global-auto-revert-mode 1)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(add-hook 'find-file-hook 'global-kbd-mode)
(tool-bar-mode -1)
