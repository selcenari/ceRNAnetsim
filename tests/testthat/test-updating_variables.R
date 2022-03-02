context("Check to Update")



test_that("Check the functions which update the values on the datasets.", {

  data("midsamp")
  data("minsamp")
  data("new_counts")

  primerg<- midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)


  seconderg<- primerg%>%
    update_how(sample_n(midsamp, 1)$Genes, 2)

  minsamp%>%
    priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression)%>%
    update_variables(new_counts)%>%
    as_tibble()%>%
    select(count_current)%>%
    pull()-> min_res

  new_counts%>%
    mutate(Competing= ifelse(Competing== "Gene2", "Gene16", Competing))->new_counts2
  new_counts%>%
    mutate(miRNA= ifelse(miRNA== "Mir2", "Mir3", miRNA))-> new_counts3

  expect_equal(ncol(as_tibble(primerg%>%activate(nodes))), 7)
  expect_equal(ncol(as_tibble(seconderg%>%activate(nodes))), 7)
  expect_equal(ncol(as_tibble(seconderg%>%activate(edges))), ncol(as_tibble(primerg%>%activate(edges))))
  expect_equal(min_res, c(10000, 20000, 5000, 10000, 5000, 10000, 1000, 2000))
  expect_error(primerg%>%update_how("Gene30", 2), "Given node name Gene30 was not found! Please check it.")
  expect_error(primerg%>%update_how("Gene3", -2), "Fold change should not be less than zero.\n                     Please use decimal values for decrease. e.g. 0.5 for 2-fold decrease")
  expect_error(minsamp%>%
                 priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression)%>%
                 update_variables(current_counts=new_counts2),
               "Current values include one or more different node name!")
  expect_error(minsamp%>%
                 priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression)%>%
                 update_variables(current_counts=new_counts3),
               "Current values include one or more different node name!")
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
    update_how("Gene6", 0, knockdown = FALSE)%>%
    simulate(10, knockdown = FALSE)%>%
    as_tibble()%>%
    dplyr::mutate(count_current= round(count_current, 2))%>%
    dplyr::select(count_current)%>%
    pull() -> gene6_zero

  expect_equal(gene6_zero, c(9999.85, 10000.00, 4999.95, 9952.49, 4999.79, 707.65, 6960.06, 2999.24, 5970.73, 1995.51, 7938.52, 1491.92, 498.08, 6751.97, 2989.48, 1998.78, 5949.22, 1000.00, 6486.38, 4795.55, 1000.00, 2000.00, 3000.00, 5000.00))


})



test_that("Check gene knock down", {

  data("midsamp")

  midsamp %>%
    priming_graph(competing_count = Gene_expression,
                  miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)%>%
    update_how("Gene2", how=0, knockdown = TRUE)%>%
    as_tibble()%>%
    filter( name == "Gene2")%>%
    select(count_current)%>%
    pull()-> res1


  midsamp %>%
    priming_graph(competing_count = Gene_expression,
                  miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)%>%
    update_how("Gene2", how=0, knockdown = TRUE)%>%
    simulate(cycle = 5, knockdown = TRUE)%>%
    as_tibble()%>%
    filter( name == "Gene2")%>%
    select(count_current)%>%
    pull()-> res2


  midsamp %>%
    priming_graph(competing_count = Gene_expression,
                  miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)%>%
    update_how("Gene2", how=0, knockdown = TRUE)%>%
    simulate(cycle = 5, knockdown = TRUE)%>%
    activate(edges)%>%
    as_tibble()%>%
    filter( Competing_name == "Gene2")%>%
    select(comp_count_pre)%>%
    pull()-> res3


  midsamp %>%
    priming_graph(competing_count = Gene_expression,
                  miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)%>%
    update_how("Gene2", how=0, knockdown = TRUE)%>%
    simulate(cycle = 5, knockdown = TRUE)%>%
    activate(edges)%>%
    as_tibble()%>%
    filter(Competing_name == "Gene2")%>%
    select(comp_count_current)%>%
    pull()-> res4

  expect_equal(res1, res2, 0)
  expect_equal(res3, res4, 0)


  midsamp %>%
    priming_graph(competing_count = Gene_expression,
                  miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)%>%
    update_how("Gene2", how=0, knockdown = TRUE)%>%
    simulate(cycle = 5, knockdown = TRUE)%>%
    activate(edges)%>%
    as_tibble()%>%
    filter( Competing_name == "Gene2")%>%
    select(comp_count_list)%>%
    unnest(comp_count_list)%>%
    pull()-> sim_res

  expect_equal(sim_res, c(10000, 0, 0, 0, 0, 0))

  midsamp %>%
    priming_graph(competing_count = Gene_expression,
                  miRNA_count = miRNA_expression, aff_factor = c(seeds, Energy), deg_factor = targeting_region)%>%
    update_how("Gene2", how=0, knockdown = FALSE)%>%
    simulate(cycle = 5, knockdown = FALSE)%>%
    as_tibble()%>%
    filter(name== "Gene2")%>%
    select(count_current)%>%
    round(digits = 2)%>%
    pull()->res5

  expect_equal(res5, 6.58)

})
