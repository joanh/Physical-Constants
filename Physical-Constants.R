#### Required package: stringr // https://cran.r-project.org/web/packages/stringr/index.html
##   Data from http://physics.nist.gov/cuu/Constants/Table/allascii.txt
##   Pre-edited through OpenRefine - http://openrefine.org/
####
library(knitr)
library(stringr)
library(ggplot2)
### Read file:
GH_url <- "https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv"
PhysicalConstants <- read.csv(GH_url, header = TRUE, sep = ",",dec = ".")

## from local (after downloading "Fundamental-Physical-Constants.csv") use read.table:
## PhysicalConstants <- read.table("~/R/Physical Constants/Fundamental-Physical-Constants.csv",
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
### Just a quick graphical test
## histogram made from the count of values of the base 10 logarithm
## of the absolute value of each physical constant
histogram <- ggplot(data=PhysicalConstants, aes(log10(abs(PhysicalConstants$Value)))) +
  geom_histogram(col="orange", 
                 aes(fill=..count..), binwidth= .75) +
  scale_fill_gradient("Count", low="cyan", high="blue") +
  geom_density(aes(y =..count..), colour="red", adjust=0.3, size=0.3) +
  geom_density(aes(y =..count..), colour="red", adjust=3, size=1) +
  ggtitle("Histogram for physical constants") +
  labs(x="Base 10 logarithm of the absolute value of each physical constant", y="Count")
print(histogram)

