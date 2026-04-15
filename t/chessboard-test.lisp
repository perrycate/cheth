(use-package :cheth)

(deftest test-single-move ()
  ;; Game with a single move, e4.
  (let ((game (make-move (make-instance 'game) :e2 :e4 :pawn)))
    (check
      ;; Pawn should have moved from previous position of e2.
      (equal (get-piece :e2 (current-position game)) nil)
      (equal (get-piece :e4 (current-position game)) '(:white :pawn)))))

(deftest test-captures ()
  (let ((game (make-moves (make-instance 'game)
                          '(:e2 :e4 :pawn)
                          '(:d7 :d5 :pawn)

                          ;; A capture!
                          '(:e4 :d5 :pawn))))
    (check
      (equal (get-piece :d5 (current-position game)) '(:white :pawn)))))

(deftest test ()
  (combine-results
    (test-game-history)
    (test-captures)))

(set-difference *starting-position* '(:a5 :a1) :test (lambda (a b) (equal (car a) b)))
