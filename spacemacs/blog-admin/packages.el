(defconst blog-admin-packages
  '((blog-admin :location (recipe
                           :fetcher github
                           :repo "codefalling/blog-admin"))
    )
  )

(defun blog-admin/init-blog-admin ()
  (use-package blog-admin
    :init
    (progn
      (setq blog-admin-backend-path "~/blog"
            blog-admin-backend-type 'hexo
            blog-admin-backend-new-post-in-drafts t
            blog-admin-backend-new-post-with-same-name-dir t
            blog-admin-backend-org-page-drafts "_drafts"
            )
      ))
  )
