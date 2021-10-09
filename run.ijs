NB. Unification with Hsu trees

require'~Projects/unification/tree_display.ijs'

0 : 0
TODO
- lambda lifting:
  + handle the newly created variable nodes!!
- manage indexing for unification
)

NB. functions
var_tst =: e.&4 1@(3!:0) > *@#@$
depth =: 0 , 1 + [: ; [: $:&.> }.
depth_bfs =: /:~@:depth
flatten =: [: (#~ ~:&a:) [: , <"0 S:0 NB. keeps type compat
apply_and_flatten =: {{ ([: < u"0) S:0 }} NB.not flatten then apply to keep type compat
iota =: [: i. [: +/ #S:0
bfs =: [: ; depth </. iota
depth_to_parent =: 0 (0) } (i: <:@{:)\
parent =: [: depth_to_parent depth
is_variable =: [: ; var_tst apply_and_flatten
is_value =: [: -. is_variable
nearest_lexical_contour =: is_value {{ (y { x) } (,:{~) y }} ^:_ parent

lambda_lift =: {{
 p =. parent y
 t =. is_variable y
 variable_nodes =. I. t *. (~: i.@#) p NB. == Hsu 'i'
 new_nodes =. (#p) + i. # variable_nodes NB. == Hsu 'n[i]'
 p =. p,new_nodes
 p { new_nodes variable_nodes } i. # p NB. == Hsu 'p' lower p. 100
 NB. OK, but how to handle the newly created variable nodes??
}}

NB.display utils
display_tree =: [: tree [: }. parent ,. iota
display_columns =: {{
 names =. id`depth`parent`variable`value
 data=. (;/ iota y),.(;/ depth y),.(;/ parent y),.(;/;var_tst apply_and_flatten y),.flatten y
 names , data
}}
display =: display_tree ,: <@:display_columns

0 : 0
EXAMPLE DATA
a is AST @ Hsu p.93
at is t @ Hsu p.93
b is a with custom logic variables
c is AST @ Hsu p.99
ct is t @9 Hsu p.100 above
)
a =: t;(t;<t,t);(t;<t;t;(<t,t));(<t;<t;(t;<t;(t,t);t;(<t,t));(t;<t;(t,t);t;(<t,t));(<t,t))[t=.<'o'
at =: 3 1 0 7 1 2 9 0 10 1 3 1 2 0 10 9 0 10 1 2 0 10 9 0 10 0 10
b =: t;(t;<t,t);(t;<t;t;(<t,t));(<t;<t;(t;<t;(t,t);t;(<t,t));(t;<t;(t,t);t;(<t,t));(<t,t))[t=.<'o'
c =: t;<t,<t,<t,(<t;t),(<t,(<t,(<t;t),t,(<t;t))),(<t,(<t;t),(<t;<t,(<t;t),t,(<t;t)),(<t,(<t;t),(<t;<t,(<t;t),t,(<t;t)),<t;t)) [t=.<'o'
ct =: 3 1 3 2 0 10 3 2 0 10 9 0 10 2 0 10 3 2 0 10 9 0 10 2 0 10 3 2 0 10 9 0 10 0 10
e =: t;<t,<t,<t,(<t;0),(<1;(<t,(<t;t),t,(<t;t))),(<t,(<t;t),(<t;<t,(<t;t),t,(<t;t)),(<t,(<t;t),(<t;<t,(<t;t),t,(<t;t)),<t;t)) [t=.<'o'
f =: 0;<t,<1;<t,(<t;t),(<2;(<t,(<t;t),t,(<t;t))),(<t,(<t;t),(<3;<t,(<t;t),t,(<t;t)),(<t,(<t;t),(<4;<t,(<t;t),t,(<t;t)),<t;t)) [t=.<'o'

0 : 0
TO KEEP IN MIND
Traversal idiom {{ B } (,:{~) y }} ^:_ parent d
 Nearest lexical contour (Hsu p.94) {{ (3 ~: y { dt) } (,:{~) y }} ^:_ parent d
 quirk: m} gives  index error when y has only 1 item 

Lambda lifting
 ct {{ I. (x=3) *. (~:([:i.#)) y }} parent c is i @ Hsu p.101
 (parent c),(# parent c) + i.# ct {{ I. (x=3) *. (~:([:i.#)) y }} parent c is @ Hsu p.102
)
