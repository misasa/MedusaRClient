#' Class providing object with methods for communication with Medusa server
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @return Object of \code{\link{R6Class}} with methods for communication with Medusa server
#' @format \code{\link{R6Class}} object.
#' @examples
#' Specimen <- Resource$new("specimens")
#' Specimen$find_all()
#' Box <- Resource$new("boxes")
#' Place <- Resource$new("places")
#' surface <- Resource$new("surfaces")
#' Spot <- Resource$new("spots")
#' Analysis <- Resource$new("analyses")
#' Device <- Resource$new("devices")
#' Technique <- Resource$new("techniques")
#' Chemistry <- Resource$new("chemistries")
#' Bib <- Resource$new("bibs")
#' AttachmentFile <- Resource$new("attachment_files")
#' @field name Stores resource name of your Medusa server
#' @field conn Stores connection object
#' #' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/misasa/MedusaRClient/}
#'   \item{\code{new(name)}}{This method is used to create object of the class with \code{name} as resource name of the server object}
#'   \item{\code{find(id, options = NULL)}{This method finds a record}}
#'   \item{\code{find_by_ids(ids, options = NULL)}{This methods finds records}}
#'   \item{\code{find_by_global_id(id, options = NULL)}{This method finds a record}}
#'   \item{\code{find_all(options = NULL)}{This method finds records}}
#' }
Resource <- R6Class(
  "Resource",
  private = list(
    conn = NA,
    name = NA
  ),
  public = list(
    initialize = function(name, conn = Connection$new()) {
      private$conn <- conn
      private$name <- name
    },
    find = function(id, options = NULL) {
      private$conn$get(private$name, id, options)
    },
    find_by_ids = function(ids, options = NULL) {
      private$conn$gets(private$name, ids, options)
    },
    find_by_global_id = function(id, options = NULL) {
      private$conn$get("records", id, options)$datum_attributes
    },
    find_all = function(options = NULL) {
      private$conn$gets(private$name, NULL, options)
    },
    belongs_to = function(resource, id, options = NULL) {
      private$conn$gets_sub(resource, id, private$name, options)
    }
  )
)
