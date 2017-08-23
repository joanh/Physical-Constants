Fundamental Physical Constants
================

Just a bit of gymnastics on data collation, R and Knitr to get the most exact available values of the [physical constants](https://en.wikipedia.org/wiki/Physical_constant).

Data source:
------------

**Fundamental Physical Constants --- Complete Listing** from the [NIST reference on Constants, Units, and Uncertainity](https://physics.nist.gov/cuu/Constants/index.html). Via [the raw ASCII data](http://physics.nist.gov/cuu/Constants/Table/allascii.txt) edited through [Open Refine](http://openrefine.org/) to get [this csv file](https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv), and then the few chunks of **R** code shown below.

Code
----

``` r
knitr::opts_chunk$set(echo = TRUE)
```

``` r
library(knitr)
library(stringr)
library(ggplot2)
```

First we import the csv file from the [github repository](https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv)

``` r
GH_url <- "https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv"
PhysicalConstants <- read.csv(GH_url, header = TRUE, sep = ",",dec = ".")
```

You can do it from your local computer too after downloading the file "[Fundamental-Physical-Constants.csv](https://raw.githubusercontent.com/joanh/Physical-Constants/master/Fundamental-Physical-Constants.csv)" through '[read.table](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/read.table.html)' command:

``` r
# PhysicalConstants <- read.table("~/R/Physical Constants/Fundamental-Physical-Constants.csv",
# header = TRUE, sep = ",",dec = ".")
```

Then you need remove the spaces from "Value" and "Uncertainty" text columns:

``` r
PhysicalConstants$Value <- str_replace_all(PhysicalConstants$Value, fixed(" "), "")
PhysicalConstants$Uncertainty <- str_replace_all(PhysicalConstants$Uncertainty, fixed(" "), "")
```

and fit the residual characters coming from exact values:

``` r
PhysicalConstants$Value <- str_replace_all(PhysicalConstants$Value, fixed("..."), "")
PhysicalConstants$Uncertainty <- str_replace_all(PhysicalConstants$Uncertainty, fixed("(exact)"), "0.0")
```

You can now convert strings to numeric (scientific notation):

``` r
PhysicalConstants$Value <- as.numeric(PhysicalConstants$Value)
PhysicalConstants$Uncertainty <- as.numeric(PhysicalConstants$Uncertainty)
```

Order of magnitude histogram
----------------------------

Just a quick graphical test in order to check everything went right, a histogram made from the count of values of the base 10 logarithm of the absolute value of each physical constant, in other words, the exponent of the constant, i.e. its *order of magnitude*.

``` r
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

![](README_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-1.png)

Table
-----

And finally a quick table (pending to take a look to the R interface to the JavaScript library suggested [here](https://stackoverflow.com/questions/27120002/is-it-possible-to-have-sortableinteractive-table-in-rmarkdown). Start [here](http://rstudio.github.io/DT/)).

Note tha we have to setup the `digits` value because by default number is truncated to 7 decimal places (**[yihui](https://github.com/yihui)** himself explain it in [this issue thread](https://github.com/yihui/knitr/issues/1187)), and we can see in the above histogram we need about 70 to cover smallest constants.

``` r
kable(PhysicalConstants,format = "markdown", digits = 70)
```

<table style="width:100%;">
<colgroup>
<col width="56%" />
<col width="14%" />
<col width="15%" />
<col width="12%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Quantity</th>
<th align="right">Value</th>
<th align="left">Unit</th>
<th align="right">Uncertainty</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">{220} Lattice Spacing Of Silicon</td>
<td align="right">1.920156e-10</td>
<td align="left">m</td>
<td align="right">3.2e-18</td>
</tr>
<tr class="even">
<td align="left">Alpha Particle-electron Mass Ratio</td>
<td align="right">7.294300e+03</td>
<td align="left"></td>
<td align="right">2.4e-07</td>
</tr>
<tr class="odd">
<td align="left">Alpha Particle Mass</td>
<td align="right">6.644657e-27</td>
<td align="left">kg</td>
<td align="right">8.2e-35</td>
</tr>
<tr class="even">
<td align="left">Alpha Particle Mass Energy Equivalent</td>
<td align="right">5.971920e-10</td>
<td align="left">J</td>
<td align="right">7.3e-18</td>
</tr>
<tr class="odd">
<td align="left">Alpha Particle Mass Energy Equivalent In Mev</td>
<td align="right">3.727379e+03</td>
<td align="left">MeV</td>
<td align="right">2.3e-05</td>
</tr>
<tr class="even">
<td align="left">Alpha Particle Mass In U</td>
<td align="right">4.001506e+00</td>
<td align="left">u</td>
<td align="right">6.3e-11</td>
</tr>
<tr class="odd">
<td align="left">Alpha Particle Molar Mass</td>
<td align="right">4.001506e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">6.3e-14</td>
</tr>
<tr class="even">
<td align="left">Alpha Particle-proton Mass Ratio</td>
<td align="right">3.972600e+00</td>
<td align="left"></td>
<td align="right">3.6e-10</td>
</tr>
<tr class="odd">
<td align="left">Angstrom Star</td>
<td align="right">1.000015e-10</td>
<td align="left">m</td>
<td align="right">9.0e-17</td>
</tr>
<tr class="even">
<td align="left">Atomic Mass Constant</td>
<td align="right">1.660539e-27</td>
<td align="left">kg</td>
<td align="right">2.0e-35</td>
</tr>
<tr class="odd">
<td align="left">Atomic Mass Constant Energy Equivalent</td>
<td align="right">1.492418e-10</td>
<td align="left">J</td>
<td align="right">1.8e-18</td>
</tr>
<tr class="even">
<td align="left">Atomic Mass Constant Energy Equivalent In Mev</td>
<td align="right">9.314941e+02</td>
<td align="left">MeV</td>
<td align="right">5.7e-06</td>
</tr>
<tr class="odd">
<td align="left">Atomic Mass Unit-electron Volt Relationship</td>
<td align="right">9.314941e+08</td>
<td align="left">eV</td>
<td align="right">5.7e+00</td>
</tr>
<tr class="even">
<td align="left">Atomic Mass Unit-hartree Relationship</td>
<td align="right">3.423178e+07</td>
<td align="left">E_h</td>
<td align="right">1.6e-02</td>
</tr>
<tr class="odd">
<td align="left">Atomic Mass Unit-hertz Relationship</td>
<td align="right">2.252343e+23</td>
<td align="left">Hz</td>
<td align="right">1.0e+14</td>
</tr>
<tr class="even">
<td align="left">Atomic Mass Unit-inverse Meter Relationship</td>
<td align="right">7.513007e+14</td>
<td align="left">m^-1</td>
<td align="right">3.4e+05</td>
</tr>
<tr class="odd">
<td align="left">Atomic Mass Unit-joule Relationship</td>
<td align="right">1.492418e-10</td>
<td align="left">J</td>
<td align="right">1.8e-18</td>
</tr>
<tr class="even">
<td align="left">Atomic Mass Unit-kelvin Relationship</td>
<td align="right">1.080954e+13</td>
<td align="left">K</td>
<td align="right">6.2e+06</td>
</tr>
<tr class="odd">
<td align="left">Atomic Mass Unit-kilogram Relationship</td>
<td align="right">1.660539e-27</td>
<td align="left">kg</td>
<td align="right">2.0e-35</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of 1st Hyperpolarizability</td>
<td align="right">3.206361e-53</td>
<td align="left">C^3 m^3 J^-2</td>
<td align="right">2.0e-61</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of 2nd Hyperpolarizability</td>
<td align="right">6.235380e-65</td>
<td align="left">C^4 m^4 J^-3</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Action</td>
<td align="right">1.054572e-34</td>
<td align="left">J s</td>
<td align="right">1.3e-42</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Charge</td>
<td align="right">1.602177e-19</td>
<td align="left">C</td>
<td align="right">9.8e-28</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Charge Density</td>
<td align="right">1.081202e+12</td>
<td align="left">C m^-3</td>
<td align="right">6.7e+03</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Current</td>
<td align="right">6.623618e-03</td>
<td align="left">A</td>
<td align="right">4.1e-11</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Electric Dipole Mom.</td>
<td align="right">8.478354e-30</td>
<td align="left">C m</td>
<td align="right">5.2e-38</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Electric Field</td>
<td align="right">5.142207e+11</td>
<td align="left">V m^-1</td>
<td align="right">3.2e+03</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Electric Field Gradient</td>
<td align="right">9.717362e+21</td>
<td align="left">V m^-2</td>
<td align="right">6.0e+13</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Electric Polarizability</td>
<td align="right">1.648777e-41</td>
<td align="left">C^2 m^2 J^-1</td>
<td align="right">1.1e-50</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Electric Potential</td>
<td align="right">2.721139e+01</td>
<td align="left">V</td>
<td align="right">1.7e-07</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Electric Quadrupole Mom.</td>
<td align="right">4.486551e-40</td>
<td align="left">C m^2</td>
<td align="right">2.8e-48</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Energy</td>
<td align="right">4.359745e-18</td>
<td align="left">J</td>
<td align="right">5.4e-26</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Force</td>
<td align="right">8.238723e-08</td>
<td align="left">N</td>
<td align="right">1.0e-15</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Length</td>
<td align="right">5.291772e-11</td>
<td align="left">m</td>
<td align="right">1.2e-20</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Mag. Dipole Mom.</td>
<td align="right">1.854802e-23</td>
<td align="left">J T^-1</td>
<td align="right">1.1e-31</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Mag. Flux Density</td>
<td align="right">2.350518e+05</td>
<td align="left">T</td>
<td align="right">1.4e-03</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Magnetizability</td>
<td align="right">7.891037e-29</td>
<td align="left">J T^-2</td>
<td align="right">9.0e-38</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Mass</td>
<td align="right">9.109384e-31</td>
<td align="left">kg</td>
<td align="right">1.1e-38</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Mom.Um</td>
<td align="right">1.992852e-24</td>
<td align="left">kg m s^-1</td>
<td align="right">2.4e-32</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Permittivity</td>
<td align="right">1.112650e-10</td>
<td align="left">F m^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Atomic Unit Of Time</td>
<td align="right">2.418884e-17</td>
<td align="left">s</td>
<td align="right">1.4e-28</td>
</tr>
<tr class="even">
<td align="left">Atomic Unit Of Velocity</td>
<td align="right">2.187691e+06</td>
<td align="left">m s^-1</td>
<td align="right">5.0e-04</td>
</tr>
<tr class="odd">
<td align="left">Avogadro Constant</td>
<td align="right">6.022141e+23</td>
<td align="left">mol^-1</td>
<td align="right">7.4e+15</td>
</tr>
<tr class="even">
<td align="left">Bohr Magneton</td>
<td align="right">9.274010e-24</td>
<td align="left">J T^-1</td>
<td align="right">5.7e-32</td>
</tr>
<tr class="odd">
<td align="left">Bohr Magneton In Ev/t</td>
<td align="right">5.788382e-05</td>
<td align="left">eV T^-1</td>
<td align="right">2.6e-14</td>
</tr>
<tr class="even">
<td align="left">Bohr Magneton In Hz/t</td>
<td align="right">1.399625e+10</td>
<td align="left">Hz T^-1</td>
<td align="right">8.6e+01</td>
</tr>
<tr class="odd">
<td align="left">Bohr Magneton In Inverse Meters Per Tesla</td>
<td align="right">4.668645e+01</td>
<td align="left">m^-1 T^-1</td>
<td align="right">2.9e-07</td>
</tr>
<tr class="even">
<td align="left">Bohr Magneton In K/t</td>
<td align="right">6.717140e-01</td>
<td align="left">K T^-1</td>
<td align="right">3.9e-07</td>
</tr>
<tr class="odd">
<td align="left">Bohr Radius</td>
<td align="right">5.291772e-11</td>
<td align="left">m</td>
<td align="right">1.2e-20</td>
</tr>
<tr class="even">
<td align="left">Boltzmann Constant</td>
<td align="right">1.380649e-23</td>
<td align="left">J K^-1</td>
<td align="right">7.9e-30</td>
</tr>
<tr class="odd">
<td align="left">Boltzmann Constant In Ev/k</td>
<td align="right">8.617330e-05</td>
<td align="left">eV K^-1</td>
<td align="right">5.0e-11</td>
</tr>
<tr class="even">
<td align="left">Boltzmann Constant In Hz/k</td>
<td align="right">2.083661e+10</td>
<td align="left">Hz K^-1</td>
<td align="right">1.2e+04</td>
</tr>
<tr class="odd">
<td align="left">Boltzmann Constant In Inverse Meters Per Kelvin</td>
<td align="right">6.950346e+01</td>
<td align="left">m^-1 K^-1</td>
<td align="right">4.0e-05</td>
</tr>
<tr class="even">
<td align="left">Characteristic Impedance Of Vacuum</td>
<td align="right">3.767303e+02</td>
<td align="left">ohm</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Classical Electron Radius</td>
<td align="right">2.817940e-15</td>
<td align="left">m</td>
<td align="right">1.9e-24</td>
</tr>
<tr class="even">
<td align="left">Compton Wavelength</td>
<td align="right">2.426310e-12</td>
<td align="left">m</td>
<td align="right">1.1e-21</td>
</tr>
<tr class="odd">
<td align="left">Compton Wavelength Over 2 Pi</td>
<td align="right">3.861593e-13</td>
<td align="left">m</td>
<td align="right">1.8e-22</td>
</tr>
<tr class="even">
<td align="left">Conductance Quantum</td>
<td align="right">7.748092e-05</td>
<td align="left">S</td>
<td align="right">1.8e-14</td>
</tr>
<tr class="odd">
<td align="left">Conventional Value Of Josephson Constant</td>
<td align="right">4.835979e+14</td>
<td align="left">Hz V^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Conventional Value Of Von Klitzing Constant</td>
<td align="right">2.581281e+04</td>
<td align="left">ohm</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Cu X Unit</td>
<td align="right">1.002077e-13</td>
<td align="left">m</td>
<td align="right">2.8e-20</td>
</tr>
<tr class="even">
<td align="left">Deuteron-electron Mag. Mom. Ratio</td>
<td align="right">-4.664346e-04</td>
<td align="left"></td>
<td align="right">2.6e-12</td>
</tr>
<tr class="odd">
<td align="left">Deuteron-electron Mass Ratio</td>
<td align="right">3.670483e+03</td>
<td align="left"></td>
<td align="right">1.3e-07</td>
</tr>
<tr class="even">
<td align="left">Deuteron G Factor</td>
<td align="right">8.574382e-01</td>
<td align="left"></td>
<td align="right">4.8e-09</td>
</tr>
<tr class="odd">
<td align="left">Deuteron Mag. Mom.</td>
<td align="right">4.330735e-27</td>
<td align="left">J T^-1</td>
<td align="right">3.6e-35</td>
</tr>
<tr class="even">
<td align="left">Deuteron Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">4.669755e-04</td>
<td align="left"></td>
<td align="right">2.6e-12</td>
</tr>
<tr class="odd">
<td align="left">Deuteron Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">8.574382e-01</td>
<td align="left"></td>
<td align="right">4.8e-09</td>
</tr>
<tr class="even">
<td align="left">Deuteron Mass</td>
<td align="right">3.343584e-27</td>
<td align="left">kg</td>
<td align="right">4.1e-35</td>
</tr>
<tr class="odd">
<td align="left">Deuteron Mass Energy Equivalent</td>
<td align="right">3.005063e-10</td>
<td align="left">J</td>
<td align="right">3.7e-18</td>
</tr>
<tr class="even">
<td align="left">Deuteron Mass Energy Equivalent In Mev</td>
<td align="right">1.875613e+03</td>
<td align="left">MeV</td>
<td align="right">1.2e-05</td>
</tr>
<tr class="odd">
<td align="left">Deuteron Mass In U</td>
<td align="right">2.013553e+00</td>
<td align="left">u</td>
<td align="right">4.0e-11</td>
</tr>
<tr class="even">
<td align="left">Deuteron Molar Mass</td>
<td align="right">2.013553e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">4.0e-14</td>
</tr>
<tr class="odd">
<td align="left">Deuteron-neutron Mag. Mom. Ratio</td>
<td align="right">-4.482065e-01</td>
<td align="left"></td>
<td align="right">1.1e-07</td>
</tr>
<tr class="even">
<td align="left">Deuteron-proton Mag. Mom. Ratio</td>
<td align="right">3.070122e-01</td>
<td align="left"></td>
<td align="right">1.5e-09</td>
</tr>
<tr class="odd">
<td align="left">Deuteron-proton Mass Ratio</td>
<td align="right">1.999008e+00</td>
<td align="left"></td>
<td align="right">1.9e-10</td>
</tr>
<tr class="even">
<td align="left">Deuteron Rms Charge Radius</td>
<td align="right">2.141300e-15</td>
<td align="left">m</td>
<td align="right">2.5e-18</td>
</tr>
<tr class="odd">
<td align="left">Electric Constant</td>
<td align="right">8.854188e-12</td>
<td align="left">F m^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Electron Charge To Mass Quotient</td>
<td align="right">-1.758820e+11</td>
<td align="left">C kg^-1</td>
<td align="right">1.1e+03</td>
</tr>
<tr class="odd">
<td align="left">Electron-deuteron Mag. Mom. Ratio</td>
<td align="right">-2.143923e+03</td>
<td align="left"></td>
<td align="right">1.2e-05</td>
</tr>
<tr class="even">
<td align="left">Electron-deuteron Mass Ratio</td>
<td align="right">2.724437e-04</td>
<td align="left"></td>
<td align="right">9.6e-15</td>
</tr>
<tr class="odd">
<td align="left">Electron G Factor</td>
<td align="right">-2.002319e+00</td>
<td align="left"></td>
<td align="right">5.2e-13</td>
</tr>
<tr class="even">
<td align="left">Electron Gyromag. Ratio</td>
<td align="right">1.760860e+11</td>
<td align="left">s^-1 T^-1</td>
<td align="right">1.1e+03</td>
</tr>
<tr class="odd">
<td align="left">Electron Gyromag. Ratio Over 2 Pi</td>
<td align="right">2.802495e+04</td>
<td align="left">MHz T^-1</td>
<td align="right">1.7e-04</td>
</tr>
<tr class="even">
<td align="left">Electron-helion Mass Ratio</td>
<td align="right">1.819543e-04</td>
<td align="left"></td>
<td align="right">8.8e-15</td>
</tr>
<tr class="odd">
<td align="left">Electron Mag. Mom.</td>
<td align="right">-9.284765e-24</td>
<td align="left">J T^-1</td>
<td align="right">5.7e-32</td>
</tr>
<tr class="even">
<td align="left">Electron Mag. Mom. Anomaly</td>
<td align="right">1.159652e-03</td>
<td align="left"></td>
<td align="right">2.6e-13</td>
</tr>
<tr class="odd">
<td align="left">Electron Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">-1.001160e+00</td>
<td align="left"></td>
<td align="right">2.6e-13</td>
</tr>
<tr class="even">
<td align="left">Electron Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">-1.838282e+03</td>
<td align="left"></td>
<td align="right">1.7e-07</td>
</tr>
<tr class="odd">
<td align="left">Electron Mass</td>
<td align="right">9.109384e-31</td>
<td align="left">kg</td>
<td align="right">1.1e-38</td>
</tr>
<tr class="even">
<td align="left">Electron Mass Energy Equivalent</td>
<td align="right">8.187106e-14</td>
<td align="left">J</td>
<td align="right">1.0e-21</td>
</tr>
<tr class="odd">
<td align="left">Electron Mass Energy Equivalent In Mev</td>
<td align="right">5.109989e-01</td>
<td align="left">MeV</td>
<td align="right">3.1e-09</td>
</tr>
<tr class="even">
<td align="left">Electron Mass In U</td>
<td align="right">5.485799e-04</td>
<td align="left">u</td>
<td align="right">1.6e-14</td>
</tr>
<tr class="odd">
<td align="left">Electron Molar Mass</td>
<td align="right">5.485799e-07</td>
<td align="left">kg mol^-1</td>
<td align="right">1.6e-17</td>
</tr>
<tr class="even">
<td align="left">Electron-muon Mag. Mom. Ratio</td>
<td align="right">2.067670e+02</td>
<td align="left"></td>
<td align="right">4.6e-06</td>
</tr>
<tr class="odd">
<td align="left">Electron-muon Mass Ratio</td>
<td align="right">4.836332e-03</td>
<td align="left"></td>
<td align="right">1.1e-10</td>
</tr>
<tr class="even">
<td align="left">Electron-neutron Mag. Mom. Ratio</td>
<td align="right">9.609205e+02</td>
<td align="left"></td>
<td align="right">2.3e-04</td>
</tr>
<tr class="odd">
<td align="left">Electron-neutron Mass Ratio</td>
<td align="right">5.438673e-04</td>
<td align="left"></td>
<td align="right">2.7e-13</td>
</tr>
<tr class="even">
<td align="left">Electron-proton Mag. Mom. Ratio</td>
<td align="right">-6.582107e+02</td>
<td align="left"></td>
<td align="right">2.0e-06</td>
</tr>
<tr class="odd">
<td align="left">Electron-proton Mass Ratio</td>
<td align="right">5.446170e-04</td>
<td align="left"></td>
<td align="right">5.2e-14</td>
</tr>
<tr class="even">
<td align="left">Electron-tau Mass Ratio</td>
<td align="right">2.875920e-04</td>
<td align="left"></td>
<td align="right">2.6e-08</td>
</tr>
<tr class="odd">
<td align="left">Electron To Alpha Particle Mass Ratio</td>
<td align="right">1.370934e-04</td>
<td align="left"></td>
<td align="right">4.5e-15</td>
</tr>
<tr class="even">
<td align="left">Electron To Shielded Helion Mag. Mom. Ratio</td>
<td align="right">8.640583e+02</td>
<td align="left"></td>
<td align="right">1.0e-05</td>
</tr>
<tr class="odd">
<td align="left">Electron To Shielded Proton Mag. Mom. Ratio</td>
<td align="right">-6.582276e+02</td>
<td align="left"></td>
<td align="right">7.2e-06</td>
</tr>
<tr class="even">
<td align="left">Electron-triton Mass Ratio</td>
<td align="right">1.819200e-04</td>
<td align="left"></td>
<td align="right">8.4e-15</td>
</tr>
<tr class="odd">
<td align="left">Electron Volt</td>
<td align="right">1.602177e-19</td>
<td align="left">J</td>
<td align="right">9.8e-28</td>
</tr>
<tr class="even">
<td align="left">Electron Volt-atomic Mass Unit Relationship</td>
<td align="right">1.073544e-09</td>
<td align="left">u</td>
<td align="right">6.6e-18</td>
</tr>
<tr class="odd">
<td align="left">Electron Volt-hartree Relationship</td>
<td align="right">3.674932e-02</td>
<td align="left">E_h</td>
<td align="right">2.3e-10</td>
</tr>
<tr class="even">
<td align="left">Electron Volt-hertz Relationship</td>
<td align="right">2.417989e+14</td>
<td align="left">Hz</td>
<td align="right">1.5e+06</td>
</tr>
<tr class="odd">
<td align="left">Electron Volt-inverse Meter Relationship</td>
<td align="right">8.065544e+05</td>
<td align="left">m^-1</td>
<td align="right">5.0e-03</td>
</tr>
<tr class="even">
<td align="left">Electron Volt-joule Relationship</td>
<td align="right">1.602177e-19</td>
<td align="left">J</td>
<td align="right">9.8e-28</td>
</tr>
<tr class="odd">
<td align="left">Electron Volt-kelvin Relationship</td>
<td align="right">1.160452e+04</td>
<td align="left">K</td>
<td align="right">6.7e-03</td>
</tr>
<tr class="even">
<td align="left">Electron Volt-kilogram Relationship</td>
<td align="right">1.782662e-36</td>
<td align="left">kg</td>
<td align="right">1.1e-44</td>
</tr>
<tr class="odd">
<td align="left">Elementary Charge</td>
<td align="right">1.602177e-19</td>
<td align="left">C</td>
<td align="right">9.8e-28</td>
</tr>
<tr class="even">
<td align="left">Elementary Charge Over H</td>
<td align="right">2.417989e+14</td>
<td align="left">A J^-1</td>
<td align="right">1.5e+06</td>
</tr>
<tr class="odd">
<td align="left">Faraday Constant</td>
<td align="right">9.648533e+04</td>
<td align="left">C mol^-1</td>
<td align="right">5.9e-04</td>
</tr>
<tr class="even">
<td align="left">Faraday Constant For Conventional Electric Current</td>
<td align="right">9.648533e+04</td>
<td align="left">C_90 mol^-1</td>
<td align="right">1.2e-03</td>
</tr>
<tr class="odd">
<td align="left">Fermi Coupling Constant</td>
<td align="right">1.166379e-05</td>
<td align="left">GeV^-2</td>
<td align="right">6.0e-12</td>
</tr>
<tr class="even">
<td align="left">Fine-structure Constant</td>
<td align="right">7.297353e-03</td>
<td align="left"></td>
<td align="right">1.7e-12</td>
</tr>
<tr class="odd">
<td align="left">First Radiation Constant</td>
<td align="right">3.741772e-16</td>
<td align="left">W m^2</td>
<td align="right">4.6e-24</td>
</tr>
<tr class="even">
<td align="left">First Radiation Constant For Spectral Radiance</td>
<td align="right">1.191043e-16</td>
<td align="left">W m^2 sr^-1</td>
<td align="right">1.5e-24</td>
</tr>
<tr class="odd">
<td align="left">Hartree-atomic Mass Unit Relationship</td>
<td align="right">2.921262e-08</td>
<td align="left">u</td>
<td align="right">1.3e-17</td>
</tr>
<tr class="even">
<td align="left">Hartree-electron Volt Relationship</td>
<td align="right">2.721139e+01</td>
<td align="left">eV</td>
<td align="right">1.7e-07</td>
</tr>
<tr class="odd">
<td align="left">Hartree Energy</td>
<td align="right">4.359745e-18</td>
<td align="left">J</td>
<td align="right">5.4e-26</td>
</tr>
<tr class="even">
<td align="left">Hartree Energy In Ev</td>
<td align="right">2.721139e+01</td>
<td align="left">eV</td>
<td align="right">1.7e-07</td>
</tr>
<tr class="odd">
<td align="left">Hartree-hertz Relationship</td>
<td align="right">6.579684e+15</td>
<td align="left">Hz</td>
<td align="right">3.9e+04</td>
</tr>
<tr class="even">
<td align="left">Hartree-inverse Meter Relationship</td>
<td align="right">2.194746e+07</td>
<td align="left">m^-1</td>
<td align="right">1.3e-04</td>
</tr>
<tr class="odd">
<td align="left">Hartree-joule Relationship</td>
<td align="right">4.359745e-18</td>
<td align="left">J</td>
<td align="right">5.4e-26</td>
</tr>
<tr class="even">
<td align="left">Hartree-kelvin Relationship</td>
<td align="right">3.157751e+05</td>
<td align="left">K</td>
<td align="right">1.8e-01</td>
</tr>
<tr class="odd">
<td align="left">Hartree-kilogram Relationship</td>
<td align="right">4.850870e-35</td>
<td align="left">kg</td>
<td align="right">6.0e-43</td>
</tr>
<tr class="even">
<td align="left">Helion-electron Mass Ratio</td>
<td align="right">5.495885e+03</td>
<td align="left"></td>
<td align="right">2.7e-07</td>
</tr>
<tr class="odd">
<td align="left">Helion G Factor</td>
<td align="right">-4.255251e+00</td>
<td align="left"></td>
<td align="right">5.0e-08</td>
</tr>
<tr class="even">
<td align="left">Helion Mag. Mom.</td>
<td align="right">-1.074618e-26</td>
<td align="left">J T^-1</td>
<td align="right">1.4e-34</td>
</tr>
<tr class="odd">
<td align="left">Helion Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">-1.158741e-03</td>
<td align="left"></td>
<td align="right">1.4e-11</td>
</tr>
<tr class="even">
<td align="left">Helion Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">-2.127625e+00</td>
<td align="left"></td>
<td align="right">2.5e-08</td>
</tr>
<tr class="odd">
<td align="left">Helion Mass</td>
<td align="right">5.006413e-27</td>
<td align="left">kg</td>
<td align="right">6.2e-35</td>
</tr>
<tr class="even">
<td align="left">Helion Mass Energy Equivalent</td>
<td align="right">4.499539e-10</td>
<td align="left">J</td>
<td align="right">5.5e-18</td>
</tr>
<tr class="odd">
<td align="left">Helion Mass Energy Equivalent In Mev</td>
<td align="right">2.808392e+03</td>
<td align="left">MeV</td>
<td align="right">1.7e-05</td>
</tr>
<tr class="even">
<td align="left">Helion Mass In U</td>
<td align="right">3.014932e+00</td>
<td align="left">u</td>
<td align="right">1.2e-10</td>
</tr>
<tr class="odd">
<td align="left">Helion Molar Mass</td>
<td align="right">3.014932e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">1.2e-13</td>
</tr>
<tr class="even">
<td align="left">Helion-proton Mass Ratio</td>
<td align="right">2.993153e+00</td>
<td align="left"></td>
<td align="right">2.9e-10</td>
</tr>
<tr class="odd">
<td align="left">Hertz-atomic Mass Unit Relationship</td>
<td align="right">4.439822e-24</td>
<td align="left">u</td>
<td align="right">2.0e-33</td>
</tr>
<tr class="even">
<td align="left">Hertz-electron Volt Relationship</td>
<td align="right">4.135668e-15</td>
<td align="left">eV</td>
<td align="right">2.5e-23</td>
</tr>
<tr class="odd">
<td align="left">Hertz-hartree Relationship</td>
<td align="right">1.519830e-16</td>
<td align="left">E_h</td>
<td align="right">9.0e-28</td>
</tr>
<tr class="even">
<td align="left">Hertz-inverse Meter Relationship</td>
<td align="right">3.335641e-09</td>
<td align="left">m^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Hertz-joule Relationship</td>
<td align="right">6.626070e-34</td>
<td align="left">J</td>
<td align="right">8.1e-42</td>
</tr>
<tr class="even">
<td align="left">Hertz-kelvin Relationship</td>
<td align="right">4.799245e-11</td>
<td align="left">K</td>
<td align="right">2.8e-17</td>
</tr>
<tr class="odd">
<td align="left">Hertz-kilogram Relationship</td>
<td align="right">7.372497e-51</td>
<td align="left">kg</td>
<td align="right">9.1e-59</td>
</tr>
<tr class="even">
<td align="left">Inverse Fine-structure Constant</td>
<td align="right">1.370360e+02</td>
<td align="left"></td>
<td align="right">3.1e-08</td>
</tr>
<tr class="odd">
<td align="left">Inverse Meter-atomic Mass Unit Relationship</td>
<td align="right">1.331025e-15</td>
<td align="left">u</td>
<td align="right">6.1e-25</td>
</tr>
<tr class="even">
<td align="left">Inverse Meter-electron Volt Relationship</td>
<td align="right">1.239842e-06</td>
<td align="left">eV</td>
<td align="right">7.6e-15</td>
</tr>
<tr class="odd">
<td align="left">Inverse Meter-hartree Relationship</td>
<td align="right">4.556335e-08</td>
<td align="left">E_h</td>
<td align="right">2.7e-19</td>
</tr>
<tr class="even">
<td align="left">Inverse Meter-hertz Relationship</td>
<td align="right">2.997925e+08</td>
<td align="left">Hz</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Inverse Meter-joule Relationship</td>
<td align="right">1.986446e-25</td>
<td align="left">J</td>
<td align="right">2.4e-33</td>
</tr>
<tr class="even">
<td align="left">Inverse Meter-kelvin Relationship</td>
<td align="right">1.438777e-02</td>
<td align="left">K</td>
<td align="right">8.3e-09</td>
</tr>
<tr class="odd">
<td align="left">Inverse Meter-kilogram Relationship</td>
<td align="right">2.210219e-42</td>
<td align="left">kg</td>
<td align="right">2.7e-50</td>
</tr>
<tr class="even">
<td align="left">Inverse Of Conductance Quantum</td>
<td align="right">1.290640e+04</td>
<td align="left">ohm</td>
<td align="right">2.9e-06</td>
</tr>
<tr class="odd">
<td align="left">Josephson Constant</td>
<td align="right">4.835979e+14</td>
<td align="left">Hz V^-1</td>
<td align="right">3.0e+06</td>
</tr>
<tr class="even">
<td align="left">Joule-atomic Mass Unit Relationship</td>
<td align="right">6.700535e+09</td>
<td align="left">u</td>
<td align="right">8.2e+01</td>
</tr>
<tr class="odd">
<td align="left">Joule-electron Volt Relationship</td>
<td align="right">6.241509e+18</td>
<td align="left">eV</td>
<td align="right">3.8e+10</td>
</tr>
<tr class="even">
<td align="left">Joule-hartree Relationship</td>
<td align="right">2.293712e+17</td>
<td align="left">E_h</td>
<td align="right">2.8e+09</td>
</tr>
<tr class="odd">
<td align="left">Joule-hertz Relationship</td>
<td align="right">1.509190e+33</td>
<td align="left">Hz</td>
<td align="right">1.9e+25</td>
</tr>
<tr class="even">
<td align="left">Joule-inverse Meter Relationship</td>
<td align="right">5.034117e+24</td>
<td align="left">m^-1</td>
<td align="right">6.2e+16</td>
</tr>
<tr class="odd">
<td align="left">Joule-kelvin Relationship</td>
<td align="right">7.242973e+22</td>
<td align="left">K</td>
<td align="right">4.2e+16</td>
</tr>
<tr class="even">
<td align="left">Joule-kilogram Relationship</td>
<td align="right">1.112650e-17</td>
<td align="left">kg</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Kelvin-atomic Mass Unit Relationship</td>
<td align="right">9.251084e-14</td>
<td align="left">u</td>
<td align="right">5.3e-20</td>
</tr>
<tr class="even">
<td align="left">Kelvin-electron Volt Relationship</td>
<td align="right">8.617330e-05</td>
<td align="left">eV</td>
<td align="right">5.0e-11</td>
</tr>
<tr class="odd">
<td align="left">Kelvin-hartree Relationship</td>
<td align="right">3.166811e-06</td>
<td align="left">E_h</td>
<td align="right">1.8e-12</td>
</tr>
<tr class="even">
<td align="left">Kelvin-hertz Relationship</td>
<td align="right">2.083661e+10</td>
<td align="left">Hz</td>
<td align="right">1.2e+04</td>
</tr>
<tr class="odd">
<td align="left">Kelvin-inverse Meter Relationship</td>
<td align="right">6.950346e+01</td>
<td align="left">m^-1</td>
<td align="right">4.0e-05</td>
</tr>
<tr class="even">
<td align="left">Kelvin-joule Relationship</td>
<td align="right">1.380649e-23</td>
<td align="left">J</td>
<td align="right">7.9e-30</td>
</tr>
<tr class="odd">
<td align="left">Kelvin-kilogram Relationship</td>
<td align="right">1.536179e-40</td>
<td align="left">kg</td>
<td align="right">8.8e-47</td>
</tr>
<tr class="even">
<td align="left">Kilogram-atomic Mass Unit Relationship</td>
<td align="right">6.022141e+26</td>
<td align="left">u</td>
<td align="right">7.4e+18</td>
</tr>
<tr class="odd">
<td align="left">Kilogram-electron Volt Relationship</td>
<td align="right">5.609589e+35</td>
<td align="left">eV</td>
<td align="right">3.4e+27</td>
</tr>
<tr class="even">
<td align="left">Kilogram-hartree Relationship</td>
<td align="right">2.061486e+34</td>
<td align="left">E_h</td>
<td align="right">2.5e+26</td>
</tr>
<tr class="odd">
<td align="left">Kilogram-hertz Relationship</td>
<td align="right">1.356393e+50</td>
<td align="left">Hz</td>
<td align="right">1.7e+42</td>
</tr>
<tr class="even">
<td align="left">Kilogram-inverse Meter Relationship</td>
<td align="right">4.524438e+41</td>
<td align="left">m^-1</td>
<td align="right">5.6e+33</td>
</tr>
<tr class="odd">
<td align="left">Kilogram-joule Relationship</td>
<td align="right">8.987552e+16</td>
<td align="left">J</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Kilogram-kelvin Relationship</td>
<td align="right">6.509660e+39</td>
<td align="left">K</td>
<td align="right">3.7e+33</td>
</tr>
<tr class="odd">
<td align="left">Lattice Parameter Of Silicon</td>
<td align="right">5.431021e-10</td>
<td align="left">m</td>
<td align="right">8.9e-18</td>
</tr>
<tr class="even">
<td align="left">Loschmidt Constant (273.15 K, 100 Kpa)</td>
<td align="right">2.651647e+25</td>
<td align="left">m^-3</td>
<td align="right">1.5e+19</td>
</tr>
<tr class="odd">
<td align="left">Loschmidt Constant (273.15 K, 101.325 Kpa)</td>
<td align="right">2.686781e+25</td>
<td align="left">m^-3</td>
<td align="right">1.5e+19</td>
</tr>
<tr class="even">
<td align="left">Mag. Constant</td>
<td align="right">1.256637e-06</td>
<td align="left">N A^-2</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Mag. Flux Quantum</td>
<td align="right">2.067834e-15</td>
<td align="left">Wb</td>
<td align="right">1.3e-23</td>
</tr>
<tr class="even">
<td align="left">Molar Gas Constant</td>
<td align="right">8.314460e+00</td>
<td align="left">J mol^-1 K^-1</td>
<td align="right">4.8e-06</td>
</tr>
<tr class="odd">
<td align="left">Molar Mass Constant</td>
<td align="right">1.000000e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Molar Mass Of Carbon-12</td>
<td align="right">1.200000e-02</td>
<td align="left">kg mol^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Molar Planck Constant</td>
<td align="right">3.990313e-10</td>
<td align="left">J s mol^-1</td>
<td align="right">1.8e-19</td>
</tr>
<tr class="even">
<td align="left">Molar Planck Constant Times C</td>
<td align="right">1.196266e-01</td>
<td align="left">J m mol^-1</td>
<td align="right">5.4e-11</td>
</tr>
<tr class="odd">
<td align="left">Molar Volume Of Ideal Gas (273.15 K, 100 Kpa)</td>
<td align="right">2.271095e-02</td>
<td align="left">m^3 mol^-1</td>
<td align="right">1.3e-08</td>
</tr>
<tr class="even">
<td align="left">Molar Volume Of Ideal Gas (273.15 K, 101.325 Kpa)</td>
<td align="right">2.241396e-02</td>
<td align="left">m^3 mol^-1</td>
<td align="right">1.3e-08</td>
</tr>
<tr class="odd">
<td align="left">Molar Volume Of Silicon</td>
<td align="right">1.205883e-05</td>
<td align="left">m^3 mol^-1</td>
<td align="right">6.1e-13</td>
</tr>
<tr class="even">
<td align="left">Mo X Unit</td>
<td align="right">1.002100e-13</td>
<td align="left">m</td>
<td align="right">5.3e-20</td>
</tr>
<tr class="odd">
<td align="left">Muon Compton Wavelength</td>
<td align="right">1.173444e-14</td>
<td align="left">m</td>
<td align="right">2.6e-22</td>
</tr>
<tr class="even">
<td align="left">Muon Compton Wavelength Over 2 Pi</td>
<td align="right">1.867594e-15</td>
<td align="left">m</td>
<td align="right">4.2e-23</td>
</tr>
<tr class="odd">
<td align="left">Muon-electron Mass Ratio</td>
<td align="right">2.067683e+02</td>
<td align="left"></td>
<td align="right">4.6e-06</td>
</tr>
<tr class="even">
<td align="left">Muon G Factor</td>
<td align="right">-2.002332e+00</td>
<td align="left"></td>
<td align="right">1.3e-09</td>
</tr>
<tr class="odd">
<td align="left">Muon Mag. Mom.</td>
<td align="right">-4.490448e-26</td>
<td align="left">J T^-1</td>
<td align="right">1.0e-33</td>
</tr>
<tr class="even">
<td align="left">Muon Mag. Mom. Anomaly</td>
<td align="right">1.165921e-03</td>
<td align="left"></td>
<td align="right">6.3e-10</td>
</tr>
<tr class="odd">
<td align="left">Muon Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">-4.841970e-03</td>
<td align="left"></td>
<td align="right">1.1e-10</td>
</tr>
<tr class="even">
<td align="left">Muon Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">-8.890597e+00</td>
<td align="left"></td>
<td align="right">2.0e-07</td>
</tr>
<tr class="odd">
<td align="left">Muon Mass</td>
<td align="right">1.883532e-28</td>
<td align="left">kg</td>
<td align="right">4.8e-36</td>
</tr>
<tr class="even">
<td align="left">Muon Mass Energy Equivalent</td>
<td align="right">1.692834e-11</td>
<td align="left">J</td>
<td align="right">4.3e-19</td>
</tr>
<tr class="odd">
<td align="left">Muon Mass Energy Equivalent In Mev</td>
<td align="right">1.056584e+02</td>
<td align="left">MeV</td>
<td align="right">2.4e-06</td>
</tr>
<tr class="even">
<td align="left">Muon Mass In U</td>
<td align="right">1.134289e-01</td>
<td align="left">u</td>
<td align="right">2.5e-09</td>
</tr>
<tr class="odd">
<td align="left">Muon Molar Mass</td>
<td align="right">1.134289e-04</td>
<td align="left">kg mol^-1</td>
<td align="right">2.5e-12</td>
</tr>
<tr class="even">
<td align="left">Muon-neutron Mass Ratio</td>
<td align="right">1.124545e-01</td>
<td align="left"></td>
<td align="right">2.5e-09</td>
</tr>
<tr class="odd">
<td align="left">Muon-proton Mag. Mom. Ratio</td>
<td align="right">-3.183345e+00</td>
<td align="left"></td>
<td align="right">7.1e-08</td>
</tr>
<tr class="even">
<td align="left">Muon-proton Mass Ratio</td>
<td align="right">1.126095e-01</td>
<td align="left"></td>
<td align="right">2.5e-09</td>
</tr>
<tr class="odd">
<td align="left">Muon-tau Mass Ratio</td>
<td align="right">5.946490e-02</td>
<td align="left"></td>
<td align="right">5.4e-06</td>
</tr>
<tr class="even">
<td align="left">Natural Unit Of Action</td>
<td align="right">1.054572e-34</td>
<td align="left">J s</td>
<td align="right">1.3e-42</td>
</tr>
<tr class="odd">
<td align="left">Natural Unit Of Action In Ev S</td>
<td align="right">6.582120e-16</td>
<td align="left">eV s</td>
<td align="right">4.0e-24</td>
</tr>
<tr class="even">
<td align="left">Natural Unit Of Energy</td>
<td align="right">8.187106e-14</td>
<td align="left">J</td>
<td align="right">1.0e-21</td>
</tr>
<tr class="odd">
<td align="left">Natural Unit Of Energy In Mev</td>
<td align="right">5.109989e-01</td>
<td align="left">MeV</td>
<td align="right">3.1e-09</td>
</tr>
<tr class="even">
<td align="left">Natural Unit Of Length</td>
<td align="right">3.861593e-13</td>
<td align="left">m</td>
<td align="right">1.8e-22</td>
</tr>
<tr class="odd">
<td align="left">Natural Unit Of Mass</td>
<td align="right">9.109384e-31</td>
<td align="left">kg</td>
<td align="right">1.1e-38</td>
</tr>
<tr class="even">
<td align="left">Natural Unit Of Mom.Um</td>
<td align="right">2.730924e-22</td>
<td align="left">kg m s^-1</td>
<td align="right">3.4e-30</td>
</tr>
<tr class="odd">
<td align="left">Natural Unit Of Mom.Um In Mev/c</td>
<td align="right">5.109989e-01</td>
<td align="left">MeV/c</td>
<td align="right">3.1e-09</td>
</tr>
<tr class="even">
<td align="left">Natural Unit Of Time</td>
<td align="right">1.288089e-21</td>
<td align="left">s</td>
<td align="right">5.8e-31</td>
</tr>
<tr class="odd">
<td align="left">Natural Unit Of Velocity</td>
<td align="right">2.997925e+08</td>
<td align="left">m s^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Neutron Compton Wavelength</td>
<td align="right">1.319591e-15</td>
<td align="left">m</td>
<td align="right">8.8e-25</td>
</tr>
<tr class="odd">
<td align="left">Neutron Compton Wavelength Over 2 Pi</td>
<td align="right">2.100194e-16</td>
<td align="left">m</td>
<td align="right">1.4e-25</td>
</tr>
<tr class="even">
<td align="left">Neutron-electron Mag. Mom. Ratio</td>
<td align="right">1.040669e-03</td>
<td align="left"></td>
<td align="right">2.5e-10</td>
</tr>
<tr class="odd">
<td align="left">Neutron-electron Mass Ratio</td>
<td align="right">1.838684e+03</td>
<td align="left"></td>
<td align="right">9.0e-07</td>
</tr>
<tr class="even">
<td align="left">Neutron G Factor</td>
<td align="right">-3.826085e+00</td>
<td align="left"></td>
<td align="right">9.0e-07</td>
</tr>
<tr class="odd">
<td align="left">Neutron Gyromag. Ratio</td>
<td align="right">1.832472e+08</td>
<td align="left">s^-1 T^-1</td>
<td align="right">4.3e+01</td>
</tr>
<tr class="even">
<td align="left">Neutron Gyromag. Ratio Over 2 Pi</td>
<td align="right">2.916469e+01</td>
<td align="left">MHz T^-1</td>
<td align="right">6.9e-06</td>
</tr>
<tr class="odd">
<td align="left">Neutron Mag. Mom.</td>
<td align="right">-9.662365e-27</td>
<td align="left">J T^-1</td>
<td align="right">2.3e-33</td>
</tr>
<tr class="even">
<td align="left">Neutron Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">-1.041876e-03</td>
<td align="left"></td>
<td align="right">2.5e-10</td>
</tr>
<tr class="odd">
<td align="left">Neutron Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">-1.913043e+00</td>
<td align="left"></td>
<td align="right">4.5e-07</td>
</tr>
<tr class="even">
<td align="left">Neutron Mass</td>
<td align="right">1.674927e-27</td>
<td align="left">kg</td>
<td align="right">2.1e-35</td>
</tr>
<tr class="odd">
<td align="left">Neutron Mass Energy Equivalent</td>
<td align="right">1.505350e-10</td>
<td align="left">J</td>
<td align="right">1.9e-18</td>
</tr>
<tr class="even">
<td align="left">Neutron Mass Energy Equivalent In Mev</td>
<td align="right">9.395654e+02</td>
<td align="left">MeV</td>
<td align="right">5.8e-06</td>
</tr>
<tr class="odd">
<td align="left">Neutron Mass In U</td>
<td align="right">1.008665e+00</td>
<td align="left">u</td>
<td align="right">4.9e-10</td>
</tr>
<tr class="even">
<td align="left">Neutron Molar Mass</td>
<td align="right">1.008665e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">4.9e-13</td>
</tr>
<tr class="odd">
<td align="left">Neutron-muon Mass Ratio</td>
<td align="right">8.892484e+00</td>
<td align="left"></td>
<td align="right">2.0e-07</td>
</tr>
<tr class="even">
<td align="left">Neutron-proton Mag. Mom. Ratio</td>
<td align="right">-6.849793e-01</td>
<td align="left"></td>
<td align="right">1.6e-07</td>
</tr>
<tr class="odd">
<td align="left">Neutron-proton Mass Difference</td>
<td align="right">2.305574e-30</td>
<td align="left"></td>
<td align="right">8.5e-37</td>
</tr>
<tr class="even">
<td align="left">Neutron-proton Mass Difference Energy Equivalent</td>
<td align="right">2.072146e-13</td>
<td align="left"></td>
<td align="right">7.6e-20</td>
</tr>
<tr class="odd">
<td align="left">Neutron-proton Mass Difference Energy Equivalent In Mev</td>
<td align="right">1.293332e+00</td>
<td align="left"></td>
<td align="right">4.8e-07</td>
</tr>
<tr class="even">
<td align="left">Neutron-proton Mass Difference In U</td>
<td align="right">1.388449e-03</td>
<td align="left"></td>
<td align="right">5.1e-10</td>
</tr>
<tr class="odd">
<td align="left">Neutron-proton Mass Ratio</td>
<td align="right">1.001378e+00</td>
<td align="left"></td>
<td align="right">5.1e-10</td>
</tr>
<tr class="even">
<td align="left">Neutron-tau Mass Ratio</td>
<td align="right">5.287900e-01</td>
<td align="left"></td>
<td align="right">4.8e-05</td>
</tr>
<tr class="odd">
<td align="left">Neutron To Shielded Proton Mag. Mom. Ratio</td>
<td align="right">-6.849969e-01</td>
<td align="left"></td>
<td align="right">1.6e-07</td>
</tr>
<tr class="even">
<td align="left">Newtonian Constant Of Gravitation</td>
<td align="right">6.674080e-11</td>
<td align="left">m^3 kg^-1 s^-2</td>
<td align="right">3.1e-15</td>
</tr>
<tr class="odd">
<td align="left">Newtonian Constant Of Gravitation Over H-bar C</td>
<td align="right">6.708610e-39</td>
<td align="left">(GeV/c<sup>2)</sup>-2</td>
<td align="right">3.1e-43</td>
</tr>
<tr class="even">
<td align="left">Nuclear Magneton</td>
<td align="right">5.050784e-27</td>
<td align="left">J T^-1</td>
<td align="right">3.1e-35</td>
</tr>
<tr class="odd">
<td align="left">Nuclear Magneton In Ev/t</td>
<td align="right">3.152451e-08</td>
<td align="left">eV T^-1</td>
<td align="right">1.5e-17</td>
</tr>
<tr class="even">
<td align="left">Nuclear Magneton In Inverse Meters Per Tesla</td>
<td align="right">2.542623e-02</td>
<td align="left">m^-1 T^-1</td>
<td align="right">1.6e-10</td>
</tr>
<tr class="odd">
<td align="left">Nuclear Magneton In K/t</td>
<td align="right">3.658269e-04</td>
<td align="left">K T^-1</td>
<td align="right">2.1e-10</td>
</tr>
<tr class="even">
<td align="left">Nuclear Magneton In Mhz/t</td>
<td align="right">7.622593e+00</td>
<td align="left">MHz T^-1</td>
<td align="right">4.7e-08</td>
</tr>
<tr class="odd">
<td align="left">Planck Constant</td>
<td align="right">6.626070e-34</td>
<td align="left">J s</td>
<td align="right">8.1e-42</td>
</tr>
<tr class="even">
<td align="left">Planck Constant In Ev S</td>
<td align="right">4.135668e-15</td>
<td align="left">eV s</td>
<td align="right">2.5e-23</td>
</tr>
<tr class="odd">
<td align="left">Planck Constant Over 2 Pi</td>
<td align="right">1.054572e-34</td>
<td align="left">J s</td>
<td align="right">1.3e-42</td>
</tr>
<tr class="even">
<td align="left">Planck Constant Over 2 Pi In Ev S</td>
<td align="right">6.582120e-16</td>
<td align="left">eV s</td>
<td align="right">4.0e-24</td>
</tr>
<tr class="odd">
<td align="left">Planck Constant Over 2 Pi Times C In Mev Fm</td>
<td align="right">1.973270e+02</td>
<td align="left">MeV fm</td>
<td align="right">1.2e-06</td>
</tr>
<tr class="even">
<td align="left">Planck Length</td>
<td align="right">1.616229e-35</td>
<td align="left">m</td>
<td align="right">3.8e-40</td>
</tr>
<tr class="odd">
<td align="left">Planck Mass</td>
<td align="right">2.176470e-08</td>
<td align="left">kg</td>
<td align="right">5.1e-13</td>
</tr>
<tr class="even">
<td align="left">Planck Mass Energy Equivalent In Gev</td>
<td align="right">1.220910e+19</td>
<td align="left">GeV</td>
<td align="right">2.9e+14</td>
</tr>
<tr class="odd">
<td align="left">Planck Temperature</td>
<td align="right">1.416808e+32</td>
<td align="left">K</td>
<td align="right">3.3e+27</td>
</tr>
<tr class="even">
<td align="left">Planck Time</td>
<td align="right">5.391160e-44</td>
<td align="left">s</td>
<td align="right">1.3e-48</td>
</tr>
<tr class="odd">
<td align="left">Proton Charge To Mass Quotient</td>
<td align="right">9.578833e+07</td>
<td align="left">C kg^-1</td>
<td align="right">5.9e-01</td>
</tr>
<tr class="even">
<td align="left">Proton Compton Wavelength</td>
<td align="right">1.321410e-15</td>
<td align="left">m</td>
<td align="right">6.1e-25</td>
</tr>
<tr class="odd">
<td align="left">Proton Compton Wavelength Over 2 Pi</td>
<td align="right">2.103089e-16</td>
<td align="left">m</td>
<td align="right">9.7e-26</td>
</tr>
<tr class="even">
<td align="left">Proton-electron Mass Ratio</td>
<td align="right">1.836153e+03</td>
<td align="left"></td>
<td align="right">1.7e-07</td>
</tr>
<tr class="odd">
<td align="left">Proton G Factor</td>
<td align="right">5.585695e+00</td>
<td align="left"></td>
<td align="right">1.7e-08</td>
</tr>
<tr class="even">
<td align="left">Proton Gyromag. Ratio</td>
<td align="right">2.675222e+08</td>
<td align="left">s^-1 T^-1</td>
<td align="right">1.8e+00</td>
</tr>
<tr class="odd">
<td align="left">Proton Gyromag. Ratio Over 2 Pi</td>
<td align="right">4.257748e+01</td>
<td align="left">MHz T^-1</td>
<td align="right">2.9e-07</td>
</tr>
<tr class="even">
<td align="left">Proton Mag. Mom.</td>
<td align="right">1.410607e-26</td>
<td align="left">J T^-1</td>
<td align="right">9.7e-35</td>
</tr>
<tr class="odd">
<td align="left">Proton Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">1.521032e-03</td>
<td align="left"></td>
<td align="right">4.6e-12</td>
</tr>
<tr class="even">
<td align="left">Proton Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">2.792847e+00</td>
<td align="left"></td>
<td align="right">8.5e-09</td>
</tr>
<tr class="odd">
<td align="left">Proton Mag. Shielding Correction</td>
<td align="right">2.569100e-05</td>
<td align="left"></td>
<td align="right">1.1e-08</td>
</tr>
<tr class="even">
<td align="left">Proton Mass</td>
<td align="right">1.672622e-27</td>
<td align="left">kg</td>
<td align="right">2.1e-35</td>
</tr>
<tr class="odd">
<td align="left">Proton Mass Energy Equivalent</td>
<td align="right">1.503278e-10</td>
<td align="left">J</td>
<td align="right">1.8e-18</td>
</tr>
<tr class="even">
<td align="left">Proton Mass Energy Equivalent In Mev</td>
<td align="right">9.382721e+02</td>
<td align="left">MeV</td>
<td align="right">5.8e-06</td>
</tr>
<tr class="odd">
<td align="left">Proton Mass In U</td>
<td align="right">1.007276e+00</td>
<td align="left">u</td>
<td align="right">9.1e-11</td>
</tr>
<tr class="even">
<td align="left">Proton Molar Mass</td>
<td align="right">1.007276e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">9.1e-14</td>
</tr>
<tr class="odd">
<td align="left">Proton-muon Mass Ratio</td>
<td align="right">8.880243e+00</td>
<td align="left"></td>
<td align="right">2.0e-07</td>
</tr>
<tr class="even">
<td align="left">Proton-neutron Mag. Mom. Ratio</td>
<td align="right">-1.459898e+00</td>
<td align="left"></td>
<td align="right">3.4e-07</td>
</tr>
<tr class="odd">
<td align="left">Proton-neutron Mass Ratio</td>
<td align="right">9.986235e-01</td>
<td align="left"></td>
<td align="right">5.1e-10</td>
</tr>
<tr class="even">
<td align="left">Proton Rms Charge Radius</td>
<td align="right">8.751000e-16</td>
<td align="left">m</td>
<td align="right">6.1e-18</td>
</tr>
<tr class="odd">
<td align="left">Proton-tau Mass Ratio</td>
<td align="right">5.280630e-01</td>
<td align="left"></td>
<td align="right">4.8e-05</td>
</tr>
<tr class="even">
<td align="left">Quantum Of Circulation</td>
<td align="right">3.636948e-04</td>
<td align="left">m^2 s^-1</td>
<td align="right">1.7e-13</td>
</tr>
<tr class="odd">
<td align="left">Quantum Of Circulation Times 2</td>
<td align="right">7.273895e-04</td>
<td align="left">m^2 s^-1</td>
<td align="right">3.3e-13</td>
</tr>
<tr class="even">
<td align="left">Rydberg Constant</td>
<td align="right">1.097373e+07</td>
<td align="left">m^-1</td>
<td align="right">6.5e-05</td>
</tr>
<tr class="odd">
<td align="left">Rydberg Constant Times C In Hz</td>
<td align="right">3.289842e+15</td>
<td align="left">Hz</td>
<td align="right">1.9e+04</td>
</tr>
<tr class="even">
<td align="left">Rydberg Constant Times Hc In Ev</td>
<td align="right">1.360569e+01</td>
<td align="left">eV</td>
<td align="right">8.4e-08</td>
</tr>
<tr class="odd">
<td align="left">Rydberg Constant Times Hc In J</td>
<td align="right">2.179872e-18</td>
<td align="left">J</td>
<td align="right">2.7e-26</td>
</tr>
<tr class="even">
<td align="left">Sackur-tetrode Constant (1 K, 100 Kpa)</td>
<td align="right">-1.151708e+00</td>
<td align="left"></td>
<td align="right">1.4e-06</td>
</tr>
<tr class="odd">
<td align="left">Sackur-tetrode Constant (1 K, 101.325 Kpa)</td>
<td align="right">-1.164871e+00</td>
<td align="left"></td>
<td align="right">1.4e-06</td>
</tr>
<tr class="even">
<td align="left">Second Radiation Constant</td>
<td align="right">1.438777e-02</td>
<td align="left">m K</td>
<td align="right">8.3e-09</td>
</tr>
<tr class="odd">
<td align="left">Shielded Helion Gyromag. Ratio</td>
<td align="right">2.037895e+08</td>
<td align="left">s^-1 T^-1</td>
<td align="right">2.7e+00</td>
</tr>
<tr class="even">
<td align="left">Shielded Helion Gyromag. Ratio Over 2 Pi</td>
<td align="right">3.243410e+01</td>
<td align="left">MHz T^-1</td>
<td align="right">4.3e-07</td>
</tr>
<tr class="odd">
<td align="left">Shielded Helion Mag. Mom.</td>
<td align="right">-1.074553e-26</td>
<td align="left">J T^-1</td>
<td align="right">1.4e-34</td>
</tr>
<tr class="even">
<td align="left">Shielded Helion Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">-1.158671e-03</td>
<td align="left"></td>
<td align="right">1.4e-11</td>
</tr>
<tr class="odd">
<td align="left">Shielded Helion Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">-2.127498e+00</td>
<td align="left"></td>
<td align="right">2.5e-08</td>
</tr>
<tr class="even">
<td align="left">Shielded Helion To Proton Mag. Mom. Ratio</td>
<td align="right">-7.617666e-01</td>
<td align="left"></td>
<td align="right">9.2e-09</td>
</tr>
<tr class="odd">
<td align="left">Shielded Helion To Shielded Proton Mag. Mom. Ratio</td>
<td align="right">-7.617861e-01</td>
<td align="left"></td>
<td align="right">3.3e-09</td>
</tr>
<tr class="even">
<td align="left">Shielded Proton Gyromag. Ratio</td>
<td align="right">2.675153e+08</td>
<td align="left">s^-1 T^-1</td>
<td align="right">3.3e+00</td>
</tr>
<tr class="odd">
<td align="left">Shielded Proton Gyromag. Ratio Over 2 Pi</td>
<td align="right">4.257639e+01</td>
<td align="left">MHz T^-1</td>
<td align="right">5.3e-07</td>
</tr>
<tr class="even">
<td align="left">Shielded Proton Mag. Mom.</td>
<td align="right">1.410571e-26</td>
<td align="left">J T^-1</td>
<td align="right">1.8e-34</td>
</tr>
<tr class="odd">
<td align="left">Shielded Proton Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">1.520993e-03</td>
<td align="left"></td>
<td align="right">1.7e-11</td>
</tr>
<tr class="even">
<td align="left">Shielded Proton Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">2.792776e+00</td>
<td align="left"></td>
<td align="right">3.0e-08</td>
</tr>
<tr class="odd">
<td align="left">Speed Of Light In Vacuum</td>
<td align="right">2.997925e+08</td>
<td align="left">m s^-1</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Standard Acceleration Of Gravity</td>
<td align="right">9.806650e+00</td>
<td align="left">m s^-2</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Standard Atmosphere</td>
<td align="right">1.013250e+05</td>
<td align="left">Pa</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="even">
<td align="left">Standard-state Pressure</td>
<td align="right">1.000000e+05</td>
<td align="left">Pa</td>
<td align="right">0.0e+00</td>
</tr>
<tr class="odd">
<td align="left">Stefan-boltzmann Constant</td>
<td align="right">5.670367e-08</td>
<td align="left">W m^-2 K^-4</td>
<td align="right">1.3e-13</td>
</tr>
<tr class="even">
<td align="left">Tau Compton Wavelength</td>
<td align="right">6.977870e-16</td>
<td align="left">m</td>
<td align="right">6.3e-20</td>
</tr>
<tr class="odd">
<td align="left">Tau Compton Wavelength Over 2 Pi</td>
<td align="right">1.110560e-16</td>
<td align="left">m</td>
<td align="right">1.0e-20</td>
</tr>
<tr class="even">
<td align="left">Tau-electron Mass Ratio</td>
<td align="right">3.477150e+03</td>
<td align="left"></td>
<td align="right">3.1e-01</td>
</tr>
<tr class="odd">
<td align="left">Tau Mass</td>
<td align="right">3.167470e-27</td>
<td align="left">kg</td>
<td align="right">2.9e-31</td>
</tr>
<tr class="even">
<td align="left">Tau Mass Energy Equivalent</td>
<td align="right">2.846780e-10</td>
<td align="left">J</td>
<td align="right">2.6e-14</td>
</tr>
<tr class="odd">
<td align="left">Tau Mass Energy Equivalent In Mev</td>
<td align="right">1.776820e+03</td>
<td align="left">MeV</td>
<td align="right">1.6e-01</td>
</tr>
<tr class="even">
<td align="left">Tau Mass In U</td>
<td align="right">1.907490e+00</td>
<td align="left">u</td>
<td align="right">1.7e-04</td>
</tr>
<tr class="odd">
<td align="left">Tau Molar Mass</td>
<td align="right">1.907490e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">1.7e-07</td>
</tr>
<tr class="even">
<td align="left">Tau-muon Mass Ratio</td>
<td align="right">1.681670e+01</td>
<td align="left"></td>
<td align="right">1.5e-03</td>
</tr>
<tr class="odd">
<td align="left">Tau-neutron Mass Ratio</td>
<td align="right">1.891110e+00</td>
<td align="left"></td>
<td align="right">1.7e-04</td>
</tr>
<tr class="even">
<td align="left">Tau-proton Mass Ratio</td>
<td align="right">1.893720e+00</td>
<td align="left"></td>
<td align="right">1.7e-04</td>
</tr>
<tr class="odd">
<td align="left">Thomson Cross Section</td>
<td align="right">6.652459e-29</td>
<td align="left">m^2</td>
<td align="right">9.1e-38</td>
</tr>
<tr class="even">
<td align="left">Triton-electron Mass Ratio</td>
<td align="right">5.496922e+03</td>
<td align="left"></td>
<td align="right">2.6e-07</td>
</tr>
<tr class="odd">
<td align="left">Triton G Factor</td>
<td align="right">5.957925e+00</td>
<td align="left"></td>
<td align="right">2.8e-08</td>
</tr>
<tr class="even">
<td align="left">Triton Mag. Mom.</td>
<td align="right">1.504610e-26</td>
<td align="left">J T^-1</td>
<td align="right">1.2e-34</td>
</tr>
<tr class="odd">
<td align="left">Triton Mag. Mom. To Bohr Magneton Ratio</td>
<td align="right">1.622394e-03</td>
<td align="left"></td>
<td align="right">7.6e-12</td>
</tr>
<tr class="even">
<td align="left">Triton Mag. Mom. To Nuclear Magneton Ratio</td>
<td align="right">2.978962e+00</td>
<td align="left"></td>
<td align="right">1.4e-08</td>
</tr>
<tr class="odd">
<td align="left">Triton Mass</td>
<td align="right">5.007357e-27</td>
<td align="left">kg</td>
<td align="right">6.2e-35</td>
</tr>
<tr class="even">
<td align="left">Triton Mass Energy Equivalent</td>
<td align="right">4.500388e-10</td>
<td align="left">J</td>
<td align="right">5.5e-18</td>
</tr>
<tr class="odd">
<td align="left">Triton Mass Energy Equivalent In Mev</td>
<td align="right">2.808921e+03</td>
<td align="left">MeV</td>
<td align="right">1.7e-05</td>
</tr>
<tr class="even">
<td align="left">Triton Mass In U</td>
<td align="right">3.015501e+00</td>
<td align="left">u</td>
<td align="right">1.1e-10</td>
</tr>
<tr class="odd">
<td align="left">Triton Molar Mass</td>
<td align="right">3.015501e-03</td>
<td align="left">kg mol^-1</td>
<td align="right">1.1e-13</td>
</tr>
<tr class="even">
<td align="left">Triton-proton Mass Ratio</td>
<td align="right">2.993717e+00</td>
<td align="left"></td>
<td align="right">2.2e-10</td>
</tr>
<tr class="odd">
<td align="left">Unified Atomic Mass Unit</td>
<td align="right">1.660539e-27</td>
<td align="left">kg</td>
<td align="right">2.0e-35</td>
</tr>
<tr class="even">
<td align="left">Von Klitzing Constant</td>
<td align="right">2.581281e+04</td>
<td align="left">ohm</td>
<td align="right">5.9e-06</td>
</tr>
<tr class="odd">
<td align="left">Weak Mixing Angle</td>
<td align="right">2.223000e-01</td>
<td align="left"></td>
<td align="right">2.1e-03</td>
</tr>
<tr class="even">
<td align="left">Wien Frequency Displacement Law Constant</td>
<td align="right">5.878924e+10</td>
<td align="left">Hz K^-1</td>
<td align="right">3.4e+04</td>
</tr>
<tr class="odd">
<td align="left">Wien Wavelength Displacement Law Constant</td>
<td align="right">2.897773e-03</td>
<td align="left">m K</td>
<td align="right">1.7e-09</td>
</tr>
</tbody>
</table>
