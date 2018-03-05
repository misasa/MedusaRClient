#' Class providing object with methods for communication with Medusa server
#'
#' @docType class
#' @importFrom R6 R6Class
#' @importFrom plyr ldply
#' @export
#' @return Object of \code{\link{R6Class}} with methods for communication with Medusa server
#' @format \code{\link{R6Class}} object.
#' #' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/misasa/MedusaRClient/}
#'   \item{\code{new()}}{This method is used to create object of the class}
#'   \item{\code{read(global_id, options = NULL)}{This method get a record with \code{global_id} as global-ID of the record and \code{opts} as Recursivep}}
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
      resource = Resource$new("pmlame")
      opts <- private$set_opts(opts)
      private$json_list = resource$belongs_to("records", global_id, opts)
      df <- ldply(private$json_list, data.frame)
      df <- private$convert(df)
      df
    }
  )
)
