# Copyright 2018 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Ordered dictionary
#' 
#' @description Data structure for ordered dictionaries,
#' ala \code{OrderedDict} in Python or Julia.
#' 
#' @details Like ordinary dictionaries (\code{dict}) and unlike most R objects,
#' ordered dictionaries are mutable. The implementation combines a dictionary
#' with a circular doubly linked list, exactly as in Python's
#' \code{OrderedDict}.
#' 
#' @seealso \code{\link{dict}}
ordered_dict <- function(...) {
  as_ordered_dict(list(...))
}

#' @rdname ordered_dict
as_ordered_dict <- function(x) UseMethod("as_ordered_dict")
as_ordered_dict.ordered_dict <- identity
as_ordered_dict.list <- function(x) {
  d = ordered_dict_class$new()
  for (i in seq_along(x))
    d[[names(x)[[i]]]] = x[[i]]
  d
}

`[[.ordered_dict` <- function(d, k) d$get(k)$value
`[[<-.ordered_dict` <- function(d, k, value) {
  node = if (d$has(k)) d$get(k) else d$add(k)
  node$value = value
  d
}

has_key.ordered_dict <- function(d, k) d$has(k)
del.ordered_dict <- function(d, k) d$del(k)
length.ordered_dict <- function(d) d$length()
keys.ordered_dict <- function(d) map_chr(d$as_list(), function(n) n$key)
values.ordered_dict <- function(d) map(d$as_list(), function(n) n$value)

ordered_dict_class <- R6Class(
  classname = c("ordered_dict", "dict"),
  private = list(
    dict = NULL,
    root = NULL
  ),
  public = list(
    initialize = function() {
      private$dict = dict()
      root = ordered_dict_node$new()
      root$prev = root
      root$next_ = root
      private$root = root
    },
    length = function() length(private$dict),
    get = function(key) private$dict[[key]],
    has = function(key) has_key(private$dict, key),
    add = function(key) {
      stopifnot(!self$has(key))
      root = private$root
      last = root$prev
      node = ordered_dict_node$new(last, root, key)
      last$next_ = root$prev = private$dict[[key]] = node
    },
    del = function(key) {
      stopifnot(self$has(key))
      node = self$get(key)
      node$prev$next_ = node$next_
      node$next_$prev = node$prev
      node$prev = node$next_ = NULL
      del(private$dict, key)
    },
    next_ = function(node=NULL) {
      if (is.null(node))
        node = private$root
      node = node$next_
      if (identical(node, private$root)) NULL else node
    },
    as_list = function() {
      n = self$length()
      nodes = vector(mode="list", length=n)
      node = NULL
      for (i in seq2(1,n))
        nodes[[i]] = node = self$next_(node)
      nodes
    }
  )
)

ordered_dict_node <- R6Class("ordered_dict_node",
  public = list(
    prev = NULL,
    next_ = NULL,
    key = NULL,
    value = NULL,
    initialize = function(prev=NULL, next_=NULL, key=NULL, value=NULL) {
      self$prev = prev
      self$next_ = next_
      self$key = key
      self$value = value
    }
  )
)