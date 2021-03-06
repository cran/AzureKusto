% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbi.R
\name{AzureKusto}
\alias{AzureKusto}
\alias{dbConnect,AzureKustoDriver-method}
\alias{AzureKusto-connection}
\alias{dbCanConnect,AzureKustoDriver-method}
\alias{dbDisconnect,AzureKustoDriver-method}
\title{DBI interface: connect to a Kusto cluster}
\usage{
AzureKusto()

\S4method{dbConnect}{AzureKustoDriver}(drv, ..., bigint = c("numeric", "integer64"))

\S4method{dbCanConnect}{AzureKustoDriver}(drv, ...)

\S4method{dbDisconnect}{AzureKustoDriver}(conn, ...)
}
\arguments{
\item{drv}{An AzureKusto DBI driver object, instantiated with \code{AzureKusto()}.}

\item{...}{Authentication arguments supplied to \code{kusto_database_endpoint}.}

\item{bigint}{How to treat Kusto long integer columns. By default, they will be converted to R numeric variables. If this is "integer64", they will be converted to \code{integer64} variables using the bit64 package.}

\item{conn}{For \code{dbDisconnect}, an AzureKustoConnection object obtained with \code{dbConnect}.}
}
\value{
For \code{dbConnect}, an object of class AzureKustoConnection.

For \code{dbCanConnect}, TRUE if authenticating with the Kusto server succeeded with the given arguments, and FALSE otherwise.

For \code{dbDisconnect}, always TRUE, invisibly.
}
\description{
Functions to connect to a Kusto cluster.
}
\details{
Kusto is connectionless, so \code{dbConnect} simply wraps a database endpoint object, generated with \code{kusto_database_endpoint(...)}. The endpoint itself can be accessed via the \verb{@endpoint} slot. Similarly, \code{dbDisconnect} always returns TRUE.

\code{dbCanConnect} attempts to detect whether querying the database with the given information and credentials will be successful. The result may not be accurate; essentially all it does is check that its arguments are valid Kusto properties. Ultimately the best way to tell if querying will work is to try it.
}
\examples{
\dontrun{
db <- DBI::dbConnect(AzureKusto(),
    server="https://mycluster.westus.kusto.windows.net", database="database", tenantid="contoso")

DBI::dbDisconnect(db)

# no authentication credentials: returns FALSE
DBI::dbCanConnect(AzureKusto(),
    server="https://mycluster.westus.kusto.windows.net")

}
}
\seealso{
\link{kusto-DBI}, \link{dbReadTable}, \link{dbWriteTable}, \link{dbGetQuery}, \link{dbSendStatement}, \link{kusto_database_endpoint}
}
