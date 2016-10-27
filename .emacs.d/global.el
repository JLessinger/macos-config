(load-file "~/.emacs.d/org-ext.el")

(setq inhibit-startup-message t)

(setq indent-tabs-mode nil)

(delete-selection-mode t)
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
(eval-after-load 'org
  (define-key org-mode-map (kbd "C-,") nil))


(global-set-key (kbd "C-,") 'backward-paragraph)
(global-set-key (kbd "C-.") 'forward-paragraph)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c i") (kbd "C-x h C-M-\\"))
(global-set-key (kbd "M-r") (lambda () (interactive) (revert-buffer)))

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
