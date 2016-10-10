(load-file "~/.emacs.d/package_bootstrap.el")
(load-file "~/.emacs.d/global.el")
(load-file "~/.emacs.d/org-ext.el")

(use-package try)

 (use-package which-key
  :config (which-key-mode))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


(global-set-key (kbd "C-.") (lambda () (interactive) (next-line 5)))
(global-set-key (kbd "C-c i") (kbd "C-x h C-M-\\"))
(global-set-key (kbd "M-r") (lambda () (interactive) (revert-buffer)))
