;; always end a file with a newline
(setq require-final-newline t)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2))))
