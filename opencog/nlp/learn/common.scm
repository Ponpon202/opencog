;
; common.scm
;
; Common functions shared between multpile functional units.
;
; Copyright (c) 2017 Linas Vepstas
;
; ---------------------------------------------------------------------
;
(use-modules (srfi srfi-1))
(use-modules (opencog))

; ---------------------------------------------------------------------
; Define locations where statistics will be stored.

(define freq-key (PredicateNode "*-FrequencyKey-*"))
(define mi-key (PredicateNode "*-Mutual Info Key-*"))

; get-count ATOM - return the raw observational count on ATOM.
(define (get-count ATOM) (cog-tv-count (cog-tv ATOM)))

; ----
; set-freq ATOM FREQ - set the frequency count on ATOM.
;
; FREQ is assumed to be some simple ratio, interpreted as a
; probability: i.e. 0.0 < FREQ <= 1.0.  The frequency and it's log_2
; are stored: the log is accessed thousands of times, and so it
; is worth caching it as a pre-computed value.
;
; Returns ATOM.
;
(define (set-freq ATOM FREQ)
	; 1.4426950408889634 is 1/0.6931471805599453 is 1/log 2
	(define ln2 (* -1.4426950408889634 (log FREQ)))
	(cog-set-value! ATOM freq-key (FloatValue FREQ ln2))
)

; ----
; get-logli ATOM - get the -log_2(frequency) on ATOM.
;
; The log will be in position 2 of the value.
(define (get-logli ATOM)
	(cadr (cog-value->list (cog-value ATOM freq-key)))
)

; ----
; set-mi ATOM MI - set the mutual information on ATOM.
;
; MI is assumed to be a scheme floating-point value, holding the
; mutual-information value appropriate for the ATOM.
;
; In essentially all cases, ATOM is actually an EvaluationLink that
; is holding the structural pattern to which the mutial information
; applied. CUrrently, this is almost always a word-pair.
;
; Returns ATOM.
;
(define (set-mi ATOM MI)
	(cog-set-value! ATOM mi-key (FloatValue MI))
)

; ----
; get-mi ATOM - get the mutual information on ATOM.
;
; Returns a floating-point value holding the mutual information
; for the ATOM.
;
; In essentially all cases, ATOM is actually an EvaluationLink that
; is holding the structural pattern to which the mutial information
; applied. CUrrently, this is almost always a word-pair.
;
(define (get-mi ATOM)
	(car (cog-value->list (cog-value ATOM pair-mi-key)))
)

; ---------------------------------------------------------------------
