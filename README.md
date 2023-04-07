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
for PackageB and packageC, and you want to enhance a function in PackageA.

This enhancement might necessitate an update to a function in PackageB and
packageC as well.

If you're developing all packages, you can use multiloadr to load them all in
your session:
``` r
library(multiloadr)

# add packages to multiloadr
add_pkgs("packageA", "local-path-to-packageA")
add_pkgs("packageB", "local-path-to-packageB")
add_pkgs("packageC", "local-path-to-packageC")

# load packages from presently active branch
load_pkgs()

# load packages from develop branch
load_pkgs(branch_name = "develop")

# perform git pull before loading
load_pkgs(branch_name = "develop", git_pull = TRUE)
```

Executing this action loads both packages into your current session, allowing
you to assess the impact of PackageA update on PackageB without rebuilding or
reinstall all packages.

