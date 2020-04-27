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
#  Samples <- kusto_database_endpoint(server="https://help.kusto.windows.net", database="Samples")
#  
#  ## To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code ######### to authenticate.
#  ## Waiting for device code in browser...
#  ## Press Esc/Ctrl + C to abort
#  ## Authentication complete.
#  

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
#  

## ----run_query_params, eval = FALSE-------------------------------------------
#  res <- run_query(Samples, "MyFunction(lim)", lim=10L)
#  head(res)
#  
#  ##             StartTime             EndTime EpisodeId EventId          State
#  ## 1 2007-09-29 08:11:00 2007-09-29 08:11:00     11091   61032 ATLANTIC SOUTH
#  ## 2 2007-09-18 20:00:00 2007-09-19 18:00:00     11074   60904        FLORIDA
#  ## 3 2007-09-20 21:57:00 2007-09-20 22:05:00     11078   60913        FLORIDA
#  ## 4 2007-12-30 16:00:00 2007-12-30 16:05:00     11749   64588        GEORGIA
#  ## 5 2007-12-20 07:50:00 2007-12-20 07:53:00     12554   68796    MISSISSIPPI
#  ## 6 2007-12-20 10:32:00 2007-12-20 10:36:00     12554   68814    MISSISSIPPI
#  

## ----run_query_commands, eval = FALSE-----------------------------------------
#  res <- run_query(Samples, ".show tables | count")
#  res[[1]]
#  
#  ##   Count
#  ## 1     5
#  

## ----dplyr, eval = FALSE------------------------------------------------------
#  library(dplyr)
#  
#  StormEvents <- tbl_kusto(Samples, "StormEvents")
#  
#  q <- StormEvents %>%
#      group_by(State) %>%
#      summarize(EventCount=n()) %>%
#      arrange(State)
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
#  

## ----tbl_kusto_params, eval = FALSE-------------------------------------------
#  MyFunctionDate <- tbl_kusto(Samples, "MyFunctionDate(dt)", dt=as.Date("2019-01-01"))
#  
#  MyFunctionDate %>%
#      select(StartTime, EndTime, EpisodeId, EventId, State) %>%
#      head() %>%
#      collect()
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
#  

## ----dbi, eval = FALSE--------------------------------------------------------
#  library(DBI)
#  
#  Samples <- dbConnect(AzureKusto(),
#                       server="https://help.kusto.windows.net",
#                       database="Samples")
#  
#  dbListTables(Samples)
#  
#  ## [1] "StormEvents"       "demo_make_series1" "demo_series2"
#  ## [4] "demo_series3"      "demo_many_series1"
#  
#  dbExistsTable(Samples, "StormEvents")
#  
#  ##[1] TRUE
#  
#  dbGetQuery(Samples, "StormEvents | summarize ct = count()")
#  
#  ##      ct
#  ## 1 59066
#  

