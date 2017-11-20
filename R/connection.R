library(httr)
library(jsonlite)
library(R6)
library(stringr)

library(yaml)

Connection <- R6Class(
  "Connection",
  private = list(
    protocol = "http",
    host = "localhost",
    port = 80,
    build_uri = function(path) {
      paste0(private$protocol, "://", private$host, ":", private$port, path)
    },
    GET = function(path) {
      tryCatch({
        uri <- private$build_uri(path)
        res <- GET(uri, authenticate("admin", "admin"))
        stop_for_status(res)
        fromJSON(content(res, "text"))
      }, error = function(e) {
        cat(file=stderr(), "----------ERROR---------", "\n")
        traceback()
        print(e)
      })
    },
    build_query = function(params) {
      if (is.null(params)) {
        return(NULL)
      }
      query <- list()
      for (name in names(params)) {
        query <- c(query, paste0(name, "=", unlist(params[name])))
      }
      return(paste(query, collapse = "&"))
    }
  ),
  public = list(
    initialize = function(protocol=NULL, host=NULL, port=NULL) {
      # TODO: 接続情報を外部ファイルから取得する。取得元および初期値は要検討
      connection_info <- yaml.load_file("~/.orochirc")
      private$protocol <- ifelse(is.null(protocol), connection_info$protocol, protocol)
      private$host     <- ifelse(is.null(host), connection_info$host, host)
      private$port     <- ifelse(is.null(port), connection_info$port, port)
    },
    get = function(resource, id, params = NULL) {
      query <- private$build_query(params)
      params <- ifelse(is.null(query), "", paste0("?", query))
      path <- paste0("/", resource, "/", id, ".json", params)
      private$GET(path)
    },
    gets = function(resource, ids, params = NULL) {
      ids_param <- paste((function(id) { paste0("q[id_in][]=", id) })(ids), collapse = "&")
      query <- private$build_query(params)
      params <- ifelse(is.null(query), "", paste0("&", query))
      path <- paste0("/", resource, ".json", "?", ids_param, params)
      private$GET(path)
    },
    gets_sub = function(owner, id, resource, params = NULL) {
      query <- private$build_query(params)
      params <- ifelse(is.null(query), "", paste0("?", query))
      path <- paste0("/", owner, "/", id , "/", resource, ".json", params)
      private$GET(path)
    }
  )
)