## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "##"
)

## ----setup, eval = FALSE------------------------------------------------------
#  library(AzureKusto)
#  ## The first time you import AzureKusto, you'll be asked if you'd like to create a directory to cache OAuth2 tokens.
#  
#  ## Connect to an AzureKusto database with (default) device code authentication:
#  Samples <- kusto_database_endpoint(server = "https://help.kusto.windows.net", database = "Samples")
#  # (New in 1.1.0) Some other ways to call this that also work:
#  # Samples <- kusto_database_endpoint(server="help", database="Samples")
#  # Samples <- kusto_database_endpoint(cluster="help", database="Samples")
#  
#  # No app ID supplied; using KustoClient app
#  # Waiting for authentication in browser...
#  # Press Esc/Ctrl + C to abort
#  # VSCode WebView only supports showing local http content.
#  # Opening in external browser...
#  # Browsing https://login.microsoftonline.com/common/oauth2/v2.0/authorize...
#  # Authentication complete.

## ----run_query, eval = FALSE--------------------------------------------------
#  res <- run_query(Samples, "StormEvents | summarize EventCount = count() by State | order by State asc")
#  head(res)
#  
#  ##            State EventCount
#  ## 1        ALABAMA       1315
#  ## 2         ALASKA        257
#  ## 3 AMERICAN SAMOA         16
#  ## 4        ARIZONA        340
#  ## 5       ARKANSAS       1028
#  ## 6 ATLANTIC NORTH        188

## ----run_query_params, eval = FALSE-------------------------------------------
#  res <- run_query(Samples, "MyFunction(lim)", lim = 10L)
#  head(res)
#  
#  ##             StartTime             EndTime EpisodeId EventId          State
#  ## 1 2007-09-29 08:11:00 2007-09-29 08:11:00     11091   61032 ATLANTIC SOUTH
#  ## 2 2007-09-18 20:00:00 2007-09-19 18:00:00     11074   60904        FLORIDA
#  ## 3 2007-09-20 21:57:00 2007-09-20 22:05:00     11078   60913        FLORIDA
#  ## 4 2007-12-30 16:00:00 2007-12-30 16:05:00     11749   64588        GEORGIA
#  ## 5 2007-12-20 07:50:00 2007-12-20 07:53:00     12554   68796    MISSISSIPPI
#  ## 6 2007-12-20 10:32:00 2007-12-20 10:36:00     12554   68814    MISSISSIPPI

## ----run_query_commands, eval = FALSE-----------------------------------------
#  res <- run_query(Samples, ".show tables | count")
#  res[[1]]
#  
#  ##   Count
#  ## 1     5

## ----dplyr, eval = FALSE------------------------------------------------------
#  library(dplyr)
#  
#  StormEvents <- tbl_kusto(Samples, "StormEvents")
#  
#  q <- StormEvents %>%
#    group_by(State) %>%
#    summarize(EventCount = n()) %>%
#    arrange(State)
#  
#  show_query(q)
#  
#  ## <KQL> database('Samples').['StormEvents']
#  ## | summarize ['EventCount'] = count() by ['State']
#  ## | order by ['State'] asc
#  
#  collect(q)
#  
#  ## # A tibble: 67 x 2
#  ##    State          EventCount
#  ##    <chr>               <dbl>
#  ##  1 ALABAMA              1315
#  ##  2 ALASKA                257
#  ##  3 AMERICAN SAMOA         16
#  ##  4 ARIZONA               340
#  ##  5 ARKANSAS             1028
#  ##  6 ATLANTIC NORTH        188
#  ##  7 ATLANTIC SOUTH        193
#  ##  8 CALIFORNIA            898
#  ##  9 COLORADO             1654
#  ## 10 CONNECTICUT           148
#  ## # ... with 57 more rows

