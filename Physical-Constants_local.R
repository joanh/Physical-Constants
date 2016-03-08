## Data wrangling - Fundamental-Physical-Constants.csv
#### Required package: stringr // https://cran.r-project.org/web/packages/stringr/index.html
##  From http://physics.nist.gov/cuu/Constants/Table/allascii.txt
##  More - http://physics.nist.gov/cuu/Constants
##  Pre-edited through OpenRefine - http://openrefine.org/
####
# library(stringr)
# Read file:
PhyConst <- read.table("~/R/Physical Constants/Fundamental-Physical-Constants.csv", header = TRUE, sep = ",",dec = ".")
# removing spaces from "Value" and "Uncertainty" text columns:
PhyConst$Value <- str_replace_all(PhyConst$Value, fixed(" "), "")
PhyConst$Uncertainty <- str_replace_all(PhyConst$Uncertainty, fixed(" "), "")
# fixing extra characters coming from exact values:
PhyConst$Value <- str_replace_all(PhyConst$Value, fixed("..."), "")
PhyConst$Uncertainty <- str_replace_all(PhyConst$Uncertainty, fixed("(exact)"), "0")
# converting string to numeric (scientific notation):
PhyConst$Value <- as.numeric(PhyConst$Value)
PhyConst$Uncertainty <- as.numeric(PhyConst$Uncertainty)
## Just a quick graphical test
hist(log(PhyConst$Value))
