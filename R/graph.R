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

#' Graphs
#' 
#' @description Generic interface for graphs as S3 objects
#' (directed or undirected, simple or multi-edged).
#' 
#' @details Unlike most R objects, graphs are mutable and have
#' pass-by-reference semantics.
#'
#' @name graph
NULL

#' @rdname graph
#' @export
is_directed <- function(g) UseMethod("is_directed")

#' @rdname graph
#' @export
nodes <- function(g) UseMethod("nodes")

#' @rdname graph
#' @export
edges <- function(g, ...) UseMethod("edges")

#' @rdname graph
#' @export
nnodes <- function(g) UseMethod("nnodes")

#' @rdname graph
#' @export
nedges <- function(g, ...) UseMethod("nedges")

#' @rdname graph
#' @export
add_node <- function(g, node, ...) UseMethod("add_node")

#' @rdname graph
#' @export
add_nodes <- function(g, nodes) UseMethod("add_nodes")

#' @export
add_nodes.default <- function(g, nodes) {
  for (node in nodes)
    add_node(g, node)
}

#' @rdname graph
#' @export
has_node <- function(g, node) UseMethod("has_node")

#' @rdname graph
#' @export
rem_node <- function(g, node) UseMethod("rem_node")

#' @rdname graph
#' @export
add_edge <- function(g, src, tgt, ...) UseMethod("add_edge")

#' @rdname graph
#' @export
has_edge <- function(g, src, tgt) UseMethod("has_edge")

#' @rdname graph
#' @export
rem_edge <- function(g, src, tgt, ...) UseMethod("rem_edge")

#' @rdname graph
neighbors <- function(g, node) UseMethod("neighbors")

#' @export
neighbors.default <- function(g, node) successors(g, node)

#' @rdname graph
#' @export
successors <- function(g, node) UseMethod("successors")

#' @export
successors.default <- function(g, node) neighbors(g, node)

#' @rdname graph
#' @export
predecessors <- function(g, node) UseMethod("predecessors")

#' @export
predecessors.default <- function(g, node) neighbors(g, node)

#' Graph data
#' 
#' @description Arbitrary metadata can be attached to graphs, nodes, and edges.
#' By default, the data is a named list of attributes (key-value pairs).
#' 
#' @export
graph_data <- function(g) UseMethod("graph_data")

#' @rdname graph_data
#' @export
`graph_data<-` <- function(g, value) UseMethod("graph_data<-")

#' @rdname graph_data
#' @export
graph_attr <- function(g, key) UseMethod("graph_attr")

#' @export
graph_attr.default <- function(g, key) graph_data(g)[[key]]

#' @rdname graph_data
#' @export
`graph_attr<-` <- function(g, key, value) UseMethod("graph_attr<-")

#' @export
`graph_attr<-.default` <- function(g, key, value) {
  graph_data(g)[[key]] <- value
  g
}

#' @rdname graph_data
#' @export
node_data <- function(g, node) UseMethod("node_data")

#' @rdname graph_data
#' @export
`node_data<-` <- function(g, node, value) UseMethod("node_data<-")

#' @rdname graph_data
#' @export
node_attr <- function(g, node, key) UseMethod("node_attr")

#' @export
node_attr.default <- function(g, node, key) node_data(g, node)[[key]]

#' @rdname graph_data
#' @export
`node_attr<-` <- function(g, node, key, value) UseMethod("node_attr<-")

#' @export
`node_attr<-.default` <- function(g, node, key, value) {
  node_data(g, node)[[key]] <- value
  g
}

#' @rdname graph_data
#' @export
edge_data <- function(g, src, tgt, ...) UseMethod("edge_data")

#' @rdname graph_data
#' @export
`edge_data<-` <- function(g, src, tgt, ..., value) UseMethod("edge_data<-")

#' @rdname graph_data
#' @export
edge_attr <- function(g, src, tgt, ..., key) UseMethod("edge_attr")

#' @export
edge_attr.default <- function(g, src, tgt, key) edge_data(g, src, tgt)[[key]]

#' @rdname graph_data
#' @export
`edge_attr<-` <- function(g, src, tgt, ..., key, value) UseMethod("edge_attr<-")

#' @export
`edge_attr<-.default` <- function (g, src, tgt, key, value) {
  edge_data(g, src, tgt)[[key]] <- value
  g
}

#' @export
print.graph <- function(g, ...) {
  cat(class(g)[[1]], "with", nnodes(g), "nodes and", nedges(g), "edges")
}

#' @export
print.edge <- function(e, ...) {
  cat(class(e)[[1]], "(", e$src, " => ", e$tgt, ")", sep="")
}
