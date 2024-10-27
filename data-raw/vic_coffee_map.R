## code to prepare `vic_coffee_map` dataset goes here

vic_coffee_map <- sf::read_sf("data-raw/vic_coffee_map.geojson")

usethis::use_data(vic_coffee_map, overwrite = TRUE)
