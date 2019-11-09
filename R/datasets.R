#' @name huge_example 
#' @title huge example
#' @description A sample dataset which is utilised through integration of TCGA_E9_A1N5_normal, 
#'     TCGA_E9_A1N5_mirnanormal and high-throughput experimental miRNA:gene dataset.
#' @docType data
#' @format A data frame with 7 variables and 26176 observation:
#' \describe{
#'   \item{competing}{name of gene}
#'   \item{miRNA}{name of miRNA}
#'   \item{competing_counts}{Expression values of competing element (gene)}
#'   \item{mirnaexpression_normal}{Expression value of miRNA elements in normal tissue}
#'   \item{Energy}{Energy of miRNA:target binding}
#'   \item{region_effect}{Coefficient for efficiency of location on target}
#'   \item{seed_type_effect}{Coefficient for efficiency of seed sequence of miRNA:target interaction}
#'   }
#' @source Dataset was integrated by us.
#' 

NULL


#' @name midsamp 
#' @title midsamp
#' @description middle sized sample dataset
#' @docType data
#' @format A data frame with 7 variables and 26 observation of them:
#' \describe{
#'   \item{Genes}{symbol of gene}
#'   \item{miRNAs}{symol of miRNA}
#'   \item{Gene_expression}{Expression values of competing gene}
#'   \item{miRNA_expression}{Expression value of miRNA}
#'   \item{seeds}{Coefficient for efficiency of seed type of miRNA:target interaction}
#'   \item{targeting_region}{Coefficient for efficiency of location on target}
#'   \item{Energy}{Energy of miRNA:target binding}
#'   }
#' 
#' @source Dataset was created by us.
#' 

NULL

#' @name midsamp_new_counts 
#' @title midsamp_new_counts
#' @description includes new expression values for middle sized sample dataset
#' @docType data
#' @format A data frame with 4 variables and 26 observation of them:
#' \describe{
#'   \item{Competing}{symbol of gene}
#'   \item{miRNA}{symol of miRNA}
#'   \item{Competing_count}{Expression values of competing gene}
#'   \item{miRNA_count}{Expression value of miRNA}
#'   }
#' @source Dataset was created by us.
#' 

NULL

#' @name minsamp 
#' @title minsamp
#' @description minimal sample dataset
#' @docType data
#' @format A data frame with 7 variables and 7 observation of them:
#' \describe{
#'   \item{competing}{symbol of gene}
#'   \item{miRNA}{symol of miRNA}
#'   \item{Competing_expression}{Expression values of competing gene}
#'   \item{miRNA_expression}{Expression value of miRNA}
#'   \item{seed_type}{Coefficient for efficiency of seed sequence of miRNA:target interaction}
#'   \item{region}{Coefficient for efficiency of location on target}
#'   \item{energy}{Energy of miRNA:target binding}
#'   }
#' @source Dataset was created by us.
#' 

NULL

#' @name new_counts 
#' @title new_counts
#' @description includes new expression values for minimal sample dataset
#' @docType data
#' @format A data frame with 7 variables and 7 observation of them:
#' \describe{
#'   \item{Competing}{symbol of gene}
#'   \item{miRNA}{symol of miRNA}
#'   \item{Competing_count}{Expression values of competing gene}
#'   \item{miRNA_count}{Expression value of miRNA}
#'   }
#' 
#' @source Dataset was created by us.
#' 

NULL

#' @name mirtarbasegene
#' @title mirtarbasegene
#' @description the dataset that includes miRNA:target gene interactions downloaded from mirtarbase
#' @source \url{http://mirtarbase.mbc.nctu.edu.tw/php/index.php}
#' @format Classes tbl_df, tbl and data.frame with 380627 observation of 2 variables:
#' \describe{
#'   \item{miRNA}{miRNA symbol}
#'   \item{Target}{target gene symbol}
#'   }
#' @docType data

NULL

#' @name TCGA_E9_A1N5_mirnanormal
#' @title TCGA_E9_A1N5_mirnanormal 
#' @description The dataset contains mirna expression values for normal tissue sample of TCGA-E9-A1N5 barcoded patient
#' @source \url{https://portal.gdc.cancer.gov/}
#' @format Classes tbl_df, tbl and data.frame with	750 observation of  6 variables:
#' \describe{
#'   \item{barcode}{Sample, normal tissue, barcode of patient based on TCGA}
#'   \item{mirbase_ID}{mirbase id of miRNA}
#'   \item{miRNA}{miRNA name}
#'   \item{Precusor}{Precusor id of miRNA which is given in miRNA variable}
#'   \item{total_read}{total reading count of miRNA which is produced from different gene locations}
#'   \item{total_RPM}{total RPM (reading per million) of miRNA}
#'   }
#' 
#' @docType data

NULL

#' @name TCGA_E9_A1N5_mirnatumor
#' @title TCGA_E9_A1N5_mirnatumor 
#' @description The dataset contains mirna expression values for tumor tissue sample of TCGA-E9-A1N5 barcoded patient
#' @source \url{https://portal.gdc.cancer.gov/}
#' @format Classes tbl_df, tbl and data.frame with	648 observation of  6 variables:
#' \describe{
#'   \item{barcode}{Sample, tumor tissue, barcode of patient based on TCGA}
#'   \item{mirbase_ID}{mirbase id of miRNA}
#'   \item{miRNA}{miRNA name}
#'   \item{Precusor}{Precusor id of miRNA which is given in miRNA variable}
#'   \item{total_read}{total reading count of miRNA which is produced from different gene locations}
#'   \item{total_RPM}{total RPM (reading per million) of miRNA}
#'   }
#' @docType data

NULL

#' @name TCGA_E9_A1N5_normal 
#' @title TCGA_E9_A1N5_normal
#' @description The dataset contains gene expression values for normal tissue sample of TCGA-E9-A1N5 barcoded patient
#' @source \url{https://portal.gdc.cancer.gov/}
#' @format Classes tbl_df, tbl and data.frame with	56830 observation of  7 variables:
#' \describe{
#'   \item{patient}{Barcode of patient based on TCGA}
#'   \item{sample}{Tissue sample barcode of the patient}
#'   \item{barcode}{Sample barcode of the patient}
#'   \item{definition}{Tissue type of sample (Solid Tissue Normal)}
#'   \item{ensembl_gene_id}{Gene id}
#'   \item{external_gene_name}{Gene symbol}
#'   \item{gene_expression}{Gene expression value}
#'   }
#' @docType data


NULL

#' @name TCGA_E9_A1N5_tumor 
#' @title TCGA_E9_A1N5_tumor
#' @description The dataset contains gene expression values for cancer tissue sample of TCGA-E9-A1N5 barcoded patient
#' @source \url{https://portal.gdc.cancer.gov/}
#' @format Classes tbl_df, tbl and data.frame with	56830 observtion of  7 variables:
#' \describe{
#'   \item{patient}{Barcode of patient based on TCGA}
#'   \item{sample}{Tissue sample barcode of the patient}
#'   \item{barcode}{Sample barcode of the patient}
#'   \item{definition}{Tissue type of sample (Primary solid Tumor)}
#'   \item{ensembl_gene_id}{Gene id}
#'   \item{external_gene_name}{Gene symbol}
#'   \item{gene_expression}{Gene expression value}
#'   }
#' @docType data

NULL