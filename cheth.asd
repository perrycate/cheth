(defsystem :cheth/evil-compatibility-hacks
  :components ((:file "evil-compatibility-hacks")))

(defsystem :cheth
  :depends-on (
               :cheth/evil-compatibility-hacks
               :cl-gtk2-gtk
               :cl-gtk2-cairo)
  :components (
               (:file "package")
               (:module "src/pieces"
                :components ((:file "black-bishop")
                             (:file "black-king")
                             (:file "black-knight")
                             (:file "black-pawn")
                             (:file "black-queen")
                             (:file "black-rook")
                             (:file "white-bishop")
                             (:file "white-king")
                             (:file "white-knight")
                             (:file "white-pawn")
                             (:file "white-queen")
                             (:file "white-rook")))
               (:module "src"
                :components (
                             (:file "chessboard")
                             (:file "cheth")
                             (:file "test")))))
