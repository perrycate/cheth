(dolist (asd (directory (merge-pathnames "deps/**/*.asd")))
  (asdf:load-asd asd))
