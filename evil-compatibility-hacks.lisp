;; Compatiblity stuff to be called before attempting to load cl-gtk2-gtk.
(sb-ext:unlock-package :sb-unix)
(defun sb-unix::sigpipe-handler (signal code scp)
  (declare (ignore signal code scp))
  nil)
