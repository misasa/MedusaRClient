#' @title Return an R object that will return Medusa records or Medusa records
#'
#' @description Return an R object that will return Medusa records or
#'   Medusa records.  This class provides a coherent wrapper
#'   object-relational mapping for Medusa's RESTful Web service.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @return An R object of \code{\link{R6Class}} with methods that
#'   communicate with Medusa or R objects that correspond to Medusa records.
#' @format \code{\link{R6Class}} object.
#' @seealso \code{\link{connection}}
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
#' @section Methods:
#' \describe{
#'   \item{Documentation}{Return an R object that will return Medusa records or Medusa records.
#'   Visit \url{https://github.com/misasa/MedusaRClient/} for detail.}
#'   \item{\code{new(NAME)}}{Return a new R object that corresponds to records having resource
#'   name \code{NAME} in Medusa.  As of March 2018, "specimens", "boxes", "places", "surfaces",
#'   "spots", "analyses", "devices", "techniques", "chemistries", "bibs", and "attachment_files" are defined in Medusa.}
#'   \item{\code{find(id, options = NULL)}}{Return a Medusa record with local \code{ID} specified.}
#'   \item{\code{find_by_ids(ids, options = NULL)}}{Return Medusa records with local \code{ID} specified.}
#'   \item{\code{find_by_global_id(id, options = NULL)}}{Return a Medusa record with glocal \code{ID} specified.}
#'   \item{\code{find_all(options = NULL)}}{Return all Medusa records having the resource name.}
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
