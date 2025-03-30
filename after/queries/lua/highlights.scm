;; extends 

(("in" @keyword) (#set! conceal "i"))
(("and" @keyword.function) (#set! conceal "&"))
(("return" @keyword.function) (#set! conceal "R"))
(("do" @repeat) (#set! conceal "d"))
((function_call name: (identifier) @function.builtin (#eq? @function.builtin "require")) (#set! conceal "r"))
(("elseif" @conditional) (#set! conceal "e"))
(("end" @keyword.function) (#set! conceal "E"))
(("then" @conditional) (#set! conceal "t"))
(("for" @keyword) (#set! conceal "F"))
(("function" @keyword.function) (#set! conceal "f"))
(("else" @conditional) (#set! conceal "e"))
(("if" @conditional) (#set! conceal "?"))
