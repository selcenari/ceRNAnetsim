context("Most significant node detection")

test_that("Could the function detect most affected nodes from a specific node in ceRNA network? ",{
  
  data("midsamp")

  midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    find_affected_nodes(node_name = "Gene1", how = 2, cycle = 2, top = 2)->test_affected_nodes
  
  midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    find_affected_nodes(node_name = "Gene1", how = 2, cycle = 2)->test_affected_nodes_2
  
  expect_true(is.data.frame(test_affected_nodes_2))
  expect_true(is.data.frame(test_affected_nodes))
  expect_equal(test_affected_nodes$top_nodes, c("Gene2", "Gene4" ))
  expect_equal(test_affected_nodes$change[1], "upregulated")
  expect_equal(length(test_affected_nodes_2$change), 5)

})





test_that("Could the function detect potential effective node(s) on a specified node? ",{
  
  data("midsamp")
  
  midsamp%>%
    priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
    find_targeting_nodes(how = 2, cycle = 2, target = "Gene1")->test_targeting
  

  
  expect_true(is.data.frame(test_targeting))
  expect_equal(test_targeting$targeting_node, c("Gene2", "Gene3", "Gene4", "Mir1"))
  expect_equal(test_targeting$change[4], "downregulated")

  
})