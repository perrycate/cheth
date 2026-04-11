(in-package :cheth)

(defparameter *draw-fns*
  '(((:white :pawn) . draw-white-pawn)
    ((:white :knight) . draw-white-knight)
    ((:white :bishop) . draw-white-bishop)
    ((:white :rook) . draw-white-rook)
    ((:white :queen) . draw-white-queen)
    ((:white :king) . draw-white-king)
    ((:black :pawn) . draw-black-pawn)
    ((:black :knight) . draw-black-knight)
    ((:black :bishop) . draw-black-bishop)
    ((:black :rook) . draw-black-rook)
    ((:black :queen) . draw-black-queen)
    ((:black :king) . draw-black-king)))

(defparameter *starting-position*
  '((:a1 . (:white :rook))
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
    (:h8 . (:black :rook))))

(defclass game ()
  ;; Stack of moves played, with the most recent moves on top.
  ((history
    :initform ()
    :accessor history)
   (draw-context
    :initarg :draw-context)))

(defun current-player (game)
  (if (= 0 (mod (length (history game)) 2))
      :white
      :black))

(defun make-move (game start end piece)
  (with-accessors ((history history)) game
    (push (make-instance 'move
                         :start-square start
                         :end-square end
                         :piece piece)
          history)))

(defclass move ()
  (
   (start-square
    :initarg :start-square
    :accessor start-square)
   (end-square
    :initarg :end-square
    :accessor end-square)

   ;; The type of piece moved.
   ;; If the piece moved was a pawn that promoted, this is
   ;; the type of piece post-promotion.
   (piece
    :initarg :piece
    :accessor piece)))

;; Prints moves in a slightly-more readable format.
;; Eventually we'll probably want to explicitly output standard
;; algebraic notation, either here or via a dedicated function.
(defmethod print-object ((obj move) stream)
  (with-accessors ((start start-square)
                   (end end-square)
                   (piece piece))
      obj
    (format stream "~A:~A-~A" piece start end)
    ))

(defun draw-piece (color piece pixel-coordinates board-width)
  (destructuring-bind (x-offset y-offset) pixel-coordinates
    (let* ((width (/ board-width 8))
           (x (* x-offset width))
           (y (* y-offset width)))
      (funcall (cdr (assoc (list color piece) *draw-fns* :test #'equal)) x y width))))

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
        (fill-path)))))

;; Translates a square value (eg :b2) into x and y coordinates, where each square
;; is one unit, and the top left square is (0,0).
;; e.g. :b2 -> (1,6).
;;
;; (Having 0,0 be in the top left instead of bottom left matches Cairo's coordinate
;; system, so all we have to do is scale the coordinates to the resolution we're using.)
(defun coordinates-of (square)
  (let* ((s (string square))

         ;; Start by getting integer values with 0,0 at a1.
         (x-int (- (char-int (char s 0)) (char-int #\A)))
         (y-int (- (digit-char-p (char s 1)) 1)))

    ;; Make 0,0 the top left.
    (list x-int (- 7 y-int))))

;; Converts x and y pixel values using cairo/gtk's coordinate system
;; ((0,0) in the top left) into a specific square (a8, etc.)
;;
;; FIXME: This function assumes the chessboard starts at (0,0) and is the
;; full width of the window. That will not always be true.
(defun square-of (x y board-width)
  (when (> (max x y) board-width)
    (return-from square-of))
  (let* ((square-width (/ board-width 8))

         ;; Convert to x,y coordinates with (0,0) at a8 and (7,7) at h1.
         (x-coordinate (floor (/ x square-width)))
         (y-coordinate (floor (/ y square-width))))

    ;; Build our keyword (eg :b2) from character-based shenanigans.
    ;; Feels inelegant but it works, and I haven't figured out a more
    ;; idiomatic way yet.
    (read-from-string (coerce
                       (list #\:
                             (code-char (+ (char-int #\A) x-coordinate))
                             (digit-char (- 8 y-coordinate)))
                       'string))))

(defun draw-position (position width)
  (dolist (piece position)
    (destructuring-bind (square . (color piece)) piece
      (draw-piece color piece (coordinates-of square) width))))
