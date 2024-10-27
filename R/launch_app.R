launch_app <- function() {

  # Set up the resource path for HTML files
  shiny::addResourcePath("html", system.file("www/html", package = "Melcafe"))

  # Define the UI
  ui <- shiny::tagList(
    theme = shinythemes::shinytheme("paper"),
    shiny::navbarPage(
      "cafeMel",

      # Introduction tab
      shiny::tabPanel(
        "Introduction",
        shiny::titlePanel("Coffee Culture"),
        shiny::tags$iframe(
          src = "html/introduction.html",
          height = "600px",
          width = "100%",
          frameborder = "0"
        )
      ),

      # Coffee shop counts plot tab
      shiny::tabPanel(
        "Coffee Shops",
        shiny::titlePanel("Coffee business in Melbourne suburbs (2002-2022)"),

        shiny::sidebarLayout(
          shiny::sidebarPanel(
            # Input: Select location
            shiny::selectInput(
              inputId = "location",
              label = "Choose a suburb:",
              choices = unique(vic_coffee_map$Location)
            )
          ),

          shiny::mainPanel(
            # Output: Plot of data
            shiny::plotOutput("coffee_shop_counts")
          )
        )
      ),  # Close tabPanel for "Coffee Shops"

      # Census table tab
      shiny::tabPanel(
        "Census Table",
        shiny::titlePanel("Coffee business and Census data"),

        shiny::sidebarLayout(
          shiny::sidebarPanel(
            # Input: Select location and year
            shiny::selectizeInput(
              "suburb", "Choose Suburb(s):",
              choices = unique(census_suburb$Location),
              selected = unique(census_suburb$Location)[1],
              multiple = TRUE,
              options = list(maxItems = 5)
            ),

            shiny::selectInput(
              "year", "Choose Year:",
              choices = c(2016, 2021),
              selected = 2016
            )
          ),

          # Output: Table of data
          shiny::mainPanel(
            shiny::uiOutput("censusTable")
          )
        )
      )  # Close tabPanel for "Census Table"
    )
  )

  # Define the server logic
  server <- function(input, output) {
    output$coffee_shop_counts <- shiny::renderPlot({
      vic_coffee_map |>
        dplyr::filter(Location == !!input$location) |>
        ggplot2::ggplot(ggplot2::aes(x = census_year, y = cafe_count)) +
        ggplot2::geom_col(width = 0.6, fill = "skyblue") +
        ggplot2::labs(
          title = paste("Number of coffee shops in", input$location, "(2002–2022)"),
          x = "Year",
          y = "Number of coffee shops"
        ) +
        ggplot2::scale_x_continuous(breaks = seq(2002, 2022, 2)) +
        ggplot2::theme_minimal() +
        ggplot2::theme(
          axis.title.x = ggplot2::element_text(size = 12),
          axis.title.y = ggplot2::element_text(size = 12),
          axis.text.x = ggplot2::element_text(size = 8),
          axis.text.y = ggplot2::element_text(size = 8),
          plot.title = ggplot2::element_text(size = 18, face = "bold")
        )
    })

    output$censusTable <- shiny::renderUI({
      # Filter the data for the selected suburbs and year
      result <- lapply(input$suburb, function(suburb) {
        median_age <- if (input$year == 2016)
          census_suburb |>
          dplyr::filter(Location == suburb) |>
          dplyr::pull(Median_age_16)
        else census_suburb |>
          dplyr::filter(Location == suburb) |>
          dplyr::pull(Median_age_21)

        median_income <- if (input$year == 2016)
          census_suburb |>
          dplyr::filter(Location == suburb) |>
          dplyr::pull(Median_income_16)
        else census_suburb |>
          dplyr::filter(Location == suburb) |>
          dplyr::pull(Median_income_21)

        cafe_count <- vic_coffee_map |>
          dplyr::filter(Location == suburb) |>
          dplyr::filter(census_year == input$year) |>
          dplyr::pull(cafe_count)

        tibble::tibble(
          "Suburb" = suburb,
          "Median age" = median_age,
          "Median income" = median_income,
          "Cafe shops count" = cafe_count
        )
      })

      # Combine the list of tibbles into a single data frame
      final_result <- dplyr::bind_rows(result)

      # Use kableExtra to style the table
      final_result |>
        kableExtra::kable(caption = paste(
          "Census data and number of coffee shops in",
          paste(input$suburb, collapse = ", "),
          "(", input$year, ")")) |>
        kableExtra::kable_styling(
          bootstrap_options = "basic",
          full_width = FALSE,
          position = "center"
        ) |>
        as.character() |>
        shiny::HTML()
    })
  }

  # Run the application
  shiny::shinyApp(ui = ui, server = server)
}
