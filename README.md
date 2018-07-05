<!-- README.md is generated from README.Rmd. Please edit that file -->
tycho2
======

Author: Eric Marty  
This R package provides a simple wrapper for the [Project
Tycho](https://www.tycho.pitt.edu/) 2.0 web API.

The development of this package was supported by the National Institute
of General Medical Sciences of the National Institutes of Health under
Award Number U01GM110744. The content is solely the responsibility of
the authors and does not necessarily reflect the official views of the
National Institutes of Health.

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

Project Tycho database, website and API are by:  
[Wilbert van Panhuis](https://www.tycho.pitt.edu/people/person/49/)
(Principal Investogator)  
[Donald Burke](https://www.tycho.pitt.edu/people/person/66/) (Principal
Investogator)  
[Anne Cross](https://www.tycho.pitt.edu/people/person/50/) (Database
Programmer)  
Project Tycho is published under a [Creative Commons Attribution 4.0
International Public
License](http://creativecommons.org/licenses/by/4.0/).

tycho2 package
--------------

-   `apicall()` - Helper function to assemble arbitrary web api call
    URLs from a base URL and query string terms. Returns a URL as a
    string.
-   `tycho2()` - Wrapper for the Tycho 2.0 web API. Calls `apicall()`
    with Tycho’s default base URL and applies some automation to
    facilitate downloading large datasets with a single call. Returns a
    dataframe.
