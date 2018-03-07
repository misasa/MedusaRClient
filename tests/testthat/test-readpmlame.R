context("Get pmlame")
test_that("medusaRClient.read.pmlame works.",{
  gid <- "20081202172326.hkitagawa"
  pmlame <- medusaRClient.read.pmlame(gid)
  expect_equal(class(pmlame),"data.frame")
})
