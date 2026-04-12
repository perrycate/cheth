(in-package :cheth)

;; We should probably have a higher-level UI state class at some point
;; that contains this (among other things), but this will do for now.
(defparameter *selected-square* nil)

(defparameter *game* (make-instance 'game))

(defun render-chessboard (widget event)
  (declare (ignore event))
  (setf *context* (cl-gtk2-cairo:create-gdk-context (gtk:widget-window widget)))
  (multiple-value-bind (w h) (gdk:drawable-get-size (gtk:widget-window widget))
    (draw-board (min w h))
    (draw-position (current-position *game*) (min w h)))
  (format t "Rendered!~%"))

(defun handle-click (widget event)
  (multiple-value-bind (w h) (gdk:drawable-get-size (gtk:widget-window widget))
    (let ((square (square-of (gdk:event-button-x event) (gdk:event-button-y event) (min w h))))
      ;; TODO nullify selected square when user clicks on an invalid location?
      (unless (eq square nil)
        (format t "clicked ~A~%" square))

      (cond
        ;; If the user clicked an invalid square, do nothing.
        ((eq square nil) nil)

        ;; If there isn't already a selected square, select it.
        ((eq *selected-square* nil)
         (setf *selected-square* square)
         (format t "selected ~A~%" square))

        ;; If we already selected a square, add our move to the game history
        ;; and reset the selected square.
        (t
         (destructuring-bind (s c piece) (assoc *selected-square* (current-position *game*))
           (make-move *game* *selected-square* square piece)
           (setf *selected-square* nil)

           ;; Render new board.
           (render-chessboard widget event)))))))

(defun run ()
  (gtk:within-main-loop
    (let ((window (make-instance 'gtk:gtk-window
                                 :type :toplevel
                                 :title "Hello World"
                                 :default-width 600
                                 :default-height 800))
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
      (gtk:widget-show window :all t))))
(run)
