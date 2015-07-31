#
# This is not yet ready in any way.
#
#
# TODOS:
#
# - add these attributes allowed on all elements:
#
#     aria-* data-* style
#
# - sanitize css in style= attributes
# - sanitize css in <style> tags
# - sanitize all URL containing fields regardless of element
#
defmodule HtmlSanitizeEx.Scrubber.HTML5 do
  @moduledoc """
  Allows all HTML5 tags to support user input.

  Sanitizes all malicious content.
  """

  require HtmlSanitizeEx.Scrubber.Meta
  alias HtmlSanitizeEx.Scrubber.Meta

  # Removes any CDATA tags before the traverser/scrubber runs.
  Meta.remove_cdata_sections_before_scrub

  Meta.strip_comments

  @valid_schemes ["http", "https"]


  Meta.allow_tag_with_uri_attributes   "a", ["href"], @valid_schemes
  Meta.allow_tag_with_these_attributes "a", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "target", "ping", "rel", "media", "hreflang", "type"]

  Meta.allow_tag_with_these_attributes "abbr", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "address", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "area", ["href"], @valid_schemes
  Meta.allow_tag_with_these_attributes "area", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                                "alt", "coords", "shape", "target", "ping", "rel", "media", "hreflang", "type"]

  Meta.allow_tag_with_these_attributes "article", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "aside", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "a", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "audio", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                                "crossorigin", "preload", "autoplay", "mediagroup", "loop", "muted", "controls"]

  Meta.allow_tag_with_these_attributes "b", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "base", ["href"], @valid_schemes
  Meta.allow_tag_with_these_attributes "base", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                                "target"]

  Meta.allow_tag_with_these_attributes "bdi", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "bdo", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "blockquote", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                                      "cite"]

  Meta.allow_tag_with_these_attributes "body", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "br", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "button", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                                  "autofocus", "disabled", "form", "formaction", "formenctype", "formmethod", "formnovalidate", "formtarget", "name", "type", "value"]
  Meta.allow_tag_with_these_attributes "canvas", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                                  "width", "height"]

  Meta.allow_tag_with_these_attributes "caption", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "cite", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "code", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "col", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "span"]
  Meta.allow_tag_with_these_attributes "colgroup", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "span"]
  Meta.allow_tag_with_these_attributes "command", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "type label icon disabled checked radiogroup command"]
  Meta.allow_tag_with_these_attributes "data", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "value"]
  Meta.allow_tag_with_these_attributes "datalist", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "option"]

  Meta.allow_tag_with_these_attributes "dd", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "del", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "cite", "datetime"]
  Meta.allow_tag_with_these_attributes "details", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "open"]

  Meta.allow_tag_with_these_attributes "dfn", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "dialog", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "open"]

  Meta.allow_tag_with_these_attributes "div", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "dl", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "dt", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "em", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "embed", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "embed", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "type", "width", "height"]

  Meta.allow_tag_with_these_attributes "fieldset", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "disabled", "form", "name"]

  Meta.allow_tag_with_these_attributes "figcaption", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "figure", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "footer", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "form", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "accept-charset", "action", "autocomplete", "enctype", "method", "name", "novalidate", "target"]

  Meta.allow_tag_with_these_attributes "h1", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "h2", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "h3", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "h4", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "h5", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "h6", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "head", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "header", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "hgroup", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "hr", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "html", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "manifest"]

  Meta.allow_tag_with_these_attributes "i", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "iframe", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "iframe", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "name", "sandbox", "seamless", "width", "height"]

  Meta.allow_tag_with_uri_attributes   "img", ["src", "lowsrc", "srcset"], @valid_schemes
  Meta.allow_tag_with_these_attributes "img", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "alt crossorigin usemap ismap width height"]

  Meta.allow_tag_with_uri_attributes   "input", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "input", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "accept", "alt", "autocomplete", "autofocus", "checked", "dirname", "disabled", "form", "formaction", "formenctype", "formmethod", "formnovalidate", "formtarget", "height", "inputmode", "list", "max", "maxlength", "min", "multiple", "name", "pattern", "placeholder", "readonly", "required", "size", "step", "type", "value", "width"]

  Meta.allow_tag_with_these_attributes "ins", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "cite", "datetime"]

  Meta.allow_tag_with_these_attributes "kbd", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "keygen", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "autofocus", "challenge", "disabled", "form", "keytype", "name"]
  Meta.allow_tag_with_these_attributes "label", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "form", "for"]

  Meta.allow_tag_with_these_attributes "legend", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "li", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "value"]

  #Meta.allow_tag_with_uri_attributes   "link", ["href"], @valid_schemes
  #Meta.allow_tag_with_these_attributes "link", ["href rel media hreflang type sizes"]

  Meta.allow_tag_with_these_attributes "map", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "name"]

  Meta.allow_tag_with_these_attributes "mark", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "menu", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "type", "label"]
  Meta.allow_tag_with_these_attributes "meta", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "name", "http-equiv", "content", "charset"]
  Meta.allow_tag_with_these_attributes "meter", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "value", "min", "max", "low", "high", "optimum"]

  Meta.allow_tag_with_these_attributes "nav", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  #Meta.allow_tag_with_these_attributes "noscript"

  Meta.allow_tag_with_these_attributes "object", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "data", "type", "typemustmatch", "name", "usemap", "form", "width", "height"]
  Meta.allow_tag_with_these_attributes "ol", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "reversed", "start"]
  Meta.allow_tag_with_these_attributes "optgroup", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "disabled", "label"]
  Meta.allow_tag_with_these_attributes "option", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "disabled", "label", "selected", "value"]
  Meta.allow_tag_with_these_attributes "output", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "for", "form", "name"]

  Meta.allow_tag_with_these_attributes "p", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "param", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "name", "value"]

  Meta.allow_tag_with_these_attributes "pre", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "progress", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "value", "max"]
  Meta.allow_tag_with_these_attributes "q", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "cite"]

  Meta.allow_tag_with_these_attributes "rp", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "rt", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "ruby", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "s", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "samp", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  #Meta.allow_tag_with_these_attributes "script", ["src async defer type charset"]

  Meta.allow_tag_with_these_attributes "section", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "select", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "autofocus", "disabled", "form", "multiple", "name", "required", "size"]

  Meta.allow_tag_with_these_attributes "small", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "source", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "source", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "type", "media"]

  Meta.allow_tag_with_these_attributes "span", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "strong", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  # TODO: scrub evil css from style tags
  #Meta.allow_tag_with_these_attributes "style", ["media type scoped"]

  Meta.allow_tag_with_these_attributes "sub", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "summary", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "sup", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "table", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "tbody", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "td", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "colspan", "rowspan", "headers"]
  Meta.allow_tag_with_these_attributes "textarea", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "autocomplete", "autofocus", "cols", "dirname", "disabled", "form", "inputmode", "maxlength", "name", "placeholder", "readonly", "required", "rows", "wrap"]

  Meta.allow_tag_with_these_attributes "tfoot", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "th", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "colspan", "rowspan", "headers", "scope", "abbr"]

  Meta.allow_tag_with_these_attributes "thead", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_these_attributes "time", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "datetime", "pubdate"]

  Meta.allow_tag_with_these_attributes "title", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "tr", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "track", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "track", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "default", "kind", "label", "srclang"]

  Meta.allow_tag_with_these_attributes "u", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "ul", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]
  Meta.allow_tag_with_these_attributes "var", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]

  Meta.allow_tag_with_uri_attributes   "video", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "video", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate",
                                              "crossorigin", "poster", "preload", "autoplay", "mediagroup", "loop", "muted", "controls", "width", "height"]

  Meta.allow_tag_with_these_attributes "wbr", ["accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "inert", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "role", "spellcheck", "tabindex", "title", "translate"]


  Meta.strip_everything_not_covered
end
