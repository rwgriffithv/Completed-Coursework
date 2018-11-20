;; Robert Griffith
;; CS 131 Fall 2019

(define (comp-output-list x y)
  (list 'if '% x y))

(define (output-quote-var-val x)
  (list 'quote x))

(define (is-special-form x)
  (member x '(quote lambda let if)))

;; create list of lists containing (arg-in-x arg-in-y replacement-arg) lists
;; used for turning '(lambda (a) (+ a 2)) '(lambda (b) (+ b 2)) into '(lambda (a!b) (+ a!b 2))
(define (get-replacement-args-list argsx argsy bodyx bodyy)
  (filter
   (lambda (x) (list? x))
   (map
    (lambda (u v)
      (if (not (eq? u v))
	  (list u v (string->symbol (string-append (symbol->string u) "!" (symbol->string v))))
	  u))
    argsx argsy)))

;; create list of lists containing (var-in-x var-in-y replacement-var) lists
;; used for turning '(let ([a 2]) (+ a 2)) '(let ([b 2]) (+ b 2)) into '(let ([a!b 2]) (+ a!b 2))
(define (get-replacement-vars-list varsx varsy bodyx bodyy)
  (filter
   (lambda (x) (list? x))
   (map
    (lambda (u v)
      (let ([cu (car u)] [cv (car v)])
	(if (not (eq? cu cv))
	    (list cu cv (string->symbol (string-append (symbol->string cu) "!" (symbol->string cv))))
	    cu)))
    varsx varsy)))

;; arguments:
;; x:  body to replace symbols in
;; p:  list (a b a!b)
;; il: if true replace all appropriate a in x with a!b else replace all appropriate b in x with a!b
(define/match (body-replace x p il)
  [('() _ _) '()]
  [(hxl (list hxl hxr s) #t) s]
  [(hxr (list hxl hxr s) #f) s]
  [((list 'lambda args body) (list hxl hxr s) il)
   (if (or (and il
		(member hxl args))
	   (and (not il)
		(member hxr args)))
       (list 'lambda args body)
       (list 'lambda args (body-replace body (list hxl hxr s) il)))]
  [((list 'let vars body) p il)
   (let ([rep-vars (map (lambda (x) (list (car x) (body-replace (cadr x) p il))) vars)]
	 [var-names (map (lambda (x) (car x)) vars)])
     (if (or (and il
		  (member (car p) var-names))
	     (and (not il)
		  (member (cadr p) var-names)))
	 (list 'let rep-vars body)
	 (list 'let rep-vars (body-replace body p il))))]
  [((cons hxl tx) (list hxl hxr s) #t)
   (cons s (body-replace tx (list hxl hxr s) #t))]
  [((cons hxr tx) (list hxl hxr s) #f)
   (cons s (body-replace tx (list hxl hxr s) #f))]
  [((cons hx tx) p il)
   (cons (body-replace hx p il) (body-replace tx p il))]
  [(x _ _) x])

;; applies a list of (a b a!b) lists to a body x, replacing all desired symbols
(define/match (full-body-replace x lp il)
  [(x '() _) x]
  [(x (cons p rp) il) (full-body-replace (body-replace x p il) rp il)])

;; like body-replace but only used on variable lists from let expressions
(define/match (vars-replace x p il)
  [('() _ _) '()]
  [((cons (list varl ex) tx) (list varl varr s) #t)
   (cons (list s ex) (vars-replace tx (list varl varr s) #t))]
  [((cons (list varr ex) tx) (list varl varr s) #f)
   (cons (list s ex) (vars-replace tx (list varl varr s) #f))]
  [((cons varex tx) p il)
   (cons varex (vars-replace tx p il))])

;; applies a list of (a b a!b) lists to a variable list x, replacing all desired variables
(define/match (full-vars-replace x lp il)
  [(x '() _) x]
  [(x (cons p rp) il) (full-vars-replace (vars-replace x p il) rp il)])

;; full function expr-compare - as described in the spec
(define/match (expr-compare x y)
  [(x x) x]
  [(#t #f) '%]
  [(#f #t)
   (list 'not '%)]
  [((list 'quote ex) (list 'quote ey))
   (comp-output-list (output-quote-var-val ex) (output-quote-var-val ey))]
  [((list 'lambda args bodyx) (list 'lambda args bodyy))
   (list 'lambda args (expr-compare bodyx bodyy))]
  [((list 'lambda argsx bodyx) (list 'lambda argsy bodyy))
   (if (= (length argsx) (length argsy))
       (let ([replace-args (get-replacement-args-list argsx argsy bodyx bodyy)])
	 (let ([newargsx (full-body-replace argsx replace-args #t)]
	       [newargsy (full-body-replace argsy replace-args #f)]
	       [newbodyx (full-body-replace bodyx replace-args #t)]
	       [newbodyy (full-body-replace bodyy replace-args #f)])
	   (list 'lambda (expr-compare newargsx newargsy) (expr-compare newbodyx newbodyy))))
       (comp-output-list (list 'lambda argsx bodyx) (list 'lambda argsy bodyy)))]
  [((list 'let vars bodyx) (list 'let vars bodyy))
   (list 'let vars (expr-compare bodyx bodyy))]
  [((list 'let varsx bodyx) (list 'let varsy bodyy))
   (if (= (length varsx) (length varsy))
       (let ([replace-vars (get-replacement-vars-list varsx varsy bodyx bodyy)])
	 (let ([newvarsx (full-vars-replace varsx replace-vars #t)]
	       [newvarsy (full-vars-replace varsy replace-vars #f)]
	       [newbodyx (full-body-replace bodyx replace-vars #t)]
	       [newbodyy (full-body-replace bodyy replace-vars #f)])
	   (list 'let (expr-compare newvarsx newvarsy) (expr-compare newbodyx newbodyy))))
       (comp-output-list (list 'let varsx bodyx) (list 'let varsy bodyy)))]
  [((cons hx tx) (cons hy ty))
   (if (and (= (length tx) (length ty))
	    (or (nor (is-special-form hx) (is-special-form hy))
		(eq? hx hy)))
       (cons (expr-compare hx hy) (expr-compare tx ty))
       (comp-output-list (cons hx tx) (cons hy ty)))]
  [(x y) (comp-output-list x y)])


(define test-expr-x
  '(list
    "same"
    "different"
    #t
    #f
    '(1 2)
    (quote (1 2))
    (let ((e (lambda (b a) (cons b (cons a '())))))
      (eq?
       (e "1" "2")
       ((lambda (c d) (cons d (cons c '()))) "2" "1")))
    (cons "testsame"
	  (cons "testdiff"
		(cons (let ([x #t] [y 1] [z 2]) (if x y z))
		      (cons (let ([x #t] [y 1] [z 2]) (if x y z))
			    (cons (let ((a "1")) a) '())))))
    (let ((a (lambda (b a) (b a))))
      (eq?
       a
       (lambda (a b) (let ((a b) (b a)) (a b)))))))
  

(define test-expr-y
  '(list
    "same"
    "diff"
    #f
    #t
    '(1 20)
    (quote (1 20))
    (let ((f (lambda (a b) (cons b (cons a '())))))
      (eq?
       (f "1" "2")
       ((lambda (g d) (cons d (cons g '()))) "2" "1")))
    (cons "testsame"
	  (cons "diff"
		(cons (let ([x #t] [y 1] [z 2]) (if x y z))
		      (cons (let ([x 3] [y 1] [z 2]) (+ x y z))
			    (cons (let ((c "1")) c) '())))))
    (let ((a (lambda (a b) (a b))))
      (eqv?
       a
       (lambda (b a) (let ((a b) (b a)) (a b)))))))



(define (test-expr-compare x y)
  (let ([res (expr-compare x y)])
    (if (and (equal? (eval (list 'let '((% #t)) res))
		     (eval x))
	     (equal? (eval (list 'let '((% #f)) res))
		     (eval y)))
	#t
	#f)))
