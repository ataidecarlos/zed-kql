; Syntax highlighting for Kusto Query Language (KQL).
; Node names come from kiennq/tree-sitter-kusto.
; Specific patterns come before the broad `(simple_name_reference)` fallback,
; so contextual captures such as @function and @property take priority.

; ---------------------------------------------------------------------------
; Comments and literals
; ---------------------------------------------------------------------------
(comment) @comment

[
  (string_literal)
  (command_string)
  (verbatim_double_quoted_string)
  (verbatim_single_quoted_string)
  (multiline_backtick_string)
  (multiline_tilde_string)
] @string

[
  (integer_literal)
  (real_number)
  (int_literal_expression)
  (long_literal_expression)
  (real_literal_expression)
  (decimal_literal_expression)
  (number_like_literal_expression)
] @number

; Time spans such as 24h or 30m are numeric constants in KQL.
(time_span_literal_expression) @number

(date_time_literal_expression) @string.special

[
  (guid_literal_expression)
  (raw_guid_literal_expression)
  (raw_guid)
] @constant

[
  (boolean_literal_expression)
  (json_boolean)
] @boolean

[
  "null"
  (json_null)
] @constant.builtin

[
  (scalar_type)
  (extended_scalar_type)
  (type_literal_expression)
] @type

; ---------------------------------------------------------------------------
; Declarations and calls
; ---------------------------------------------------------------------------
(let_variable_declaration
  name: (identifier_or_keyword_or_escaped_name) @variable)

(let_view_declaration
  name: (identifier_or_keyword_or_escaped_name) @variable)

(let_materialize_declaration
  name: (identifier_or_keyword_or_escaped_name) @variable)

(let_function_declaration
  name: (identifier_or_keyword_or_escaped_name) @function)

(parameter_name) @variable.parameter

(named_function_call_expression
  name: (simple_name_reference
    (identifier_or_keyword_or_escaped_name) @function))

[
  (count_expression "count")
  (to_scalar_expression "toscalar")
  (data_table_expression "datatable")
  (external_data_expression "externaldata")
  (range_expression "range")
] @function

; ---------------------------------------------------------------------------
; Query keywords: tabular operators, clauses, and control words
; ---------------------------------------------------------------------------
[
  "access"
  "alias"
  "as"
  "asc"
  "assert-schema"
  "by"
  "cluster"
  "consume"
  "database"
  "datascope"
  "declare"
  "default"
  "desc"
  "distinct"
  "evaluate"
  "execute"
  "external_data"
  "externaldata"
  "facet"
  "filter"
  "find"
  "fork"
  "from"
  "graph-mark-components"
  "graph-match"
  "graph-shortest-paths"
  "graph-to-table"
  "in"
  "into"
  "invoke"
  "join"
  "kind"
  "let"
  "lookup"
  "make-graph"
  "make-series"
  "materialize"
  "materialized-view-combine"
  "macro-expand"
  "mv-apply"
  "mv-expand"
  "on"
  "optional"
  "order"
  "output"
  "parse"
  "parse-kv"
  "parse-where"
  "partition"
  "pattern"
  "print"
  "project"
  "project-away"
  "project-keep"
  "project-rename"
  "project-reorder"
  "query_parameters"
  "range"
  "reduce"
  "render"
  "restrict"
  "sample"
  "sample-distinct"
  "scan"
  "search"
  "serialize"
  "set"
  "sort"
  "step"
  "summarize"
  "take"
  "to"
  "top"
  "top-hitters"
  "top-nested"
  "union"
  "view"
  "where"
  "with"
] @keyword

[
  "and"
  "or"
] @operator

; ---------------------------------------------------------------------------
; Operators
; ---------------------------------------------------------------------------
(string_binary_operator) @operator

; Join flavor after `kind=`.
(join_operator
  (relaxed_query_operator_parameter
    (identifier_or_keyword_name) @constant))

[
  "="
  "=="
  "!="
  "<>"
  "<"
  ">"
  "<="
  ">="
  "=~"
  "!~"
  "+"
  "-"
  "*"
  "/"
  "%"
  "|"
] @operator

; ---------------------------------------------------------------------------
; Management commands
; ---------------------------------------------------------------------------
(management_command
  name: (command_word) @keyword)

(command_name) @variable
(command_string) @string
(command_bracket) @punctuation.bracket
(command_punct) @punctuation.delimiter

; ---------------------------------------------------------------------------
; Properties and names
; ---------------------------------------------------------------------------
(named_expression_name_clause
  (identifier_or_extended_keyword_or_escaped_name) @property)

(query_operator_property
  (identifier) @property)

(render_operator
  (identifier) @property)

(project_expression
  (simple_or_wildcarded_name_reference
    (simple_name_reference
      (identifier_or_keyword_or_escaped_name) @property)))

(function_call_or_path_operation
  (identifier_or_keyword_or_escaped_name) @property)

; Bare table name at the head of a query.
(before_pipe_expression
  (unnamed_expression
    (logical_or_expression
      (logical_and_expression
        (equality_expression
          (relational_expression
            (additive_expression
              (multiplicative_expression
                (string_operator_expression
                  (string_binary_operator_expression
                    (invocation_expression
                      (function_call_or_path_expression
                        (function_call_or_path_root
                          (primary_expression
                            (name_reference_with_data_scope
                              (simple_name_reference
                                (identifier_or_keyword_or_escaped_name) @type))))))))))))))))

; ---------------------------------------------------------------------------
; Punctuation (keep before the variable fallback)
; ---------------------------------------------------------------------------
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  ","
  ";"
  ":"
  "."
] @punctuation.delimiter

; Fallback: anything left that looks like a name is a reference.
(simple_name_reference) @variable
