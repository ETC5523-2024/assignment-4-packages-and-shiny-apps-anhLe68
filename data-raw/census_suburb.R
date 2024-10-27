## code to prepare `census_suburb` dataset goes here

census_suburb <- readr::read_csv("data-raw/census_surb.csv")

usethis::use_data(census_suburb, overwrite = TRUE)

