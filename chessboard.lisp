(asdf:operate 'asdf:load-op :cl-cairo2)
(use-package :cl-cairo2)
(defparameter *surface* (create-pdf-surface "test.pdf" 600 600))
(setf *context* (create-context *surface*))

(defparameter *starting-position*
  '(
    (:a1 . (:white :rook))
    (:b1 . (:white :knight))
    (:c1 . (:white :bishop))
    (:d1 . (:white :queen))
    (:e1 . (:white :king))
    (:f1 . (:white :bishop))
    (:g1 . (:white :knight))
    (:h1 . (:white :rook))

    (:a2 . (:white :pawn))
    (:b2 . (:white :pawn))
    (:c2 . (:white :pawn))
    (:d2 . (:white :pawn))
    (:e2 . (:white :pawn))
    (:f2 . (:white :pawn))
    (:g2 . (:white :pawn))
    (:h2 . (:white :pawn))


    (:a7 . (:black :pawn))
    (:b7 . (:black :pawn))
    (:c7 . (:black :pawn))
    (:d7 . (:black :pawn))
    (:e7 . (:black :pawn))
    (:f7 . (:black :pawn))
    (:g7 . (:black :pawn))
    (:h7 . (:black :pawn))

    (:a8 . (:black :rook))
    (:b8 . (:black :knight))
    (:c8 . (:black :bishop))
    (:d8 . (:black :queen))
    (:e8 . (:black :king))
    (:f8 . (:black :bishop))
    (:g8 . (:black :knight))
    (:h8 . (:black :rook))
    ))

;; The whole drawing surface be painted over,
;; so this red is just to highlight if something is misaligned.
(set-source-rgb 1 0 0)
(paint)

;; One day I will figure out how to actually make this all a cohesive package.
;; Today is not that day.
(dolist (file (directory "pieces/*.lisp"))
  (load file))

(defun draw-piece (color piece pixel-coordinates board-width)
  (destructuring-bind (x-offset y-offset) pixel-coordinates
    (let* ((width (/ board-width 8))
           (x (* x-offset width))
           (y (* y-offset width)))
      (cond
        ((and (eq color :white) (eq piece :pawn)) (draw-white-pawn x y width))
        ((and (eq color :white) (eq piece :knight)) (draw-white-knight x y width))
        ((and (eq color :white) (eq piece :bishop)) (draw-white-bishop x y width))
        ((and (eq color :white) (eq piece :rook)) (draw-white-rook x y width))
        ((and (eq color :white) (eq piece :queen)) (draw-white-queen x y width))
        ((and (eq color :white) (eq piece :king)) (draw-white-king x y width))

        ((and (eq color :black) (eq piece :pawn)) (draw-black-pawn x y width))
        ((and (eq color :black) (eq piece :knight)) (draw-black-knight x y width))
        ((and (eq color :black) (eq piece :bishop)) (draw-black-bishop x y width))
        ((and (eq color :black) (eq piece :rook)) (draw-black-rook x y width))
        ((and (eq color :black) (eq piece :queen)) (draw-black-queen x y width))
        ((and (eq color :black) (eq piece :king)) (draw-black-king x y width))
        ))
    ))

;; TODO I wonder if I can just get width from the context?
;; Would need to call gdk:drawable-get-size on the widget window.
;; The context takes the widget window as a parameter, so I bet I can
;; get it.
(defun draw-board (width)
  (let ((square-width (/ width 8)))
    (dotimes (x 8)
      (dotimes (y 8)
        (rectangle (* x square-width) (* y square-width) square-width square-width)
        ;; Alternate square colors.
        (if (= (mod (+ x y) 2) 0) (set-source-rgb 1 1 1) (set-source-rgb 0 0 0))
        (fill-path)
        ))
    ))

;; Translates a square value (eg :b2) into x and y coordinates, where each square
;; is one unit, and the top left square is (0,0).
;; e.g. :b2 -> (1,6).
;;
;; (Having 0,0 be in the top left instead of bottom left matches Cairo's coordinate
;; system, so all we have to do is scale the coordinates to the resolution we're using.)
(defun get-coordinates (square)
  (let* (
         (s (string square))

         ;; Start by getting integer values with 0,0 at a1.
         (x-int (- (char-int (char s 0)) (char-int #\A)))
         (y-int (- (digit-char-p (char s 1)) 1)))

    ;; Make 0,0 the top left.
    (list x-int (- 7 y-int))
    ))

(defun draw-position (position width)
  (dolist (piece position)
    (destructuring-bind (square . (color piece)) piece
      (draw-piece color piece (get-coordinates square) width))))

(draw-board 600)
(draw-position *starting-position* 600)

(destroy *context*)
(destroy *surface*)
