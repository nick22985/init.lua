;; Highlight non-standard ASCII characters
[
  ((string) @non_standard (#match? @non_standard "[^\x00-\x7F]"))
]


;; Highlight invisible characters
[
  ((string) @invisible (#match? @invisible "[\x00-\x1F\x7F]"))
]

