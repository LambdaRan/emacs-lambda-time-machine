

(with-eval-after-load 'company
  (require 'codeium)
  
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))  
  (setq codeium/document/text 'my-codeium/document/text)  
  
  (add-hook 'prog-mode-hook
            #'(lambda ()
                (setq-local completion-at-point-functions '(codeium-completion-at-point))))
)

(provide 'init-codeium)
