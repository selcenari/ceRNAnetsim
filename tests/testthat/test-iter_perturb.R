context("Simulation and perturbation of network")

test_that("Could the functions work? ",{

  data("midsamp")

calc_test<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    calc_perturbation(sample_n(midsamp, 1)$Genes,3, cycle = 30, limit = 0.1)

perturb_test<- midsamp%>%
  priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)


  expect_is(find_iteration(midsamp,Gene_expression, miRNA_expression, node_name = sample_n(midsamp, 1)$Genes, how= 3), 'numeric')
  expect_gt(find_iteration(midsamp,Gene_expression, miRNA_expression, node_name = sample_n(midsamp, 1)$Genes, how= 3),  0)
  expect_equal(attr(calc_test, "names"), c("perturbation_efficiency", "perturbed_count" ))
  expect_true(is.data.frame(find_node_perturbation(perturb_test)))

 })



test_that("Outputs of the functions", {

data("midsamp")

  classofout<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    update_nodes(once = TRUE)%>%
    update_how(sample_n(midsamp, 1)$Genes, 3)%>%
    update_nodes()%>%
    simulate(15)%>%
    class()


  classofout2<-midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    update_nodes(once = TRUE)%>%
    update_how(sample_n(midsamp, 1)$Genes, 3)%>%
    update_nodes()%>%
    simulate_vis(4)%>%
    class()

  expect_equal(classofout, classofout2)


})


