(library (docgen)
  (export
    describe
    gen-doc)
  (import
    (chezscheme))

(define documented-defs '())

(define add-definition!
  (lambda (defName doc . params)
    (if (null? (search-definition defName))
        (set! documented-defs
              (cons `(,defName ,doc ,params)
                     documented-defs))
        (error 'gen-doc "Definition already documented" defName))))

(define search-definition
  (lambda (defName)
    (call/cc
      (lambda (return)
        (map (lambda (def)
               (if (member defName def)
                   (return def)
                   (return #f))) documented-defs)))))

(define describe
  (lambda (defName)
    (if (null? documented-defs)
        (error 'describe "No documentation at all" 'describe)
        (let ([docList (search-definition defName)])
          (if docList
            (let ([name (car docList)]
                  [doc (cadr docList)]
                  [params (caddr docList)])
              (display "Definition: ")
              (display name)
              (newline)
              (display doc)
              (newline)
              (if (not (null? params))
                  (begin
                    (display "Parameters: ")
                    (display params)
                    (newline))))
            (error 'describe "Definition not documented" defName))))))

(define-syntax gen-doc
  (lambda (expr)
    (syntax-case expr ()
      [(_)
        (syntax-violation #f "Must not be empty:" expr)]
      [(_ defName doc)
        #'(add-definition! defName doc)]
      [(_ defName doc p1 ...)
        #'(add-definition! defName doc p1 ...)]))))
