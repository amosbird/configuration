(defconst c-c++-hook-packages
  '(cc-mode
    (cc-styles :location built-in)))

(defun c-c++-hook/init-cc-styles ()
  (use-package cc-styles
    :defer t
    :config
    (progn
      (c-add-style "amos"
                   '((indent-tabs-mode . nil)
                     (c-basic-offset . 2)
                     (c-offsets-alist
                      (substatement-open . 0)
                      (inline-open . 0)
                      (statement-cont . c-lineup-assignments)
                      (inextern-lang . 0)
                      (innamespace . 0))))
      (c-add-style "sintef"
                   '((indent-tabs-mode . nil)
                     (c-basic-offset . 2)
                     (c-offsets-alist
                      (substatement-open . 0)
                      (inline-open . 0)
                      (statement-cont . c-lineup-assignments)
                      (inextern-lang . 0)
                      (innamespace . 0))))
      (push '(other . "amos") c-default-style))))
