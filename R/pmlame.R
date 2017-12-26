library(R6)
library (plyr)

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
