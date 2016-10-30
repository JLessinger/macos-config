(use-package try)

(use-package which-key
  :config (which-key-mode))

(load-file "~/.emacs.d/org-ext.el")

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

(add-hook 'find-file-hook (lambda () (linum-mode 1)))

(defun eshell/clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
	(revert-buffer t t t) )))
  (message "Refreshed open files.") )

(defun revert-all-buffers-no-confirm ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
	(revert-buffer t t) )))
  (message "Refreshed open files."))

;;; Company, and Company backends.
(add-hook 'after-init-hook 'global-company-mode)
(eval-after-load 'company
  (progn
    '(add-to-list 'company-backends 'company-anaconda)))

(global-set-key (kbd "C-,") 'backward-paragraph)
(global-set-key (kbd "C-.") 'forward-paragraph)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c i") (kbd "C-x h C-M-\\"))
(global-set-key (kbd "M-r") (lambda () (interactive) (revert-buffer)))
