context("Resource")
test_that("new works with resource_name.",{
  resource_name <- "specimens"
  obj <- Resource$new(resource_name)
  expect_that(obj,is_a("Resource"))
})

test_that("new works with resource_name and connection.",{
  resource_name <- "specimens"
  connection <- Connection$new(list(uri="dream.misasa.okayama-u.ac.jp/pub/", user="admin", password="admin"))
  obj <- Resource$new(resource_name, connection)
  expect_that(obj,is_a("Resource"))
})

test_that("find_all works without parameters.",{
  resource_name <- "specimens"
  connection <- Connection$new(list(uri="dream.misasa.okayama-u.ac.jp/pub/"))
  obj <- Resource$new(resource_name, connection)
  expect_that(obj$find_all(),shows_message("URI: https://dream.misasa.okayama-u.ac.jp/pub/specimens.json?"))
})

