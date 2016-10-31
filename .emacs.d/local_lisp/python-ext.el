(add-hook 'python-mode-hook 'anaconda-mode)
(eval-after-load 'anaconda-mode
  '(define-key anaconda-mode-map (kbd "C-M-i") 'company-anaconda))
