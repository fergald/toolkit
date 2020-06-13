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
    (if root
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

; (extract-path-from-url "https://cs.chromium.org/chromium/src/tools/emacs/?q=emacs&sq=package:chromium&dr")
; (extract-path-from-url "https://cs.chromiu.org/chromium/src/tools/emacs/?q=emacs&sq=package:chromium&dr")
; (extract-path-from-url "https://source.chromium.org/chromium/chromium/src/+/master:content/browser/frame_host/embedding_token_browsertest.cc?q=EmbeddingTokenBrowserTest.EmbeddingTokensDoNotSwapOnSameSiteNavigations&ss=chromium&originalUrl=https:%2F%2Fcs.chromium.org%2Fsearch%2F")
; -> "chromium/src/..."
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

;; (file-from-url "https://cs.chromium.org/chromium/src/tools/emacs/adsf?q=emacs&sq=package:chromium&dr")
;; (file-from-url "https://source.chromium.org/chromium/chromium/src/+/master:content/browser/frame_host/embedding_token_browsertest.cc?q=EmbeddingTokenBrowserTest.EmbeddingTokensDoNotSwapOnSameSiteNavigations&ss=chromium&originalUrl=https:%2F%2Fcs.chromium.org%2Fsearch%2F")
;; -> "/home/fergal/chromium/src/tools/emacs/adsf"
(defun file-from-url (url)
  (file-from-something 'extract-path-from-url url)
  )

;; (extract-path-from-git-path "a/content/renderer/render_frame_impl.cc")
(defun extract-path-from-git-path (path)
  (if (or (string= path "a") (string= path "b"))
      "chromium/src"
    (concat (file-name-as-directory
             (extract-path-from-git-path
              (directory-file-name (file-name-directory path))))
            (file-name-nondirectory path))
    )
  )

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
      (if (string= (file-name-nondirectory newpath) "..")
          (all-parents-p (file-name-directory newpath))
        nil
        ))))
;; (all-parents-p "..")
;; (all-parents-p "../")
;; (all-parents-p "../../")
;; (all-parents-p "../../foo")
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

(defun file-from-local-path (path)
  (file-from-something 'extract-path-from-local-path path)
  )
;; (file-from-git-path "content/renderer/render_frame_impl.cc")
;; (file-from-git-path "../../content/renderer/render_frame_impl.cc")

(defun open-file-from-codesearch (url)
  (interactive "sEnter codesearch URL: ")
  (find-file (file-from-url url))
  )

(defun open-file-from-git-path (path)
  (interactive "sEnter git path: ")
  (find-file (file-from-git-path path))
  )

(defun open-file-from-local-path (path)
  (interactive "sEnter local path: ")
  (find-file (file-from-local-path path))
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