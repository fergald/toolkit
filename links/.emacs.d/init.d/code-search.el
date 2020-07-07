;; Defines open-file-from-codesearch an interactive command that takes
;; a URL from codesearch and opens it as a file in the current chromium
;; client.

; (extract-path-from-filename (url-filename (url-generic-parse-url "https://source.chromium.org/chromium/chromium/src/+/master:content/browser/frame_host/embedding_token_browsertest.cc?q=EmbeddingTokenBrowserTest.EmbeddingTokensDoNotSwapOnSameSiteNavigations&ss=chromium&originalUrl=https:%2F%2Fcs.chromium.org%2Fsearch%2F")))
(defun extract-path-from-filename (filename)
  (substring (nth 0 (split-string filename "?")) 1)
  )

(defun parent-directory (filename)
  (directory-file-name (file-name-directory filename)))

(defun ends-with-chromium-src-p (filename)
  (if (string= (file-name-nondirectory (directory-file-name filename)) "src")
      (if (string= (file-name-nondirectory (parent-directory filename)) "chromium")
          t)
    )
  )

; (chromium-root "/home/fergal/chromium/src/")
; (chromium-root "/home/fergal/chromium/src/BUILD.gn")
; (chromium-root "/home/fergal/chromium/src/foo/bar/asdf")
; (chromium-root "/home/fergal/chromium/foo/bar/asdf")

; returns the directory above chromium/src
(defun chromium-root (filename)
  (let ((parent (parent-directory filename)))
    (if (string= filename parent)
        "/home/fergal"
      (if (ends-with-chromium-src-p filename)
          (parent-directory (parent-directory filename))
        (chromium-root parent))
      )
    )
  )

(defun file-from-something (path-extractor something)
  (let ((root (chromium-root buffer-file-name))
        (filename (funcall path-extractor something))
        )
    (if (and root filename)
        (concat (file-name-as-directory root) filename)
      (progn (message "something: %s" something)
             (message "filename: %s" filename)
             (message "root: %s" root)
             nil)
      )
    )
  )

(defun remove-branch (path)
  (replace-regexp-in-string (regexp-quote "chromium/chromium/src/+/master:")
                            "chromium/src/"
                            path)
  )

(defun extract-path-from-url (url)
  (let ((parsed (url-generic-parse-url url)))
    (let ((host (url-host parsed)))
      (if (or (string= host "cs.chromium.org")
              (string= host "source.chromium.org")
              )
          (remove-branch (extract-path-from-filename (url-filename parsed)))
        nil
        )
      )
    )
  )
; (extract-path-from-url "https://cs.chromium.org/chromium/src/tools/emacs/?q=emacs&sq=package:chromium&dr")
; (extract-path-from-url "https://cs.chromiu.org/chromium/src/tools/emacs/?q=emacs&sq=package:chromium&dr")
; (extract-path-from-url "https://source.chromium.org/chromium/chromium/src/+/master:content/browser/frame_host/embedding_token_browsertest.cc?q=EmbeddingTokenBrowserTest.EmbeddingTokensDoNotSwapOnSameSiteNavigations&ss=chromium&originalUrl=https:%2F%2Fcs.chromium.org%2Fsearch%2F")
; -> "chromium/src/..."

