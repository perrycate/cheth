(defsystem :cheth-test
  :depends-on (:cheth)
  :components (
               (:module "t"
                :components ((:file "util")
                             (:file "chessboard-test")))))
