;;; global-state --- Defines top-level emacs variable values
;;; Commentary:
;;; Code:

(load-file "~/.emacs.d/load-directory.el")
(require 'load-directory)
(load-directory "~/.emacs.d/themes")
(load-theme 'whiteboard)
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

(use-package fill-column-indicator)
(add-hook 'find-file-hook 'fci-mode)
(setq-default fci-rule-column 80)

(setq inhibit-startup-message t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default js-indent-level 2)
(setq x-select-enable t)
(global-linum-mode 1)
(delete-selection-mode t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(global-auto-revert-mode 1)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(add-hook 'find-file-hook 'global-kbd-mode)
(tool-bar-mode -1)
(add-to-list 'default-frame-alist '(font . "monaco-20" ))
(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))
(setq auto-save-default nil)
(setq org-log-done 'note)


(require 'org-gcal)
(setq org-gcal-client-id "373560261426-2flhceom34nmrck54ch9gvunnrmebart.apps.googleusercontent.com"
      org-gcal-client-secret (get-secret 'org-gcal-client-secret)
      org-gcal-file-alist '(("jonathan.lessinger@gmail.com" .  "~/.gcal-sync.org")))

(provide 'global-state)
;;; global-state.el ends here


