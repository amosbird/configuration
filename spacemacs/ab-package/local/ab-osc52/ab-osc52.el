;;;###autoload
(defun osc52-select-text (string &optional replace yank-handler)
  (let ((b64-length (+ (* (length string) 3) 2)))
    (if (<= b64-length 100000)
        (send-string-to-terminal
         (let ((osc-string
                (concat "\e]52;c;"
                        (base64-encode-string (encode-coding-string string 'utf-8) t)
                        "\07")))
           (if (getenv "TMUX")
               (concat "\033Ptmux;\033"
                       osc-string
                       "\033\\")
             osc-string
             )
           )
         )
      (message "Selection too long to send to terminal %d" b64-length)
      (sit-for 2))))
(provide 'ab-osc52)
