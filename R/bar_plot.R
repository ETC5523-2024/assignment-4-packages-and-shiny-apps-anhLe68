bar_plot <- function(suburb) {
  vic_coffee_map |>
    # Filter the data to the location of interest
    dplyr::filter(Location == suburb) |>

    # Plot the bar chart with the number of coffee shops
    ggplot2::ggplot(ggplot2::aes(x = census_year,
                                 y = cafe_count)) +
    ggplot2::geom_col(fill = "#D2B48C", width = 0.8) +

    # Customize the plot
    ggplot2::theme_minimal() +
    ggplot2::scale_x_continuous(breaks = seq(2002, 2022, 2)) +
    ggplot2::labs(title = paste("Number of coffee shops in", suburb, "(2002-2022)"),
                  x = "Year",
                  y = "Cafe shops count")+
    ggplot2::theme(plot.title = ggplot2::element_text(size = 16))
}
