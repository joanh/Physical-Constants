# Fundamental Physical Constants

Just a bit of gymnastics on data collation, R and Knitr to get the most exact available values of the [physical constants](https://en.wikipedia.org/wiki/Physical_constant).

## Data source:

**Fundamental Physical Constants --- Complete Listing**
from the [NIST reference on Constants, Units, and Uncertainity](https://physics.nist.gov/cuu/Constants/index.html). 
Via [the raw ASCII data](http://physics.nist.gov/cuu/Constants/Table/allascii.txt) edited through [Open Refine](http://openrefine.org/) to get [this csv file](https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv), and then the few chunks of **R** code shown below.


## Code


```r
knitr::opts_chunk$set(echo = TRUE)
```


```r
# Install packages through `install.packages` command and load them to the environment
library(knitr)
library(stringr)
library(ggplot2)
library(printr)
```
First we import the csv file from the [github repository](https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv)


```r
GH_url <- "https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv"
PhysicalConstants <- read.csv(GH_url, header = TRUE, sep = ",",dec = ".")
```

You can do it from your local computer too after downloading the file  "[Fundamental-Physical-Constants.csv](https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv)" through '[read.table](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/read.table.html)' command:


```r
# PhysicalConstants <- read.table("~/R/Physical Constants/Fundamental-Physical-Constants.csv",
# header = TRUE, sep = ",",dec = ".")
```
Then you need remove the spaces from "Value" and "Uncertainty" text columns:


```r
PhysicalConstants$Value <- str_replace_all(PhysicalConstants$Value, fixed(" "), "")
PhysicalConstants$Uncertainty <- str_replace_all(PhysicalConstants$Uncertainty, fixed(" "), "")
```

and fit the residual characters coming from exact values:


```r
PhysicalConstants$Value <- str_replace_all(PhysicalConstants$Value, fixed("..."), "")
PhysicalConstants$Uncertainty <- str_replace_all(PhysicalConstants$Uncertainty, fixed("(exact)"), "0.0")
```

You can now convert strings to numeric (scientific notation):


```r
PhysicalConstants$Value <- as.numeric(PhysicalConstants$Value)
PhysicalConstants$Uncertainty <- as.numeric(PhysicalConstants$Uncertainty)
```

These are the five first lines of the table: 


```r
head(PhysicalConstants)
```



Quantity                                              Value  Unit    Uncertainty
---------------------------------------------  ------------  -----  ------------
{220} Lattice Spacing Of Silicon                   0.000000  m           0.0e+00
Alpha Particle-electron Mass Ratio              7294.299541              2.0e-07
Alpha Particle Mass                                0.000000  kg          0.0e+00
Alpha Particle Mass Energy Equivalent              0.000000  J           0.0e+00
Alpha Particle Mass Energy Equivalent In Mev    3727.379378  MeV         2.3e-05
Alpha Particle Mass In U                           4.001506  u           0.0e+00

## Order of magnitude histogram

Just a quick graphical test in order to check everything went right, a histogram made from the count of values of the base 10 logarithm of the absolute value of each physical constant, in other words, the exponent of the constant, i.e. its *order of magnitude*.


```r
histogram <- ggplot(data=PhysicalConstants, aes(log10(abs(PhysicalConstants$Value)))) +
  geom_histogram(col="orange", 
                 aes(fill=..count..), binwidth= .75) +
  scale_fill_gradient("Count", low="cyan", high="blue") +
  geom_density(aes(y =..count..), colour="red", adjust=0.3, size=0.3) +
  geom_density(aes(y =..count..), colour="red", adjust=3, size=1) +
  ggtitle("Histogram for physical constants") +
  labs(x="Order of magnitude", y="Count")
print(histogram)
```

![](README_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

## Table

And finally a quick table (pending to take a look to the R interface to the JavaScript library suggested [here](https://stackoverflow.com/questions/27120002/is-it-possible-to-have-sortableinteractive-table-in-rmarkdown). Start [here](http://rstudio.github.io/DT/)).


Note tha we have to setup the `digits` value because by default number is truncated to 7 decimal places (**[yihui](https://github.com/yihui)** himself explain it in [this issue thread](https://github.com/yihui/knitr/issues/1187)), and we can see in the above histogram we need about 70 to cover smallest constants. 


```r
kable(PhysicalConstants,format = "markdown", digits = 70)
```



|Quantity                                                |         Value|Unit           | Uncertainty|
|:-------------------------------------------------------|-------------:|:--------------|-----------:|
|{220} Lattice Spacing Of Silicon                        |  1.920156e-10|m              |     3.2e-18|
|Alpha Particle-electron Mass Ratio                      |  7.294300e+03|               |     2.4e-07|
|Alpha Particle Mass                                     |  6.644657e-27|kg             |     8.2e-35|
|Alpha Particle Mass Energy Equivalent                   |  5.971920e-10|J              |     7.3e-18|
|Alpha Particle Mass Energy Equivalent In Mev            |  3.727379e+03|MeV            |     2.3e-05|
|Alpha Particle Mass In U                                |  4.001506e+00|u              |     6.3e-11|
|Alpha Particle Molar Mass                               |  4.001506e-03|kg mol^-1      |     6.3e-14|
|Alpha Particle-proton Mass Ratio                        |  3.972600e+00|               |     3.6e-10|
|Angstrom Star                                           |  1.000015e-10|m              |     9.0e-17|
|Atomic Mass Constant                                    |  1.660539e-27|kg             |     2.0e-35|
|Atomic Mass Constant Energy Equivalent                  |  1.492418e-10|J              |     1.8e-18|
|Atomic Mass Constant Energy Equivalent In Mev           |  9.314941e+02|MeV            |     5.7e-06|
|Atomic Mass Unit-electron Volt Relationship             |  9.314941e+08|eV             |     5.7e+00|
|Atomic Mass Unit-hartree Relationship                   |  3.423178e+07|E_h            |     1.6e-02|
|Atomic Mass Unit-hertz Relationship                     |  2.252343e+23|Hz             |     1.0e+14|
|Atomic Mass Unit-inverse Meter Relationship             |  7.513007e+14|m^-1           |     3.4e+05|
|Atomic Mass Unit-joule Relationship                     |  1.492418e-10|J              |     1.8e-18|
|Atomic Mass Unit-kelvin Relationship                    |  1.080954e+13|K              |     6.2e+06|
|Atomic Mass Unit-kilogram Relationship                  |  1.660539e-27|kg             |     2.0e-35|
|Atomic Unit Of 1st Hyperpolarizability                  |  3.206361e-53|C^3 m^3 J^-2   |     2.0e-61|
|Atomic Unit Of 2nd Hyperpolarizability                  |  6.235380e-65|C^4 m^4 J^-3   |     0.0e+00|
|Atomic Unit Of Action                                   |  1.054572e-34|J s            |     1.3e-42|
|Atomic Unit Of Charge                                   |  1.602177e-19|C              |     9.8e-28|
|Atomic Unit Of Charge Density                           |  1.081202e+12|C m^-3         |     6.7e+03|
|Atomic Unit Of Current                                  |  6.623618e-03|A              |     4.1e-11|
|Atomic Unit Of Electric Dipole Mom.                     |  8.478354e-30|C m            |     5.2e-38|
|Atomic Unit Of Electric Field                           |  5.142207e+11|V m^-1         |     3.2e+03|
|Atomic Unit Of Electric Field Gradient                  |  9.717362e+21|V m^-2         |     6.0e+13|
|Atomic Unit Of Electric Polarizability                  |  1.648777e-41|C^2 m^2 J^-1   |     1.1e-50|
|Atomic Unit Of Electric Potential                       |  2.721139e+01|V              |     1.7e-07|
|Atomic Unit Of Electric Quadrupole Mom.                 |  4.486551e-40|C m^2          |     2.8e-48|
|Atomic Unit Of Energy                                   |  4.359745e-18|J              |     5.4e-26|
|Atomic Unit Of Force                                    |  8.238723e-08|N              |     1.0e-15|
|Atomic Unit Of Length                                   |  5.291772e-11|m              |     1.2e-20|
|Atomic Unit Of Mag. Dipole Mom.                         |  1.854802e-23|J T^-1         |     1.1e-31|
|Atomic Unit Of Mag. Flux Density                        |  2.350518e+05|T              |     1.4e-03|
|Atomic Unit Of Magnetizability                          |  7.891037e-29|J T^-2         |     9.0e-38|
|Atomic Unit Of Mass                                     |  9.109384e-31|kg             |     1.1e-38|
|Atomic Unit Of Mom.Um                                   |  1.992852e-24|kg m s^-1      |     2.4e-32|
|Atomic Unit Of Permittivity                             |  1.112650e-10|F m^-1         |     0.0e+00|
|Atomic Unit Of Time                                     |  2.418884e-17|s              |     1.4e-28|
|Atomic Unit Of Velocity                                 |  2.187691e+06|m s^-1         |     5.0e-04|
|Avogadro Constant                                       |  6.022141e+23|mol^-1         |     7.4e+15|
|Bohr Magneton                                           |  9.274010e-24|J T^-1         |     5.7e-32|
|Bohr Magneton In Ev/t                                   |  5.788382e-05|eV T^-1        |     2.6e-14|
|Bohr Magneton In Hz/t                                   |  1.399625e+10|Hz T^-1        |     8.6e+01|
|Bohr Magneton In Inverse Meters Per Tesla               |  4.668645e+01|m^-1 T^-1      |     2.9e-07|
|Bohr Magneton In K/t                                    |  6.717140e-01|K T^-1         |     3.9e-07|
|Bohr Radius                                             |  5.291772e-11|m              |     1.2e-20|
|Boltzmann Constant                                      |  1.380649e-23|J K^-1         |     7.9e-30|
|Boltzmann Constant In Ev/k                              |  8.617330e-05|eV K^-1        |     5.0e-11|
|Boltzmann Constant In Hz/k                              |  2.083661e+10|Hz K^-1        |     1.2e+04|
|Boltzmann Constant In Inverse Meters Per Kelvin         |  6.950346e+01|m^-1 K^-1      |     4.0e-05|
|Characteristic Impedance Of Vacuum                      |  3.767303e+02|ohm            |     0.0e+00|
|Classical Electron Radius                               |  2.817940e-15|m              |     1.9e-24|
|Compton Wavelength                                      |  2.426310e-12|m              |     1.1e-21|
|Compton Wavelength Over 2 Pi                            |  3.861593e-13|m              |     1.8e-22|
|Conductance Quantum                                     |  7.748092e-05|S              |     1.8e-14|
|Conventional Value Of Josephson Constant                |  4.835979e+14|Hz V^-1        |     0.0e+00|
|Conventional Value Of Von Klitzing Constant             |  2.581281e+04|ohm            |     0.0e+00|
|Cu X Unit                                               |  1.002077e-13|m              |     2.8e-20|
|Deuteron-electron Mag. Mom. Ratio                       | -4.664346e-04|               |     2.6e-12|
|Deuteron-electron Mass Ratio                            |  3.670483e+03|               |     1.3e-07|
|Deuteron G Factor                                       |  8.574382e-01|               |     4.8e-09|
|Deuteron Mag. Mom.                                      |  4.330735e-27|J T^-1         |     3.6e-35|
|Deuteron Mag. Mom. To Bohr Magneton Ratio               |  4.669755e-04|               |     2.6e-12|
|Deuteron Mag. Mom. To Nuclear Magneton Ratio            |  8.574382e-01|               |     4.8e-09|
|Deuteron Mass                                           |  3.343584e-27|kg             |     4.1e-35|
|Deuteron Mass Energy Equivalent                         |  3.005063e-10|J              |     3.7e-18|
|Deuteron Mass Energy Equivalent In Mev                  |  1.875613e+03|MeV            |     1.2e-05|
|Deuteron Mass In U                                      |  2.013553e+00|u              |     4.0e-11|
|Deuteron Molar Mass                                     |  2.013553e-03|kg mol^-1      |     4.0e-14|
|Deuteron-neutron Mag. Mom. Ratio                        | -4.482065e-01|               |     1.1e-07|
|Deuteron-proton Mag. Mom. Ratio                         |  3.070122e-01|               |     1.5e-09|
|Deuteron-proton Mass Ratio                              |  1.999008e+00|               |     1.9e-10|
|Deuteron Rms Charge Radius                              |  2.141300e-15|m              |     2.5e-18|
|Electric Constant                                       |  8.854188e-12|F m^-1         |     0.0e+00|
|Electron Charge To Mass Quotient                        | -1.758820e+11|C kg^-1        |     1.1e+03|
|Electron-deuteron Mag. Mom. Ratio                       | -2.143923e+03|               |     1.2e-05|
|Electron-deuteron Mass Ratio                            |  2.724437e-04|               |     9.6e-15|
|Electron G Factor                                       | -2.002319e+00|               |     5.2e-13|
|Electron Gyromag. Ratio                                 |  1.760860e+11|s^-1 T^-1      |     1.1e+03|
|Electron Gyromag. Ratio Over 2 Pi                       |  2.802495e+04|MHz T^-1       |     1.7e-04|
|Electron-helion Mass Ratio                              |  1.819543e-04|               |     8.8e-15|
|Electron Mag. Mom.                                      | -9.284765e-24|J T^-1         |     5.7e-32|
|Electron Mag. Mom. Anomaly                              |  1.159652e-03|               |     2.6e-13|
|Electron Mag. Mom. To Bohr Magneton Ratio               | -1.001160e+00|               |     2.6e-13|
|Electron Mag. Mom. To Nuclear Magneton Ratio            | -1.838282e+03|               |     1.7e-07|
|Electron Mass                                           |  9.109384e-31|kg             |     1.1e-38|
|Electron Mass Energy Equivalent                         |  8.187106e-14|J              |     1.0e-21|
|Electron Mass Energy Equivalent In Mev                  |  5.109989e-01|MeV            |     3.1e-09|
|Electron Mass In U                                      |  5.485799e-04|u              |     1.6e-14|
|Electron Molar Mass                                     |  5.485799e-07|kg mol^-1      |     1.6e-17|
|Electron-muon Mag. Mom. Ratio                           |  2.067670e+02|               |     4.6e-06|
|Electron-muon Mass Ratio                                |  4.836332e-03|               |     1.1e-10|
|Electron-neutron Mag. Mom. Ratio                        |  9.609205e+02|               |     2.3e-04|
|Electron-neutron Mass Ratio                             |  5.438673e-04|               |     2.7e-13|
|Electron-proton Mag. Mom. Ratio                         | -6.582107e+02|               |     2.0e-06|
|Electron-proton Mass Ratio                              |  5.446170e-04|               |     5.2e-14|
|Electron-tau Mass Ratio                                 |  2.875920e-04|               |     2.6e-08|
|Electron To Alpha Particle Mass Ratio                   |  1.370934e-04|               |     4.5e-15|
|Electron To Shielded Helion Mag. Mom. Ratio             |  8.640583e+02|               |     1.0e-05|
|Electron To Shielded Proton Mag. Mom. Ratio             | -6.582276e+02|               |     7.2e-06|
|Electron-triton Mass Ratio                              |  1.819200e-04|               |     8.4e-15|
|Electron Volt                                           |  1.602177e-19|J              |     9.8e-28|
|Electron Volt-atomic Mass Unit Relationship             |  1.073544e-09|u              |     6.6e-18|
|Electron Volt-hartree Relationship                      |  3.674932e-02|E_h            |     2.3e-10|
|Electron Volt-hertz Relationship                        |  2.417989e+14|Hz             |     1.5e+06|
|Electron Volt-inverse Meter Relationship                |  8.065544e+05|m^-1           |     5.0e-03|
|Electron Volt-joule Relationship                        |  1.602177e-19|J              |     9.8e-28|
|Electron Volt-kelvin Relationship                       |  1.160452e+04|K              |     6.7e-03|
|Electron Volt-kilogram Relationship                     |  1.782662e-36|kg             |     1.1e-44|
|Elementary Charge                                       |  1.602177e-19|C              |     9.8e-28|
|Elementary Charge Over H                                |  2.417989e+14|A J^-1         |     1.5e+06|
|Faraday Constant                                        |  9.648533e+04|C mol^-1       |     5.9e-04|
|Faraday Constant For Conventional Electric Current      |  9.648533e+04|C_90 mol^-1    |     1.2e-03|
|Fermi Coupling Constant                                 |  1.166379e-05|GeV^-2         |     6.0e-12|
|Fine-structure Constant                                 |  7.297353e-03|               |     1.7e-12|
|First Radiation Constant                                |  3.741772e-16|W m^2          |     4.6e-24|
|First Radiation Constant For Spectral Radiance          |  1.191043e-16|W m^2 sr^-1    |     1.5e-24|
|Hartree-atomic Mass Unit Relationship                   |  2.921262e-08|u              |     1.3e-17|
|Hartree-electron Volt Relationship                      |  2.721139e+01|eV             |     1.7e-07|
|Hartree Energy                                          |  4.359745e-18|J              |     5.4e-26|
|Hartree Energy In Ev                                    |  2.721139e+01|eV             |     1.7e-07|
|Hartree-hertz Relationship                              |  6.579684e+15|Hz             |     3.9e+04|
|Hartree-inverse Meter Relationship                      |  2.194746e+07|m^-1           |     1.3e-04|
|Hartree-joule Relationship                              |  4.359745e-18|J              |     5.4e-26|
|Hartree-kelvin Relationship                             |  3.157751e+05|K              |     1.8e-01|
|Hartree-kilogram Relationship                           |  4.850870e-35|kg             |     6.0e-43|
|Helion-electron Mass Ratio                              |  5.495885e+03|               |     2.7e-07|
|Helion G Factor                                         | -4.255251e+00|               |     5.0e-08|
|Helion Mag. Mom.                                        | -1.074618e-26|J T^-1         |     1.4e-34|
|Helion Mag. Mom. To Bohr Magneton Ratio                 | -1.158741e-03|               |     1.4e-11|
|Helion Mag. Mom. To Nuclear Magneton Ratio              | -2.127625e+00|               |     2.5e-08|
|Helion Mass                                             |  5.006413e-27|kg             |     6.2e-35|
|Helion Mass Energy Equivalent                           |  4.499539e-10|J              |     5.5e-18|
|Helion Mass Energy Equivalent In Mev                    |  2.808392e+03|MeV            |     1.7e-05|
|Helion Mass In U                                        |  3.014932e+00|u              |     1.2e-10|
|Helion Molar Mass                                       |  3.014932e-03|kg mol^-1      |     1.2e-13|
|Helion-proton Mass Ratio                                |  2.993153e+00|               |     2.9e-10|
|Hertz-atomic Mass Unit Relationship                     |  4.439822e-24|u              |     2.0e-33|
|Hertz-electron Volt Relationship                        |  4.135668e-15|eV             |     2.5e-23|
|Hertz-hartree Relationship                              |  1.519830e-16|E_h            |     9.0e-28|
|Hertz-inverse Meter Relationship                        |  3.335641e-09|m^-1           |     0.0e+00|
|Hertz-joule Relationship                                |  6.626070e-34|J              |     8.1e-42|
|Hertz-kelvin Relationship                               |  4.799245e-11|K              |     2.8e-17|
|Hertz-kilogram Relationship                             |  7.372497e-51|kg             |     9.1e-59|
|Inverse Fine-structure Constant                         |  1.370360e+02|               |     3.1e-08|
|Inverse Meter-atomic Mass Unit Relationship             |  1.331025e-15|u              |     6.1e-25|
|Inverse Meter-electron Volt Relationship                |  1.239842e-06|eV             |     7.6e-15|
|Inverse Meter-hartree Relationship                      |  4.556335e-08|E_h            |     2.7e-19|
|Inverse Meter-hertz Relationship                        |  2.997925e+08|Hz             |     0.0e+00|
|Inverse Meter-joule Relationship                        |  1.986446e-25|J              |     2.4e-33|
|Inverse Meter-kelvin Relationship                       |  1.438777e-02|K              |     8.3e-09|
|Inverse Meter-kilogram Relationship                     |  2.210219e-42|kg             |     2.7e-50|
|Inverse Of Conductance Quantum                          |  1.290640e+04|ohm            |     2.9e-06|
|Josephson Constant                                      |  4.835979e+14|Hz V^-1        |     3.0e+06|
|Joule-atomic Mass Unit Relationship                     |  6.700535e+09|u              |     8.2e+01|
|Joule-electron Volt Relationship                        |  6.241509e+18|eV             |     3.8e+10|
|Joule-hartree Relationship                              |  2.293712e+17|E_h            |     2.8e+09|
|Joule-hertz Relationship                                |  1.509190e+33|Hz             |     1.9e+25|
|Joule-inverse Meter Relationship                        |  5.034117e+24|m^-1           |     6.2e+16|
|Joule-kelvin Relationship                               |  7.242973e+22|K              |     4.2e+16|
|Joule-kilogram Relationship                             |  1.112650e-17|kg             |     0.0e+00|
|Kelvin-atomic Mass Unit Relationship                    |  9.251084e-14|u              |     5.3e-20|
|Kelvin-electron Volt Relationship                       |  8.617330e-05|eV             |     5.0e-11|
|Kelvin-hartree Relationship                             |  3.166811e-06|E_h            |     1.8e-12|
|Kelvin-hertz Relationship                               |  2.083661e+10|Hz             |     1.2e+04|
|Kelvin-inverse Meter Relationship                       |  6.950346e+01|m^-1           |     4.0e-05|
|Kelvin-joule Relationship                               |  1.380649e-23|J              |     7.9e-30|
|Kelvin-kilogram Relationship                            |  1.536179e-40|kg             |     8.8e-47|
|Kilogram-atomic Mass Unit Relationship                  |  6.022141e+26|u              |     7.4e+18|
|Kilogram-electron Volt Relationship                     |  5.609589e+35|eV             |     3.4e+27|
|Kilogram-hartree Relationship                           |  2.061486e+34|E_h            |     2.5e+26|
|Kilogram-hertz Relationship                             |  1.356393e+50|Hz             |     1.7e+42|
|Kilogram-inverse Meter Relationship                     |  4.524438e+41|m^-1           |     5.6e+33|
|Kilogram-joule Relationship                             |  8.987552e+16|J              |     0.0e+00|
|Kilogram-kelvin Relationship                            |  6.509660e+39|K              |     3.7e+33|
|Lattice Parameter Of Silicon                            |  5.431021e-10|m              |     8.9e-18|
|Loschmidt Constant (273.15 K, 100 Kpa)                  |  2.651647e+25|m^-3           |     1.5e+19|
|Loschmidt Constant (273.15 K, 101.325 Kpa)              |  2.686781e+25|m^-3           |     1.5e+19|
|Mag. Constant                                           |  1.256637e-06|N A^-2         |     0.0e+00|
|Mag. Flux Quantum                                       |  2.067834e-15|Wb             |     1.3e-23|
|Molar Gas Constant                                      |  8.314460e+00|J mol^-1 K^-1  |     4.8e-06|
|Molar Mass Constant                                     |  1.000000e-03|kg mol^-1      |     0.0e+00|
|Molar Mass Of Carbon-12                                 |  1.200000e-02|kg mol^-1      |     0.0e+00|
|Molar Planck Constant                                   |  3.990313e-10|J s mol^-1     |     1.8e-19|
|Molar Planck Constant Times C                           |  1.196266e-01|J m mol^-1     |     5.4e-11|
|Molar Volume Of Ideal Gas (273.15 K, 100 Kpa)           |  2.271095e-02|m^3 mol^-1     |     1.3e-08|
|Molar Volume Of Ideal Gas (273.15 K, 101.325 Kpa)       |  2.241396e-02|m^3 mol^-1     |     1.3e-08|
|Molar Volume Of Silicon                                 |  1.205883e-05|m^3 mol^-1     |     6.1e-13|
|Mo X Unit                                               |  1.002100e-13|m              |     5.3e-20|
|Muon Compton Wavelength                                 |  1.173444e-14|m              |     2.6e-22|
|Muon Compton Wavelength Over 2 Pi                       |  1.867594e-15|m              |     4.2e-23|
|Muon-electron Mass Ratio                                |  2.067683e+02|               |     4.6e-06|
|Muon G Factor                                           | -2.002332e+00|               |     1.3e-09|
|Muon Mag. Mom.                                          | -4.490448e-26|J T^-1         |     1.0e-33|
|Muon Mag. Mom. Anomaly                                  |  1.165921e-03|               |     6.3e-10|
|Muon Mag. Mom. To Bohr Magneton Ratio                   | -4.841970e-03|               |     1.1e-10|
|Muon Mag. Mom. To Nuclear Magneton Ratio                | -8.890597e+00|               |     2.0e-07|
|Muon Mass                                               |  1.883532e-28|kg             |     4.8e-36|
|Muon Mass Energy Equivalent                             |  1.692834e-11|J              |     4.3e-19|
|Muon Mass Energy Equivalent In Mev                      |  1.056584e+02|MeV            |     2.4e-06|
|Muon Mass In U                                          |  1.134289e-01|u              |     2.5e-09|
|Muon Molar Mass                                         |  1.134289e-04|kg mol^-1      |     2.5e-12|
|Muon-neutron Mass Ratio                                 |  1.124545e-01|               |     2.5e-09|
|Muon-proton Mag. Mom. Ratio                             | -3.183345e+00|               |     7.1e-08|
|Muon-proton Mass Ratio                                  |  1.126095e-01|               |     2.5e-09|
|Muon-tau Mass Ratio                                     |  5.946490e-02|               |     5.4e-06|
|Natural Unit Of Action                                  |  1.054572e-34|J s            |     1.3e-42|
|Natural Unit Of Action In Ev S                          |  6.582120e-16|eV s           |     4.0e-24|
|Natural Unit Of Energy                                  |  8.187106e-14|J              |     1.0e-21|
|Natural Unit Of Energy In Mev                           |  5.109989e-01|MeV            |     3.1e-09|
|Natural Unit Of Length                                  |  3.861593e-13|m              |     1.8e-22|
|Natural Unit Of Mass                                    |  9.109384e-31|kg             |     1.1e-38|
|Natural Unit Of Mom.Um                                  |  2.730924e-22|kg m s^-1      |     3.4e-30|
|Natural Unit Of Mom.Um In Mev/c                         |  5.109989e-01|MeV/c          |     3.1e-09|
|Natural Unit Of Time                                    |  1.288089e-21|s              |     5.8e-31|
|Natural Unit Of Velocity                                |  2.997925e+08|m s^-1         |     0.0e+00|
|Neutron Compton Wavelength                              |  1.319591e-15|m              |     8.8e-25|
|Neutron Compton Wavelength Over 2 Pi                    |  2.100194e-16|m              |     1.4e-25|
|Neutron-electron Mag. Mom. Ratio                        |  1.040669e-03|               |     2.5e-10|
|Neutron-electron Mass Ratio                             |  1.838684e+03|               |     9.0e-07|
|Neutron G Factor                                        | -3.826085e+00|               |     9.0e-07|
|Neutron Gyromag. Ratio                                  |  1.832472e+08|s^-1 T^-1      |     4.3e+01|
|Neutron Gyromag. Ratio Over 2 Pi                        |  2.916469e+01|MHz T^-1       |     6.9e-06|
|Neutron Mag. Mom.                                       | -9.662365e-27|J T^-1         |     2.3e-33|
|Neutron Mag. Mom. To Bohr Magneton Ratio                | -1.041876e-03|               |     2.5e-10|
|Neutron Mag. Mom. To Nuclear Magneton Ratio             | -1.913043e+00|               |     4.5e-07|
|Neutron Mass                                            |  1.674927e-27|kg             |     2.1e-35|
|Neutron Mass Energy Equivalent                          |  1.505350e-10|J              |     1.9e-18|
|Neutron Mass Energy Equivalent In Mev                   |  9.395654e+02|MeV            |     5.8e-06|
|Neutron Mass In U                                       |  1.008665e+00|u              |     4.9e-10|
|Neutron Molar Mass                                      |  1.008665e-03|kg mol^-1      |     4.9e-13|
|Neutron-muon Mass Ratio                                 |  8.892484e+00|               |     2.0e-07|
|Neutron-proton Mag. Mom. Ratio                          | -6.849793e-01|               |     1.6e-07|
|Neutron-proton Mass Difference                          |  2.305574e-30|               |     8.5e-37|
|Neutron-proton Mass Difference Energy Equivalent        |  2.072146e-13|               |     7.6e-20|
|Neutron-proton Mass Difference Energy Equivalent In Mev |  1.293332e+00|               |     4.8e-07|
|Neutron-proton Mass Difference In U                     |  1.388449e-03|               |     5.1e-10|
|Neutron-proton Mass Ratio                               |  1.001378e+00|               |     5.1e-10|
|Neutron-tau Mass Ratio                                  |  5.287900e-01|               |     4.8e-05|
|Neutron To Shielded Proton Mag. Mom. Ratio              | -6.849969e-01|               |     1.6e-07|
|Newtonian Constant Of Gravitation                       |  6.674080e-11|m^3 kg^-1 s^-2 |     3.1e-15|
|Newtonian Constant Of Gravitation Over H-bar C          |  6.708610e-39|(GeV/c^2)^-2   |     3.1e-43|
|Nuclear Magneton                                        |  5.050784e-27|J T^-1         |     3.1e-35|
|Nuclear Magneton In Ev/t                                |  3.152451e-08|eV T^-1        |     1.5e-17|
|Nuclear Magneton In Inverse Meters Per Tesla            |  2.542623e-02|m^-1 T^-1      |     1.6e-10|
|Nuclear Magneton In K/t                                 |  3.658269e-04|K T^-1         |     2.1e-10|
|Nuclear Magneton In Mhz/t                               |  7.622593e+00|MHz T^-1       |     4.7e-08|
|Planck Constant                                         |  6.626070e-34|J s            |     8.1e-42|
|Planck Constant In Ev S                                 |  4.135668e-15|eV s           |     2.5e-23|
|Planck Constant Over 2 Pi                               |  1.054572e-34|J s            |     1.3e-42|
|Planck Constant Over 2 Pi In Ev S                       |  6.582120e-16|eV s           |     4.0e-24|
|Planck Constant Over 2 Pi Times C In Mev Fm             |  1.973270e+02|MeV fm         |     1.2e-06|
|Planck Length                                           |  1.616229e-35|m              |     3.8e-40|
|Planck Mass                                             |  2.176470e-08|kg             |     5.1e-13|
|Planck Mass Energy Equivalent In Gev                    |  1.220910e+19|GeV            |     2.9e+14|
|Planck Temperature                                      |  1.416808e+32|K              |     3.3e+27|
|Planck Time                                             |  5.391160e-44|s              |     1.3e-48|
|Proton Charge To Mass Quotient                          |  9.578833e+07|C kg^-1        |     5.9e-01|
|Proton Compton Wavelength                               |  1.321410e-15|m              |     6.1e-25|
|Proton Compton Wavelength Over 2 Pi                     |  2.103089e-16|m              |     9.7e-26|
|Proton-electron Mass Ratio                              |  1.836153e+03|               |     1.7e-07|
|Proton G Factor                                         |  5.585695e+00|               |     1.7e-08|
|Proton Gyromag. Ratio                                   |  2.675222e+08|s^-1 T^-1      |     1.8e+00|
|Proton Gyromag. Ratio Over 2 Pi                         |  4.257748e+01|MHz T^-1       |     2.9e-07|
|Proton Mag. Mom.                                        |  1.410607e-26|J T^-1         |     9.7e-35|
|Proton Mag. Mom. To Bohr Magneton Ratio                 |  1.521032e-03|               |     4.6e-12|
|Proton Mag. Mom. To Nuclear Magneton Ratio              |  2.792847e+00|               |     8.5e-09|
|Proton Mag. Shielding Correction                        |  2.569100e-05|               |     1.1e-08|
|Proton Mass                                             |  1.672622e-27|kg             |     2.1e-35|
|Proton Mass Energy Equivalent                           |  1.503278e-10|J              |     1.8e-18|
|Proton Mass Energy Equivalent In Mev                    |  9.382721e+02|MeV            |     5.8e-06|
|Proton Mass In U                                        |  1.007276e+00|u              |     9.1e-11|
|Proton Molar Mass                                       |  1.007276e-03|kg mol^-1      |     9.1e-14|
|Proton-muon Mass Ratio                                  |  8.880243e+00|               |     2.0e-07|
|Proton-neutron Mag. Mom. Ratio                          | -1.459898e+00|               |     3.4e-07|
|Proton-neutron Mass Ratio                               |  9.986235e-01|               |     5.1e-10|
|Proton Rms Charge Radius                                |  8.751000e-16|m              |     6.1e-18|
|Proton-tau Mass Ratio                                   |  5.280630e-01|               |     4.8e-05|
|Quantum Of Circulation                                  |  3.636948e-04|m^2 s^-1       |     1.7e-13|
|Quantum Of Circulation Times 2                          |  7.273895e-04|m^2 s^-1       |     3.3e-13|
|Rydberg Constant                                        |  1.097373e+07|m^-1           |     6.5e-05|
|Rydberg Constant Times C In Hz                          |  3.289842e+15|Hz             |     1.9e+04|
|Rydberg Constant Times Hc In Ev                         |  1.360569e+01|eV             |     8.4e-08|
|Rydberg Constant Times Hc In J                          |  2.179872e-18|J              |     2.7e-26|
|Sackur-tetrode Constant (1 K, 100 Kpa)                  | -1.151708e+00|               |     1.4e-06|
|Sackur-tetrode Constant (1 K, 101.325 Kpa)              | -1.164871e+00|               |     1.4e-06|
|Second Radiation Constant                               |  1.438777e-02|m K            |     8.3e-09|
|Shielded Helion Gyromag. Ratio                          |  2.037895e+08|s^-1 T^-1      |     2.7e+00|
|Shielded Helion Gyromag. Ratio Over 2 Pi                |  3.243410e+01|MHz T^-1       |     4.3e-07|
|Shielded Helion Mag. Mom.                               | -1.074553e-26|J T^-1         |     1.4e-34|
|Shielded Helion Mag. Mom. To Bohr Magneton Ratio        | -1.158671e-03|               |     1.4e-11|
|Shielded Helion Mag. Mom. To Nuclear Magneton Ratio     | -2.127498e+00|               |     2.5e-08|
|Shielded Helion To Proton Mag. Mom. Ratio               | -7.617666e-01|               |     9.2e-09|
|Shielded Helion To Shielded Proton Mag. Mom. Ratio      | -7.617861e-01|               |     3.3e-09|
|Shielded Proton Gyromag. Ratio                          |  2.675153e+08|s^-1 T^-1      |     3.3e+00|
|Shielded Proton Gyromag. Ratio Over 2 Pi                |  4.257639e+01|MHz T^-1       |     5.3e-07|
|Shielded Proton Mag. Mom.                               |  1.410571e-26|J T^-1         |     1.8e-34|
|Shielded Proton Mag. Mom. To Bohr Magneton Ratio        |  1.520993e-03|               |     1.7e-11|
|Shielded Proton Mag. Mom. To Nuclear Magneton Ratio     |  2.792776e+00|               |     3.0e-08|
|Speed Of Light In Vacuum                                |  2.997925e+08|m s^-1         |     0.0e+00|
|Standard Acceleration Of Gravity                        |  9.806650e+00|m s^-2         |     0.0e+00|
|Standard Atmosphere                                     |  1.013250e+05|Pa             |     0.0e+00|
|Standard-state Pressure                                 |  1.000000e+05|Pa             |     0.0e+00|
|Stefan-boltzmann Constant                               |  5.670367e-08|W m^-2 K^-4    |     1.3e-13|
|Tau Compton Wavelength                                  |  6.977870e-16|m              |     6.3e-20|
|Tau Compton Wavelength Over 2 Pi                        |  1.110560e-16|m              |     1.0e-20|
|Tau-electron Mass Ratio                                 |  3.477150e+03|               |     3.1e-01|
|Tau Mass                                                |  3.167470e-27|kg             |     2.9e-31|
|Tau Mass Energy Equivalent                              |  2.846780e-10|J              |     2.6e-14|
|Tau Mass Energy Equivalent In Mev                       |  1.776820e+03|MeV            |     1.6e-01|
|Tau Mass In U                                           |  1.907490e+00|u              |     1.7e-04|
|Tau Molar Mass                                          |  1.907490e-03|kg mol^-1      |     1.7e-07|
|Tau-muon Mass Ratio                                     |  1.681670e+01|               |     1.5e-03|
|Tau-neutron Mass Ratio                                  |  1.891110e+00|               |     1.7e-04|
|Tau-proton Mass Ratio                                   |  1.893720e+00|               |     1.7e-04|
|Thomson Cross Section                                   |  6.652459e-29|m^2            |     9.1e-38|
|Triton-electron Mass Ratio                              |  5.496922e+03|               |     2.6e-07|
|Triton G Factor                                         |  5.957925e+00|               |     2.8e-08|
|Triton Mag. Mom.                                        |  1.504610e-26|J T^-1         |     1.2e-34|
|Triton Mag. Mom. To Bohr Magneton Ratio                 |  1.622394e-03|               |     7.6e-12|
|Triton Mag. Mom. To Nuclear Magneton Ratio              |  2.978962e+00|               |     1.4e-08|
|Triton Mass                                             |  5.007357e-27|kg             |     6.2e-35|
|Triton Mass Energy Equivalent                           |  4.500388e-10|J              |     5.5e-18|
|Triton Mass Energy Equivalent In Mev                    |  2.808921e+03|MeV            |     1.7e-05|
|Triton Mass In U                                        |  3.015501e+00|u              |     1.1e-10|
|Triton Molar Mass                                       |  3.015501e-03|kg mol^-1      |     1.1e-13|
|Triton-proton Mass Ratio                                |  2.993717e+00|               |     2.2e-10|
|Unified Atomic Mass Unit                                |  1.660539e-27|kg             |     2.0e-35|
|Von Klitzing Constant                                   |  2.581281e+04|ohm            |     5.9e-06|
|Weak Mixing Angle                                       |  2.223000e-01|               |     2.1e-03|
|Wien Frequency Displacement Law Constant                |  5.878924e+10|Hz K^-1        |     3.4e+04|
|Wien Wavelength Displacement Law Constant               |  2.897773e-03|m K            |     1.7e-09|
