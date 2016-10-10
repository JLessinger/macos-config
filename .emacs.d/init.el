;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(load-file "~/.emacs.d/package_bootstrap.el")
(load-file "~/.emacs.d/org-ext.el")
(load-file "~/.emacs.d/global.el")

(use-package try)

(use-package which-key
  :config (which-key-mode))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))





