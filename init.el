; basic key bind
(keyboard-translate ?\C-h ?\C-?)
(global-unset-key "\C-z")
(define-key global-map [?¥] [?\\])
(global-auto-revert-mode 1)

;; Cask
(require 'cask "/usr/local/opt/cask/cask.el")
(cask-initialize)

;; path
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; replace Command and Option
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; character-code
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; fonts
(when (display-graphic-p)
  (set-face-attribute 'default nil
                      :family "Ricty"
                      :height 140)
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0208
                    (cons "Ricty" "iso10646-1"))
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0212
                    (cons "Ricty" "iso10646-1"))
  (set-fontset-font (frame-parameter nil 'font)
                    'katakana-jisx0201
                    (cons "Ricty" "iso10646-1"))
  )


;; add package site
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(package-initialize)

;;;; elscreen ;;;;
(setq elscreen-prefix-key "\C-j")
(global-set-key [(C-tab)] 'elscreen-next)
(global-set-key [(C-S-tab)] 'elscreen-previous)
(elscreen-start)
; disable ctrl-j on lisp-interaction-mode
(add-hook 'lisp-interaction-mode-hook
          (lambda ()
            (progn
              (local-unset-key "\C-j")
              (local-set-key "\C-J" 'eval-print-last-sexp))))

(when window-system
  (add-hook 'after-init-hook
            '(lambda ()
               (run-with-idle-timer
                0.1
                nil
                '(lambda ()
                   (set-frame-parameter nil 'fullscreen 'maximized))))))


;;;; color-theme ;;;;
(require 'color-theme)
(color-theme-initialize)
(when (display-graphic-p) (color-theme-classic))


;;;; linum ;;;;
(global-linum-mode t)
(setq linum-format "%5d ")

;;;; global ;;;;
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))
(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1)
             (gtags-make-complete-list)
             ))

;;;;;; company-mode ;;;;
(global-company-mode +1)

;;;; helm ;;;;
(require 'helm-config)
(require 'helm-files)
(require 'helm-for-files)
(global-set-key (kbd "C-l") 'helm-mini)
(helm-mode 1)
(define-key global-map (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;(add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
;;;;;; helm-ghq ;;;;;;
(add-to-list 'helm-for-files-preferred-list 'helm-source-ghq)
(define-key global-map (kbd "C-'") 'helm-ghq)

;;;;;; helm-git-grep ;;;;;;
(require 'helm-git-grep) ;; Not necessary if installed by package.el
(global-set-key (kbd "C-c g") 'helm-git-grep)
(global-set-key (kbd "C-c i") 'helm-git-grep-at-point)
;; Invoke `helm-git-grep' from isearch.
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
;; Invoke `helm-git-grep' from other helm.
(eval-after-load 'helm
  '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))

;;;; git-gutter-fringe ;;;;
(when (display-graphic-p)
  (require 'git-gutter-fringe)
  (global-git-gutter-mode))

;;;; indent ;;;;
(setq-default c-basic-offset 2
              tab-width 2
              indent-tabs-mode nil)

;(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; javascript ;;
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))

(eval-after-load 'flycheck
  '(progn
     (flycheck-add-mode 'javascript-eslint 'web-mode)
     (flycheck-add-mode 'javascript-eslint 'js2-mode)
     (flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)
     '(custom-set-variables
       '(flycheck-disabled-checkers '(javascript-jshint javascript-jscs javascript-gjslint))
       )))

(setq-default flycheck-disabled-checkers '(javascript-jshint))
(setq-default flycheck-disabled-checkers '(javascript-jscs))
(setq-default flycheck-disabled-checkers '(javascript-gjslint))

(setq js2-strict-trailing-comma-warning nil)
(setq js2-strict-missing-semi-warning t)
(setq js2-missing-semi-one-line-override t)
(setq js2-strict-inconsistent-return-warning nil)
(setq js-switch-indent-offset 2)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-javascript-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
)

(add-hook 'web-mode-hook  'my-web-mode-hook)

;; scss mode
(defun scss-custom ()
  "scss-mode-hook"
  (and
   (set (make-local-variable 'css-indent-offset) 2)
   (set (make-local-variable 'scss-compile-at-save) nil)
   )
  )
(add-hook 'scss-mode-hook
  '(lambda() (scss-custom)))

;; coffee-mode ;;
;(autoload 'coffee-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.cjsx$" . coffee-mode))

;; ruby-mode ;;
(add-to-list 'auto-mode-alist '("Capfile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))
(setq ruby-insert-encoding-magic-comment nil)

;; prolog-mode ;;
(setq auto-mode-alist
      (append '(("\\.pl" . prolog-mode))
              auto-mode-alist))
(setq prolog-program-name "gprolog")
(setq prolog-consult-string "[%f].\n")

;; haskell
(add-hook 'haskell-mode-hook
          (lambda ()
            (progn
;              (turn-on-haskell-simple-indent)
              (turn-on-haskell-indent)
              (c-basic-offset 4)
              (tab-width 4)
              )))

;; swift
(add-hook 'swift-mode-hook
          (lambda ()
            (setq-local tab-width 4)
            (defvar swift-indent-offset)
            (setq-local swift-indent-offset 4)))


;; golang

(add-hook 'go-mode-hook 'flycheck-mode)
(add-hook 'go-mode-hook
          (lambda()
            (add-hook 'before-save-hook' 'gofmt-before-save)
            (local-set-key (kbd "M-.") 'godef-jump)
            (set (make-local-variable 'company-backends) '(company-go))
            (setq c-basic-offset 4)
            (setq tab-width 4)))

(require 'company-go)
(add-hook 'go-mode-hook
          (lambda()
            (company-mode)
            (setq company-transformers '(company-sort-by-backend-importance))
            (setq company-idle-delay 0)
            (setq company-minimum-prefix-length 3)
            (setq company-selection-wrap-around t)
            (setq completion-ignore-case t)
            (setq company-dabbrev-downcase nil)
            (global-set-key (kbd "C-M-i") 'company-complete)
            (define-key company-active-map (kbd "C-n") 'company-select-next)
            (define-key company-active-map (kbd "C-p") 'company-select-previous)
            (define-key company-active-map (kbd "C-s") 'company-filter-candidates)
            (define-key company-active-map [tab] 'company-complete-selection)
            (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
            ))

;; rainbow mode
(require 'rainbow-mode)
(add-hook 'css-mode-hook  'rainbow-mode)
(add-hook 'scss-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)

;; TODO customize whitespace-mode config
;; see http://www.emacswiki.org/emacs/WhiteSpace
(global-whitespace-mode 1)

(line-number-mode t)
(column-number-mode t)

(show-paren-mode 1)

(defun update-alpha () (set-frame-parameter nil 'alpha frame-alpha))
(defun up-alpha ()
  "set frame parameter 'alpha"
  (interactive)
  (set 'frame-alpha (min (+ frame-alpha 5) 100))
  (update-alpha))
(defun down-alpha ()
  "set frame parameter 'alpha"
  (interactive)
  (set 'frame-alpha (max (- frame-alpha 5) 0))
  (update-alpha))
(set 'frame-alpha 90)
(update-alpha)

(global-set-key (kbd "C-x C-p") 'up-alpha)
(global-set-key (kbd "C-x C-n") 'down-alpha)

(setq inhibit-startup-message t)
(cd "~/")
