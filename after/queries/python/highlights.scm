;; extends 

(("not" @keyword.operator) (#set! conceal "!"))
(("continue" @keyword) (#set! conceal "C"))
(("return" @keyword) (#set! conceal "R"))
(("import" @include) (#set! conceal "i"))
(("def" @keyword.function) (#set! conceal "f"))
(("del" @keyword) (#set! conceal "D"))
(("while" @repeat) (#set! conceal "W"))
((yield ("from") @keyword) (#set! conceal "F"))
(("global" @keyword) (#set! conceal "G"))
(("lambda" @include) (#set! conceal "λ"))
(("with" @keyword) (#set! conceal "w"))
(("pass" @keyword) (#set! conceal "P"))
(("elif" @conditional) (#set! conceal "e"))
((call function: (identifier) @function.builtin (#eq? @function.builtin "print")) (#set! conceal "p"))
(("else" @conditional) (#set! conceal "e"))
((import_from_statement ("from") @include) (#set! conceal "f"))
(("or" @keyword.operator) (#set! conceal "|"))
(("class" @keyword) (#set! conceal "c"))
(("for" @repeat) (#set! conceal "F"))
(("yield" @keyword) (#set! conceal "Y"))
(("and" @keyword.operator) (#set! conceal "&"))
(("if" @conditional) (#set! conceal "?"))
(("assert" @keyword) (#set! conceal "?"))
(("break" @keyword) (#set! conceal "B"))
