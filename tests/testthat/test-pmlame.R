context("Pmlame")
test_that("new works without parameters.",{
  pmlame <- Pmlame$new()
  expect_that(pmlame,is_a("Pmlame"))
})

test_that("new works with connection.",{
  con <- Connection$new(list(uri="devel.misasa.okayama-u.ac.jp/Chelyabinsk/", user="admin", password="admin"))
  pmlame <- Pmlame$new(con)
  expect_that(pmlame,is_a("Pmlame"))
})

test_that("read works with global_id.",{
  global_id <- "20081202172326.hkitagawa"
  con <- Connection$new(list(uri="devel.misasa.okayama-u.ac.jp/Chelyabinsk/", user="admin", password="admin"))
  pmlame <- Pmlame$new(con)
  expect_that(pmlame$read(global_id, list(Recursivep=TRUE)),is_a("data.frame"))
})
