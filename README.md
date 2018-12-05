# r package -- MedusaRClient

A series of R interfaces to Medusa

# Description

A series of R interfaces to Medusa.  It provides a interface to acquire
date from Medusa in the usable form for R.

See [r package -- chelyabinsk](https://github.com/misasa/chelyabinsk) that refers to this package.
See [shiny project -- VisualAnalysis](https://github.com/misasa/VisualAnalysis) that refers to this package.

# Dependency

## [GNU R](https://www.r-project.org/ "follow instruction")

# User's guide

To install this package issue following command.

    R> install.packages('devtools')
    R> devtools::install_github('misasa/MedusaRClient')

    R> library(MedusaRClient)
    R> system.time(medusaRClient.read.pmlame("20081202172326.hkitagawa"))
    R> objs <- Resource$new("specimens") # specimens, boxes, or places
    R> objs$find_all()
