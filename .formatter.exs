# Used by "mix format" and to export configuration.
export_locals_without_parens = []

[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: export_locals_without_parens,
  export: [locals_without_parens: export_locals_without_parens],
  line_length: 80
]
