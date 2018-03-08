context("Connection")
test_that("new works without parameters.",{
  con <- Connection$new()
  expect_that(con,is_a("Connection"))
})

test_that("new works with connection_info.",{
  connection_info <- list(uri="devel.misasa.okayama-u.ac.jp/Chelyabinsk/", user="admin", password="admin")
  con <- Connection$new(connection_info)
  expect_that(con,is_a("Connection"))
})


test_that("gets works with resource_name and id.",{
  resource_name <- "specimens"
  id <- 23952
  connection_info <- list(uri="devel.misasa.okayama-u.ac.jp/Chelyabinsk/", user="admin", password="admin")
  con <- Connection$new(connection_info)
  expect_that(con$gets(resource_name, id),is_a("data.frame"))
})
