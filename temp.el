
;; ### vterm
;; (unless sys/windows-p
;;   (lazy-load-global-keys
;;    '(
;;      ("C-`" . multi-vterm)
;;      ("C-q" . ran-vterm-open-in-right-window)
;;      ("s-x m" . ran-vterm-open-in-below-window)
;;      ("s-x n" . multi-vterm-dedicated-toggle)
;;      )
;;    "init-multi-vterm"))

;;; ### Ido ###
;;; --- 交互式管理文件和缓存
;; (lazy-load-set-keys
;;  '(
;;    ("C-x C-f" . ido-find-file)          ;交互式查找文件
;;    ("C-x b" . ido-switch-buffer)        ;交互式切换buffer
;;    ("C-x i" . ido-insert-buffer)        ;插入缓存
;;    ("C-x I" . ido-insert-file)          ;插入文件
;;    ))
;; (defun ido-my-keys (keymap)
;;   "Add my keybindings for ido."
;;   (lazy-load-set-keys
;;    '(
;;      ("M-p" . ido-prev-match)              ;上一个匹配
;;      ("M-n" . ido-next-match)              ;下一个匹配
;;      ("M-h" . ido-next-work-directory)     ;下一个工作目录
;;      ("M-l" . ido-prev-work-directory)     ;上一个工作目录
;;      ("M-o" . backward-delete-char-untabify) ;向前删除字符
;;      ("M-O" . ido-delete-backward-updir)     ;删除字符或进入上一级目录
;;      )
;;    keymap))
;; (add-hook 'ido-setup-hook
;;           #'(lambda ()
;;               (interactive)
;;               (ido-my-keys ido-completion-map)))
