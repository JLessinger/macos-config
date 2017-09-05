(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(require 'org)
(require 'org-id)

(eval-after-load 'org
  '(progn
    (define-key org-mode-map (kbd "C-,") nil)
    (define-key org-mode-map (kbd "C-c l") 'org-store-link)
    ))

(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
   (setq org-todo-keywords
	 '((sequence "TODO" "AWAIT" "|" "DONE")))

(setq org-highest-priority ?0)
(setq org-lowest-priority ?9)
(setq org-default-priority ?5)
(setq org-enforce-todo-dependencies 't)

(defun eos/org-custom-id-get (&optional pom create prefix)
  "Get the CUSTOM_ID property of the entry at point-or-marker POM.
   If POM is nil, refer to the entry at point. If the entry does
   not have an CUSTOM_ID, the function returns nil. However, when
   CREATE is non nil, create a CUSTOM_ID if none is present
   already. PREFIX will be passed through to `org-id-new'. In any
   case, the CUSTOM_ID of the entry is returned."
  (interactive)
  (org-with-point-at pom
    (let ((id (org-entry-get nil "CUSTOM_ID")))
      (cond
       ((and id (stringp id) (string-match "\\S-" id))
        id)
       (create
        (setq id (org-id-new (concat prefix "h")))
        (org-entry-put pom "CUSTOM_ID" id)
        (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
        id)))))

(defun eos/org-add-ids-to-headlines-in-file ()
  "Add CUSTOM_ID properties to all headlines in the current
   file which do not already have one. Only adds ids if the
   `auto-id' option is set to `t' in the file somewhere. ie,
   #+OPTIONS: auto-id:t"
  (interactive)
  (save-excursion
    (widen)
    (goto-char (point-min))
    (when (re-search-forward "^#\\+OPTIONS:.*auto-id:t" (point-max) t)
      (org-map-entries (lambda () (eos/org-custom-id-get (point) 'create))))))

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
;; automatically add ids to saved org-mode headlines
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'before-save-hook
                      (lambda ()
                        (when (and (eq major-mode 'org-mode)
                                   (eq buffer-read-only nil))
                          (eos/org-add-ids-to-headlines-in-file))))))

;; drawer visibility
(defalias 'org-cycle-hide-drawers 'lawlist-block-org-cycle-hide-drawers)

(defun lawlist-block-org-cycle-hide-drawers (state)
  "Re-hide all drawers, footnotes or html blocks after a visibility state change."
  (when
    (and
      (derived-mode-p 'org-mode)
      (not (memq state '(overview folded contents))))
    (save-excursion
      (let* (
          (globalp (memq state '(contents all)))
          (beg (if globalp (point-min) (point)))
          (end
            (cond
              (globalp
                (point-max))
              ((eq state 'children)
                (save-excursion (outline-next-heading) (point)))
              (t (org-end-of-subtree t)) )))
        (goto-char beg)
        (while
          (re-search-forward
            ".*\\[fn\\|^\\#\\+BEGIN_SRC.*$\\|^[ \t]*:PROPERTIES:[ \t]*$" end t)
          (lawlist-org-flag t))))))

(defalias 'org-cycle-internal-local 'lawlist-block-org-cycle-internal-local)

(defun lawlist-block-org-cycle-internal-local ()
  "Do the local cycling action."
  (let ((goal-column 0) eoh eol eos has-children children-skipped struct)
    (save-excursion
      (if (org-at-item-p)
        (progn
          (beginning-of-line)
          (setq struct (org-list-struct))
          (setq eoh (point-at-eol))
          (setq eos (org-list-get-item-end-before-blank (point) struct))
          (setq has-children (org-list-has-child-p (point) struct)))
        (org-back-to-heading)
        (setq eoh (save-excursion (outline-end-of-heading) (point)))
        (setq eos (save-excursion (1- (org-end-of-subtree t t))))
        (setq has-children
          (or
            (save-excursion
              (let ((level (funcall outline-level)))
                (outline-next-heading)
                (and
                  (org-at-heading-p t)
                  (> (funcall outline-level) level))))
            (save-excursion
              (org-list-search-forward (org-item-beginning-re) eos t)))))
      (beginning-of-line 2)
      (if (featurep 'xemacs)
        (while
            (and
              (not (eobp))
              (get-char-property (1- (point)) 'invisible))
          (beginning-of-line 2))
        (while
            (and
              (not (eobp))
              (get-char-property (1- (point)) 'invisible))
          (goto-char (next-single-char-property-change (point) 'invisible))
          (and
            (eolp)
            (beginning-of-line 2))))
      (setq eol (point)))
    (cond
      ((= eos eoh)
        (unless (org-before-first-heading-p)
          (run-hook-with-args 'org-pre-cycle-hook 'empty))
        (org-unlogged-message "EMPTY ENTRY")
        (setq org-cycle-subtree-status nil)
        (save-excursion
          (goto-char eos)
          (outline-next-heading)
          (if (outline-invisible-p)
            (org-flag-heading nil))))
      ((and
          (or
            (>= eol eos)
            (not (string-match "\\S-" (buffer-substring eol eos))))
          (or
            has-children
            (not (setq children-skipped
              org-cycle-skip-children-state-if-no-children))))
        (unless (org-before-first-heading-p)
          (run-hook-with-args 'org-pre-cycle-hook 'children))
        (if (org-at-item-p)
          ;; then
          (org-list-set-item-visibility (point-at-bol) struct 'children)
          ;; else
          (org-show-entry)
          (org-with-limited-levels (show-children))
          (when (eq org-cycle-include-plain-lists 'integrate)
            (save-excursion
              (org-back-to-heading)
              (while (org-list-search-forward (org-item-beginning-re) eos t)
                (beginning-of-line 1)
                (let* (
                    (struct (org-list-struct))
                    (prevs (org-list-prevs-alist struct))
                    (end (org-list-get-bottom-point struct)))
                  (mapc (lambda (e) (org-list-set-item-visibility e struct 'folded))
                    (org-list-get-all-items (point) struct prevs))
                  (goto-char (if (< end eos) end eos)))))))
        (org-unlogged-message "CHILDREN")
        (save-excursion
          (goto-char eos)
          (outline-next-heading)
          (if (outline-invisible-p)
            (org-flag-heading nil)))
        (setq org-cycle-subtree-status 'children)
        (unless (org-before-first-heading-p)
          (run-hook-with-args 'org-cycle-hook 'children)))
      ((or
          children-skipped
          (and
            (eq last-command this-command)
            (eq org-cycle-subtree-status 'children)))
        (unless (org-before-first-heading-p)
          (run-hook-with-args 'org-pre-cycle-hook 'subtree))
        (outline-flag-region eoh eos nil)
        (org-unlogged-message
        (if children-skipped
          "SUBTREE (NO CHILDREN)"
          "SUBTREE"))
        (setq org-cycle-subtree-status 'subtree)
        (unless (org-before-first-heading-p)
          (run-hook-with-args 'org-cycle-hook 'subtree)))
      ((eq org-cycle-subtree-status 'subtree)
        (org-show-subtree)
        (message "ALL")
        (setq org-cycle-subtree-status 'all))
      (t
        (run-hook-with-args 'org-pre-cycle-hook 'folded)
        (outline-flag-region eoh eos t)
        (org-unlogged-message "FOLDED")
        (setq org-cycle-subtree-status 'folded)
        (unless (org-before-first-heading-p)
        (run-hook-with-args 'org-cycle-hook 'folded))))))

(defun lawlist-org-flag (flag)
  "When FLAG is non-nil, hide any of the following:  html code block;
footnote; or, the properties drawer.  Otherwise make it visible."
  (save-excursion
    (beginning-of-line 1)
    (cond
      ((looking-at ".*\\[fn")
        (let* (
          (begin (match-end 0))
          end-footnote)
          (if (re-search-forward "\\]"
                (save-excursion (outline-next-heading) (point)) t)
            (progn
              (setq end-footnote (point))
              (outline-flag-region begin end-footnote flag))
            (user-error "Error beginning at point %s." begin))))
      ((looking-at "^\\#\\+BEGIN_SRC.*$\\|^[ \t]*:PROPERTIES:[ \t]*$")
        (let* ((begin (match-end 0)))
          (if (re-search-forward "^\\#\\+END_SRC.*$\\|^[ \t]*:END:"
                (save-excursion (outline-next-heading) (point)) t)
            (outline-flag-region begin (point-at-eol) flag)
            (user-error "Error beginning at point %s." begin)))))))

(defun lawlist-toggle-block-visibility ()
"For this function to work, the cursor must be on the same line as the regexp."
(interactive)
  (if
      (save-excursion
        (beginning-of-line 1)
          (looking-at
            ".*\\[fn\\|^\\#\\+BEGIN_SRC.*$\\|^[ \t]*:PROPERTIES:[ \t]*$"))
    (lawlist-org-flag (not (get-char-property (match-end 0) 'invisible)))
    (message "Sorry, you are not on a line containing the beginning regexp.")))

(defun lawlist-org-cycle-hide-drawers (state)
  "Re-hide all drawers after a visibility state change."
  (when (and (derived-mode-p 'org-mode)
       (not (memq state '(overview folded contents))))
    (save-excursion
      (let* ((globalp (memq state '(contents all)))
             (beg (if globalp (point-min) (point)))
             (end (if globalp (point-max)
        (if (eq state 'children)
      (save-excursion (outline-next-heading) (point))
          (org-end-of-subtree t)))))
  (goto-char beg)
  (while (re-search-forward "^.*DEADLINE:.*$\\|^\\*\\* Someday.*$\\|^\\*\\* None.*$\\|^\\*\\* Planning.*$\\|^\\* TASKS.*$" end t)
     (save-excursion
    (beginning-of-line 1)
    (when (looking-at "^.*DEADLINE:.*$\\|^\\*\\* Someday.*$\\|^\\*\\* None.*$\\|^\\*\\* Planning.*$\\|^\\* TASKS.*$")
      (let ((b (match-end 0)))
  (if (re-search-forward
       "^[ \t]*:END:"
       (save-excursion (outline-next-heading) (point)) t)
      (outline-flag-region b (point-at-eol) t)
    (user-error ":END: line missing at position %s" b))))))))))


(setq org-agenda-prefix-format
      '((agenda . " %i %-12:c%?-12t% s")
        (timeline . "  % s")
        (todo . "%-8:c %-18(concat \" \" (org-entry-get-deadline) \" \")")
        (tags . "%-8:c %-18(concat \" \" (org-entry-get-deadline) \" \")")
        (search . " %i %-12:c")))

(defun org-entry-get-deadline ()
  (let ((dl (org-entry-get (point) "DEADLINE")))
    (if dl dl "")))

(defun org-pretty-format-outline-path (p)
  (if (consp p)
      (concat (org-format-outline-path p) " ")
    ""))

(setq org-columns-default-format
      "%64ITEM %TODO %3PRIORITY %DEADLINE")


;;open agenda in current window
(setq org-agenda-window-setup (quote current-window))
;;warn me of any deadlines in next 7 days
(setq org-deadline-warning-days 7)
;;show me tasks scheduled or due in next fortnight
(setq org-agenda-span (quote fortnight))
;;don't show tasks as scheduled if they are already shown as a deadline
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
;;don't give awarning colour to tasks with impending deadlines
;;if they are scheduled to be done
(setq org-agenda-skip-deadline-prewarning-if-scheduled (quote pre-scheduled))
;;don't show tasks that are scheduled or have deadlines in the
;;normal todo list
(setq org-agenda-todo-ignore-deadlines (quote all))
(setq org-agenda-todo-ignore-scheduled (quote all))
;;sort tasks in order of when they are due and then by priority
(setq org-agenda-sorting-strategy
  (quote
   ((agenda deadline-up priority-down)
    (todo priority-down category-keep)
    (tags priority-down category-keep)
    (search category-keep))))

;;store org-mode links to messages
(require 'org-mu4e)
;;store link to message if in header view, not to header query
(setq org-mu4e-link-query-in-headers-mode nil)

(setq org-refile-use-outline-path 'file)
(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))
