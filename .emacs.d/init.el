
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(load-file "~/.emacs.d/local_lisp/global.el")

(use-package try)

(use-package which-key
  :config (which-key-mode))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(org-agenda-files
   (quote
    ("~/Documents/notes/money.org" "~/Documents/notes/shared-notes/sh_main.org" "~/Documents/notes/main.org")))
 '(package-selected-packages
   (quote
    (which-key use-package try org-bullets org haskell-mode haskell-emacs company-jedi company-anaconda buffer-move auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
