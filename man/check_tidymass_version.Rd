% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/8-tidymass_update.R
\name{check_tidymass_version}
\alias{check_tidymass_version}
\title{check_tidymass_version}
\usage{
check_tidymass_version(
  packages = c("core", "all"),
  from = c("gitlab", "github", "gitee", "shen")
)
}
\arguments{
\item{packages}{core or all packages in tidymass. "core" means all the core
packages in tidymass and "all" means all the packages in tidymass.}

\item{from}{"gitlab", "github", or "gitee", or "tidymass.org"}
}
\description{
Check if there are packages in tidymass can be updated.
}
\author{
Xiaotao Shen
\email{shenxt1990@outlook.com}
}
