;; -*- coding: utf-8; lexical-binding: t; -*-
;;; init-company-tabnine.el --- Configure for TabNine

;;; Commentary:
;;
;; Configure for TabNine using shuxiao9058/tabnine package.
;; https://github.com/shuxiao9058/tabnine
;;

;;; Code:

;; Load tabnine-core only (skip chat features to avoid transient dependency)
(require 'tabnine-core)

;; The free version of TabNine is good enough,
;; and below code is recommended that TabNine not always
;; prompt me to purchase a paid version in a large project.
(defadvice company-echo-show (around disable-tabnine-upgrade-message activate)
  (let ((company-message-func (ad-get-arg 0)))
    (when (and company-message-func
               (stringp (funcall company-message-func)))
      (unless (string-match "The free version of TabNine only indexes up to" (funcall company-message-func))
        ad-do-it))))

;; Enable tabnine-mode for overlay completions in programming modes
(dolist (hook (list
               'c-mode-common-hook
               'c-mode-hook
               'emacs-lisp-mode-hook
               'lisp-interaction-mode-hook
               'lisp-mode-hook
               'makefile-gmake-mode-hook
               'python-mode-hook
               'go-mode-hook
               'cmake-mode-hook
               'php-mode-hook
               'web-mode-hook
               'rust-mode-hook
               'lua-mode-hook
               'llvm-mode-hook
               'conf-toml-mode-hook
               ))
  (add-hook hook #'tabnine-mode))

(provide 'init-company-tabnine)

;;; init-company-tabnine.el ends here
