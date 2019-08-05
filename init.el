;;                                                                  _/
;;     _/_/    _/_/_/  _/_/      _/_/_/    _/_/_/    _/_/_/    _/_/_/
;;  _/_/_/_/  _/    _/    _/  _/    _/  _/        _/_/      _/    _/
;; _/        _/    _/    _/  _/    _/  _/            _/_/  _/    _/
;;  _/_/_/  _/    _/    _/    _/_/_/    _/_/_/  _/_/_/      _/_/_/
;;
;;
;;                                      _/_/  _/
;;     _/_/_/    _/_/    _/_/_/      _/            _/_/_/
;;  _/        _/    _/  _/    _/  _/_/_/_/  _/  _/    _/
;; _/        _/    _/  _/    _/    _/      _/  _/    _/
;;  _/_/_/    _/_/    _/    _/    _/      _/    _/_/_/
;;                                                 _/
;;                                            _/_/

(message "-------- Started emacs startup at %s" (current-time-string))

;; PACKAGE

(require 'package)

(setq user-emacs-directory "~/.emacs.d/")
(setq package-user-dir (concat user-emacs-directory "packages"))

;; (let ((default-directory "/home/ilyapavlovski/melpa/"))
;;   (normal-top-level-add-subdirs-to-load-path))
;; (setq package-user-dir "/home/ilyapavlovski/melpa")

(setq package-archives
      '(("org" . "http://orgmode.org/elpa/")
	("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "http://melpa.org/packages/")))

(when (>= emacs-major-version 25)
  (setq package-archive-priorities '(("org" . 3)
				     ("melpa" . 2)
				     ("gnu" . 1))))

(setq package-load-list '(all))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

;; GENERAL VARS
(setq inhibit-startup-message t)
(setq disabled-command-function nil)
(setq backup-inhibited t)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq initial-buffer-choice "/home/ilyapavlovski/org/logs/journal.org")
(setq visible-bell nil)
(setq ring-bell-function (lambda () (invert-face 'header-line)
			   (run-with-timer 0.1 nil 'invert-face 'header-line)))
(setq x-select-enable-primary nil)
(setq x-select-enable-clipboard t)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)
(setq custom-file "~/.emacs.d/custom.el")
(setq uniquify-buffer-name-style 'forward)

;; General settings
(load custom-file)
(setenv "LC_ALL" "C")
(delete-selection-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(kill-buffer "*scratch*")
;; (mouse-wheel-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1) 
(scroll-bar-mode -1)
(auto-composition-mode 1)
(auto-compression-mode 1)
(auto-encryption-mode 1)
(file-name-shadow-mode 1)
(electric-pair-mode -1) 
(electric-indent-mode 1)
(tooltip-mode -1)
(global-visual-line-mode 1)
(visual-line-mode 1)
(column-number-mode 1)
(line-number-mode 1)
(cua-mode 1)


	     
;; KEYS

(defun emacsd-dired-copy-filename ()
  (interactive)
  (dired-copy-filename-as-kill 0))

(use-package dired
    :ensure nil
    :bind (:map dired-mode-map ("'" . dired-goto-file)
		(";" . dired-up-directory)
		("W" . emacsd-dired-copy-filename)
		;; ("C-m" . dired-open-file)
		;; ("C-M-m" . dired-open-xdg)
		;; ("C-z" . dired-toggle-sudo)
		)
    :init
    (setq dired-listing-switches "-AlXh --group-directories-first")
    (setq dired-recursive-copies 'always) ;; "always" means no asking
    (setq dired-recursive-deletes 'top)   ;; "top" means ask once
    (setq dired-dwim-target t)
    :config
    (add-hook 'dired-mode-hook 'auto-revert-mode))




;; WINDOWS
(setq scroll-preserve-screen-position t)
(setq pop-up-frames nil)
(setq split-window-preferred-function 'split-window-sensibly)
(setq header-line-format nil)

;; HELM
(use-package helm
    :ensure t
    :demand t
    :bind (:map helm-map
		("<tab>" . helm-execute-persistent-action)
		("C-<tab>" . helm-select-action)
		("M-p" . helm-previous-source)
		("M-n" . helm-next-source)
		("C-M-p" . helm-follow-action-backward)
		("C-M-n" . helm-follow-action-forward))
    :init
    (setq helm-samewindow nil)
    (setq helm-buffers-fuzzy-matching t)
    (setq helm-split-window-in-side-p t)
    (setq helm-scroll-amount 8)
    (setq helm-ff-file-name-history-use-recentf t)
    (setq helm-candidate-number-limit 1000)
    (setq helm-echo-input-in-header-line t)
    (setq helm-autoresize-max-height 40)
    (setq helm-autoresize-min-height 10)
    
    :config
    (helm-mode 1)
    ;; (use-package helm-config)
    (global-set-key (kbd "M-x") 'helm-M-x)
    (global-set-key (kbd "C-M-x") 'helm-mini)
    (global-set-key (kbd "s-x") 'helm-resume)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    (global-set-key (kbd "C-\\") 'helm-occur)
    (global-set-key (kbd "M-X") 'helm-apropos))

(use-package smartparens
    :ensure t
    :config
    (add-hook 'minibuffer-setup-hook 'turn-on-smartparens-strict-mode)
    (show-smartparens-global-mode t)
    ;; (use-package smartparens-config)
    )


(use-package company
    :ensure t
    :bind
    (:map company-active-map
	  ("C-n" . company-select-next)
	  ("C-p" . company-select-previous)
	  ("M-n" . company-next-page)
	  ("M-p" . company-previous-page)
	  ("<tab>" . company-complete)
	  ("C-<tab>" . company-complete-common)
	  ("RET" . company-complete-selection)
	  ("C-s" . company-search-candidates))
    (:map company-search-map
	  ("C-n" . company-search-repeat-forward)
	  ("C-p" . company-search-repeat-backward))
    :init
    (setq company-show-numbers t)
    (setq company-idle-delay 0.25)
    (setq company-minimum-prefix-length 3)
    (setq company-search-filtering t)
    :config
    (global-set-key (kbd "<tab>") 'company-indent-or-complete-common)
    )




(use-package org
  :ensure org-plus-contrib
  :pin org
  :init  
  ;; general
  (setq org-hide-emphasis-markers t)
  (setq org-support-shift-select nil)
  (setq org-startup-indented t)
  (setq org-startup-folded t)
  (setq org-pretty-entities t)
  (setq org-cycle-separator-lines 0) ; no blanks in collapsed view
  (setq org-indent-indentation-per-level 1)
  (setq org-catch-invisible-edits 'show-and-error)
  (setq org-goto-interface 'outline)
  (setq org-use-sub-superscripts nil)
  (setq org-effort-property "EFFORT")
  ;; special keys
  (setq org-special-ctrl-k t)
  (setq org-special-ctrl-o nil)
  (setq org-special-ctrl-a/e t)
  (setq org-return-follows-link t)
  ;; babel/src
  (setq org-edit-src-block-indentation 1)
  (setq org-edit-src-content-indentation 1)
  (setq org-src-fontify-natively t)
  (setq org-src-window-setup 'other-window)
  (setq org-confirm-babel-evaluate nil)
  (setq org-babel-capitalize-example-region-markers t)
  (setq org-babel-min-lines-for-block-output 40)
  ;; agenda
  (setq org-agenda-files '("/home/ilyapavlovski/org/tasks/current/"))
  ;; todo
  )


;; GRAPHICS

(use-package cl :ensure t)
(use-package color :ensure t)

(use-package rainbow-delimiters
    :ensure t
    :config
    (defun rainbow-delims-angle (m div lightness saturation)
      (loop for i from 1 to 9 do
	    (let* ((angle (* m pi (/ i div)))
		   (a (* saturation (cos angle)))
		   (b (* saturation (sin angle))))
	      (set-face-attribute 
	       (intern (format "rainbow-delimiters-depth-%s-face" i))
	       nil
	       :foreground (apply 'color-rgb-to-hex
				  (color-lab-to-srgb lightness a b))))))
    (rainbow-delims-angle 2 10.0 70 47))

(use-package powerline :ensure t
	     :config (powerline-default-theme)
	     )

;; frame
(blink-cursor-mode 1)
(setq blink-cursor-blinks -1)
(set-cursor-color "white")
(add-to-list 'default-frame-alist '(cursor-type . (bar . 2)))
(add-to-list 'default-frame-alist `(font . "Source Code Pro-11"))
(add-to-list 'default-frame-alist '(alpha 90 87))

;; Background color and fringes to matches it
(custom-set-faces
 `(default
      ((t (:background "Gray2" :foreground "#DEDEDE"))))
 `(fringe
   ((t (:background "Gray2")))))

;; modeline/headerline
(custom-set-faces
 `(header-line
   ((t (:foreground "black" :background "Gray76"))))
 `(mode-line
   ((t (:foreground "#BCBCBC" :background "#000000"))))
 `(mode-line-inactive
   ((t (:foreground "#BCBCBC" :background "#000000"))))
 `(mode-line-buffer-id
   ((t (:foreground "#BCBCBC" :background "#000000" :weight bold))))
 `(mode-line-highlight
   ((t (:foreground "#BCBCBC" :background "#000000"))))
 `(mode-line-emphasis
   ((t (:foreground "#BCBCBC" :background "#000000")))))

;; minibuffer
(custom-set-faces
 `(minibuffer-prompt
   ((t (:foreground "DeepSkyBlue1")))))

;; whitespace
;; prevent colorization of `?\xA0' character
(custom-set-faces
 `(nobreak-space ((t nil))))

;; fontlock
(custom-set-faces
   `(font-lock-builtin-face ((t (:foreground "#FF80F4"))))
   `(font-lock-comment-delimiter-face ((t (:foreground "#8C8C8C"))))
   `(font-lock-comment-face ((t (:foreground "#8C8C8C"))))
   `(font-lock-constant-face ((t (:foreground "#FF80F4"))))
   `(font-lock-doc-face ((t (:foreground "#EEDC82"))))
   `(font-lock-doc-string-face ((t (:foreground "#EEDC82"))))
   `(font-lock-function-name-face ((t (:foreground "#A6E22E"))))
   `(font-lock-keyword-face ((t (:foreground "#F92672"))))
   `(font-lock-negation-char-face ((t (:foreground "#FF6C60"))))
   `(font-lock-number-face ((t (:foreground "#FC580C"))))
   `(font-lock-preprocessor-face ((t (:foreground "#F92672"))))
   `(font-lock-reference-face ((t (:foreground "#FF80F4"))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground "#A63A62"))))
   `(font-lock-regexp-grouping-construct ((t (:foreground "#A63A62"))))
   `(font-lock-string-face ((t (:foreground "#EEDC82"))))
   `(font-lock-type-face ((t (:foreground "#66D9EF"))))
   `(font-lock-variable-name-face ((t (:foreground "#FD971F"))))
   `(font-lock-warning-face ((t (:foreground "#FF6C60")))))


;; brackets
(custom-set-faces
 `(show-paren-match
   ((t (:foreground "DodgerBlue" :background nil))))
 `(show-paren-mismatch
   ((t (:foreground "orange" :background nil)))))

;; selection
;; Was "LightGoldenrod1" before
(custom-set-faces
 `(region
   ((t (:foreground "LawnGreen")))))


;; company
(let ((bg (face-attribute 'default :background)))
  (custom-set-faces
   `(company-tooltip ((t (:inherit default :background ,(color-lighten-name bg 2)))))
   `(company-scrollbar-bg ((t (:background ,(color-lighten-name bg 10)))))
   `(company-scrollbar-fg ((t (:background ,(color-lighten-name bg 5)))))
   `(company-tooltip-selection ((t (:inherit font-lock-function-name-face))))
   `(company-tooltip-common ((t (:inherit font-lock-constant-face))))))

;; popup
(let ((bg (face-attribute 'default :background)))
  (custom-set-faces
   `(popup-summary-face ((t (:inherit default :background ,(color-lighten-name bg 2)))))
   `(popup-tip-face ((t (:background ,(color-lighten-name bg 10)))))))


;; org
(custom-set-faces
 `(org-code ((t (:family "Ubuntu Mono" :inherit 'shadow))))
 `(org-verbatim ((t (:family "Ubuntu Mono" :inherit 'shadow))))
 `(org-block ((t (:family "Ubuntu Mono" :inherit 'shadow))))
 `(org-table ((t (:family "Ubuntu Mono" :foreground "LightSkyBlue"))))
 `(org-block-background ((t (:family "Ubuntu Mono" :background "gray5"))))
 `(org-block-begin-line ((t (:font "Source Code Pro 9" :inherit 'org-meta-line))))
 `(org-block-end-line ((t (:font "Source Code Pro 9" :inherit 'org-meta-line)))))


;; DEFUNS


(defun emacd-debug () (interactive) (message "Debug defun finished."))

(defun emacsd-insert-time (arg)
  (interactive "P")
  (cond ((not arg) (insert (format-time-string "%Y-%m-%d %A")))
	((equal arg '(4))
	 (insert (format-time-string "%Y-%m-%d %A"
				     (let ((time (current-time)))
				       (setf (nth 1 time) (- (nth 1 time) (* 60 60 24))) time))))))


(defun emacsd-org-insert-timestamp ()
  (interactive)
  (org-insert-time-stamp (current-time) t t))

(bind-keys
 :map org-mode-map
 :prefix "<f10>"
 :prefix-map emacsd-org-time-map
 ("<f10>" . emacsd-org-insert-timestamp)
 ("1" . emacsd-insert-time))


(define-key org-mode-map (kbd "<prior>") 'org-metaup)
(define-key org-mode-map (kbd "<next>") 'org-metadown)
(define-key org-mode-map (kbd "S-<prior>") 'org-shiftmetaup)
(define-key org-mode-map (kbd "S-<next>") 'org-shiftmetadown)

(define-key org-mode-map (kbd "M-\\") 'helm-org-in-buffer-headings)

(define-key org-mode-map (kbd "M-<prior>") 'org-backward-heading-same-level)
(define-key org-mode-map (kbd "M-<next>") 'org-forward-heading-same-level)
(define-key org-mode-map (kbd "M-<home>") 'outline-up-heading)
(define-key org-mode-map (kbd "M-<end>") 'org-next-visible-heading)

(define-key org-mode-map (kbd "s-\\") 'helm-org-agenda-files-headings)

(defun emacsd-org-insert-list-todo ()
  (interactive)
  (insert "- [ ] "))
(define-key org-mode-map (kbd "C-M-<return>") 'emacsd-org-insert-list-todo)


(defun emacsd-org-insert-statistic-cookie ()
  (interactive)
  (insert "[/]")
  (call-interactively 'org-update-statistics-cookies))

(define-key org-mode-map (kbd "C-c C-/") 'emacsd-org-insert-statistic-cookie)


(global-set-key (kbd "<f5>") 'describe-key-briefly)
(global-set-key (kbd "<f6>") 'emacsd-debug)

(global-set-key (kbd "C-c b") 'org-iswitchb)

(global-set-key (kbd "M-<tab>") 'other-window)
(global-set-key (kbd "C-c C-b") 'ibuffer)
(global-set-key (kbd "C-1") 'describe-key-briefly)
(global-set-key (kbd "C-2") 'dired-jump)

(global-set-key (kbd "M-<XF86Back>") 'next-buffer)

(defun emacsd-activate-region ()
  (interactive)
  (if mark-active
      (setq mark-active nil)
      (progn
	(exchange-point-and-mark)
	(exchange-point-and-mark))))

(global-set-key (kbd "C-SPC") 'emacsd-activate-region)


(defun emacsd-leave-mark ()
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(global-set-key (kbd "C-M-SPC") 'emacsd-leave-mark)

(use-package scratch
  :ensure t
  :config
  (global-set-key (kbd "C-c s") 'scratch)
  )





(defun emacsd-unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
  (when mark-ring
    (let ((pos (marker-position (car (last mark-ring)))))
      (if (not (= (point) pos))
	  (goto-char pos)
	(setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
	(set-marker (mark-marker) pos)
	(setq mark-ring (nbutlast mark-ring))
	(goto-char (marker-position (car (last mark-ring))))))))

(global-set-key (kbd "C-{") 'pop-to-mark-command)
(global-set-key (kbd "C-}") 'emacsd-unpop-to-mark-command)
(global-set-key (kbd "C-h") nil)


(define-key org-mode-map (kbd "M-n") 'emacsd-org-timestamp-move-up)
(define-key org-mode-map (kbd "M-p") 'emacsd-org-timestamp-move-down)

(define-key org-mode-map (kbd "C-c C-v C-/") 'org-babel-examplify-region)


(defun emacsd-org-timestamp-move-up ()
  (interactive)
  (re-search-forward org-element--timestamp-regexp nil t))

(defun emacsd-org-timestamp-move-down ()
  (interactive)
  (re-search-backward org-element--timestamp-regexp nil t))

(setq org-list-demote-modify-bullet '(("-" . "-")
				      ("1" . "+")))

(setq org-M-RET-may-split-line nil)
(setq org-support-shift-select t)
(setq org-emphasis-alist '(("*" bold)
			   ("/" italic)
			   ("_" underline)
			   ("`" org-code)))
(global-set-key (kbd "<f8>")
		'(lambda () (interactive)
		  (find-file "~/org/logs/journal.org")))

(require 'org-habit nil t)

(defun org-add-my-extra-fonts ()
  "Add alert and overdue fonts."
  (add-to-list 'org-font-lock-extra-keywords '("\\(!\\)\\([^\n\r\t]+\\)\\(!\\)" (1 '(face org-verbatim invisible t)) (2 'org-verbatim) (3 '(face org-verbatim invisible t)))))

;; (add-to-list 'org-font-lock-extra-keywords '("\\(%\\)\\([^\n\r\t]+\\)\\(%\\)" (1 '(face org-habit-overdue-face invisible t)) (2 'org-habit-overdue-face) (3 '(face org-habit-overdue-face invisible t)))))

(add-hook 'org-font-lock-set-keywords-hook #'org-add-my-extra-fonts)

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     :isearch t)))

(use-package yasnippet
    :demand t
    :ensure t
    :bind (:map yas-minor-mode-map
		("C-c C-y C-v" . yas-visit-snippet-file)
		("C-c C-y C-n" . yas-new-snippet)
		("C-c C-y C-c" . yas-insert-snippet)
		("C-c C-y C-d" . yas-describe-tables)
		("C-c C-y C-h" . yas-describe-table-by-namehash)
		("C-c C-y C-r" . yas-reload-all))
    :init
    (setq yas-alias-to-yas/prefix-p nil)
    (setq yas-prompt-functions
	  '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))
    (setq yas-snippet-dirs (list (concat user-emacs-directory "snippets"))))

(use-package multiple-cursors
    :demand t
    :ensure t
    :init
    (setq mc/insert-numbers-default 1)
    :config
    (global-set-key (kbd "C-c C-.") 'mc/edit-lines)
    (global-set-key (kbd "C->") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-c C-,") 'mc/mark-all-like-this))


(use-package drag-stuff
    :demand t
    :ensure t
    :bind (:map drag-stuff-mode-map
		("C-<up>" . drag-stuff-up)
		("C-<down>" . drag-stuff-down)))

(use-package emacs-lisp-mode
    :bind (:map emacs-lisp-mode-map ("C-M-x" . nil))
    :ensure nil
    :hook ((emacs-lisp-mode . drag-stuff-mode)
	   (emacs-lisp-mode . multiple-cursors-mode)
	   (emacs-lisp-mode . smartparens-mode)
	   (emacs-lisp-mode . linum-mode)
	   (emacs-lisp-mode . company-mode)
	   )
    :init
    (setq lisp-indent-function 'common-lisp-indent-function))

(global-set-key (kbd "C-x C-t") 'toggle-truncate-lines)
(global-set-key (kbd "C-x C-j") 'join-line)

(global-set-key (kbd "s-d") 'delete-window)
(global-set-key (kbd "s-o") 'delete-other-windows)
(global-set-key (kbd "s-w") 'delete-frame)
(global-set-key (kbd "s-n") 'make-frame)
(global-set-key (kbd "s-SPC") 'other-window)

(global-set-key (kbd "C-a") 'beginning-of-line)
(global-set-key (kbd "C-e") 'end-of-line)


(use-package markdown-mode
    :ensure t)





(global-set-key (kbd "<f12>") 'emacsd-agenda-active)
(setq org-agenda-window-setup 'only-window)

(global-set-key (kbd "C-x C-j") 'join-line)

(setq org-outline-path-complete-in-steps nil)

(directory-files "~/org/tasks/blogs" nil "[^\\.]")


(defun emacsd-org-refile-local ()
  (interactive)
  (setq org-refile-targets '((nil :maxlevel . 9)))
  (setq org-refile-use-outline-path t)
  (call-interactively 'org-refile))

(defun emacsd-org-refile-blog ()
  (interactive)
  (setq org-refile-targets `((,(directory-files "~/org/tasks/blogs" t "[^\\.]") :maxlevel . 9)))
  (setq org-refile-use-outline-path t)
  (call-interactively 'org-refile))

(defun emacsd-org-refile-agenda ()
  (interactive)
  (setq org-refile-targets '((org-agenda-files :maxlevel . 9)))
  (setq org-refile-use-outline-path 'file)
  (call-interactively 'org-refile))

(bind-keys
 :map org-mode-map
 :prefix "<f9>"
 :prefix-map emacsd-org-refile-map
 ("1" . emacsd-org-refile-local)
 ("2" . emacsd-org-refile-blog)
 ("3" . emacsd-org-refile-agenda))


(setq org-capture-templates
      '(("a" "Todo" entry (file "~/org/tasks/current/capture.org") "* TODO %?\n%U" :empty-lines 1)
	("b" "Blog" entry (file "~/org/tasks/blogs/capture.org") "* TODO %?\n%U" :empty-lines 1)
	))


(global-set-key (kbd "M-<f12>") 'org-agenda)
(global-set-key (kbd "<f11>") 'org-capture)

(setq org-todo-keywords '((sequence "TODO" "NEXT" "ACTIVE" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "pink" :weight bold))
	("NEXT" . (:foreground "DeepPink3" :weight bold))
	("ACTIVE" . (:foreground "yellow" :weight bold))
	("DONE" . (:foreground "PaleGreen" :weight bold))))



(defun emacsd-agenda-todo ()
  (interactive)
  (emacsd-agenda-generator "TODO"))

(defun emacsd-agenda-next ()
  (interactive)
  (emacsd-agenda-generator "NEXT"))

(defun emacsd-agenda-active ()
  (interactive)
  (emacsd-agenda-generator "ACTIVE"))

;; (define-prefix-command 'emacsd-agenda-map)
;; (global-set-key (kbd "<f12>") 'emacsd-agenda-map)
;; (global-set-key (kbd "<f12> 1") 'emacsd-agenda-todo)
;; (global-set-key (kbd "<f12> 2") 'emacsd-agenda-next)
;; (global-set-key (kbd "<f12> 3") 'emacsd-agenda-active)
(bind-keys
 :prefix "<f12>"
 :prefix-map emacsd-agenda-map
 ("1" . emacsd-agenda-todo)
 ("2" . emacsd-agenda-next)
 ("3" . emacsd-agenda-active))



(defun emacsd-agenda-generator (todo-keyword)
  (let ((org-agenda-custom-commands
	 `((" " "Agenda"
		,(mapcar
		  (lambda (category)
		    `(tags ,(concat "@" category "/" todo-keyword)
			   ((org-agenda-overriding-header (format "%s\n" ,(upcase category)))
			    (org-tags-match-list-sublevels nil)
			    ;; (org-agenda-prefix-format "  %?-12t% s")
			    (org-agenda-prefix-format  "%?-40(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\")")
			    (org-agenda-hide-tags-regexp
           ,(concat org-agenda-hide-tags-regexp "\\|@" category))
			    )))
		  
		  ;; dynamically generate the filenames from the candidate list
		  (mapcar (lambda (filename)
			    (file-name-sans-extension filename))
			  (directory-files "~/org/tasks/current" nil "[^\\.]")))
		

		nil))))
    (org-agenda nil " ")))

 (defun org-agenda-delete-empty-blocks ()
    "Remove empty agenda blocks.
  A block is identified as empty if there are fewer than 2
  non-empty lines in the block (excluding the line with
  `org-agenda-block-separator' characters)."
    (when org-agenda-compact-blocks
      (user-error "Cannot delete empty compact blocks"))
    (setq buffer-read-only nil)
    (save-excursion
      (goto-char (point-min))
      (let* ((blank-line-re "^\\s-*$")
             (content-line-count (if (looking-at-p blank-line-re) 0 1))
             (start-pos (point))
             (block-re (format "%c\\{10,\\}" org-agenda-block-separator)))
        (while (and (not (eobp)) (forward-line))
          (cond
           ((looking-at-p block-re)
            (when (< content-line-count 2)
              (delete-region start-pos (1+ (point-at-bol))))
            (setq start-pos (point))
            (forward-line)
            (setq content-line-count (if (looking-at-p blank-line-re) 0 1)))
           ((not (looking-at-p blank-line-re))
            (setq content-line-count (1+ content-line-count)))))
        (when (< content-line-count 2)
          (delete-region start-pos (point-max)))
        (goto-char (point-min))
        ;; The above strategy can leave a separator line at the beginning
        ;; of the buffer.
        (when (looking-at-p block-re)
          (delete-region (point) (1+ (point-at-eol))))))
    (setq buffer-read-only t))

  (add-hook 'org-agenda-finalize-hook #'org-agenda-delete-empty-blocks)
