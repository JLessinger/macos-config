(setq inhibit-startup-message t)
(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")))


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(set (setq use-package-always-ensure t)

(use-package try
  :ensure t)

 (use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(global-set-key (kbd "C-,") (lambda () (interactive) (next-line -5)))
(global-set-key (kbd "C-.") (lambda () (interactive) (next-line 5)))
(global-set-key (kbd "C-c i") (kbd "C-x h C-M-\\"))
(global-set-key (kbd "M-r") (lambda () (interactive) (revert-buffer)))

(defun eshell/clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))


(delete-selection-mode t)
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/.autocom/ac-dict")
(ac-config-default)
(global-linum-mode 1)
(add-hook 'c-mode-common-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

(add-hook 'after-init-hook '(lambda () (delete-other-frames)))

(require 'install)

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install-downloads/")
(my-load-all-in-directory auto-install-directory)

(add-hook 'text-mode-hook
          '(lambda ()
             (setq indent-tabs-mode t)
             (setq tab-width 4)
             (setq indent-line-function (quote insert-tab))))

(put 'downcase-region 'disabled nil)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)
