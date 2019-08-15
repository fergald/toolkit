;; Make page down/up move the point, not the screen. In practice, this
;; means that the point can move to the beginning or end of the
;; buffer.
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
