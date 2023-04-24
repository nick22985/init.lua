;; extends
((element
	(start_tag
		(tag_name) @_name)
	(#any-of? @_name "component" "filter" "macgyer" "schema" "server" "service" "endpoint")
		(text) @javascript))

