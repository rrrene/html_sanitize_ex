# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

# config :html_sanitize_ex, :html_sanitize_ex,
#   list_of_tags_with_these_attributes: [
#     ["a", ["name", "title"]],
#     ["b", []],
#     ["blockquote", []],
#     ["br", []],
#     ["code", []],
#     ["del", []],
#     ["em", []],
#     ["h1", []],
#     ["h2", []],
#     ["h3", []],
#     ["h4", []],
#     ["h5", []],
#     ["h6", []],
#     ["hr", []],
#     ["i", []],
#     [
#       "img",
#       [
#         "width",
#         "height",
#         "title",
#         "alt"
#       ]
#     ],
#     ["li", []],
#     ["ol", []],
#     ["p", []],
#     ["pre", []],
#     ["span", []],
#     ["strong", []],
#     ["table", []],
#     ["tbody", []],
#     ["td", []],
#     ["th", []],
#     ["thead", []],
#     ["tr", []],
#     ["u", []],
#     ["ul", []]
#   ],
#   list_of_tags_with_uri_attributes: [
#     ["a", ["href"], ["http", "https", "mailto"]],
#     ["img", ["src"], ["http", "https", "mailto"]]
#   ]
