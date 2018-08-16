#' Get data from Tycho 2.0 database
#'
#' Calls the Tycho 2.0 database using the Tycho 2.0 web API.
#'
#' \strong{Project Tycho, a repository for global health data}
#'
#' Project Tycho is a repository for global health data in a standardized format compliant with FAIR
#' (Findable, Accessible, Interoperable, and Reusable) guidelines.
#'
#' Version 2.0 of the database currently contains:
#'
#' \itemize{ \item Weekly case counts for 78 notifiable conditions for 50 states and 1284 cities
#' between 1888 and 2014, reported by health agencies in the United States. \item Data for
#' dengue-related conditions for 100 countries between 1955 and 2010, obtained from the World Health
#' Organization and national health agencies. }
#'
#' Project Tycho 2.0 datasets are represented in a standard format registered with FAIRsharing
#' (bsg-s000718) and include standard SNOMED-CT codes for reported conditions, ISO 3166 codes for
#' countries and first administrative level subdivisions, and NCBI TaxonID numbers for pathogens.
#'
#' Precompiled datasets with DOI's are also available for download directly from
#' \href{https://www.tycho.pitt.edu/}{Project Tycho}.
#'
#' See \url{https://www.tycho.pitt.edu/dataset/api/} for a complete documentation of the API.
#'
#' \strong{\code{tycho2()}}
#'
#' \code{tycho2} calls \code{\link{apicall}} with the base URL
#' "https://www.tycho.pitt.edu/api/". If \code{path} is the name of a data field in the Tycho 2.0
#' database, \code{tycho2} will return a dataframe of possible values for the field with additional
#' information. See \url{https://www.tycho.pitt.edu/dataset/api/} for more details. If \code{path}
#' is "query", \code{tycho2} will return a dataframe of case counts with associated variables for
#' the query terms specified. See \url{https://www.tycho.pitt.edu/dataset/api/} for more details.
#' Queries are built from a list of key-value pairs passed to the \code{param} argument, and/or a
#' character vector of query terms (conditions) passed to the \code{queryterms} argument. An account
#' with Project Tycho and an API Key is required to access the database.  The API Key can be
#' retrieved from your Tycho account. The API key can be set with the \code{apikey} argument, or
#' passed to \code{param} or \code{queryterms}. Any combination of \code{queryterms}, \code{param}
#' and \code{apikey} can be used.
#'
#' \code{tycho2()} automatically replaces spaces with \code{\%20} in the final URL.
#'
#' To pull large datasets, \code{tycho2()} repeatedly calls the API to retrieve partial datasets in
#' chunks of 5000 records until all the requested data has been received, then outputs a single
#' large dataframe. Therefore, the \code{limit} and \code{offset} querry parameters described in the
#' API do not need to be specified. \code{tycho2()} handles these parameters invisibly.
#'
#' To avoid errors, date ranges should be specified in YYYY-MM-DD format using
#' \code{PeriodStartDate} and \code{PeriodEndDate} query parameters with the \code{>=} and \code{<=}
#' operators. The use of \code{>=} and \code{<=} requires passing dates using the "queryterms"
#' argument.
#'
#' Although the Tycho 2.0 database can be querried directly by passing a manually assembled API call
#' URL to \code{read.csv}, as below...
#'
#' \code{read.csv('https://www.tycho.pitt.edu/api/query?CountryISO=US&ConditionName=Gonorrhea&apikey=YOURAPIKEY')}
#'
#' ...use of \code{tycho2} allows querries to be assembled more flexibly and programmatically.
#'
#' Accessing the Project Tycho API using \code{tycho2} requires an API key, which can be retrieved
#' from your Project Tycho account. You must have a Project Tycho account to receive an API key.
#'
#' The Project Tycho 2.0 database and API are by
#' \href{https://www.tycho.pitt.edu/people/person/49/}{Wilbert van Panhuis} (Principal
#' Investogator), \href{https://www.tycho.pitt.edu/people/person/66/}{Donald Burke} (Principal
#' Investogator), \href{https://www.tycho.pitt.edu/people/person/50/}{Anne Cross} (Database
#' Programmer). Project Tycho is published under a
#' \href{http://creativecommons.org/licenses/by/4.0/}{Creative Commons Attribution 4.0 International
#' Public License}.
#'
#' @param path string (optional). Must be either "query" to perform data queries, or one of the
#'   tycho 2.0 database fields to retrieve variable listings.
#' @param params list (optional). A list of query terms in the form
#'   \code{list(var1=value1,var2=value2,...)}
#' @param queryterms character vector (optional). Vector of query terms passed as strings in the
#'   form \code{c("var1[operator]value1", "var2[operator]value2", ...)}. Dates must be passed this
#'   way using the \code{>=} and \code{<=} operators (i.e.
#'   \code{queryterms=c("PeriodStartDate>=2000-01-01")})
#' @param apikey string. (required).   Your Project Tycho API key. This can also be passed with
#'   \code{params} or \code{queryterms}.
#' @param baseurl string. Defaults to "https://www.tycho.pitt.edu/api/".
#' @param fixdates "cdc", "iso", or NULL.  If \code{fixdates="cdc"}, PeriodStartDate and PeriodEndDate
#' are rounded to nearest CDC epidemiological week ("epiweek") start and end days
#' (Sunday - Saturday), respectively. If \code{fixdates="cdc"}, PeriodStartDate and PeriodEndDate are
#' rounded to nearest ISO week start and end dates (Monday - Sunday), respectively. CDC epiweeks are
#' used for US data reporting. Elsewhere, epiweeks are synonymous with ISO weeks. Rounding is done
#' with \code{\link{round2wday}}. This param may be necessary because some entries in the Tycho 2.0
#' database have incorrect dates that may be off by one day from the actual epiweek start or end
#' dates. default=NULL.
#' @param start Date, POSIXct, POSIXlt, or character string in "YYYY-MM-DD" format. The start date.
#' If present, overrides "PeriodStartDate" passed to \code{queryterms}. Default = NULL
#' @param end Date, POSIXct, POSIXlt, or character string in "YYYY-MM-DD" format. The end date.
#' If present, overrides "PeriodEndDate" passed to \code{queryterms}. Default = NULL
#'
#' @return dataframe with the following possible columns:
#'   \item{$ConditionName}{factor. Name of reported condition as listed in \href{https://doi.org/10.25504/FAIRsharing.d88s6e}{SNOMED-CT}}
#'   \item{$ConditionSNOMED}{factor. \href{https://doi.org/10.25504/FAIRsharing.d88s6e}{SNOMED-CT} code for reported condition}
#'   \item{$PathogenName}{factor. \href{https://doi.org/10.25504/FAIRsharing.fj07xj}{NCBI Taxonomy} organism name for pathogen causing reported condition}
#'   \item{$PathogenTaxonID}{factor. \href{https://doi.org/10.25504/FAIRsharing.fj07xj}{NCBI Taxonomy} identifier for pathogen causing reported condition}
#'   \item{$Fatalities}{logical. Counts of reported condition ($CountValue) represent fatalities}
#'   \item{$CountryName}{factor. \href{https://www.iso.org/obp/ui/#search/code/}{ISO 3166} English Short Name of country}
#'   \item{$CountryCode}{factor. \href{https://www.iso.org/obp/ui/#search/code/}{ISO 3166} 2-letter code for country}
#'   \item{$Admin1Name}{factor. \href{https://www.iso.org/standard/63546.html}{ISO 3166-2} Name of first administrative subdivision (such as US state)}
#'   \item{$Admin1ISO}{factor. \href{https://www.iso.org/standard/63546.html}{ISO 3166-2} code for first administrative subdivision}
#'   \item{$Admin2Name}{factor. \href{http://www.geonames.org/}{Geonames} Placename of second order administrative division}
#'   \item{$CityName}{factor. \href{http://www.geonames.org/}{Geonames} Name of populated place}
#'   \item{$PeriodStartDate}{Date, format: YYYY-MM-DD. Start date of time interval for which a count was reported}
#'   \item{$PeriodEndDate}{Date, format: YYYY-MM-DD. End date of time interval for which a count was reported}
#'   \item{$PartOfCumulativeCountSeries}{logical. Count is part of a series of cumulative counts
#'   (instead of being part of a series of fixed time interval counts)}
#'   \item{$AgeRange}{Ordered factor. Age range in years for which a count was reported e.g. "0-18". Max age = 130}
#'   \item{$Subpopulation}{factor. "Civilian", "Military", or "None specified"}
#'   \item{$PlaceOfAcquisition}{factor. "Domestic", "Abroad", or NA}
#'   \item{$DiagnosisCertainty}{factor. \href{https://doi.org/10.25504/FAIRsharing.d88s6e}{SNOMED-CT}
#'   Qualifier for certainty of diagnosis for a count condition: "Definite", "Equivocal", "Possible diagnosis","Probable diagnosis", or NA}
#'   \item{$SourceName}{factor. Name of the source (system, database, institution) from which counts
#'   were obtained by the Project Tycho team}
#'   \item{$CountValue}{integer. The count value.}
#'   Variables described in detail here:
#'   \url{https://www.tycho.pitt.edu/dataformat/ProjectTychoCustomCompiledDataFormat.pdf}
#
#'
#' @examples
#' # Note: retrive your API key from your Project Tycho account
#'
#' # List of conditions showing "ConditionName", "ConditionSNOMED"
#'
#' TYCHOKEY <- 'some1long2alphanumeric3string'
#' conditions <- tycho2("condition", apikey = TYCHOKEY)
#'
#' # All cases of scarlet fever in California
#'
#' params <- list(ConditionName = "Scarlet fever", Admin1ISO = "US-CA")
#' Scarlet <- tycho2("query", params = params, apikey = TYCHOKEY)
#'
#' # All measles cases in California from 2000 to 2010
#'
#' queryterms <- c(
#'   "ConditionName=Measles",
#'   "Admin1ISO=US-CA",
#'   "PeriodStartDate>=2000-01-01",
#'   "PeriodEndDate<=2010-01-01"
#'   )
#' Measles_CA_2000_2010 <- tycho2("query", queryterms=queryterms, apikey=TYCHOKEY)
#'
#' @export
#' @importFrom utils read.csv
#'
tycho2 <- function(path="", params=NULL, queryterms=NULL, apikey=NULL,
                   baseurl="https://www.tycho.pitt.edu/api/",
                   fixdates=NULL, start=NULL, end=NULL){
  p <- params
  p$offset <- 0
  p$limit <- 5000
  q <- queryterms[-grep("offset",queryterms)]
  q <- queryterms[-grep("limit",queryterms)]

  if(!is.null(start)){
    q <- c(
      queryterms[-grep("PeriodStartDate",queryterms)],
      paste0("PeriodStartDate>=",as.Date(start))
      )
  }
  if(!is.null(end)){
    q <- c(
      queryterms[-grep("PeriodEndDate",queryterms)],
      paste0("PeriodEndDate>=",as.Date(end))
    )
  }

  out <- utils::read.csv(apicall(baseurl=baseurl,path=path,params=p,queryterms=queryterms,apikey=apikey))
  more <- nrow(out)>=5000
  while (more == TRUE) {
    p$offset <- p$offset+5000
    df <- read.csv(apicall(baseurl=baseurl, path, params=p, queryterms=q, apikey=apikey))
    more <- nrow(df)>0
    if (more) {
      out <- rbind(out,df)
    }
  }

  if(!is.null(fixdates) & fixdates %in% c("cdc","iso")) {
    week.start <- weekdays[paste0(fixdates,"week.start")]
    week.end <- weekdays[paste0(fixdates,"week.end")]
  }else{
    warning('"fixdates" must be "cdc", "iso" or NULL. Ignoring "fixdates".')
  }

  # classes
  vars <- colnames(out)

  if("ConditionName" %in% vars) {
    out$ConditionName <- as.factor(out$ConditionName)
  }
  if("ConditionSNOMED" %in% vars) {
    out$ConditionSNOMED <- as.factor(out$ConditionSNOMED)
  }
  if("PathogenName" %in% vars) {
    out$PathogenName <- as.factor(out$PathogenName)
  }
  if("PathogenTaxonID" %in% vars) {
    out$PathogenTaxonID <- as.factor(out$PathogenTaxonID)
  }
  if("Fatalities" %in% vars) {
    out$Fatalities <- as.logical(out$Fatalities)
  }
  if("CountryName" %in% vars) {
    out$CountryName <- as.factor(out$CountryName)
  }
  if("CountryCode" %in% vars) {
    out$CountryCode <- as.factor(out$CountryCode)
  }
  if("Admin1Name" %in% vars) {
    out$Admin1Name <- as.factor(out$Admin1Name)
  }
  if("Admin1ISO" %in% vars) {
    out$Admin1ISO <- as.factor(out$Admin1ISO)
  }
  if("Admin2Name" %in% vars) {
    out$Admin2Name <- as.factor(out$Admin2Name)
  }
  if("CityName" %in% vars) {
    out$CityName <- as.factor(out$CityName)
  }
  if("PeriodStartDate" %in% vars) {
    out$PeriodStartDate <- as.Date(out$PeriodStartDate,format = "%Y-%m-%d")
    if(!is.null(fixdates)) {
      out$PeriodStartDate <- round2wday(out$PeriodEndDate,"cdcweek.start")
    }
  }
  if("PeriodEndDate" %in% vars) {
    out$PeriodEndDate <- as.Date(out$PeriodEndDate,format = "%Y-%m-%d")
  }
  if("PartOfCumulativeCountSeries" %in% vars) {
    out$PartOfCumulativeCountSeries <- as.logical(out$PartOfCumulativeCountSeries)
  }
  if("AgeRange" %in% vars) {
    out$AgeRange <- as.ordered(out$AgeRange)
  }
  if("Subpopulation" %in% vars) {
    out$Subpopulation <- factor(out$Subpopulation,
                                levels = c("Civilian", "Military","None specified"))
  }
  if("PlaceOfAcquisition" %in% vars) {
    out$PlaceOfAcquisition <- factor(out$PlaceOfAcquisition,
                                     levels = c("Domestic", "Abroad"))
  }
  if("DiagnosisCertainty" %in% vars) {
    out$DiagnosisCertainty <- as.factor(out$DiagnosisCertainty)
  }
  if("SourceName" %in% vars) {
    out$SourceName <- as.factor(out$SourceName)
  }
  if("CountValue" %in% vars) {
    out$CountValue <- as.integer(out$CountValue)
  }

  return(out)
}




