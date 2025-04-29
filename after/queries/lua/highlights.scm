;; extends 

(("in" @keyword) (#set! conceal "i"))
(("and" @keyword.function) (#set! conceal "&"))
(("return" @keyword.function) (#set! conceal "R"))
(("do" @repeat) (#set! conceal "d"))
(("else" @conditional) (#set! conceal "e"))
(("elseif" @conditional) (#set! conceal "e"))
(("end" @keyword.function) (#set! conceal "E"))
((function_call name: (identifier) @function.builtin (#eq? @function.builtin "require")) (#set! conceal "r"))
(("for" @keyword) (#set! conceal "F"))
(("function" @keyword.function) (#set! conceal "f"))
(("then" @conditional) (#set! conceal "t"))
(("if" @conditional) (#set! conceal "?"))
