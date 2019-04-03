context("Check to Update")



test_that("Check the functions which update the values on the datasets.", {

  data("midsamp")

  primerg<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)

  seconderg <- primerg%>%
    update_nodes(once= TRUE)

  thirdg<- seconderg%>%
    update_how(sample_n(midsamp, 1)$Genes, 2)

  forth<- thirdg%>%
    update_nodes()


  expect_equal(ncol(as_tibble(primerg%>%activate(nodes))), 3)
  expect_equal(ncol(as_tibble(seconderg%>%activate(nodes))), 7)
  expect_equal(ncol(as_tibble(thirdg%>%activate(nodes))), 7)
  expect_equal(ncol(as_tibble(forth%>%activate(nodes))), 7)
  expect_equal(ncol(as_tibble(seconderg%>%activate(edges))), 19)
  expect_equal(ncol(as_tibble(thirdg%>%activate(edges))), 19)
  expect_equal(ncol(as_tibble(forth%>%activate(edges))), 19)


})


test_that("Check the functions which update the values on the datasets with interaction factors.", {

  data("midsamp")

  primergf <- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)

  secondergf <- primergf%>%
    update_nodes(once= TRUE)

  thirdgf <- secondergf%>%
    update_how(sample_n(midsamp, 1)$Genes, 2)

  forthf <- thirdgf%>%
    update_nodes()

  midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    update_nodes(once=TRUE)%>%
    update_how("Gene15", 0.3)%>%
    update_nodes()%>%
    simulate(10)%>%
    as_tibble()%>%
    dplyr::mutate(count_current= round(count_current, 2))%>%
    dplyr::select(count_current)%>%
    pull() -> outputall


  expect_equal(ncol(as_tibble(secondergf%>%activate(edges))), 22)
  expect_equal(ncol(as_tibble(thirdgf%>%activate(edges))), 22)
  expect_equal(ncol(as_tibble(forthf%>%activate(edges))), 22)
  expect_equal(outputall, c(9999.79, 9999.79, 4999.90, 9974.16, 4999.65, 9975.21, 6981.25, 2991.97, 5999.03, 1999.68, 7998.70, 1499.76,  499.92, 6982.40, 1020.79, 1994.64, 5984.21,  999.93, 6499.55, 4799.67, 1000.00, 2000.00, 3000.00, 5000.00))


})



