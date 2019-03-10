;; clock
(require 'time)
(display-time)
(setq display-time-24hr-format t)

;; layout
(column-number-mode t)
(line-number-mode t)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(add-to-list 'default-frame-alist '(internal-border . 0))

(setq visible-bell t)

(setq-default fill-column 80)

(global-hl-line-mode 1)

(setq case-fold-search t)

(if (< emacs-major-version 24)
    (pc-selection-mode 1)
  (progn
    (delete-selection-mode 1)
    (setq x-select-enable-clipboard t
					x-select-enable-primary t)))


(setq select-active-regions t)

;; theme

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)

;; font customization
;;(set-default-font "DejaVu Sans Mono Book 12")
(set-default-font "Monaco 16")

(require 'package)

;; Repositories
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("elpa" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.org/packages/"))
  (package-refresh-contents)
  (package-initialize)
  (package-install 'el-get)
  (require 'el-get))

(defun el-get-cleanup (packages)
  "Remove packages not explicitly declared"
  (let* ((packages-to-keep (el-get-dependencies (mapcar 'el-get-as-symbol packages)))
         (packages-to-remove (set-difference (mapcar 'el-get-as-symbol
                                                     (el-get-list-package-names-with-status
                                                      "installed")) packages-to-keep)))
    (mapc 'el-get-remove packages-to-remove)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (zone-nyan zone-rainbow))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
