;; Following a 15 year old tutorial, let's render an image to a pdf using Cairo 2.
(asdf:operate 'asdf:load-op :cl-cairo2)
(use-package :cl-cairo2)
(defparameter *surface* (create-pdf-surface "test.pdf" 200 100))
(setf *context* (create-context *surface*))
(set-source-rgb 0.2 0.2 1)
(paint)

;; Draw a white diagonal line.
(move-to 200 0)
(line-to 0 100)
(set-source-rgb 1 1 1)
(set-line-width 5)
(stroke)
(destroy *context*)
(destroy *surface*)
