;; repos for packages
(require 'package)
(add-to-list 'package-archives
  '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives 
  '("marmalade" . "https://marmalade-repo.org/packages/"))
(package-initialize)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit dired-hide-dotfiles csv-mode osx-trash markdown-mode highlight-symbol)))
 '(safe-local-variable-values (quote ((pyvenv-activate . "~/miniconda3/envs/witan.ap")))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; hide menu bar
(menu-bar-mode -1)

;; view recent files
(recentf-mode 1)
(setq recentf-max-menu-items 50)


;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; Set the default comment column to 70
(setq-default comment-column 70)


;; Clojure stuff
;(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;(add-hook 'prog-mode-hook 'highlight-symbol-mode)
;(setq show-paren-delay 0)
;(show-paren-mode 1)

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

;; transpose-frame
(require 'transpose-frame)

;; dired settings
(setq dired-dwim-target t)
;(when (eq system-type 'darwin)
;  (osx-trash-setup))
(setq delete-by-moving-to-trash t)

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



;; Cua mode (copy, paste, undo with C-c,v,z) 
(cua-mode t)

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


;;spell checker
(setq ispell-program-name "aspell")


;;mode launching commands (C-x x)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)
(global-set-key (kbd "C-x r") 'recentf-open-files)
(global-set-key (kbd "C-x f") 'find-file)
(global-set-key (kbd "C-x C-?") 'ispell)
(global-set-key (kbd "C-x ?") 'ispell)
(global-set-key (kbd "C-x g") 'magit-status)

;;navigation commands (C-c x)
(global-set-key (kbd "C-c t") 'transpose-frame)
(global-set-key (kbd "C-c r") 'flop-frame)
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<left>") 'windmove-left)
(global-set-key (kbd "S-<up>") 'windmove-up)
(global-set-key (kbd "S-<down>") 'windmove-down)
(global-set-key (kbd "C-c n") (kbd "C-u 18 C-x {"))
(global-set-key (kbd "C-c w") (kbd "C-u 18 C-x }"))


(defun dired-mode-key-bindings-hook ()
  (local-set-key (kbd "C-x <up>") 'dired-up-directory)
  (local-set-key (kbd "C-x C-<up>") 'dired-up-directory)
  (local-set-key (kbd "C-x <RET>") 'open-in-external-app)
  (local-set-key (kbd "C-c o") 'open-in-external-app)
  (local-set-key (kbd ".") 'dired-hide-dotfiles-mode)
  (local-set-key (kbd "C-<up>") (kbd "C-u 10 <up>"))
  (local-set-key (kbd "C-<down>") (kbd "C-u 10 <down>")))

(add-hook 'dired-mode-hook 'dired-mode-key-bindings-hook)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
