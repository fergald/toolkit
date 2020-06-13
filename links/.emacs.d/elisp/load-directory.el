(defun load-directory (dir)
  (if (file-directory-p dir)
      (let ((load-it (lambda (f)
                       (load-file (concat (file-name-as-directory dir) f)))
                     ))
        (mapc load-it (directory-files dir nil "\\.el$")))
    (message "%s does not exist" dir)))

(provide 'load-directory)
