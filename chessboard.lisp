(asdf:operate 'asdf:load-op :cl-cairo2)
(use-package :cl-cairo2)
(defparameter *surface* (create-pdf-surface "test.pdf" 200 200))
(setf *context* (create-context *surface*))

;; This should all be painted over, so the red is just to highlight if something is misaligned.
(set-source-rgb 1 0 0)
(paint)

(defun draw-board (width)
  (let ((square-width (/ width 8)))
    (dotimes (x 8)
      (dotimes (y 8)
        (rectangle (* x square-width) (* y square-width) square-width square-width)
        ;; Alternate square colors.
        (if (= (mod (+ x y) 2) 0) (set-source-rgb 1 1 1) (set-source-rgb 0 0 0))
        (fill-path)
        ))
    (set-source-rgb 1 1 1)
    (set-line-width 5)
    (fill-path)
    ))

(draw-board 200)
(destroy *context*)
(destroy *surface*)
