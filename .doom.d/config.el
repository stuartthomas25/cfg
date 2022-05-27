
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Stuart Nathan Thomas"
      user-mail-address "snthomas@umd.edu")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Fira Code" :size 12)
      doom-variable-pitch-font (font-spec :family "Fira Code")
      doom-unicode-font (font-spec :family "Fira Code")
      doom-big-font (font-spec :family "Fira Code" :size 19))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

(defun update-pdf-colors ()
  (interactive)
  (setq pdf-view-midnight-colors
        (cons (face-attribute 'default :foreground) (face-attribute 'default :background))))

(after! pdf-tools (update-pdf-colors))

(add-hook 'doom-load-theme-hook 'update-pdf-colors)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(add-hook 'org-mode-hook 'org-indent-mode)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq doom-inhibit-large-file-detection t)

(setq rmh-elfeed-org-files '("~/org/elfeed.org"))
(add-hook! 'elfeed-search-mode-hook 'elfeed-update)
(after! elfeed
  (setq elfeed-search-filter "+arxiv"))


;; EIN
;; (setq ein:output-area-inlined-images t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(after! org
        (setq org-startup-indented t)
        (setq org-startup-with-latex-preview  t)
        (setq org-startup-with-inline-images t)
        (plist-put org-format-latex-options :scale 1.5))
;; (setq ns-auto-hide-menu-bar t)
;; (set-frame-position nil 0 -24)
;; (tool-bar-mode 0)
;; (set-frame-size nil 150 80)

;; (map! :n "RET" #'(lambda () (interactive) (evil-open-below 1) (evil-force-normal-state)))
;; (map! :n "S-RET" #'(lambda () (interactive) (evil-open-above 1) (evil-force-normal-state)))

;; (map! (:when (not buffer-read-only)
;;  :n "RET" #'(lambda () (interactive) (evil-open-below 1) (evil-force-normal-state))
;;  :n "S-RET" #'(lambda () (interactive) (evil-open-above 1) (evil-force-normal-state))))

(map! :n "Q" #'evil-record-macro)
(map! :n "q" #'kill-current-buffer)

(defun org-latex-preview-buffer ()
  (interactive)
  (org-latex-preview '(16)))
(map! (:map org-mode-map :localleader :desc "Preview LaTeX in buffer" "L" #'org-latex-preview-buffer))

(modify-syntax-entry ?- "w" emacs-lisp-mode-syntax-table)
(modify-syntax-entry ?_ "w" emacs-lisp-mode-syntax-table)


;; (defun splash ()
;;   (insert-file-contents "/Users/stuart/Downloads/initials2.txt"))
;; (setcar +doom-dashboard-functions #'splash)

;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; (setq pop-up-frames 'graphic-only)


(use-package dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;; (setq dashboard-banner-logo-title "\nKEYBINDINGS:\nOpen dired file manager  (SPC .)\nOpen buffer list         (SPC b i)\nFind recent files        (SPC f r)\nOpen the eshell          (SPC e s)\nToggle big font mode     (SPC t b)")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.doom.d/doom-emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content t) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (projects . 5)))
  (setq dashboard-agenda-time-string-format "%a, %b %d")
  (setq dashboard-agenda-time-string-format "%a, %b %d")
  (setq dashboard-agenda-prefix-format "(%(projectile-project-name)) %i %-12:c %s ")
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-set-footer nil)
  (setq dashboard-force-refresh t)
  (setq dashboard-filter-agenda-entry 'dashboard-filter-agenda-by-todo)
  ;(add-hook 'dashboard-mode-hook #'dashboard-refresh-buffer)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  (push (lambda (f)
          (with-selected-frame  f (dashboard-refresh-buffer)))
        after-make-frame-functions)
  (setq doom-fallback-buffer-name "*dashboard*"))

;; (setq doom-fallback-buffer "*dashboard*")
;; (defun doom-fallback-buffer () (get-buffer "*dashboard*"))
;; (setq doom-fallback-buffer-name "*dashboard*")
;; (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
;;(setq initial-buffer-choice "*dashboard*")

;; (use-package! zotero-browser)

;; (after! zotero-browser
;;   (nconc zotero-browser-item-columns (list '(:dateAdded . 50)))
;;   (setq zotero-browser-default-item-level 0))

;; (after! zotero
;;   (setq zotero-auth-token (zotero-auth-token-create     :token "HsmRD31PVsye5ygG4J2fTUnm"
;;                                                         :token-secret "HsmRD31PVsye5ygG4J2fTUnm"
;;                                                         :userid "5412779"
;;                                                         :username "snthomas01"))
;;   (customize-save-variable 'zotero-auth-token zotero-auth-token))

;; (use-package! zotero
;;   :ensure t
;;   :defer t
;;   :commands (zotero-browser zotero-sync))
;; (defun open-zotero ()
;;   (interactive)
;;   (zotero-browser)
;;   (zotero-browser-collapse-all))

;; (map! :leader :desc "Open Zotero Browser" :g "o z" #'open-zotero)
(map! :leader :desc "Open Elfeed" :g "o x" '=rss)

;; (after! doom-modeline
;;        (setq-default mode-line-format nil))

;; (map! :leader :g "d"
;;       (lambda () ; toggle modeline
;;         (interactive)
;;         (if (equal mode-line-format nil)
;;                 (setq mode-line-format '("%e"
;;                         (:eval
;;                         (doom-modeline-format--project))))

;;                 (setq mode-line-format nil))))
;;
; (global-hide-mode-line-mode)

(map! :leader :desc "Switch workspace right" :g "l" #'+workspace/switch-right)
(map! :leader :desc "Switch workspace left" :g "L" #'+workspace/switch-left)
(map! :leader :desc "Switch window focus" :g "k" #'other-window)

(evil-define-key 'normal zotero-browser-items-mode-map (kbd "RET") 'zotero-browser-open)

(global-hide-mode-line-mode 'toggle)
(map! :leader :desc "Toggle Doom Mode Line" :g "d" (lambda () (interactive) (global-hide-mode-line-mode 'toggle)))
(map! :leader :desc "Open eshell" :g "e" 'eshell)

;; (setq initial-frame-alist (append '((minibuffer . nil)) initial-frame-alist))
;; (setq default-frame-alist (append '((minibuffer . nil)) default-frame-alist))
;; (setq minibuffer-auto-raise t)
;; (setq minibuffer-exit-hook '(lambda () (lower-frame)))



(set-email-account!
 "umd"
 '((mu4e-sent-folder       . "/umd/[Gmail]/Sent Mail")
   (mu4e-drafts-folder       . "/umd/[Gmail]/Drafts")
   (mu4e-trash-folder      . "/umd/[Gmail]/Bin")
   (smtpmail-smtp-user     . "snthomas@umd.edu"))
 t)

(setq org-msg-signature "

#+begin_signature
Best wishes, \\\\
Stuart Thomas (he/him) \\\\
snthomas@umd.edu \\\\
+1 (407) 701-7788
#+end_signature")

(setq mu4e-compose-context-policy 'pick-first)

(setq mu4e-get-mail-command "mbsync umd"
      ;; get emails and index every 5 minutes
      mu4e-update-interval 300
	  ;; send emails with format=flowed
	  mu4e-compose-format-flowed t
	  ;; don't need to run cleanup after indexing for gmail
	  mu4e-index-cleanup nil
	  mu4e-index-lazy-check t)
      ;; more sensible date format
      ;; mu4e-headers-date-format "%d.%m.%y")
(after! auth-source (setq auth-sources (nreverse auth-sources)))
;; tell message-mode how to send mail
(setq message-send-mail-function 'smtpmail-send-it)
;; if our mail server lives at smtp.example.org; if you have a local
;; mail-server, simply use 'localhost' here.
(setq smtpmail-smtp-server "smtp.google.com")


(defvar my-mu4e-account-alist
  '(("umd"
     (mu4e-sent-folder "/umd/[Gmail]/Sent Mail")
     (user-mail-address "snthomas@umd.edu")
     (smtpmail-smtp-user "snthomas@umd.edu")
     (smtpmail-local-domain "gmail.com")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587)
     )
     ;; Include any other accounts here ...
    ))

(defun my-mu4e-set-account ()
  "Set the account for composing a message.
   This function is taken from:
     https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html"
  (let* ((account
    (if mu4e-compose-parent-message
        (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
    (string-match "/\\(.*?\\)/" maildir)
    (match-string 1 maildir))
      (completing-read (format "Compose with account: (%s) "
             (mapconcat #'(lambda (var) (car var))
            my-mu4e-account-alist "/"))
           (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
           nil t nil nil (caar my-mu4e-account-alist))))
   (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
  (mapc #'(lambda (var)
      (set (car var) (cadr var)))
        account-vars)
      (error "No email account found"))))
(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)






;; BIBTEX
(setq bibtex-completion-pdf-field "File")

(defun my/bibtex-open-pdf (url other)
  (message "Loading PDF...")
  (print other)
  (open-link url))

(setq bibtex-completion-browser-function 'my/bibtex-open-pdf)

(defun my/open-bib ()
  (interactive)
  (let ((root (projectile-acquire-root)))
    (setq bibtex-completion-library-path (concat root "references")
          bibtex-completion-bibliography (concat root "bib.bib"))
    (helm-bibtex-with-local-bibliography)))

(map! :leader :desc "Open helm-bibtex" :g "z" 'my/open-bib)
;; (add-hook 'find-file-hook 'config-projectile)
;; (add-hook 'projectile-after-switch-project-hook 'config-projectile)

(after! projectile
        (add-to-list 'projectile-other-file-alist '("tex" "pdf")))


(map! :desc "Search forward in PDF" :n "g P" #'pdf-sync-forward-search)

(after! tex-mode
        (add-to-list 'tex--prettify-symbols-alist '("\\left(" . 10222))
        (add-to-list 'tex--prettify-symbols-alist '("\\right)" . 10223))
        (add-to-list 'tex--prettify-symbols-alist '("\\sqrt" . 08730))
        (add-to-list 'tex--prettify-symbols-alist '("\\sqrt" . 08730)))

(map! :i "C-(" (lambda ()
                (interactive)
                (insert "\\left(  \\right)")
                (if (eq (point) (line-end-position))
                        (evil-backward-char 7)
                        (evil-backward-char 8))))

;; (defun my/biblio--selection-insert-at-end-of-bibfile-callback (bibtex entry)
;;   "Add BIBTEX (from ENTRY) to end of a user-specified bibtex file."
;;   (with-current-buffer (find-file-noselect bibtex-completion-bibliography)
;;     (goto-char (point-max))
;;     (insert bibtex))
;;   (message "Inserted bibtex entry for %S."
;; 	   (biblio--prepare-title (biblio-alist-get 'title entry))))

;; (defun ans/biblio-selection-insert-end-of-bibfile ()
;;   "Insert BibTeX of current entry at the end of user-specified bibtex file."
;;   (interactive)
;;   (biblio--selection-forward-bibtex #'my/biblio--selection-insert-at-end-of-bibfile-callback))

(window-divider-mode 0)

;;
;; DOI SYSTEM
;;

(setq bibtex-autokey-titlewords 0)
(setq bibtex-autokey-titleword-length 0)
(setq bibtex-autokey-year-title-separator "")
(setq bibtex-autokey-year-length 4)
(setq biblio-bibtex-use-autokey t)


;; (defun open-pdf (link buffer)

;;   )



(defun my/doi-to-reference ()
  (interactive)
  (let ((line (thing-at-point 'line t)))
    (string-match "10\\.[0-9]\\{4,5\\}\\/[^ -]+[^;,. -]+" line)
    (let ((doi (match-string 0 line)))
      (kill-whole-line)
      (biblio-doi-insert-bibtex doi))))
(map! (:map bibtex-mode-map :localleader "d" :desc "Replace DOI in line with Bibtex reference" #'my/doi-to-reference))

;; returns t if retrieved successfully
(defun display-pdf (url &optional fname)
  (unless (string-match-p "scitation" url)
    (let ((buffer (url-retrieve-synchronously url t t 5)))
      (when (equal 200 (url-http-symbol-value-in-buffer 'url-http-response-status buffer))
        ;; (display-buffer buffer)
        (goto-char (point-min))
        (re-search-forward "^$")
        (delete-region (point) (point-min))
        (message "Successfully retrieved PDF")
        (let ((filename (if fname fname (make-temp-file "stumacs" nil ".pdf"))))
          (with-current-buffer buffer (write-region (point) (point-max) filename))
          (find-file filename))
        t))))

(defun callback (status)
  "Uri callback.
STATUS: the status"
  ;; remove headers
  (message "Recieved search results...")
  (goto-char url-http-end-of-headers)
  ;; (print status)
  ;; (print (plist-get status :error))
  (let* ((json (json-read))
         (pdf-links (cdr (assoc 'link (assoc 'message json))) ))
    (advice-add 'url-http-handle-authentication :around #'ignore)
    (catch 'success
      (seq-doseq (link pdf-links)
        (let ((url (cdr (assoc 'URL link))))
          ;; (message (concat "Retrieved from " url))
          (if (display-pdf url) (throw 'success t))))
      (message "Unsuccessful"))
  (advice-remove 'url-http-handle-authentication #'ignore)))

(defun open-doi (doi)
  (interactive "sDOI: ")
  (url-retrieve (url-encode-url (concat "http://api.crossref.org/v1/works/" doi "\n")) 'callback nil t t))

(defun open-arxiv (arxivid)
  (interactive "sArXiv Id: ")
  (display-pdf (concat "https://arxiv.org/pdf/" arxivid) ))

(defun open-link (uri)
  "Open a doi link.
 URI: the uri"
  (cond ((string-match "10\\.[0-9]\\{4,5\\}\\/[^ -]+[^;,. -]+" uri) (open-doi (match-string 0 uri)))
        ((string-match "[0-9]\\{4\\}\\.[0-9]\\{5\\}\\(v[0-9]+\\)*$" uri) (open-arxiv (match-string 0 uri)))
        ( t (pdf-links-browse-uri-default uri))))

(setq pdf-links-browse-uri-function 'open-link)
(url-handler-mode 1)

;; (load! "+math")
(setq conda-env-home-directory "/opt/miniforge3")
(setq conda-anaconda-home "/opt/miniforge3")

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
              "[ \t\n]*$" "" (shell-command-to-string
                      "$SHELL --login -i -c 'echo $PATH'"
                            ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)


(use-package! org-latex-impatient
  :defer t
  :hook (org-mode . org-latex-impatient-mode)
  :init
  (setq org-latex-impatient-tex2svg-bin
        ;; location of tex2svg executable
        "~/Library/node_modules/mathjax-node-cli/bin/tex2svg"))



;; Julia Babel
(setq org-babel-julia-command "julia --sysimage ~/.julia/sysimages/sys_itensors.so")
;; (setq org-babel-ess-julia-command "/opt/homebrew/bin/julia --sysimage ~/.julia/sysimages/sys_itensors.so")

;; Load ob-ess-julia and dependencies
;; (use-package ob-ess-julia
;;   :ensure t
;;   :config
;;   ;; Add ess-julia into supported languages:
;;   (org-babel-do-load-languages 'org-babel-load-languages
;;                                (append org-babel-load-languages
;;                                        '((ess-julia . t))))
;;   ;; Link this language to ess-julia-mode (although it should be done by default):
;;   (setq org-src-lang-modes
;;         (append org-src-lang-modes '(("ess-julia" . ess-julia)))))


;; https://emacs.stackexchange.com/questions/18775/how-to-get-a-fully-functional-julia-repl-in-emacs
(defun my/julia-repl ()
  "Runs Julia in a screen session in a `term' buffer."
  (interactive)
  (require 'term)
  ;; (let ((termbuf (apply 'make-term "Julia REPL" "screen" nil (split-string-and-unquote "arch -x86_64 /usr/local/bin/julia"))))
  (let ((termbuf (apply 'make-term "Julia REPL" "screen" nil (split-string-and-unquote "/Applications/Julia-1.8.app/Contents/Resources/julia/bin/julia --sysimage /Users/stuart/.julia/sysimages/sys_itensors.so"))))
    (set-buffer termbuf)
    (term-mode)
    (term-char-mode)
    (switch-to-buffer termbuf)))

(map! :leader :desc "Open Terminal" :g "j" #'multi-term)
(setq term-escape-char [24])



;; Simple org babel for julia
(defvar ob-julia-prompt "julia>")
(defvar my/ob-julia-end-of-input nil)
(after! ob-julia
  (defun org-babel-execute:julia (body params)
    (let* ((buffname (cdr (assoc :session params)))
           (proc (get-process (replace-regexp-in-string "\*" "" buffname))))
      (with-current-buffer (get-buffer buffname) (evil-insert 1))
      (term-send-string buffname (concat " " (dired-replace-in-string "\n" "\e\n " body) "\n"))
      (setq my/ob-julia-end-of-input (point)))))
(setq term-scroll-to-bottom-on-output t)

    ;; (add-to-list 'my/waiting-buffers buffname)))

  ;; (with-current-buffer (get-buffer "*Julia REPL*")
  ;;   (let (output-end output-start)
  ;;     (goto-char (point-max))
  ;;     (search-backward ob-julia-prompt nil nil 2)
  ;;     ;; (forward-line (+ (length (split-string body "\n")) 1))
  ;;     (setq output-start (point))
  ;;     (search-forward ob-julia-prompt)
  ;;     ;; (forward-line -1)
  ;;     (goto-char (point-max))
  ;;     (setq output-end (point))
  ;;     (goto-char (point-max))
  ;;     (print (buffer-substring output-start output-end)))))
;; (defvar my/waiting-buffers '())
(defun my/ob-julia-callback (arg)
  (print arg)
  (seq-doseq (buff my/waiting-buffers)
    (with-current-buffer (get-buffer "*Julia REPL*")
      (beginning-of-line)
      (if (not (string-equal ob-julia-prompt (replace-regexp-in-string "[ \t\n]*\\'" "" (buffer-substring (point) (point-max)))))
        (message "Done!")
        (setq my/waiting-buffers (remove buff my/waiting-buffers))))))

(add-hook 'julia-mode-hook (lambda () (set-input-method 'TeX)))

;; (add-to-list window-buffer-change-functions 'my/ob-julia-callback)
;; (setq window-buffer-change-functions '(my/ob-julia-callback doom-run-switch-buffer-hooks-h))
;; 

(setq debug-on-error nil)
(after! flycheck
        (setq flycheck-check-syntax-automatically (delq 'idle-change flycheck-check-syntax-automatically))) ;; this conflicts with tramp

(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
