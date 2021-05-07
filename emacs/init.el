;; repos for packages
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/"))
;(add-to-list 'package-archives 
;  '("marmalade" . "https://marmalade-repo.org/packages/"))
(package-initialize)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(package-selected-packages
   (quote
    (transpose-frame scala-mode magit dired-hide-dotfiles csv-mode osx-trash markdown-mode highlight-symbol)))
 '(tool-bar-mode nil))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROD REPORT INIT

(cua-mode t)
(ido-mode 1)


;; hide menu bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; navigation
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <left>") 'windmove-left)
(global-set-key (kbd "C-c <up>") 'windmove-up)
(global-set-key (kbd "C-c <down>") 'windmove-down)


;; dired sort directories first
(defun mydired-sort ()
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2)
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))
(defadvice dired-readin
    (after dired-after-updating-hook first () activate)
  (mydired-sort))


;; dired navigation
(defun dired-mode-key-bindings-hook ()
  (local-set-key (kbd "C-x <up>") 'dired-up-directory)
  (local-set-key (kbd "C-x C-<up>") 'dired-up-directory)
  (local-set-key (kbd "C-<up>") (kbd "C-u 10 <up>"))
  (local-set-key (kbd "C-<down>") (kbd "C-u 10 <down>")))

(add-hook 'dired-mode-hook 'dired-mode-key-bindings-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; END PROD REPORT INIT

;; view recent files
(recentf-mode 1)
(setq recentf-max-menu-items 50)


;; UTF-8 as default encoding
(set-language-environment "UTF-8")


;custom load paths
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes") ;themes
(add-to-list 'load-path "~/.emacs.d/extras/") ;add-on packages


;; Paste into terminal from OSX
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)


;;load theme
(load-theme 'forest-blue t)

; dired dwim
(setq dired-dwim-target t)
;(when (eq system-type 'darwin)
;  (osx-trash-setup))
(setq delete-by-moving-to-trash t)
