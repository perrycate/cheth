;; AI Slop, but it does work.
(defun hello-world ()
  (gtk:within-main-loop
   (let ((window (make-instance 'gtk:gtk-window
                                :type :toplevel
                                :title "Hello World"
                                :default-width 300
                                :default-height 200))
         (button (make-instance 'gtk:gtk-drawing-area
                                :label "Hello, World!")))
     ;; Close the window when the user clicks the X
     (gobject:connect-signal window "destroy"
                             (lambda (widget)
                               (declare (ignore widget))
                               (gtk:leave-gtk-main)))
     ;; Print a message when the button is clicked
     (gobject:connect-signal button "clicked"
                             (lambda (widget)
                               (declare (ignore widget))
                               (format t "Hello, World!~%")))
     ;; Add the button to the window and show everything
     (gtk:container-add window button)
     (gtk:widget-show window :all t))))

;; Run it
(hello-world)
