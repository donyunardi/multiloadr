# multiloadr

`multiloadr` is a highly useful R package that streamlines the process of loading
R packages that are essential dependencies for a project within a session.

This package is especially handy when working on multiple R packages that rely
on each other locally, as it simplifies the task of loading these packages and
makes the overall workflow more efficient.

## Installation

You can install the development version of `multiloadr` like so:

``` r
library(devtools)
install_github("donyunardi/multiloadr")
```

## Usage

Suppose you are currently working on PackageA, which functions as a dependency
for PackageB and PackageC, and you want to enhance a function in PackageA.

This enhancement might necessitate an update to a function in PackageB and
PackageC as well.

If you're developing all packages, you can use multiloadr to load them all in
your session:
``` r
library(multiloadr)

# add packages to multiloadr
add_pkgs("PackageA", "local-path-to-PackageA")
add_pkgs("PackageB", "local-path-to-PackageB")
add_pkgs("PackageC", "local-path-to-PackageC")

# load packages from presently active branch
load_pkgs()

# load packages from develop branch
load_pkgs(branch_name = "develop")

# perform git pull before loading
load_pkgs(branch_name = "develop", git_pull = TRUE)
```

Executing this action loads both packages into your current session, allowing
you to assess the impact of PackageA update on PackageB and PackageC without
rebuilding or reinstall all packages.

