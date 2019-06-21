#' @title Return an R object that will return association lists or association lists
#'
#' @description Return an R object that will return association lists
#'   or association lists.  This class provides object with methods
#'   for communication with RESTful services.  This is low-level
#'   function and it is not recommended for an user to call this
#'   function.
#' 
#' @docType class
#' @importFrom R6 R6Class
#' @import httr
#' @import jsonlite
#' @import stringr
#' @import yaml
#' @import urltools
#' @export
#' @return An R object of \code{\link{R6Class}} with methods that
#'   communicate with Medusa or association lists.
#' @format \code{\link{R6Class}} object.
#' @seealso \code{\link{pmlame}} and \code{\link{resource}}
#' @examples
#' conn <- Connection$new(list(uri="https://dream.misasa.okayama-u.ac.jp/pub/"))
#' record <- conn$get("specimens",23952)
#' @section Methods:
#' \describe{
#'   \item{Documentation}{Return an R object that will return association lists
#'   or association lists.  Visit \url{https://github.com/misasa/MedusaRClient/} for detail.}
#'   \item{\code{new()}}{Return a new R object that corresponds to a port (or a connection) for association lists.}
#'   \item{\code{get(resource, id, params = NULL)}}{Get record with \code{resource} as resource name, \code{id} as id, and \code{params} as list of query parameters}
#'   \item{\code{gets(resource, ids, params = NULL)}}{Get record with \code{resource} as resource name, \code{ids} as list of ids, and \code{params} as list of query parameters}
#'   \item{\code{gets_sub(owner, id, resource, params = NULL)}}{Get record with \code{owner} as parent resource name, \code{id} as id of parent record, \code{resource} as resource name, and \code{params} as list of query parameters}
#' }
Connection <- R6Class(
  "Connection",
  private = list(
    protocol = NULL,
    uri = NULL,
    user = NULL,
    password = NULL,
    access_key = NULL,
    build_uri = function(path) {
      parsed_url <- url_parse(private$uri)
      if (is.na(parsed_url$scheme)){
        parsed_url$scheme <- private$protocol
      }
      #uri <- paste0(private$protocol, "://", private$uri)
      path <- ifelse( length(grep(x=parsed_url$path, pattern="/$")), path, paste0("/", path) )
      #uri <- paste0(uri, path)
      parsed_url$path = paste0(parsed_url$path, path)
      uri <- url_compose(parsed_url)
      #cat(file=stderr(), "URI: ", uri, "\n")
      message("URI: ", uri)
      return(uri)
    },
    GET = function(path) {
      tryCatch({
        uri <- private$build_uri(path)
        if (!is.null(private$user) && !is.null(private$password)){
          res <- GET(uri, authenticate(private$user, private$password))
        } else {
          res <- GET(uri)
        }
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
    initialize = function(connection_info = yaml.load_file("~/.orochirc")) {
      # connection_info <- yaml.load_file("~/.orochirc")
      private$protocol <- ifelse(is.null(connection_info$protocol), "https", connection_info$protocol)
      private$uri      <- connection_info$uri
      private$user     <- connection_info$user
      private$password <- connection_info$password
      private$access_key <- connection_info$access_key
    },
    get = function(resource, id, params = NULL) {
      query <- private$build_query(params)
      params <- ifelse(is.null(query), "", paste0("?", query))
      path <- paste0(resource, "/", id, ".json", params)
      private$GET(path)
    },
    gets = function(resource, ids, params = NULL) {
      ids_param <- ifelse(is.null(ids), "", paste((function(id) { paste0("q[id_in][]=", id) })(ids), collapse = "&"))
      query <- private$build_query(params)
      params <- ifelse(is.null(query), "", paste0("&", query))
      path <- paste0(resource, ".json", "?", ids_param, params)
      private$GET(path)
    },
    gets_sub = function(owner, id, resource, params = NULL) {
      query <- private$build_query(params)
      params <- ifelse(is.null(query), "", paste0("?", query))
      path <- paste0(owner, "/", id , "/", resource, ".json", params)
      private$GET(path)
    }
  )
)
