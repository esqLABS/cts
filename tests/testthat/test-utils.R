test_that("check_internet works",{
  expect_no_error(check_internet())
})

test_that("is_file_url works",{
  expect_true(is_file_url("https://raw.githubusercontent.com/Open-Systems-Pharmacology/OSPSuite.BuildingBlockTemplates/main/templates.json"))
  expect_false(is_file_url("path/to/file"))
})

test_that("is_file_local works",{

  expect_true(is_file_local(test_path("data", "Itraconazole-Model.json")))
  expect_false(is_file_local(test_path("data")))

})

test_that("to_list works as expected", {
  expect_equal(to_list(NULL), list(NULL))
  expect_equal(to_list(c(1, 2)), list(1, 2))
  expect_equal(to_list(c("a", "b")), list("a", "b"))
  expect_equal(to_list(list(1, 2)), list(1, 2))
})
