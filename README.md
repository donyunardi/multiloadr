# multiloadr
![check](https://github.com/donyunardi/multiloadr/actions/workflows/r.yml/badge.svg)
![coverage](https://raw.githubusercontent.com/donyunardi/multiloadr/coverage_badge/coverage.svg)

`multiloadr` is an R package that streamlines the process of loading R packages
that are essential dependencies for a project within a session.

This package is particularly useful when developing multiple R packages that
have interdependencies, as it simplifies the process of loading these packages
in your local environment and enhances the overall efficiency of your workflow.

## Usage
Suppose the user is actively working on PackageA, a dependency for both
PackageB and PackageC, with the intention of enhancing a specific function
within PackageA.

Given that this improvement may have downstream effects on both PackageB and
PackageC, it becomes necessary to update these packages accordingly.

To manage this development process, a feature branch will be created for each of
these packages. However, it's also possible that multiple branches may be
generated to address various aspects of the feature.

The `multiloadr` package facilitates this development scenario by allowing users
to load multiple R packages into the session. `multiloadr` also provides the
capability to selectively pull changes from different branches or commits,
offering flexibility and control during the development process.

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

# load packages from "develop" branch if available, or "main" branch otherwise,
# and perform git pull
load_pkgs(branch_name = c("develop", "main"), git_pull = TRUE)

# load packages from specific commit
from_commit <- list(packageA = "hash_commit", packageC = "hash_commit")
load_pkgs(branch_name = "main", git_pull = TRUE, from_commit = from_commit)
```

By executing this action, the user can load packages into their current session
and evaluate the impact of updating PackageA on PackageB and PackageC without
having to rebuild or reinstall all the packages.

## Installation
To install the development version of `multiloadr`, follow these steps:

``` r
library(devtools)
install_github("donyunardi/multiloadr")
```

### Install Git
`Git` is required to use `multiloadr`. Please refer to the instructions
provided [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
to install git in your environment.

## Additional Information
### Installing Package Dependencies before Executing `load_pkgs()`
It is the responsibility of the user to ensure that the dependencies required
for loading the package(s) are installed before executing `load_pkgs()`. If any
dependencies are missing, a message will be displayed prompting the user to
install them. To resolve the issue, the user can install the missing packages
and then rerun the `load_pkgs()` function.
### Git in Local R Package Folder
`multiloadr` assumes that the local directory of the R package is under version
control using git. In most cases, this is true, especially if the package is
hosted in a public repository like GitHub or GitLab where users are required to
perform a `git clone`. However, if this is not the case, please initialize the
folder by running `git init` inside the folder directory before using
`multiloadr`.
