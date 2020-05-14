;;;; complain.lisp

(in-package #:complain)

(defstruct (source (:constructor source (row column)))
  (row 0 :type integer)
  (column 0 :type integer))

(defstruct (form (:constructor form (source)))
  (source (error "gimme") :type source))

(defvar *current-form* nil
  "The current form")

(defun forms-collinearp (form-1 form-2 &rest more-forms)
  ;; yes that is the correct spelling
  (let ((row (source-row (form-source form-1))))
    (every (lambda (form) (= (source-row (form-source form)) row))
           (append (list form-2) more-forms))))

(define-complaint if-indentation
    ((if cond-form
         then-form)
     ;; (if cond-form
     ;;     then-form
     ;;     else-form)
     )
  ;; If the forms are on the same line then there is nothing to be
  ;; done.
  (unless (forms-collinearp cond-form then-form else-form)
    (unless (= (source-column (form-source cond-form))
               (source-column (form-source else-form)))
      (complain "that just ain't right"))))
