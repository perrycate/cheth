;; For now this is just a bunch of helpers and stuff for me to call from the repl
;; while I experiment.
(in-package :cheth)

(defun render-chessboard (widget event)
  (declare (ignore event))
  (setf *context* (cl-gtk2-cairo:create-gdk-context (gtk:widget-window widget)))
  (multiple-value-bind (w h) (gdk:drawable-get-size (gtk:widget-window widget))
    (draw-board (min w h))
    (draw-position *starting-position* (min w h))
    )
  (format t "Rendered!~%"))

(defun handle-click (widget event)
  (multiple-value-bind (w h) (gdk:drawable-get-size (gtk:widget-window widget))
    (let ((square (square-of (gdk:event-button-x event) (gdk:event-button-y event) (min w h))))
      (unless (eq square nil)
        (format t "clicked ~A~%" square)))))

;; Ok, let's render a chessboard.
(defun test ()
  (gtk:within-main-loop
    (let ((window (make-instance 'gtk:gtk-window
                                 :type :toplevel
                                 :title "Hello World"
                                 :default-width 600
                                 :default-height 800))
          (button (make-instance 'gtk:button :label "Do"))
          (drawing-area (make-instance 'gtk:drawing-area)))


      ;; Close the window when the user clicks the X
      (gobject:connect-signal window "destroy"
                              (lambda (widget)
                                (declare (ignore widget))
                                (gtk:leave-gtk-main)))

      (gobject:connect-signal drawing-area "expose-event"
                              #'render-chessboard)

      (gobject:connect-signal drawing-area "button-press-event"
                              #'handle-click)

      ;; Allow gtk to report button-press events to the drawing area. (I think.)
      (setf (gtk:widget-events drawing-area) '(:button-press-mask))

      ;; Add the button to the window and show everything
      (gtk:container-add window drawing-area)
      (gtk:container-add window button)
      (gtk:widget-show window :all t))))
(test)
