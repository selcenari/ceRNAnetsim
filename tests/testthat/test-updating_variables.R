context("Check to Update")



test_that("Check the functions which update the values on the datasets.", {

  data("midsamp")

  primerg<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)


  seconderg<- primerg%>%
    update_how(sample_n(midsamp, 1)$Genes, 2)


  expect_equal(ncol(as_tibble(primerg%>%activate(nodes))), 7)
  expect_equal(ncol(as_tibble(seconderg%>%activate(nodes))), 7)
  expect_equal(ncol(as_tibble(seconderg%>%activate(edges))), ncol(as_tibble(primerg%>%activate(edges))))


})


test_that("Check the functions which update the values on the datasets with interaction factors.", {

  data("midsamp")

  primergf<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)


  secondergf<- primergf%>%
    update_how(sample_n(midsamp, 1)$Genes, 2)


  midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    update_how("Gene15", 0.3)%>%
    simulate(10)%>%
    as_tibble()%>%
    dplyr::mutate(count_current= round(count_current, 2))%>%
    dplyr::select(count_current)%>%
    pull() -> outputall


  expect_equal(ncol(as_tibble(secondergf%>%activate(edges))), ncol(as_tibble(primergf%>%activate(edges))))
  expect_equal(outputall, c(9999.79, 9999.79, 4999.90, 9974.16, 4999.65, 9975.21, 6981.25, 2991.97, 5999.03, 1999.68, 7998.70, 1499.76,  499.92, 6982.40, 1020.79, 1994.64, 5984.21,  999.93, 6499.55, 4799.67, 1000.00, 2000.00, 3000.00, 5000.00))
})

test_that("Check zero values", {

  data("midsamp")

  midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression,  aff_factor = c(seeds, Energy), deg_factor = targeting_region)%>%
    update_how("Gene6", 0)%>%
    simulate(10)%>%
    as_tibble()%>%
    dplyr::mutate(count_current= round(count_current, 2))%>%
    dplyr::select(count_current)%>%
    pull() -> gene6_zero

  expect_equal(gene6_zero, c(9999.85, 10000.00, 4999.95, 9952.49, 4999.79, 707.65, 6960.06, 2999.24, 5970.73, 1995.51, 7938.52, 1491.92, 498.08, 6751.97, 2989.48, 1998.78, 5949.22, 1000.00, 6486.38, 4795.55, 1000.00, 2000.00, 3000.00, 5000.00))


})