## ----dollar, eval = FALSE-----------------------------------------------------
#  q <- StormEvents %>%
#    slice_sample(10) %>%
#    mutate(Description = as.character(StormSummary$Details$Description)) %>%
#    select(EventId, Description)
#  
#  show_query(q)
#  
#  # <KQL> cluster('https://help.kusto.windows.net').database('Samples').['StormEvents']
#  # | sample 10
#  # | extend ['Description'] = tostring(['StormSummary'] . ['Details'] . ['Description'])
#  # | project ['EventId'], ['Description']
#  
#  # # A tibble: 10 × 2
#  #    EventId Description
#  #      <int> <chr>
#  #  1   61032 A waterspout formed in the Atlantic southeast of Melbourne Beach and briefly moved toward shore.
#  #  2   60904 As much as 9 inches of rain fell in a 24-hour period across parts of coastal Volusia County.
#  #  3   60913 A tornado touched down in the Town of Eustis at the northern end of West Crooked Lake. The tornado quickly intensified to EF1 strength as it moved north northwest through Eustis. The track was just under two miles long…
#  #  4   64588 The county dispatch reported several trees were blown down along Quincey Batten Loop near State Road 206. The cost of tree removal was estimated.
#  #  5   68796 Numerous large trees were blown down with some down on power lines. Damage occurred in eastern Adams county.
#  #  6   68814 This tornado began as a small, narrow path of minor damage, including a porch being blown off a house. It reached its maximum intensity as it crossed highway 29. Here, a brick home had all of its roof structure blown o…
#  #  7   68834 Several trees and power lines were blown down along Zetus Road in the Zetus Community. A few of those trees were down on a mobile home which caused significant damage.
#  #  8   68846 A swath of penny to quarter sized hail fell from just east of French Camp to about 6 miles north of Weir.
#  #  9   73241 The heavy rain from an active monsoonal trough that had been nearly stationary just to the south of the islands caused widespread flooding across Tutuila.  Flash Flooding was reported from the Malaeimi Valley to the Ba…
#  # 10   64725 State Route 8 and Rock Run Road were flooded and impassable

## ----tbl_kusto_params, eval = FALSE-------------------------------------------
#  MyFunctionDate <- tbl_kusto(Samples, "MyFunctionDate(dt)", dt = as.Date("2019-01-01"))
#  
#  MyFunctionDate %>%
#    select(StartTime, EndTime, EpisodeId, EventId, State) %>%
#    head() %>%
#    collect()
#  
#  ## # A tibble: 6 x 5
#  ##   StartTime           EndTime             EpisodeId EventId State
#  ##   <dttm>              <dttm>                  <int>   <int> <chr>
#  ## 1 2007-09-29 08:11:00 2007-09-29 08:11:00     11091   61032 ATLANTIC SOUTH
#  ## 2 2007-09-18 20:00:00 2007-09-19 18:00:00     11074   60904 FLORIDA
#  ## 3 2007-09-20 21:57:00 2007-09-20 22:05:00     11078   60913 FLORIDA
#  ## 4 2007-12-30 16:00:00 2007-12-30 16:05:00     11749   64588 GEORGIA
#  ## 5 2007-12-20 07:50:00 2007-12-20 07:53:00     12554   68796 MISSISSIPPI
#  ## 6 2007-12-20 10:32:00 2007-12-20 10:36:00     12554   68814 MISSISSIPPI

## ----exporting, eval = FALSE--------------------------------------------------
#  export(
#    database = Samples,
#    storage_uri = "https://mystorage.blob.core.windows.net/StormEvents",
#    query = "StormEvents | summarize EventCount = count() by State | order by State",
#    name_prefix = "events",
#    format = "parquet"
#  )
#  
#  #                                                                                 Path NumRecords SizeInBytes
#  # 1 https://mystorage.blob.core.windows.net/StormEvents/events/events_1.snappy.parquet         67        1511
#  
#  library(dplyr)
#  StormEvents <- tbl_kusto(Samples, "StormEvents")
#  q <- StormEvents %>%
#    group_by(State) %>%
#    summarize(EventCount = n()) %>%
#    arrange(State) %>%
#    export("https://mystorage.blob.core.windows.net/StormEvents")
#  
#  # # A tibble: 1 × 3
#  #   Path                                                                              NumRecords SizeInBytes
#  #   <chr>                                                                                  <dbl>       <dbl>
#  # 1 https://mystorage.blob.core.windows.net/StormEvents/export/export_1.snappy.parquet        50       59284

## ----dbi, eval = FALSE--------------------------------------------------------
#  library(DBI)
#  
#  Samples <- dbConnect(AzureKusto(),
#    server = "https://help.kusto.windows.net",
#    database = "Samples"
#  )
#  
#  dbListTables(Samples)
#  
#  ## [1] "StormEvents"       "demo_make_series1" "demo_series2"
#  ## [4] "demo_series3"      "demo_many_series1"
#  
#  dbExistsTable(Samples, "StormEvents")
#  
#  ## [1] TRUE
#  
#  dbGetQuery(Samples, "StormEvents | summarize ct = count()")
#  
#  ##      ct
#  ## 1 59066

