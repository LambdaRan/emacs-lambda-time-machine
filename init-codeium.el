;; -*- coding: utf-8; lexical-binding: t; -*-
;;; init-codeium.el --- Configure for Codeium

;;; Require

;;; Code:

;; 使用 v1.20.8 语言服务器（windsurf.vim 同版本）
;; v1.12.0 的 RegisterUser 协议已被服务端拒绝，v2.x 废弃了 GetCompletions
;; 必须在 require 之前设置，否则 codeium-download-url 会用旧版本拼好
(setq codeium-latest-local-server-version "1.20.8")

(require 'codeium)

;; 不使用弹窗
(setq use-dialog-box nil)

;; 修复 RegisterUser：codeium.el 走本地语言服务器代理，语言服务器会额外注入
;; api_server_url 字段导致服务端拒绝。windsurf.vim 是直接 curl 调
;; https://api.codeium.com/register_user/，这里用同样的方式绕过。
(defun my-codeium-direct-register-user (orig-fun &rest args)
  "Advice: 直接调 RegisterUser API，绕过本地语言服务器代理。"
  (cl-letf* ((orig-codeium-request (symbol-function 'codeium-request))
             ((symbol-function 'codeium-request)
              (lambda (api state vals-alist callback)
                (if (eq api 'RegisterUser)
                    (let* ((url-request-method "POST")
                           (url-request-extra-headers '(("Content-Type" . "application/json")))
                           (token (codeium-state-last-auth-token state))
                           (url-request-data
                            (encode-coding-string
                             (json-serialize `((firebase_id_token . ,token)))
                             'utf-8)))
                      (url-retrieve "https://api.codeium.com/register_user/"
                                    (lambda (status)
                                      (let ((res 'error))
                                        (when url-http-end-of-headers
                                          (goto-char url-http-end-of-headers)
                                          (ignore-error json-parse-error
                                            (setq res (json-parse-buffer :object-type 'alist))))
                                        (let ((buf (current-buffer)))
                                          (run-with-timer 0 nil
                                                          (lambda ()
                                                            (funcall callback res)
                                                            (when (buffer-live-p buf)
                                                              (kill-buffer buf)))))))
                                    nil 'silent 'inhibit-cookies))
                  (funcall orig-codeium-request api state vals-alist callback)))))
    (apply orig-fun args)))
(advice-add 'codeium-background-process-start :around #'my-codeium-direct-register-user)

;; 限制发送给 codeium 的文本量以提升性能
(defun my-codeium/document/text ()
  (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
(defun my-codeium/document/cursor_offset ()
  (codeium-utf8-byte-length
   (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
(setq codeium/document/text 'my-codeium/document/text)
(setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset)

;; 使用 codeium-completion-at-point 提供补全
;; 通过 company-capf 集成到 company-mode
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
              'conf-toml-mode-hook
              ))
  (add-hook hook
            (lambda ()
              ;; 将 codeium 加入 completion-at-point-functions 最前面（buffer-local）
              (setq-local completion-at-point-functions
                          (cons #'codeium-completion-at-point
                                (remove #'codeium-completion-at-point completion-at-point-functions)))
              ;; 将 company-capf 提升到 company-backends 最前面
              ;; 否则 company-dabbrev 排在前面会抢占，导致 codeium 永远不会被调用
              (setq-local company-backends
                          (cons 'company-capf
                                (remq 'company-capf company-backends)))
              ;; codeium 是同步请求，降低触发频率避免卡顿
              (setq-local company-minimum-prefix-length 2)
              (setq-local company-idle-delay 0.2))))

;; 首次使用时需要运行 M-x codeium-install 安装语言服务器
;; 然后运行 M-x codeium-init 登录认证

(provide 'init-codeium)

;;; init-codeium.el ends here
