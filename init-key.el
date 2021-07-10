
;;; ### Insert translated name ###
(lazy-load-global-keys
 '(
   ("," . insert-translated-name-insert-with-underline)
   ("." . insert-translated-name-insert-with-camel)
   ("/" . insert-translated-name-insert)
   )
 "insert-translated-name"
 "C-z"
 )

;; (lazy-load-global-keys
;;  '(
;;    ("s-i" . insert-translated-name-insert)
;;    )
;;  "init-insert-translated-name")


;; 模糊搜索框架
(lazy-load-global-keys
 '(
   ("C-c y" . snails)
   ("C-c u" . snails-search-point)
   )
 "snails")

;; 文件列表 TODO 目录设置
(lazy-load-global-keys
 '(
   ("C-S-s" . sr-speedbar-toggle)
   )
 "init-speedbar")

;; (lazy-load-global-keys
;;  '(
;;    ("C-7" . xref-pop-marker-stack)
;;    ("C-8" . xref-find-definitions)
;;    ("C-9" . xref-find-definitions-other-window)
;;    ("M-k" . xref-find-references)
;;    ;; ("M-," . nox-rename)
;;    ;; ("M-." . nox-show-doc)
;;    )
;;  "init-nox.el")

;; (lazy-load-global-keys
;;  '(
;;    ("s-;" . one-key-menu-window-navigation) ;快速窗口导航
;;    )
;;  "init-window")

;;; ### Aweshell ###
;;; --- 多标签式的shell
;; (lazy-load-global-keys
;;  '(
;;    ("s-n" . aweshell-new)
;;    ("s-h" . aweshell-toggle)
;;    ("s-x s-x" . aweshell-dedicated-toggle)
;;    )
;;  "init-aweshell")

;;; multi-term`
;; (lazy-load-global-keys
;;  '(
;;    ("C-`" . multi-term)
;;    ("s-x n" . multi-term-dedicated-toggle)
;;    )
;;  "init-multiterm")

;; M-x enhancement,列出最近、常用、其他命令
;; (lazy-load-global-keys
;;  '(
;;    ("M-x" . smex)
;;    ("C-c C-c M-x" . execute-extended-command)
;;    )
;;  "init-smex")

;; (lazy-load-set-keys
;;  '(
;;    ("C-x C-b" . ibuffer)))
