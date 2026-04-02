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



;; Ok, let's render a chessboard.
(gtk:within-main-loop
  (let ((window (make-instance 'gtk:gtk-window
                               :type :toplevel
                               :title "Hello World"
                               :default-width 300
                               :default-height 200))
        (button (make-instance 'gtk:button
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
    (gtk:widget-show window :all t)))
