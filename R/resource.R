library(R6)

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

# examples
# Specimen <- Resource$new("specimens")
# Box <- Resource$new("boxes")
# Place <- Resource$new("places")
# surface <- Resource$new("surfaces")
# Spot <- Resource$new("spots")
# Analysis <- Resource$new("analyses")
# Device <- Resource$new("devices")
# Technique <- Resource$new("techniques")
# Chemistry <- Resource$new("chemistries")
# Bib <- Resource$new("bibs")
# AttachmentFile <- Resource$new("attachment_files")
