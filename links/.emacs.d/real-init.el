(add-to-list 'load-path "~/.emacs-lisp/" t)
(add-to-list 'load-path "~/.emacs.d/elisp" t)
(require 'load-directory)
(load-directory "~/.emacs.d/init.d")