(defun file-from-url (url)
  (file-from-something 'extract-path-from-url url)
  )
;; (file-from-url "https://cs.chromium.org/chromium/src/tools/emacs/adsf?q=emacs&sq=package:chromium&dr")
;; (file-from-url "https://source.chromium.org/chromium/chromium/src/+/master:content/browser/frame_host/embedding_token_browsertest.cc?q=EmbeddingTokenBrowserTest.EmbeddingTokensDoNotSwapOnSameSiteNavigations&ss=chromium&originalUrl=https:%2F%2Fcs.chromium.org%2Fsearch%2F")
;; -> "/home/fergal/chromium/src/tools/emacs/adsf"
;; (file-from-url "/cs.asdf.org/chromium/src/tools/emacs/adsf?q=emacs&sq=package:chromium&dr") -> nil

(defun strip-git-a-b (path)
  (if (or (string= path "a") (string= path "b"))
      ""
    (let ((dir (file-name-directory path)) (file (file-name-nondirectory path)))
      (if dir
          (let ((subres (strip-git-a-b
                         (directory-file-name (file-name-directory path)))))
            (if subres
                (concat
                 (file-name-as-directory subres)
                 file)
              )
            )
        )
      )
    )
  )
;; (strip-git-a-b "a/content/renderer/render_frame_impl.cc")
;; (strip-git-a-b "content/renderer/render_frame_impl.cc")

(defun extract-path-from-git-path (path)
  (let ((res (strip-git-a-b path)))
    (if res
        (concat "chromium/src/" res)
      )))
;; (extract-path-from-git-path "a/content/renderer/render_frame_impl.cc")
;; (extract-path-from-git-path "content/renderer/render_frame_impl.cc")

;; (file-from-git-path "a/content/renderer/render_frame_impl.cc")
(defun file-from-git-path (path)
  (file-from-something 'extract-path-from-git-path path)
  )

(defun remove-if-slash (path)
  (if (directory-name-p path) (directory-file-name path) path)
  )
;; (remove-if-slash "asdf/sadf")
;; (remove-if-slash "asdf/sadf/")
;; (setq debug-on-error t)

;; (eq nil nil)
;; (eq (file-name-directory "../") nil)
;; (file-name-directory "..")
(defun all-parents-p (path)
  (if (eq path nil) t
    (let ((newpath (remove-if-slash path)))
      (let ((dir (file-name-nondirectory newpath)))
        (if (or (string= dir "..") (string= dir "."))
            (all-parents-p (file-name-directory newpath))
          nil
          )))))
;; (all-parents-p "..")
;; (all-parents-p "../")
;; (all-parents-p "../../")
;; (all-parents-p "./../../")
;; (all-parents-p "../../foo")
;; (all-parents-p "./../../foo")

(let ((s "foo:100:3"))
  )

(defun line-number-from-local-path (path)
  (let ((final (file-name-nondirectory path)))
    (if
        (string-match "^\\(.*?\\):\\([0-9]+\\)\\(:[0-9]+\\)?$" final)
        (list (match-string 1 final)
              (string-to-number (match-string 2 final))
              )
      final
      )
    )
  )
; (line-number-from-local-path "foo:100")
; (line-number-from-local-path "foo:100:3")
; (line-number-from-local-path "foo")

(defun extract-path-from-local-path (path)
  (cond ((or (not path) (all-parents-p path )) "chromium/src")
        ((not (file-name-directory path)) (concat "chromium/src/" path))
        (t
         (concat (file-name-as-directory
                  (extract-path-from-local-path
                   (directory-file-name (file-name-directory path))))
                 (file-name-nondirectory path))
         )
        ))
;; (extract-path-from-local-path "content/renderer/render_frame_impl.cc")
;; (extract-path-from-local-path "../../content/renderer/render_frame_impl.cc")
;; (extract-path-from-local-path "./../../content/renderer/render_frame_impl.cc")

(defun file-from-local-path (path)
  (file-from-something 'extract-path-from-local-path path)
  )
;; (file-from-git-path "content/renderer/render_frame_impl.cc")
;; (file-from-git-path "../../content/renderer/render_frame_impl.cc")

(defun get-file-and-line (i)
  (if (listp i)
      i
    (cons i 1)
    )
  )
; (get-file-and-line (cons "foo" 10)
; (get-file-and-line "foo")

; i = (cons path line)
; i = path
(defun find-file-and-line (i)
  (let* ((fl (get-file-and-line i)) (path (car fl)) (line (cdr fl)))
    (progn
      (find-file path)
      (goto-char (point-min))
      (forward-line (- line 1))
      )
    )
  )
; (find-file-and-line (cons "/etc/passwd" 10))
; (find-file-and-line "/etc/passwd")

(defun open-file-from-codesearch (url)
  (interactive "sEnter codesearch URL: ")
  (find-file-and-line (file-from-url url))
  )

(defun open-file-from-git-path (path)
  (interactive "sEnter git path: ")
  (find-file-and-line (file-from-git-path path))
  )

(defun open-file-from-local-path (path)
  (interactive "sEnter local path: ")
  (find-file-and-line (file-from-local-path path))
  )


(defun file-from-anything (path)
  (let (res)
    (dolist (f (list `file-from-url `file-from-git-path `file-from-local-path) res)
      (if res
          nil
        (setq res (funcall f path)))
      )
    )
  )
;; (file-from-anything "a/content/renderer/render_frame_impl.cc")
;; (file-from-anything "https://cs.chromium.org/chromium/src/tools/emacs/adsf?q=emacs&sq=package:chromium&dr")
;; (file-from-anything "../../content/renderer/render_frame_impl.cc")


(defun open-file-from-anything (path)
  (interactive "sEnter local path: ")
  (find-file-and-line (file-from-anything path))
  )


; (file-from-git-path "a/foo/bar/")
; (extract-path-from-git-path "a/foo/bar/")
; (extract-path-from-git-path "b/foo/bar")
; buffer-file-name
; (extract-path-from-filename "um/src/tools/emacs/?q=emacs&sq=p?asdf?")
; (file-name-directory "/")
; (file-name-directory "/home/fergal/chromium/src/foo/")
; (directory-file-name "/home/fergal/chromium/src/foo/")
; (chromium-root "/home/fergal/chromium/src/BUILD.gn")
