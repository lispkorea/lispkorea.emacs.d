;; file: lang-common-lisp.el

(use-package sly
  :requires (subr-x)
  :ensure t
  :config
  (setq inferior-lisp-program
        (string-trim
         (shell-command-to-string "which sbcl"))))

(progn
  ;; `overlay'
  ;; ref: https://www.reddit.com/r/emacs/comments/bi4xk1/evaluation_overlays_in_slime_for_common_lisp/
  (require 'cl-lib)
  (require 'eros)
  (defun custom:sly-eval-last-expression-eros ()
    (interactive)
    (let* ((region (sly-region-for-defun-at-point))
           (form (apply #'buffer-substring-no-properties region))
           (pos-end (list (- (cadr region) 1)))
           (expr (sly-eval `(slynk:eval-and-grab-output ,form))))
      (cl-destructuring-bind (output value) expr
        (let ((val (concat output value)))
          (eros--make-result-overlay value
            :where pos-end
            :duration eros-eval-result-duration)
          ;; (message value)
          (message value)))))
  ;; (keymap-set sly-mode-map "C-M-x" 'sly-eval-defun)
  (keymap-set sly-mode-map "C-M-x" 'custom:sly-eval-last-expression-eros))

