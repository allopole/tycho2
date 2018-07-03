#' Assemble a web API call URL
#'
#' Assembles an arbitrary web API call URL from a base URL and query string terms. Returns a URL as a string.
#'
#'     A web API call consitst of a base URL with optional additional path, followed by a "?" separator and query terms separated by the "&" separator.
#'
#'     Query terms are in the form \code{[key][operator][value]}, most commonly \code{[key]=[value]}.
#'
#'     \code{apicall()} uses the \code{baseurl} argument, if provided, as the base URL.
#'     \code{path} is appended to \code{baseurl} before the "?" separator.
#'     Queries are built from a list of key-value pairs passed to the \code{param} argument, and/or a character vector of query terms (conditions) passed to the \code{queryterms} argument.
#'     An API Key, if required, can be set via the \code{apikey} argument, or passed to \code{param} or \code{queryterms}.
#'     Any combination of \code{queryterms}, \code{param} and \code{apikey} can be used.
#'
#'     \code{apicall()} automatically replaces spaces with \code{\%20} in the final URL.
#'
#' @param baseurl string. The base URL to which an additional path and additional query terms may be appended.
#' @param path string (optional). An additional path to be appended to the base URL before the "?" separator and query terms.
#' @param params list (optional). A list of query terms in the form \code{list(key1=value1,key2=value2,...)}
#' @param queryterms character vector (optional). Vector of query terms passed as strings in the form \code{c("key1[operator]value1", "key2[operator]value2", ...)}. This is useful if the API allows operators other than \code{=}, for example \code{http://foo.foo/query?count>=20}.
#' @param apikey string. (optional). An API key. The API key can also be passed with \code{params} or \code{queryterms}.
#'
#' @return string
#'
#' @examples
#' apicall(baseurl="http://foo.com/", path="list")
#'
#' p <- list(author="Davy Jones",format="book")
#' apicall(baseurl="http://foo.com/", path="search", params=p)
#'
#' q <- c("author=Davy Jones","year>=1980")
#' apicall(baseurl="http://foo.com/", path="search", queryterms=q)
#'
#' apicall(baseurl="http://foo.com/search", params=p, queryterms="year>=1980", apikey="123abc")
#'
#' @export

apicall <- function(baseurl, path = "", params=NULL, queryterms=NULL, apikey=NULL) {
  u <- paste0(baseurl,path)
  q <- NULL
  if(!is.null(apikey)) {q <- c(q, paste0("apikey=",apikey))}
  if(!missing(params)) {q <- c(q, paste0(names(params),"=",params))}
  q <- c(q, queryterms)
  if (!is.null(q)) {
    qstring <- paste(q, collapse = "&")
    u <- paste(u,qstring,sep="?")
  }
  u <- gsub(" ","%20",u)
  return(u)
}

### TODO Add support for REST API's with verbs.
