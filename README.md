<!-- README.md is generated from README.Rmd. Please edit that file -->
tycho2
======

This R package provides a simple wrapper for the [Project
Tycho](https://www.tycho.pitt.edu/) 2.0 web API.

Project Tycho
-------------

Project Tycho is a repository for global health data in a standardized
format compliant with FAIR (Findable, Accessible, Interoperable, and
Reusable) guidelines.

Version 2.0 of the database currently contains:

-   weekly case counts for 78 notifiable conditions for 50 states and
    1284 cities between 1888 and 2014, reported by health agencies in
    the United States.
-   data for dengue-related conditions for 100 countries between 1955
    and 2010, obtained from the World Health Organization and national
    health agencies.

Project Tycho 2.0 datasets are represented in a standard format
registered with FAIRsharing (bsg-s000718) and include standard SNOMED-CT
codes for reported conditions, ISO 3166 codes for countries and first
administrative level subdivisions, and NCBI TaxonID numbers for
pathogens.

Precompiled datasets with DOI’s are also available for download directly
from the [Project Tycho](https://www.tycho.pitt.edu/).

See <https://www.tycho.pitt.edu/dataset/api/> for complete documentation
of the API.

tycho2 package
--------------

-   `apicall()` - Helper function to assemble arbitrary web api call
    URLs from a base URL and query string terms. Returns a URL as a
    string.
-   `tycho2()` - Wrapper for the Tycho 2.0 web API. Calls `apicall()`
    with Tycho’s default base URL and applies some automation to
    facilitate downloading large datasets with a single call. Returns a
    dataframe.
