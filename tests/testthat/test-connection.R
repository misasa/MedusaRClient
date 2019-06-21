context("Connection")

test_that("new works without parameters.",{
  con <- Connection$new()
  expect_that(con,is_a("Connection"))
})


test_that("new works with connection_info.",{
  connection_info <- list(uri="dream.misasa.okayama-u.ac.jp/pub/", user='admin', password='admin')
  con <- Connection$new(connection_info)
  expect_that(con,is_a("Connection"))
})

test_that("can get with user and passowrd",{
  GET_stub <- stubthat::stub(GET)
  GET_stub$strictlyExpects(url = 'https://dream.misasa.okayama-u.ac.jp/pub/specimens/1.json', config = authenticate('admin','admin'), handle=NULL)
  connection_info <- list(uri="dream.misasa.okayama-u.ac.jp/pub/", user='admin', password='admin')
  con <- Connection$new(connection_info)
  with_mock(
    `httr::GET` = GET_stub$f,
    stop_for_status = function(...){},
    fromJSON = function(...){},
    expect_error(con$get("specimens",1), NA)
  )
})

test_that("can get without user and passowrd",{
  GET_stub <- stubthat::stub(GET)
  GET_stub$strictlyExpects(url = 'https://dream.misasa.okayama-u.ac.jp/pub/specimens/1.json', config = list(), handle=NULL)
  connection_info <- list(uri="dream.misasa.okayama-u.ac.jp/pub/")
  con <- Connection$new(connection_info)
  with_mock(
    `httr::GET` = GET_stub$f,
    stop_for_status = function(...){},
    fromJSON = function(...){},
    expect_error(con$get("specimens",1), NA)
  )
})

test_that("can get with uri (no scheme)",{
  GET_stub <- stubthat::stub(GET)
  GET_stub$strictlyExpects(url = 'https://dream.misasa.okayama-u.ac.jp/pub/specimens/1.json', config = list(), handle=NULL)
  connection_info <- list(uri="dream.misasa.okayama-u.ac.jp/pub/")
  con <- Connection$new(connection_info)
  with_mock(
    `httr::GET` = GET_stub$f,
    stop_for_status = function(...){},
    fromJSON = function(...){},
    expect_error(con$get("specimens",1), NA)
  )
})

test_that("can get with uri (scheme)",{
  GET_stub <- stubthat::stub(GET)
  GET_stub$strictlyExpects(url = 'https://dream.misasa.okayama-u.ac.jp/pub/specimens/1.json', config = list(), handle=NULL)
  connection_info <- list(uri="https://dream.misasa.okayama-u.ac.jp/pub/")
  con <- Connection$new(connection_info)
  with_mock(
    `httr::GET` = GET_stub$f,
    stop_for_status = function(...){},
    fromJSON = function(...){},
    expect_error(con$get("specimens",1), NA)
  )
})


#test_that("gets works with resource_name and id.",{
#  resource_name <- "specimens"
#  id <- 23952
#  connection_info <- list(uri="devel.misasa.okayama-u.ac.jp/Chelyabinsk/", user="admin", password="admin")
#  con <- Connection$new(connection_info)
#  expect_that(con$gets(resource_name, id),is_a("data.frame"))
#})
