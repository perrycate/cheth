;; For now this is just a bunch of helpers and stuff for me to call from the repl
;; while I experiment.

;; Point to the correct (ancient) gtk libraries.
(push "/home/perry/quicklisp/local-projects/cl-gtk2/glib/" asdf:*central-registry*)
(push "/home/perry/quicklisp/local-projects/cl-gtk2/pango/" asdf:*central-registry*)
(push "/home/perry/quicklisp/local-projects/cl-gtk2/gdk/" asdf:*central-registry*)
(push "/home/perry/quicklisp/local-projects/cl-gtk2/gtk/" asdf:*central-registry*)
(push "/home/perry/quicklisp/local-projects/cl-gtk2/gtk-glext/" asdf:*central-registry*)
(push "/home/perry/quicklisp/local-projects/cl-gtk2/cairo/" asdf:*central-registry*)

;; Compatiblity stuff, call these first.
(sb-ext:unlock-package :sb-unix)
(defun sb-unix::sigpipe-handler (signal code scp)
  (declare (ignore signal code scp))
  nil)
(ql:quickload :cl-gtk2-gtk)
(ql:quickload :cl-gtk2-cairo)

(use-package :cl-cairo2)

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

(defun render-chessboard (widget event)
  (declare (ignore event))
  (setf *context* (cl-gtk2-cairo:create-gdk-context (gtk:widget-window widget)))
  (multiple-value-bind (w h) (gdk:drawable-get-size (gtk:widget-window widget))
    (draw-board (min w h))
    )
  (format t "Rendered!~%"))


;; Ok, let's render a chessboard.
(defun test ()
  (gtk:within-main-loop
    (let ((window (make-instance 'gtk:gtk-window
                                 :type :toplevel
                                 :title "Hello World"
                                 :default-width 300
                                 :default-height 200))
          (drawing-area (make-instance 'gtk:drawing-area)))

      ;; Close the window when the user clicks the X
      (gobject:connect-signal window "destroy"
                              (lambda (widget)
                                (declare (ignore widget))
                                (gtk:leave-gtk-main)))

      (gobject:connect-signal drawing-area "expose-event"
                              #'render-chessboard)

      ;; Add the button to the window and show everything
      (gtk:container-add window drawing-area)
      (gtk:widget-show window :all t))))
(test)
