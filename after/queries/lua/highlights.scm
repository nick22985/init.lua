;; extends 

(("end" @keyword.function) (#set! conceal "E"))
(("for" @keyword) (#set! conceal "F"))
(("function" @keyword.function) (#set! conceal "f"))
(("if" @conditional) (#set! conceal "?"))
(("in" @keyword) (#set! conceal "i"))
((function_call name: (identifier) @function.builtin (#eq? @function.builtin "require")) (#set! conceal "r"))
(("do" @repeat) (#set! conceal "d"))
(("and" @keyword.function) (#set! conceal "&"))
(("return" @keyword.function) (#set! conceal "R"))
(("then" @conditional) (#set! conceal "t"))
(("else" @conditional) (#set! conceal "e"))
(("elseif" @conditional) (#set! conceal "e"))
