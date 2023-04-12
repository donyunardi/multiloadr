# multiloadr 0.0.1

### New Features
* Created four main functions: add_pkgs, list_pkgs, load_pkgs, and reset_multiloadr. These functions provide a simple interface for managing multiloadr packages.
* Added branch_name and git_pull arguments to the load_pkgs function. These arguments allow the user to specify a specific git branch to load packages from, and to pull the latest changes from the repository before loading the packages.
* Enhance add_pkgs to check if the path is an R package directory before adding to multiloadr.
* Enhance load_pkgs to check if the directory has a remote URL when git_pull = TRUE
