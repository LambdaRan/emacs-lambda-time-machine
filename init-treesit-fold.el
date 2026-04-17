

;; (setq treesit-fold-indicators-fringe 'left-fringe)
;; (setq treesit-fold-indicators-priority 30)
(global-treesit-fold-indicators-mode 1)

;; 延迟执行 indicators 刷新，避免编辑时卡顿
;; post-command / scroll / size-change 三条路径都改为 idle timer
(defvar-local treesit-fold-indicators--idle-timer nil)

(defun treesit-fold-indicators--schedule-refresh (buf)
  "Schedule a deferred indicators refresh for BUF."
  (when (buffer-live-p buf)
    (with-current-buffer buf
      (when (timerp treesit-fold-indicators--idle-timer)
        (cancel-timer treesit-fold-indicators--idle-timer))
      (setq treesit-fold-indicators--idle-timer
            (run-with-idle-timer
             1.0 nil
             (lambda ()
               (when (buffer-live-p buf)
                 (with-current-buffer buf
                   (treesit-fold-indicators-refresh)
                   (setq treesit-fold-indicators--render-this-command-p nil
                         treesit-fold-indicators--idle-timer nil)))))))))

(defun treesit-fold-indicators--post-command ()
  "Post command, deferred with idle timer."
  (when treesit-fold-indicators--render-this-command-p
    (treesit-fold-indicators--schedule-refresh (current-buffer))))

(defun treesit-fold-indicators--scroll (&optional window &rest _)
  "Render indicators on WINDOW, deferred."
  (when (window-live-p window)
    (treesit-fold-indicators--schedule-refresh (window-buffer window))))

(defun treesit-fold-indicators--size-change (&optional frame &rest _)
  "Render indicators for visible windows from FRAME, deferred."
  (dolist (win (window-list frame))
    (treesit-fold-indicators--schedule-refresh (window-buffer win))))
