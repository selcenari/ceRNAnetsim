context("Simulation and perturbation of network")

test_that("Could the functions work? ",{

  data("midsamp")
  data("minsamp")

calc_test<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    calc_perturbation(sample_n(midsamp, 1)$Genes,3, cycle = 30, limit = 0.1)

perturb_test<- midsamp%>%
  priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)

midsamp %>%
  priming_graph(competing_count = Gene_expression,
                miRNA_count = miRNA_expression) %>%
  update_how(node_name = sample_n(midsamp, 1)$Genes, how= 3) %>%
  simulate(10) %>%
  find_iteration() -> midsamp_iteration_test

minsamp%>%
  priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression)%>%
  find_node_perturbation(how=5, cycle=3, fast = 3)%>%
  select(perturbation_efficiency)%>%
  pull()%>%
  round(digits = 2)-> node_efficiencies

  expect_is(midsamp_iteration_test, 'numeric')
  expect_gt(midsamp_iteration_test,  0)
  expect_equal(attr(calc_test, "names"), c("perturbation_efficiency", "perturbed_count" ))
  expect_true(is.data.frame(find_node_perturbation(perturb_test)))
  expect_equal(node_efficiencies, c(NA, NA, NA, 3.18, 2.27, 3.18, NA, 32.00))
  expect_error(midsamp %>%
                 priming_graph(competing_count = Gene_expression,
                               miRNA_count = miRNA_expression) %>%
                 update_how(node_name = sample_n(midsamp, 1)$Genes, how= 3) %>%
                 simulate(cycle = 0),
               "number of cycles should be more than 1")

  expect_equal(class(midsamp %>%
          priming_graph(Gene_expression, miRNA_expression) %>%
          update_how("Gene2",2) %>%
          simulate(10) %>%
          find_iteration(limit=0, plot = TRUE)), c("gg", "ggplot"))


 })



test_that("Outputs of the functions", {

data("midsamp")

  classofout<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    update_how(sample_n(midsamp, 1)$Genes, 3)%>%
    simulate(15)%>%
    class()


  classofout2<-midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    update_how(sample_n(midsamp, 1)$Genes, 3)%>%
    simulate(4)%>%
    class()

  expect_equal(classofout, classofout2)


})


