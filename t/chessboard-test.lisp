(use-package :cheth)

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
