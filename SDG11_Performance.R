library(shiny)
library(shinydashboard)
library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr)
library(plotly)
library(DT)
library(viridis)

# Load Data
data1 <- read_excel("Data_Rshiny_WC.xlsx", sheet=2)
data2 <- read_excel("Data_Rshiny_WC.xlsx", sheet=1)

# Data Preparation for Question 1
new_data1 <- data1[(data1$Location== "URBAN"), c("GeoAreaName", "Value")]
new_data2 <- data1[(data1$Location== "CITY"), c("GeoAreaName", "Value")]
filtered_data_for_Urban <- rbind(new_data1, new_data2) %>%
  rename(Country = GeoAreaName, Population_Percentage = Value)

# Data Preparation for Question 2
exclude_cols <- c("Houses for which construction is complete under Pradhan Mantri Awas Yojana",
                  "SDG India Index: Sustainable cities and communities",
                  "YearCode")
numeric_cols <- setdiff(names(data2)[sapply(data2, is.numeric)], exclude_cols)
normalize <- function(x) {
  return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)) * 100)
}
data_normalized <- data2 %>% mutate(across(all_of(numeric_cols), normalize))
data_normalized$NormalizedScore <- rowMeans(data_normalized[, numeric_cols], na.rm = TRUE)
totalscore <- mean(data_normalized$NormalizedScore, na.rm = TRUE)
dfforpiechart <- data.frame(Category = c("SDG 11 Achievement", "Gap to Target"),
                            Value = c(totalscore, 100 - totalscore))

# Color palettes
main_palette <- viridis(7)
state_palette <- viridis(length(unique(data2$srcStateName)))

