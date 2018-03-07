# MedusaRClient

R package that talks to Medusa

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
