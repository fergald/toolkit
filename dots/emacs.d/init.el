(add-to-list 'load-path "~/.emacs-lisp/" t)

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; turn on font-lock mode
(global-font-lock-mode t)
;; enable visual feedback on selections
(setq-default transient-mark-mode t)

;; always end a file with a newline
(setq require-final-newline t)

;; stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; use extended compound-text coding for X clipboard
  (set-selection-coding-system 'compound-text-with-extensions))

;(global-set-key (kbd "TAB") 'self-insert-command)
;(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq py-indent-offset 4)
(setq python-indent 2)
(setq js-indent-level 2)

;(defun mytabs ()
;  (let (tabs (counter 39))
;    (while (> counter 0)
;      (setq tabs (cons (* 2 counter) tabs))
;      (setq counter (1- counter))
;    )
;    tabs
;  )
;)

;(defun my-python-mode-hook ()
;  (setq-default indent-tabs-mode nil)
;)

;(add-hook 'python-mode-hook 'my-python-mode-hook)


;(setq tab-stop-list (mytabs))
;(add-to-list 'auto-mode-alist '("\\.te?xt\\'" . c++-mode))

(let ((path "~/.emacs-lisp/nxml-mode-20041004/rng-auto.el"))
  (if (file-exists-p path)
      (progn (load path)
             (setq auto-mode-alist
                   (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
                         auto-mode-alist)))))

(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
(setq cperl-extra-newline-before-brace t)

(setq auto-mode-alist
      (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
            auto-mode-alist))
;; Page down/up move the point, not the screen.
;; In practice, this means that they can move the
;; point to the beginning or end of the buffer.
(defun page-move-distance ()
;  (let ((height 5)) height))
  (let ((height (window-height)))
    (if (< height 4) (height) (- height 4))))

(page-move-distance)
(global-set-key [next]
  (lambda () (interactive)
    (vertical-motion (page-move-distance))))

(global-set-key [prior]
  (lambda () (interactive)
    (vertical-motion (- (page-move-distance)))))

; (require 'go-mode-load)
