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

(defun insert-current-datetime () (interactive)
       (insert (shell-command-to-string "echo -n $(date +%F_%T)")))

;;; Company, and Company backends.
(add-hook 'after-init-hook 'global-company-mode)
(eval-after-load 'company
  (progn
    '(add-to-list 'company-backends 'company-anaconda)))


(define-minor-mode global-kbd-mode
  :lighter " Global-kbd-mode"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-r") 'revert-all-buffers-no-confirm)
	    (define-key map (kbd "C-,") 'backward-paragraph)
	    (define-key map (kbd "C-.") 'forward-paragraph)
	    (define-key map (kbd "C-c i") (kbd "C-x h C-M-\\"))
	    (define-key map (kbd "M-l") 'goto-line)
	    (define-key map (kbd "M-g") 'ace-window)
	    (define-key map (kbd "M-r") (lambda () (interactive) (revert-buffer)))
            map))
