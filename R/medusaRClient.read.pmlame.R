library(httr)
library(jsonlite)
library(R6)
library(plyr)
library(stringr)

#' @title Get pmlame json from medusa and return a dataframe of pmlame
#'
#' @description Get pmlame json from medusa and return a dataframe of pmlame.
#'
#' @details This function converts a json data which is from medusa ([medusa_host]/records/[global_id]/pmlame.json) to a dataframe and read it.
#' @param pmlame_or_stone A dataframe that already converted or
#'   stone-ID.
#' @param opts List of further options for plot.
#' options are:
#'  - 'Recursivep' is an option whether to get whole family's information.
#' @param verbose Output debug info (default: TRUE).
#' @return A dataframe with unit organized.
#'   \url{https://github.com/misasa/MedusaRClient}
#'
#' @import yaml
#' @export
#' @examples
#' stone   <- "20081202172326.hkitagawa"
#' opts    <- list(Recursivep = TRUE)
#' pmlame  <- medusaRClient.read.pmlame(stone,opts=opts)
medusaRClient.read.pmlame <- function(pmlame_or_stone, opts=NULL, verbose=TRUE) {
  opts_default <- list(Recursivep=FALSE)
  opts_default[intersect(names(opts_default),names(opts))] <- NULL  ## Reset shared options
  opts <- c(opts,opts_default)

  if (verbose) {
    cat(file=stderr(),
      "medusaRClient.read.pmlame:  pmlame_or_stone? # =>",
      ifelse(is.data.frame(pmlame_or_stone), "#<pmlame>", pmlame_or_stone),"\n")
  }

  if (is.data.frame(pmlame_or_stone)) {
    df <- pmlame_or_stone
  } else {
    pmlame <- Pmlame$new()
    df <- pmlame$read(pmlame_or_stone, opts = opts)
  }

  return(df)
}
