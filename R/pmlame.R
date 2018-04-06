#' @title Return an R object that will return dataframe or dataframe
#'
#' @description Return an R object that will return dataframe or
#'   dataframe.  This class provides a coherent wrapper
#'   object-relational mapping for Medusa's RESTful web service.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @importFrom plyr ldply
#' @export
#' @return An R object of \code{\link{R6Class}} with methods that
#'   communicate with Medusa or dataframe.
#' @seealso \code{\link{medusaRClient.read.pmlame}} and \code{\link{connection}}
#' @examples
#' global_id <- "20081202172326.hkitagawa"
#' conn <- Connection$new(list(uri="devel.misasa.okayama-u.ac.jp/Chelyabinsk/", user="admin", password="admin"))
#' obj <- Pmlame$new(conn)
#' pmlame <- obj$read(global_id, list(Recursivep=TRUE))
#' @format \code{\link{R6Class}} object.
#' @section Methods:
#' \describe{
#'   \item{Documentation}{Return an R object that will return dataframe or dataframe.
#'     Visit \url{https://github.com/misasa/MedusaRClient/} for detail.}
#'   \item{\code{new()}}{Return a new R object that corresponds to a port (or a connection) for dataframes.}
#'   \item{\code{read(global_id, options = NULL)}}{Return a dataframe of
#'     a record with \code{global_id} specified.  Return a recursive dataframe when
#'     \code{Recursivep} is TRUE.}
#' }
Pmlame <- R6Class(
  "Pmlame",
  private = list(
    conn = NA,
    json_list = NA,
    convert = function(dataframe) {
      colnames <- colnames(dataframe)
      colindex <- grep(x=colnames, pattern = "element")
      if( length(colindex) > 0 ) {
        title_list <- dataframe[, "element"]
        rownames(dataframe) <- title_list
        dataframe[, "element"] <- NULL
      }
      dataframe
    },
    set_opts = function(opts = NULL) {
      params = NULL

      if (opts$Recursivep) {
        params <- list(type = "family")
      }
      params
    }
  ),
  public = list(
    initialize = function(conn = Connection$new()) {
      private$conn <- conn
    },
    read = function(global_id, opts = NULL) {
      resource = Resource$new("pmlame", private$conn)
      opts <- private$set_opts(opts)
      private$json_list = resource$belongs_to("records", global_id, opts)
      df <- ldply(private$json_list, data.frame)
      df <- private$convert(df)
      df
    }
  )
)
