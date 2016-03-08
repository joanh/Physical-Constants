#### Required package: stringr // https://cran.r-project.org/web/packages/stringr/index.html
##   From http://physics.nist.gov/cuu/Constants/Table/allascii.txt
##   Pre-edited through OpenRefine - http://openrefine.org/
####
library(stringr)
### Read file:
GH_url <- "https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv"
PhysicalConstants <- read.csv(GH_url, header = TRUE, sep = ",",dec = ".")
## from local (after downloading "Fundamental-Physical-Constants.csv") use read.table:
## PhyConst <- read.table("~/R/Physical Constants/Fundamental-Physical-Constants.csv",
## header = TRUE, sep = ",",dec = ".")
### removing spaces from "Value" and "Uncertainty" text columns:
PhysicalConstants$Value <- str_replace_all(PhysicalConstants$Value, fixed(" "), "")
PhysicalConstants$Uncertainty <- str_replace_all(PhysicalConstants$Uncertainty, fixed(" "), "")
# fixing extra characters coming from exact values:
PhysicalConstants$Value <- str_replace_all(PhysicalConstants$Value, fixed("..."), "")
PhysicalConstants$Uncertainty <- str_replace_all(PhysicalConstants$Uncertainty, fixed("(exact)"), "0.0")
# converting string to numeric (scientific notation):
PhysicalConstants$Value <- as.numeric(PhysicalConstants$Value)
PhysicalConstants$Uncertainty <- as.numeric(PhysicalConstants$Uncertainty)
## Just a quick graphical test
# hist(log(PhysicalConstants$Value))