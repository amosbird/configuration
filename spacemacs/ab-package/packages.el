;;; packages.el --- ab-package layer packages file for Spacemacs.
;; Author: Amos Bird <amosbird@gmail.com>
;; URL: https://github.com/amosbird/configuration

(defconst ab-package-packages
  '(
    ;; post hooks
    projectile
    go-mode
    company
    company-ycmd
    mu4e

    ;; init hooks
    quickrun
    editorconfig
    fullframe
    evil-terminal-cursor-changer
    thrift
    protobuf-mode
    (evil-textobj-line :location (recipe
                                  :fetcher github
                                  :repo "syohex/evil-textobj-line"))
    (fcitx :location (recipe
                      :fetcher github
                      :repo "cute-jumper/fcitx.el"))
    (centering-window-mode :location local)
    (ab-osc52 :location local)

    (evil-escape :excluded t)
    (ggtags :excluded t)
    )
  )

(defun ab-package/init-fcitx ()
  ;; (use-package fcitx)
  ;; (fcitx-aggressive-setup)
  )
(defun ab-package/init-evil-terminal-cursor-changer ()
  (use-package evil-terminal-cursor-changer)
  )
(defun ab-package/init-evil-textobj-line ()
  (use-package evil-textobj-line)
  )
(defun ab-package/init-quickrun ()
  (use-package quickrun)
  )
(defun ab-package/init-editorconfig ()
  (use-package editorconfig)
  )
(defun ab-package/init-fullframe ()
  (use-package fullframe)
  )
(defun ab-package/init-protobuf-mode ()
  (use-package protobuf-mode)
  )

(defun ab-package/init-centering-window-mode ()
  (use-package centering-window-mode)
  )

