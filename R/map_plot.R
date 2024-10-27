#' Map of the concentration of coffee shops in Melbourne suburbs
#'
#' @param 'census year'
#'
#' @return 'ggplot2' map showing the number of coffee shops in Melbourne city
#' @export
#'
#' @examples
#' map_plot(2016)

map_plot <- function(year) {
  vic_coffee_map |>
    # Filter the data to the year of interest
    dplyr::filter(census_year == year) |>
    ggplot2::ggplot() +

    # Plot the map with the number of coffee shops in each suburb
    ggplot2::geom_sf(ggplot2::aes(fill = cafe_count), color = "white", size = 1) +
    ggplot2::geom_sf_text(ggplot2::aes(label = cafe_count), color = "white", size = 2.5) +

    # Customize the plot
    ggplot2::theme_minimal() +
    ggplot2::scale_fill_gradient() +
    ggplot2::theme(axis.title.y = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_blank(),
                   axis.text.y = ggplot2::element_blank()) +
    ggplot2::labs(title = paste("Number of coffee shops in Melbourne suburbs in", year))
}
