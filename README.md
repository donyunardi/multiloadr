# multiloadr

multiloadr is a highly useful R package that streamlines the process of loading R packages that 
are essential dependencies for a project within a session. This package is especially handy when 
working on multiple R packages that rely on each other locally, as it simplifies the task of 
loading these packages and makes the overall workflow more efficient.

## Installation

You can install the development version of multiloadr like so:

``` r
library(devtools)
install_github("donyunardi/multiloadr")
```

## Example

If you're working on PackageA, which serves as a dependency for PackageB, and you want to enhance 
PackageA to examine its effect on a function within PackageB without rebuilding all packages, you 
can take the following steps when developing PackageB:
``` r
library(multiloadr)
add_pkgs("packageA", "local-path-to-packageA")
add_pkgs("packageB", "local-path-to-packageB")
load_pkgs()
```

Executing this action loads both packages into your current session, allowing you to assess the 
impact of your PackageA update on PackageB without rebuilding all packages.
