source("global.R")

function(input, output, session) {
  
  # Value for reactive mountain feature
  selected_mountain <- reactiveVal(NULL)
  
  # Sample data table in the data tab
  output$data_table <- renderDataTable({
    final_mountain_data
  })
  
  output$static_plot <- renderPlot({
    # Static plot
    final_mountain_data$year <- as.numeric(format(as.Date(final_mountain_data$date), "%Y"))
    filtered_data <- final_mountain_data %>%
      filter(year >= 1940)
    
    ggplot(filtered_data, aes(x = year)) +
      geom_line(stat = "count", color = "navyblue") +
      labs(title = "Number of Deaths Over Time",
           x = "Year",
           y = "Number of Deaths") +
      scale_x_continuous(breaks = seq(1940, max(filtered_data$year), by = 10))
  })
  
  # take input from dropdown menu
  observeEvent(input$mountain_select, {
    if (input$mountain_select == "All") {
      selected_mountain(NULL)
    } else {
      selected_mountain(input$mountain_select)
    }
  })
  
  # Calculating total deaths
  total_deaths <- reactive({
    req(final_mountain_data)
    req(selected_mountain())
    if (is.null(selected_mountain())) {
      # if there is no selection
      sum(!duplicated(final_mountain_data$climber_name))
    } else {
      # if there is a mountain selection
      sum(final_mountain_data$mountain_name == selected_mountain())
    }
  })
  
  # rendering text
  output$total_deaths_text <- renderText({
    if (is.null(selected_mountain())) {
      paste("Total Deaths:", total_deaths())
    } else {
      paste("Total Deaths in", selected_mountain(), ":", total_deaths())
    }
  })
  
  # Render total number of deaths text
  output$total_deaths_text <- renderText({
    if (is.null(selected_mountain())) {
      total_deaths_text <- paste("Total number of deaths in all mountains: ", total_deaths())
    } else {
      total_deaths_text <- paste("Total number of deaths in ", selected_mountain(), ": ", total_deaths())
    }
  })
  
  # Reactive dataset for month and cause - nightingale rose plot
  deaths_by_month_and_cause <- reactive({
    req(final_mountain_data)
    if (is.null(selected_mountain())) {
      deaths_by_month_and_cause <- final_mountain_data %>%
        group_by(month, cause_of_death) %>%
        summarise(Number_of_Deaths = n_distinct(climber_name))
    } else {
      deaths_by_month_and_cause <- final_mountain_data %>%
        filter(mountain_name == selected_mountain()) %>%
        group_by(month, cause_of_death) %>%
        summarise(Number_of_Deaths = n_distinct(climber_name))
    }
    deaths_by_month_and_cause
  })
  
  # rendering rose plot
  output$rose_plot <- renderPlotly({
    colors <- c("blue", "red", "green", "orange", "purple", "yellow")
    
    fig <- plot_ly() %>%
      add_trace(
        data = deaths_by_month_and_cause(),
        r = ~Number_of_Deaths,
        theta = ~month,
        type = "barpolar",
        color = ~cause_of_death,
        colors = colors,
        hovertemplate = paste('Deaths: %{r}',
                              '<br>Month: %{theta}'
        ),
        text = ~cause_of_death
      ) %>%  
      layout(
        legend = list(title = list(text = 'Case of Death')), 
        polar = list(angularaxis = list(
          rotation = 90,
          direction = 'clockwise',
          period = 12,
          showticklabels = TRUE
        )),
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        legend = list(
          x = 1,
          y = 1,
          xanchor = "right",
          yanchor = "top")
      ) 
    fig
  })
  
  # rendering plot
  output$plot <- renderPlot({
    if (is.null(selected_mountain())) {
      # If no mountain is selected, show data for all mountains
      temp_deaths <- final_mountain_data %>%
        group_by(temperature) %>%
        summarise(num_deaths = n_distinct(climber_name), .groups = 'drop')
    } else {
      # if mountain is selected
      mountain_data <- final_mountain_data %>%
        filter(mountain_name == selected_mountain())
      
      # summarising data
      temp_deaths <- mountain_data %>%
        group_by(temperature) %>%
        summarise(num_deaths = n_distinct(climber_name), .groups = 'drop')
    }
    
    ggplot(temp_deaths, aes(x = temperature, y = num_deaths)) +
      geom_point(color = "red") +
      labs(title = ifelse(is.null(selected_mountain()), "Scatter Plot of Temperature vs. Number of Deaths for All Mountains", paste("Scatter Plot of Temperature vs. Number of Deaths for", selected_mountain())),
           x = "Temperature in Degree Celcius",
           y = "Number of Deaths")
  })
  
  # rendering map
  output$world_map <- renderLeaflet({
    data_summary <- final_mountain_data %>%
      group_by(mountain_name, mountain_latitude, mountain_longitude) %>%
      summarise(num_deaths = n())
    
    max_deaths <- max(data_summary$num_deaths)
    ranges <- c(10, 80, max_deaths)
    
    # creating map using leaflet
    leaflet(data = data_summary) %>%
      addTiles() %>%
      #center coordinates
      setView(lng = 88.14739, lat = 27.70314, zoom = 5) %>% 
      addCircleMarkers(
        lng = ~mountain_longitude,
        lat = ~mountain_latitude,
        radius = ~sqrt(num_deaths)/3 * 3,
        color = "red",
        stroke = FALSE,
        fillOpacity = 0.8,
        label = ~paste("Mountain Name:", mountain_name),
        group = "mountain_markers"
      ) %>%
      addLegendCustom(ranges)
  })
  
  # Marker click event
  observeEvent(input$world_map_marker_click, {
    event <- input$world_map_marker_click
    if (!is.null(event)) {
      lat <- event$lat
      lng <- event$lng
      
      # filter the mountain
      selected_mountain_data <- final_mountain_data %>%
        filter(mountain_latitude == lat & mountain_longitude == lng)
      # extract name
      selected_mountain_name <- selected_mountain_data$mountain_name[1]
      selected_mountain(selected_mountain_name)
      # automatic update to the filter
      updateSelectInput(session, "mountain_select", selected = selected_mountain_name)
    } else {
      selected_mountain(NULL)
    }
  })
  
  # reactive dataset for nationalities - bubble plot
  climber_nationality_data <- reactive({
    req(final_mountain_data)
    if (is.null(selected_mountain())) {
      if (input$cause_of_death_select == "All") {
        nationality_data <- final_mountain_data %>%
          group_by(climber_nationality) %>%
          summarise(number_of_climbers = n_distinct(climber_name), .groups = 'drop')
      } else {
        nationality_data <- final_mountain_data %>%
          filter(cause_of_death == input$cause_of_death_select) %>%
          group_by(climber_nationality) %>%
          summarise(number_of_climbers = n_distinct(climber_name), .groups = 'drop')
      }
    } else {
      if (input$cause_of_death_select == "All") {
        nationality_data <- final_mountain_data %>%
          filter(mountain_name == selected_mountain()) %>%
          group_by(climber_nationality) %>%
          summarise(number_of_climbers = n_distinct(climber_name), .groups = 'drop')
      } else {
        nationality_data <- final_mountain_data %>%
          filter(mountain_name == selected_mountain() & cause_of_death == input$cause_of_death_select) %>%
          group_by(climber_nationality) %>%
          summarise(number_of_climbers = n_distinct(climber_name), .groups = 'drop')
      }
    }
    nationality_data
  })
  
  # rendering bubble plot
  output$bubble_plot <- renderPlotly({
    plot_ly(
      data = climber_nationality_data(),
      x = ~climber_nationality,
      y = ~number_of_climbers,
      type = 'scatter',
      mode = 'markers',
      marker = list(
        size = ~sqrt(number_of_climbers) * 10,
        color = ~number_of_climbers,
        colorscale = 'Viridis',
        showscale = TRUE
      ),
      text = ~paste("Nationality:", climber_nationality, "<br>Climbers:", number_of_climbers),
      hoverinfo = 'text'
    ) %>%
      layout(
        title = "Bubble Plot of Climber Nationality",
        xaxis = list(title = "Climber Nationality", showgrid = FALSE),
        yaxis = list(title = "Number of Climbers", showgrid = FALSE),
        showlegend = FALSE
      )
  })
  
  # zoom functionality
  observe({
    req(final_mountain_data)
    req(selected_mountain())
    if (!is.null(selected_mountain())) {
      # filter for selected mountains
      selected_mountain_coords <- final_mountain_data %>%
        filter(mountain_name == selected_mountain()) %>%
        select(mountain_latitude, mountain_longitude) %>%
        distinct()
      # zooming
      if (!is.null(selected_mountain_coords$mountain_latitude) && !is.null(selected_mountain_coords$mountain_longitude)) {
        leafletProxy("world_map") %>%
          setView(lng = selected_mountain_coords$mountain_longitude, lat = selected_mountain_coords$mountain_latitude, zoom = 12)
      }
    }
  })
  # zoom out on 'All'
  observeEvent(input$mountain_select, {
    req(final_mountain_data)
    if (input$mountain_select == "All") {
      leafletProxy("world_map") %>%
        setView(lng = 88.14739, lat = 27.70314, zoom = 5)
    }
  })
  # map pop up for selected mountain
  observeEvent(input$mountain_select, {
    req(final_mountain_data)
    if (input$mountain_select != "All") {
      selected_mountain_data <- final_mountain_data %>%
        filter(mountain_name == input$mountain_select) %>%
        distinct(mountain_name, mountain_location, mountain_latitude, mountain_longitude)
      leafletProxy("world_map") %>%
        clearPopups() %>%
        addPopups(
          lng = selected_mountain_data$mountain_longitude,
          lat = selected_mountain_data$mountain_latitude,
          popup = paste("<b>Mountain Name:</b> ", selected_mountain_data$mountain_name, "<br>",
                        "<b>Country:</b> ", selected_mountain_data$mountain_location)
        )
    } else {
      leafletProxy("world_map") %>%
        #removing popups
        clearPopups()
    }
  })
  
  # function for circle markers legend
  addLegendCustom <- function(map, ranges) {
    legend_html <- paste0("
  <div style='background-color: white; padding: 10px; border-radius: 5px;'>
    <h4>Number of Deaths</h4>
    <div style='display: flex; align-items: center;'>
      <div style='width: ", sqrt(ranges[1]) * 2, "px; height: ", sqrt(ranges[1]) * 2, "px; background-color: red; border-radius: 50%; margin-right: 10px;'></div>
      <span>< 50</span>
    </div>
    <div style='display: flex; align-items: center; margin-top: 5px;'>
      <div style='width: ", sqrt(ranges[2] - ranges[1]) * 2, "px; height: ", sqrt(ranges[2] - ranges[1]) * 2, "px; background-color: red; border-radius: 50%; margin-right: 10px;'></div>
      <span>51 - 100</span>
    </div>
    <div style='display: flex; align-items: center; margin-top: 5px;'>
      <div style='width: ", sqrt(ranges[3] - ranges[2]) * 2, "px; height: ", sqrt(ranges[3] - ranges[2]) * 2, "px; background-color: red; border-radius: 50%; margin-right: 10px;'></div>
      <span>> 101 </span>
    </div>
  </div>
  ")
    
    addControl(map, html = legend_html, position = "bottomright")
  }
  
}

