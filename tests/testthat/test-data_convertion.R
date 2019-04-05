context("Convertion to the graph.")


testdata <- data.frame(competing = c("TP53", "Gene2", "ABCC1", "Gene4", "Gene4", "Gene5", "PTEN"),
                       miRNA = c("mir1", "mir1","hsa-mir3", "mir1", "MiR2", "MiR2", "miR4"),
                       Competing_expression = c(10000, 10000, 5000, 10000, 10000, 5000, 10000),
                       miRNA_expression = c(1000, 1000, 1000, 1000, 2000, 2000, 2000),
                       stringsAsFactors = FALSE)

testdata2 <- data.frame(competing = c("TP53", "Gene-2", "ABCC1", "Gene 4", "Gene 4", "Gene5", "PTEN"),
                        miRNA = c("mir1", "mir1","hsa-mir3", "mir1", "MiR2", "MiR2", "miR4"),
                        Competing_expression = c(10000, 10000, 5000, 10000, 10000, 5000, 10000),
                        miRNA_expression = c(1000, 1000, 1000, 1000, 2000, 2000, 2000),
                        stringsAsFactors = FALSE)

testdata3 <- data.frame(competing = c("TP53", "Gene-2", "ABCC1", "Gene 4", "Gene 4", "Gene5", "PTEN"),
                        miRNA = c("mir1", "mir1","hsa-mir3", "mir1", "MiR2", "MiR2", "miR4"),
                        Competing_expression = c(NA, 10000, 5000, 10000, 10000, 5000, 10000),
                        miRNA_expression = c(1000, 1000, 1000, 1000, 2000, 2000, 2000),
                        stringsAsFactors = FALSE)

test_that("Can dataset be correctly converted to graph ? ", {


 prime_type_1 <-  (priming_graph(testdata, competing_count = Competing_expression, miRNA_count= miRNA_expression)%N>%
      as_tibble()%>%
      filter(type == "miRNA")%>%
      count())%>%
   pull()

 prime_type_2 <-priming_graph(testdata, competing_count = Competing_expression, miRNA_count= miRNA_expression)%N>%
     as_tibble()%>%
     filter(type == "Competing")%>%
     count()%>%
   pull()


 prime_type_3 <-  (priming_graph(testdata2, competing_count = Competing_expression, miRNA_count= miRNA_expression)%N>%
                     as_tibble()%>%
                     filter(type == "miRNA")%>%
                     count())%>%
   pull()

 prime_type_4 <-priming_graph(testdata2, competing_count = Competing_expression, miRNA_count= miRNA_expression)%N>%
   as_tibble()%>%
   filter(type == "Competing")%>%
   count()%>%
   pull()




  expect_equal(prime_type_1 , prime_type_3)
  expect_equal(prime_type_2, prime_type_4)

})


test_that("Is there any missing value that is caused by calculations in graph?", {


  sum(is.na.data.frame(priming_graph(testdata, competing_count = Competing_expression, miRNA_count= miRNA_expression)%>%
                         as.tibble()))->missings1

  sum(is.na.data.frame(priming_graph(testdata, competing_count = Competing_expression, miRNA_count= miRNA_expression)%N>%
                         as.tibble()))->missings2

  expect_equal(c(missings1, missings2), c(0,0))


}

)

test_that("When missing value is found in dataframe", {

   expect_error(priming_graph(testdata3, competing_count = Competing_expression, miRNA_count= miRNA_expression), "Missing or NA value in dataframe")

          }

)
