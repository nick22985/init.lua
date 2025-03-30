;; extends 

(("return" @keyword.function) (#set! conceal "R"))
(("do" @repeat) (#set! conceal "d"))
(("else" @conditional) (#set! conceal "e"))
(("elseif" @conditional) (#set! conceal "e"))
(("end" @keyword.function) (#set! conceal "E"))
(("for" @keyword) (#set! conceal "F"))
(("function" @keyword.function) (#set! conceal "f"))
(("if" @conditional) (#set! conceal "?"))
(("in" @keyword) (#set! conceal "i"))
(("then" @conditional) (#set! conceal "t"))
((function_call name: (identifier) @function.builtin (#eq? @function.builtin "require")) (#set! conceal "r"))
(("and" @keyword.function) (#set! conceal "&"))
