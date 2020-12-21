(defun ipdb () (interactive) (insert "import pdb;pdb.set_trace()\n"))
(defun dns () (interactive) (insert "DO NOT SUBMIT"))
(defun fheader (name)
       (save-mark-and-excursion
         (progn
           (goto-char (point-min))
           (if (search-forward (concat "fergal/debug/" name) nil t)
               (message "found it, doing nothing")
             (insert (concat "#include \""
                             (expand-file-name
                              (concat "~fergal/debug/" name)) "\"\n")
                     )
             )
           )))

(defun fdbg () (interactive)
       (fheader "log.h")
       )

(defun finsert (s h)
       (progn
         (insert s)
         (backward-char 3)
         (fheader h)
         )
       )
(defun fle () (interactive)
       (finsert "FLOG_EXPR();\n" "flog.h")
       )
(defun fot () (interactive)
       (finsert "FOT();\n" "object.h")
       )
(defun ftr () (interactive)
       (finsert "FTRACE();\n" "trace.h")
       )
(defun fbl () (interactive)
       (finsert "FBLOCK();\n" "fblock.h")
       )
