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
 '(package-selected-packages
   (quote
    (w3m transpose-frame rainbow-delimiters scala-mode magit dired-hide-dotfiles csv-mode osx-trash markdown-mode highlight-symbol))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROD REPORT INIT

;; hide menu bar
;(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
 
;; Cua mode (copy, paste, undo with C-c,v,z) 
(cua-mode t)

;;navigation commands (C-c x)
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<left>") 'windmove-left)
(global-set-key (kbd "S-<up>") 'windmove-up)
(global-set-key (kbd "S-<down>") 'windmove-down)

;; dired settings
(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header 
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))

(defun dired-mode-key-bindings-hook ()
  (local-set-key (kbd "C-x <up>") 'dired-up-directory)
  (local-set-key (kbd "C-x C-<up>") 'dired-up-directory)
  (local-set-key (kbd "C-x <RET>") 'open-in-external-app)  ;;rm
  (local-set-key (kbd "C-c o") 'open-in-external-app)  ;;rm
  (local-set-key (kbd ".") 'dired-hide-dotfiles-mode)  ;;rm   
  (local-set-key (kbd "C-<up>") (kbd "C-u 10 <up>"))
  (local-set-key (kbd "C-<down>") (kbd "C-u 10 <down>")))

(add-hook 'dired-mode-hook 'dired-mode-key-bindings-hook)

(defun comint-mode-key-bindings-hook ()
  (local-set-key (kbd "C-c <up>") 'comint-previous-input))

(add-hook 'comint-mode-hook 'comint-mode-key-bindings-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; END PROD REPORT INIT

;; view recent files
(recentf-mode 1)
(setq recentf-max-menu-items 50)


;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; Set the default comment column to 70
;;(setq-default comment-column 70)


;;; Comments or uncomments the region or the current line if there's no active region.
;; ;; (defun comment-or-uncomment-region-or-line ()
;; ;;  (if (region-active-p)
;;     (setq beg (region-beginning) end (region-end))
;;             (setq beg (line-beginning-position) end (line-end-position)))
;;         (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-/") 'comment-line)

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


;; open dired file in external app
(defun open-in-external-app ()
  (interactive)
  (let* (
         ($file-list
          (if (string-equal major-mode "dired-mode")
              (dired-get-marked-files)
            (list (buffer-file-name))))
         ($do-it-p (if (<= (length $file-list) 5)
                       t
                     (y-or-n-p "Open more than 5 files? "))))
    (when $do-it-p
      (mapc
         (lambda ($fpath)
           (shell-command
            (concat "open " (shell-quote-argument $fpath))))  $file-list))))

;; 
(defalias 'yes-or-no-p 'y-or-n-p)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;spell checker
(setq ispell-program-name "aspell")


;;mode launching commands (C-x x)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)
(global-set-key (kbd "C-x r") 'recentf-open-files)
(global-set-key (kbd "C-x f") 'find-file)
(global-set-key (kbd "C-x C-?") 'ispell)
(global-set-key (kbd "C-x ?") 'ispell)
(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "C-c n") (kbd "C-u 18 C-x {"))
(global-set-key (kbd "C-c w") (kbd "C-u 18 C-x }"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; SuperCollider
(require 'sclang)
(setq exec-path (append exec-path '("/Applications/SuperCollider.app/Contents/MacOS")))
(require 'w3m)
(eval-after-load "w3m"
 '(progn
 (define-key w3m-mode-map [left] 'backward-char)
 (define-key w3m-mode-map [right] 'forward-char)
 (define-key w3m-mode-map [up] 'previous-line)
 (define-key w3m-mode-map [down] 'next-line)))
(setq ring-bell-function 'ignore)
(add-hook 'sclang-mode-hook #'rainbow-delimiters-mode)
