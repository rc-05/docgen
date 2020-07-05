(library (docgen (1))
  (export
    list-documented-defs
    describe
    gen-doc)
  (import
    (chezscheme))

;;;; Unexported definitions.

(define documented-defs (make-eqv-hashtable))

(define add-doc-atom!
  (lambda (defname docstring)
    (if (hashtable-contains? documented-defs defname)
        (warning 'gen-doc "Definition re-documented" defname))
        (hashtable-set! documented-defs
                        defname
                        docstring)))

(define add-doc-func!
  (lambda (defname docstring . params)
    (if (hashtable-contains? documented-defs defname)
        (warning 'gen-doc "Definition re-documented" defname))
        (hashtable-set! documented-defs
                        defname
                        (list
                          docstring
                          params))))

;;;; Exported definitions.

(define list-documented-defs
  (lambda ()
    (hashtable-keys documented-defs)))

(define describe
  (lambda (defname)
    (let ([def (hashtable-ref documented-defs defname #f)])
      (cond
        ;; Value of hashtable is a list containing function parameters.
        [(list? def)
          (begin
            (display "function -> ")
            (display defname)
            (newline)
            (display (car def))
            (newline)
            (display "parameters -> ")
            (display (cadr def))
            (newline))]
        ;; Value of hashtable is just a string containing the documentation.
        [(string? def)
          (begin
            (display "atom -> ")
            (display defname)
            (newline)
            (display def)
            (newline)
            (newline))]
        ;; #f has been returned so print an error.
        [else
          (error 'describe "Definition not documented" defname)]))))

(define-syntax gen-doc
  (lambda (expr)
    (syntax-case expr ()
      [(_)
        (syntax-violation #f "Must not be empty:" expr)]
      [(_ defname docstring)
        #'(add-doc-atom! defname docstring)]
      [(_ defname docstring p1 ...)
        #'(add-doc-func! defname docstring p1 ...)]))))
