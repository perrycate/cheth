;;;; Test utilities copied from the Practical Common Lisp book, chapter 9.
;;;;
;;;; Should be adequate for our purposes.
(in-package :cheth)

(defvar *test-name* nil)

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
     ,@body))

(defmacro deftest (name parameters &body body)
  "Defines a test function. Within a test function we can call
   other test functions or use 'check' to run individual test
   cases."
  `(defun ,name ,parameters
     (let ((*test-name* (append *test-name* (list ',name))))
       ,@body)))

(defmacro check (&body forms)
  "Run each expression in 'forms' as a test case."
  `(combine-results
     ,@(loop for f in forms collect `(report-result ,f ',f))))

(defmacro combine-results (&body forms)
  "Combine the results (as booleans) of evaluating 'forms' in order."
  (with-gensyms (result)
    `(let ((,result t))
       ,@(loop for f in forms collect `(unless ,f (setf ,result nil)))
       ,result)))

(defun report-result (result form)
  "Report the results of a single test case. Called by 'check'."
  (format t "~:[FAIL~;pass~] ... ~a: ~a~%" result *test-name* form)
  result)

;;; Tests begin here.
(deftest test-game-history ()
  ;; Game with a single move, e4.
  (let ((game (make-move (make-instance 'game) :e2 :e4 :pawn)))
    (check
      ;; Pawn should have moved from previous position of e2.
      (equal (get-piece :e2 (current-position game)) nil)
      (equal (get-piece :e4 (current-position game)) '(:white :pawn)))))

(deftest test ()
  (combine-results
    (test-game-history)))

(let ((game (make-move (make-instance 'game) :e2 :e4 :pawn)))
  (current-position game))
