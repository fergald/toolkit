(defun ipdb () (interactive) (insert "import pdb;pdb.set_trace()\n"))
(defun dns () (interactive) (insert "DO NOT SUBMIT"))
(defun fdbg () (interactive)
       (save-mark-and-excursion
         (progn
           (goto-char (point-min))
           (if (search-forward "fergal/debug/log.h" nil t)
               (message "found it, doing nothing")
             (insert (concat "#include \""
                             (expand-file-name
                              "~fergal/debug/log.h" "\"\n"))
                     )
             )
           )))
(defun fle () (interactive)
       (progn
         (insert "FLOG_EXPR();\n")
         (backward-char 3)
         (fdbg)
         )
       )