# Custom CSS
custom_css <- "
.small-box {border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);}
.info-box {border-radius: 8px;}
.main-header .logo {font-weight: bold;}
.content-wrapper, .right-side {background-color: #f4f6f9;}
.box {border-radius: 10px; border-top: 3px solid #3c8dbc;}
"

# UI
ui <- dashboardPage(
  dashboardHeader(
    title = tags$div(
      tags$i(class = "fas fa-city", style = "margin-right: 10px;"),
      "SDG 11 India Dashboard"
    ),
    titleWidth = 350
  ),

  dashboardSidebar(
    width = 350,
    sidebarMenu(
      menuItem("Urban Population in Slums", tabName = "q1",
               icon = icon("chart-bar"), badgeLabel = "Global", badgeColor = "green"),
      menuItem("SDG 11 Performance", tabName = "q2",
               icon = icon("pie-chart"), badgeLabel = "National", badgeColor = "blue"),
      menuItem("State-wise Analysis", tabName = "q2b",
               icon = icon("state", lib = "glyphicon")),
      menuItem("Indicator Dashboard", tabName = "q3",
               icon = icon("dashboard")),
      menuItem("State Performance", tabName = "q4",
               icon = icon("trophy")),
      menuItem("Housing Correlation", tabName = "q5",
               icon = icon("chart-scatter", lib = "glyphicon")),
      hr(),
      conditionalPanel(
        condition = "input.sidebarid == 'q1'",
        selectizeInput("selected_countries",
                       label = tags$span(tags$i(class = "fas fa-globe"), " Select Countries:"),
                       choices = unique(filtered_data_for_Urban$Country),
                       selected = head(unique(filtered_data_for_Urban$Country), 10),
                       multiple = TRUE,
                       options = list(
                         plugins = list('remove_button'),
                         create = FALSE,
                         persist = FALSE
                       ))
      )
    )
  ),

  dashboardBody(
    tags$head(tags$style(HTML(custom_css))),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic"),

    tabItems(
      # Q1 - Urban Population in Slums
      tabItem(tabName = "q1",
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-chart-bar"), " Slum Population by Country"),
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  collapsible = TRUE,
                  plotlyOutput("barPlotInteractive", height = "500px")
                )
              ),
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-table"), " Detailed Data"),
                  status = "info",
                  solidHeader = TRUE,
                  width = 8,
                  DTOutput("filteredTableDT")
                ),
                box(
                  title = tags$span(tags$i(class = "fas fa-chart-line"), " Summary Statistics"),
                  status = "success",
                  solidHeader = TRUE,
                  width = 4,
                  verbatimTextOutput("summaryOutput"),
                  tags$div(style = "margin-top: 20px;",
                           infoBoxOutput("totalCountries"),
                           infoBoxOutput("avgPopulation"))
                )
              )
      ),

      # Q2 - Total Normalized Score
      tabItem(tabName = "q2",
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-chart-pie"), " National SDG 11 Achievement Score"),
                  status = "warning",
                  solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("pieChartInteractive", height = "400px")
                ),
                box(
                  title = tags$span(tags$i(class = "fas fa-info-circle"), " Score Interpretation"),
                  status = "info",
                  solidHeader = TRUE,
                  width = 6,
                  tags$div(style = "padding: 20px;",
                           tags$h4("Overall SDG 11 Score: ",
                                   tags$span(style = "color: #FF6B6B; font-size: 32px;",
                                             paste0(round(totalscore, 1), "%"))),
                           tags$hr(),
                           tags$p("This score represents India's overall progress towards SDG 11 targets across all states and indicators."),
                           tags$div(style = "margin-top: 30px;",
                                    tags$h5("Score Range Interpretation:"),
                                    tags$ul(
                                      tags$li(tags$span(style = "color: #28a745;", "●"), " 70-100%: On track"),
                                      tags$li(tags$span(style = "color: #ffc107;", "●"), " 40-69%: Moderate progress"),
                                      tags$li(tags$span(style = "color: #dc3545;", "●"), " 0-39%: Urgent action needed")
                                    ))
                  )
                )
              )
      ),

      # Q2B - State-wise Variable Analysis
      tabItem(tabName = "q2b",
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-sliders-h"), " Controls"),
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  column(6,
                         selectInput("selected_states",
                                     label = tags$span(tags$i(class = "fas fa-map-marker-alt"), " Select States:"),
                                     choices = unique(data2$srcStateName),
                                     selected = head(unique(data2$srcStateName), 5),
                                     multiple = TRUE,
                                     selectize = TRUE)
                  ),
                  column(6,
                         selectInput("selected_variable",
                                     label = tags$span(tags$i(class = "fas fa-chart-line"), " Select Indicator:"),
                                     choices = colnames(data2)[sapply(data2, is.numeric)],
                                     selected = colnames(data2)[sapply(data2, is.numeric)][1],
                                     selectize = TRUE)
                  )
                )
              ),
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-chart-bar"), " State-wise Comparison"),
                  status = "success",
                  solidHeader = TRUE,
                  width = 12,
                  plotlyOutput("barPlot2Interactive", height = "500px")
                )
              )
      ),

      # Q3 - Indicator Statistics
      tabItem(tabName = "q3",
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-table"), " State-wise Indicator Summary"),
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  DTOutput("summary_table_interactive")
                )
              ),
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-chart-line"), " Indicator Distribution"),
                  status = "info",
                  solidHeader = TRUE,
                  width = 12,
                  plotlyOutput("summary_plot_interactive", height = "400px")
                )
              )
      ),

      # Q4 - Normalized Scores
      tabItem(tabName = "q4",
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-trophy"), " State Performance Ranking"),
                  status = "success",
                  solidHeader = TRUE,
                  width = 12,
                  selectizeInput("selected_state4",
                                 label = tags$span(tags$i(class = "fas fa-search"), " Select States to Compare:"),
                                 choices = unique(data2$srcStateName),
                                 selected = head(unique(data2$srcStateName), 10),
                                 multiple = TRUE,
                                 options = list(
                                   plugins = list('remove_button'),
                                   create = FALSE,
                                   persist = FALSE
                                 ))
                )
              ),
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-tachometer-alt"), " Normalized SDG 11 Scores"),
                  status = "warning",
                  solidHeader = TRUE,
                  width = 12,
                  plotlyOutput("barPlot4Interactive", height = "600px")
                )
              )
      ),

      # Q5 - Housing Indicators Correlation
      tabItem(tabName = "q5",
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-chart-scatter"), " Katcha Houses vs PMAY Completion"),
                  status = "danger",
                  solidHeader = TRUE,
                  width = 9,
                  plotlyOutput("scatterPlotInteractive", height = "500px")
                ),
                box(
                  title = tags$span(tags$i(class = "fas fa-info"), " Analysis"),
                  status = "info",
                  solidHeader = TRUE,
                  width = 3,
                  tags$div(style = "padding: 15px;",
                           tags$h4("Correlation Analysis"),
                           tags$hr(),
                           tags$div(id = "correlationValue",
                                    style = "font-size: 24px; font-weight: bold; color: #0073b7;",
                                    textOutput("correlation")),
                           tags$br(),
                           tags$p("This shows the relationship between the percentage of katcha houses and completed PMAY houses across selected states."),
                           tags$hr(),
                           tags$h5("Interpretation:"),
                           tags$ul(
                             tags$li("Positive: Both increase together"),
                             tags$li("Negative: Inverse relationship"),
                             tags$li("Near 0: No linear relationship")
                           ))
                )
              ),
              fluidRow(
                box(
                  title = tags$span(tags$i(class = "fas fa-map-marker-alt"), " State Selection"),
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  selectizeInput("selected_state5",
                                 label = "Select states to include in analysis:",
                                 choices = unique(data2$srcStateName),
                                 selected = head(unique(data2$srcStateName), 8),
                                 multiple = TRUE,
                                 options = list(
                                   plugins = list('remove_button'),
                                   create = FALSE,
                                   persist = FALSE
                                 ))
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output, session) {

  # Q1 - Interactive bar plot
  output$barPlotInteractive <- renderPlotly({
    df <- filtered_data_for_Urban %>%
      filter(Country %in% input$selected_countries) %>%
      arrange(desc(Population_Percentage))

    p <- ggplot(df, aes(x = reorder(Country, Population_Percentage),
                        y = Population_Percentage,
                        fill = Population_Percentage,
                        text = paste("Country:", Country,
                                     "<br>Population in Slums:", round(Population_Percentage, 1), "%"))) +
      geom_bar(stat = "identity") +
      scale_fill_gradient(low = "#28a745", high = "#dc3545") +
      labs(x = "", y = "Population in Slums (%)") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            legend.position = "none",
            plot.title = element_text(size = 14, face = "bold")) +
      ggtitle("Percentage of Urban Population Living in Slums")

    ggplotly(p, tooltip = "text") %>%
      layout(hoverlabel = list(bgcolor = "white", font = list(size = 12)))
  })

  output$filteredTableDT <- renderDT({
    datatable(filtered_data_for_Urban %>% filter(Country %in% input$selected_countries),
              options = list(
                pageLength = 10,
                dom = 'Bfrtip',
                buttons = c('copy', 'csv', 'excel', 'pdf')
              ),
              class = 'display nowrap',
              rownames = FALSE,
              filter = 'top',
              extensions = 'Buttons') %>%
      formatStyle('Population_Percentage',
                  background = styleColorBar(filtered_data_for_Urban$Population_Percentage, 'steelblue'),
                  backgroundSize = '100% 90%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center')
  })

  output$totalCountries <- renderInfoBox({
    infoBox(
      "Total Countries",
      length(input$selected_countries),
      icon = icon("globe"),
      color = "blue",
      fill = TRUE
    )
  })

  output$avgPopulation <- renderInfoBox({
    avg <- mean(filtered_data_for_Urban$Population_Percentage[
      filtered_data_for_Urban$Country %in% input$selected_countries
    ], na.rm = TRUE)
    infoBox(
      "Average Slum Population",
      paste0(round(avg, 1), "%"),
      icon = icon("users"),
      color = "green",
      fill = TRUE
    )
  })

  # Q2 - Interactive pie chart
  output$pieChartInteractive <- renderPlotly({
    plot_ly(dfforpiechart, labels = ~Category, values = ~Value, type = 'pie',
            marker = list(colors = c('#FF6B6B', '#4ECDC4'),
                          line = list(color = '#FFFFFF', width = 2)),
            textinfo = 'label+percent',
            hoverinfo = 'text',
            text = ~paste(Category, ': ', round(Value, 1), '%')) %>%
      layout(showlegend = TRUE,
             font = list(family = "Arial", size = 14),
             margin = list(l = 50, r = 50, b = 50, t = 50))
  })

  # Q2B - State-wise bar plot
  output$barPlot2Interactive <- renderPlotly({
    req(input$selected_states, input$selected_variable)

    df <- data2 %>%
      filter(srcStateName %in% input$selected_states) %>%
      arrange(desc(.data[[input$selected_variable]]))

    p <- ggplot(df, aes(x = reorder(srcStateName, .data[[input$selected_variable]]),
                        y = .data[[input$selected_variable]],
                        fill = .data[[input$selected_variable]],
                        text = paste("State:", srcStateName,
                                     "<br>Value:", round(.data[[input$selected_variable]], 2)))) +
      geom_bar(stat = "identity") +
      scale_fill_viridis_c(option = "plasma") +
      labs(x = "", y = input$selected_variable) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            legend.position = "none",
            plot.title = element_text(size = 14, face = "bold")) +
      ggtitle(paste("State-wise Comparison:", input$selected_variable))

    ggplotly(p, tooltip = "text")
  })

  # Q3 - Summary table
  output$summary_table_interactive <- renderDT({
    summary_data <- data2 %>%
      group_by(srcStateName) %>%
      summarise(across(where(is.numeric), mean, na.rm = TRUE)) %>%
      mutate(across(where(is.numeric), ~round(., 2)))

    datatable(summary_data,
              options = list(
                pageLength = 15,
                dom = 'Bfrtip',
                buttons = c('copy', 'csv', 'excel', 'pdf'),
                scrollX = TRUE
              ),
              class = 'display nowrap',
              rownames = FALSE,
              filter = 'top',
              extensions = 'Buttons')
  })

  output$summary_plot_interactive <- renderPlotly({
    numeric_df <- data2 %>%
      select(where(is.numeric)) %>%
      select(-any_of(exclude_cols)) %>%
      pivot_longer(everything(), names_to = "Indicator", values_to = "Value")

    p <- ggplot(numeric_df, aes(x = Value, fill = Indicator)) +
      geom_density(alpha = 0.7) +
      scale_fill_viridis_d() +
      theme_minimal() +
      labs(x = "Value", y = "Density", title = "Distribution of Indicators Across States") +
      theme(legend.position = "bottom",
            legend.text = element_text(size = 8),
            plot.title = element_text(size = 14, face = "bold"))

    ggplotly(p, height = 400) %>%
      layout(legend = list(orientation = "h", y = -0.2))
  })

  # Q4 - Normalized scores
  output$barPlot4Interactive <- renderPlotly({
    req(input$selected_state4)

    df <- data_normalized %>%
      filter(srcStateName %in% input$selected_state4) %>%
      arrange(desc(NormalizedScore))

    p <- ggplot(df, aes(y = reorder(srcStateName, NormalizedScore),
                        x = NormalizedScore,
                        fill = NormalizedScore,
                        text = paste("State:", srcStateName,
                                     "<br>Normalized Score:", round(NormalizedScore, 1), "%"))) +
      geom_bar(stat = "identity", width = 0.7) +
      scale_fill_gradient(low = "#FFE0B2", high = "#FF6B6B") +
      labs(x = "Normalized SDG 11 Score (%)", y = "") +
      theme_minimal() +
      theme(legend.position = "none",
            plot.title = element_text(size = 14, face = "bold"),
            axis.text = element_text(size = 11)) +
      ggtitle("State Performance: Normalized SDG 11 Scores")

    ggplotly(p, tooltip = "text", height = 600) %>%
      layout(xaxis = list(title = "Normalized Score (%)"),
             yaxis = list(title = "", autorange = "reversed"))
  })

  # Q5 - Scatter plot
  output$scatterPlotInteractive <- renderPlotly({
    req(input$selected_state5)

    df <- data2 %>%
      filter(srcStateName %in% input$selected_state5) %>%
      filter(!is.na(`Urban households living in katcha houses (%)`),
             !is.na(`Houses for which construction is complete under Pradhan Mantri Awas Yojana`))

    p <- ggplot(df, aes(x = `Urban households living in katcha houses (%)`,
                        y = `Houses for which construction is complete under Pradhan Mantri Awas Yojana`,
                        color = srcStateName,
                        text = paste("State:", srcStateName,
                                     "<br>Katcha Houses:", round(`Urban households living in katcha houses (%)`, 1), "%",
                                     "<br>PMAY Completed:", `Houses for which construction is complete under Pradhan Mantri Awas Yojana`))) +
      geom_point(size = 4, alpha = 0.7) +
      scale_color_viridis_d() +
      geom_smooth(method = "lm", se = TRUE, color = "black", alpha = 0.2) +
      theme_minimal() +
      labs(x = "Urban households living in katcha houses (%)",
           y = "PMAY Houses Completed",
           title = "Relationship between Katcha Houses and PMAY Completion") +
      theme(legend.position = "bottom",
            plot.title = element_text(size = 14, face = "bold"))

    ggplotly(p, tooltip = "text", height = 500) %>%
      layout(legend = list(orientation = "h", y = -0.2))
  })

  output$correlation <- renderText({
    req(input$selected_state5)
    df <- data2 %>%
      filter(srcStateName %in% input$selected_state5) %>%
      filter(!is.na(`Urban households living in katcha houses (%)`),
             !is.na(`Houses for which construction is complete under Pradhan Mantri Awas Yojana`))

    if (nrow(df) > 1) {
      cor_value <- cor(df[["Urban households living in katcha houses (%)"]],
                       df[["Houses for which construction is complete under Pradhan Mantri Awas Yojana"]],
                       use = "complete.obs")

      cor_color <- ifelse(abs(cor_value) > 0.7, "strong",
                          ifelse(abs(cor_value) > 0.3, "moderate", "weak"))

      paste0(round(cor_value, 3), " (", cor_color, " correlation)")
    } else {
      "Insufficient data for correlation"
    }
  })
}

shinyApp(ui = ui, server = server)
