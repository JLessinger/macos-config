(defun eshell/clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(defun revert-all-buffers (confirm)
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)))
        (revert-buffer t (if confirm nil t) t))))
  (message "Refreshed open files."))

(defun insert-current-datetime () (interactive)
       (insert (shell-command-to-string "echo -n $(date +%F_%T)")))

;;; Company, and Company backends.
(add-hook 'after-init-hook 'global-company-mode)
(eval-after-load 'company
  (progn
    '(add-to-list 'company-backends 'company-anaconda)))

(defvar global-kbd-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-r") (lambda (interactive) (revert-all-buffers nil)))
    (define-key map (kbd "C-,") (lambda () (interactive) (next-line -8)))
    (define-key map (kbd "C-.") (lambda () (interactive) (next-line 8)))
    (define-key map (kbd "C-c i") (kbd "C-x h C-M-\\"))
    (define-key map (kbd "C-c d") 'insert-current-datetime)
    (define-key map (kbd "M-l") 'goto-line)
    (define-key map (kbd "M-g") 'ace-window)
    (define-key map (kbd "C-c s") 'replace-string)
    (define-key map (kbd "C-c r") 'replace-regexp)
    (define-key map (kbd "M-`") (lambda () (interactive) (other-window 1)))
    (define-key map (kbd "C-z") (kbd "C-x u"))
    (define-key map (kbd "M-~") (lambda () (interactive) (other-window -1)))
    (define-key map (kbd "M-r") (lambda () (interactive) (revert-buffer)))
    (define-key map (kbd "M-s M-s") 'ace-swap-window)
    (define-key map (kbd "M-o a") 'org-agenda)
    (define-key map (kbd "M-q") (kbd "C-g"))
    (define-key map (kbd "<escape>") (kbd "M-q"))
    (define-key map (kbd "C-M-,") 'shrink-window-horizontally)
    (define-key map (kbd "C-M-.") 'enlarge-window-horizontally)
    (define-key map (kbd "C-M-<") 'shrink-window)
    (define-key map (kbd "C-M->") 'enlarge-window)
    map))

(define-minor-mode global-kbd-mode
  :lighter " Global-kbd-mode")