(defun ab-package/init-ab-osc52 ()
  (use-package ab-osc52
    :demand 't)
  )
(defun ab-package/post-init-ab-osc52 ()
  (if (eq (framep (selected-frame)) 't)
      (setq interprogram-cut-function 'osc52-select-text)
    )
  (add-hook 'after-make-frame-functions
    (lambda (frame)
      (if (eq (framep frame) 't)
          (setq interprogram-cut-function 'osc52-select-text)
        )
      ))
  )

(defun ab-package/init-thrift ()
  (use-package thrift)
  )
(defun ab-package/post-init-thrift ()
  (add-hook 'thrift-mode-hook 'helm-gtags-mode)
  (add-hook 'thrift-mode-hook
            (lambda ()
              (modify-syntax-entry ?< ".")
              (use-local-map spacemacs-thrift-mode-map-root-map)))
  (spacemacs/set-leader-keys-for-major-mode 'thrift-mode
    "gc" 'helm-gtags-create-tags
    "gd" 'helm-gtags-find-tag
    "gD" 'helm-gtags-find-tag-other-window
    "gf" 'helm-gtags-select-path
    "gg" 'helm-gtags-find-tag
    "gG" 'helm-gtags-find-tag-other-window
    "gi" 'helm-gtags-tags-in-this-function
    "gl" 'helm-gtags-parse-file
    "gn" 'helm-gtags-next-history
    "gp" 'helm-gtags-previous-history
    "gr" 'helm-gtags-find-rtag
    "gR" 'helm-gtags-resume
    "gs" 'helm-gtags-select
    "gS" 'helm-gtags-show-stack
    "gu" 'helm-gtags-update-tags)
  )

(defun ab-package/post-init-projectile ()
  (with-eval-after-load 'projectile
    (push '("h" "c" "cc" "cpp" "ipp" "hpp" "cxx" "ixx" "hxx" "m" "mm")
          projectile-other-file-alist)
    (push '("cc" "h" "hpp") projectile-other-file-alist))
  )

(defun ab-package/post-init-mu4e ()

  (setq mu4e-maildir "~/Mail"
        mu4e-split-view 'vertical
        mu4e-drafts-folder "/drafts"
        mu4e-trash-folder "/trash"
        mu4e-sent-folder "/sent"
        mu4e-refile-folder "/archive"
        mu4e-get-mail-command "fdm fetch"
        mu4e-update-interval nil
        mu4e-compose-signature-auto-include nil
        mu4e-view-show-images t
        mu4e-use-fancy-chars t
        mu4e-attachment-dir "~/Downloads"
        message-send-mail-function 'message-send-mail-with-sendmail
        message-sendmail-envelope-from 'header
        sendmail-program "msmtp"
        mu4e-context-policy 'pick-first
        mu4e-compose-context-policy nil
        mu4e-maildir-shortcuts
        '(("/drafts"                    . ?d)
          ("/sent"                      . ?s)
          ("/archive"                   . ?a)
          ("/trash"                     . ?t)
          ("/inbox"                     . ?j))
        mu4e-view-show-addresses t)

  (with-eval-after-load 'mu4e
    (evilified-state-evilify-map mu4e-main-mode-map
      :mode mu4e-main-mode
      :bindings
      (kbd "C-s") 'helm-swoop
      (kbd "j") 'mu4e~headers-jump-to-maildir)

    (evilified-state-evilify-map
      mu4e-headers-mode-map
      :mode mu4e-headers-mode
      :bindings
      (kbd "C-s") 'helm-swoop
      (kbd "C-j") 'mu4e-headers-next
      (kbd "C-k") 'mu4e-headers-prev
      (kbd "J") (lambda ()
                  (interactive)
                  (mu4e-headers-mark-thread nil '(read))))

    (evilified-state-evilify-map
      mu4e-view-mode-map
      :mode mu4e-view-mode
      :bindings
      (kbd "C-s") 'helm-swoop
      (kbd "C-j") 'mu4e-view-headers-next
      (kbd "C-k") 'mu4e-view-headers-prev
      (kbd "J") (lambda ()
                  (interactive)
                  (mu4e-view-mark-thread '(read))))
    (define-key mu4e-view-mode-map (kbd "f") 'mu4e-view-go-to-url)

    (add-to-list 'mu4e-view-actions
                 '("xwidget" . mu4e-action-view-with-xwidget) t)

    (setq mu4e-contexts
          `( ,(make-mu4e-context
               :name "gmail"
               :enter-func (lambda () (mu4e-message "Entering gmail context"))
               :leave-func (lambda () (mu4e-message "Leaving gmail context"))
               ;; we match based on the contact-fields of the message
               :match-func (lambda (msg)
                             (when msg
                               (mu4e-message-contact-field-matches msg
                                                                   :to "amosbird@gmail.com")))
               :vars '(  ( user-mail-address       . "amosbird@gmail.com" )
                         ( user-full-name          . "Amos Bird" )
                         ( mu4e-compose-signature  .
                                                   (concat
                                                    "Amos Bird\n"
                                                    "amosbird@gmail.com\n") )
                         ))
             ,(make-mu4e-context
               :name "ict"
               :enter-func (lambda () (mu4e-message "Switch to the ict context"))
               ;; no leave-func
               ;; we match based on the contact-fields of the message
               :match-func (lambda (msg)
                             (when msg
                               (mu4e-message-contact-field-matches msg
                                                                   :to "zhengtianqi@software.ict.ac.cn")))
               :vars '(  ( user-mail-address       . "zhengtianqi@software.ict.ac.cn" )
                         ( user-full-name          . "郑天祺" )
                         ( mu4e-compose-signature  .
                                                   (concat
                                                    "中科院计算所 网络数据实验室\n"))))
             ,(make-mu4e-context
               :name "work"
               :enter-func (lambda () (mu4e-message "Switch to the golaxy context"))
               ;; no leave-func
               :match-func (lambda (msg)
                             (when msg
                               (mu4e-message-contact-field-matches msg
                                                                   :to "zhengtianqi@golaxy.cn")))
               :vars '(  ( user-mail-address       . "zhengtianqi@golaxy.cn" )
                         ( user-full-name          . "郑天祺" )
                         ( mu4e-compose-signature  .
                                                   (concat
                                                    "中科天玑数据科技股份有限公司\n"))))))

    (add-hook 'mu4e-compose-mode-hook 'company-mode)
  )

  (defun ab-url-mail (url)
    ""
    (interactive)
    (mu4e~compose-browse-url-mail url))
  (require 'fullframe)
  (fullframe ab-url-mail kill-buffer)
  ;; (require 'bbdb-loaddefs)
  ;; (setq bbdb-mail-user-agent (quote message-user-agent))
  ;; (setq mu4e-view-mode-hook (quote (bbdb-mua-auto-update visual-line-mode)))
  ;; (setq mu4e-compose-complete-addresses nil)
  ;; (setq bbdb-mua-pop-up t)
  ;; (setq bbdb-mua-pop-up-window-size 5)

)

(defun ab-package/post-init-company ()
  (with-eval-after-load 'company
    (defun ab/company-complete (ofun &rest args)
      (if (string= evil-state "insert")
          (progn
            (save-excursion
              (insert " "))
            (apply ofun args)
            (delete-char 1))
        ;; prevent company pop up in modes other than INSERT
        (company-cancel)
        ))

    (advice-add 'company--perform :around #'ab/company-complete)

    (defun ab/symbol-suffix ()
      (interactive)
      (let ((beg (point))
            (char (char-after)))
        (if (or (= char ?-) (memq (get-char-code-property char 'general-category)
                                  '(Ll Lu Lo Lt Lm Mn Mc Me Nl)))
            (save-excursion
              (forward-symbol 1)
              (buffer-substring beg (point))
              )
          (string char))
        )
      )

    ;; suppose candidates are trimmed without arguments by backend
    ;; or else we need
    ;; (new-candidate
    ;;  (let ((pos (s-index-of "(" candidate)))
    ;;    (if pos (s-left pos candidate)
    ;;      candidate)
    ;;    )
    ;;  )
    (defun ab/company-insert (ofun candidate)
      (let* (
             (suffix (ab/symbol-suffix))
             )
        (if (s-suffix? suffix candidate)
            (delete-region (point) (+ (point) (length suffix)))
          )
        (if (string= (kbd "C-i") (this-command-keys))
            (setq company-ycmd-insert-arguments nil)
          (setq company-ycmd-insert-arguments 't)
          )
        (apply ofun (list candidate))
        )
      )
    (advice-add 'company--insert-candidate :around #'ab/company-insert)

    (push 'backward-delete-char-untabify company-begin-commands)
    (define-key company-active-map (kbd "C-i") 'company-complete-selection)
    (if (display-graphic-p (selected-frame))
        (define-key company-active-map (kbd "C-h") 'delete-backward-char)
      )
    (define-key company-active-map (kbd "C-w") 'backward-kill-word)
    (define-key company-active-map (kbd "C-u") '(lambda () (interactive) (kill-line 0)))

    (setq-default
     company-selection-wrap-around t
     company-frontends
     '(company-pseudo-tooltip-frontend
       company-echo-metadata-frontend)
     company-minimum-prefix-length 1
     ))
)

(defun ab-package/post-init-go-mode ()
  (when (configuration-layer/package-usedp 'clean-aindent-mode)
      (add-hook 'go-mode-hook (lambda ()(clean-aindent-mode -1)) t)
    )
  )

;; it also loads ycmd
(defun ab-package/post-init-company-ycmd ()
  (setq-default
   ycmd-server-command (list "python" (expand-file-name "~/softwares/ycmd/ycmd"))
   ycmd-extra-conf-whitelist (list (expand-file-name "~/*"))
   ycmd-force-semantic-completion t)
  (when (configuration-layer/package-usedp 'rust-mode)
    (add-to-list 'company-backends-rust-mode 'company-ycmd)
    (add-hook 'rust-mode-hook 'ycmd-mode)
    )
  (when (configuration-layer/package-usedp 'go-mode)
    (add-to-list 'company-backends-go-mode 'company-ycmd)
    (add-hook 'go-mode-hook 'ycmd-mode t)
    (add-hook 'go-mode-hook (lambda ()(setq spacemacs-jump-handlers (cons 'ycmd-goto nil))) t)
    )
  (when (configuration-layer/package-usedp 'python)
    (add-to-list 'company-backends-python-mode 'company-ycmd)
    (add-hook 'python-mode-hook 'ycmd-mode)
    )
  )
