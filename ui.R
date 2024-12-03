#defining the ui
dashboardPage(
  dashboardHeader(
    title = tags$b("Summiting Risks")
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("home")),
      menuItem("Visualizations", tabName = "visualizations", icon = icon("chart-bar")),
      menuItem("Data", tabName = "data", icon = icon("table"))
    )
  ),
  dashboardBody(
    #CSS
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: white;
        }
        .death-text {
          font-size: 24px;
          text-align: center;
        }
        .leaflet-container {
          height: 600px !important;
        }
        .red-number {
          color: red;
        }
        .selectize-dropdown-content {
          z-index: 1001 !important;
        }
        .leaflet-tooltip {
        border: none !important;
        }
      "))
    ),
    tabItems(
      tabItem(tabName = "overview",
              fluidRow(
                column(width = 12,
                       h3(tags$b("Objective:")),
                       p("This interactive dashboard empowers you, the ambitious eight-thousander climber, to make data-driven decisions and prioritize safety during your expedition."),
                       h3(tags$b("Exploration:")),
                       p("We delve into historical data on climber fatalities on eight-thousanders, revealing a concerning upward trend over the past few decades. As the allure of these peaks attracts more climbers each year, understanding the risks associated with these expeditions becomes even more critical."),
                       plotOutput("static_plot", height = "500px"),
                       h3(tags$b("Key Findings:")),
                       p("1. Geographical Location: Certain mountains, such as Everest, K2, and Manaslu, emerge as hotspots for fatalities, highlighting the need for targeted safety measures in these areas."),
                       p("2. Weather Conditions: Temperature plays a significant role, with both extremely cold and warm temperatures contributing to fatalities."),
                       p("3. Climber Nationality: Trends in fatalities among climbers from specific nationalities suggest the need for culturally relevant safety protocols in their native languages."),
                       p("4. Preparation and Facilities: The availability of medical facilities and support infrastructure in a climber's home country can influence their preparedness for potential emergencies."),
                       h3(tags$b("Motivation:")),
                       p("Driven by a passion for mountaineering and a deep concern for climber safety, this project aims to equip you with crucial insights. This knowledge empowers you and other stakeholders, including expedition leaders and policymakers, to minimize risks and maximize successful ascents."),
                       h3(tags$b("Target Audience:")),
                       p("This dashboard is specifically designed for expedition groups planning to climb eight-thousanders. Beyond the thrill of conquering these peaks, these climbers understand the inherent dangers. This data provides them with the knowledge to approach these challenges with a clear-eyed understanding of the risks involved. Eight-thousander climbers are driven by a potent mix of ambition, determination, and a deep love for the mountains. They are meticulous planners, constantly seeking ways to improve their skills and knowledge. However, the allure of the summit can sometimes overshadow potential risks."),
                       h3(tags$b("Criticality of the Dashboard:")),
                       p("This dashboard bridges the gap between ambition and safety. By providing data-driven insights into historical fatalities, it empowers climbers to make informed decisions about their expeditions. This knowledge helps them mitigate risks, select the safest routes and seasons, and ultimately, increase their chances of a successful and safe summit.")
                )
              )
      ),
      tabItem(tabName = "visualizations",
              fluidRow(
                column(width = 12,
                       h3(tags$b("Climb Smart, Climb Safe: Prepare for Your Expedition with Data-Driven Insights")),
                       p("This section contains interactive visual representations related to mountain climbing risks.")
                )
              ),
              fluidRow(
                column(width = 4,
                       box(
                         title = tagList(icon("globe", style = "font-size: 24px; margin-right: 10px;"), "No. of Eight-Thousanders in the World:"),
                         solidHeader = FALSE,
                         width = NULL,
                         height = NULL,
                         background = "navy",
                         div(style = "font-size: 22px; text-align: center; font-weight: bold;", "14")
                       )
                ),
                column(width = 4,
                       box(
                         title = tagList(icon("heartbeat", style = "font-size: 24px; margin-right: 10px;"), "Fatality Rate in Eight-Thousanders in '22:"),
                         solidHeader = FALSE,
                         width = NULL,
                         height = NULL,
                         background = "navy",
                         div(style = "font-size: 22px; text-align: center; font-weight: bold;", "3%")
                       )
                ),
                column(width = 4,
                       box(
                         title = tagList(icon("calendar", style = "font-size: 24px; margin-right: 10px;"), "Dashboard Date Range:"),
                         solidHeader = FALSE,
                         width = NULL,
                         height = NULL,
                         background = "navy",
                         div(style = "font-size: 22px; text-align: center; font-weight: bold;", "2019 - 2023")
                       )
                )
              ),
              fluidRow(
                column(width = 3,
                       selectInput("mountain_select", "Select a Mountain:", 
                                   choices = c("All", 
                                               unique(final_mountain_data$mountain_name)
                                               ),
                                   selected = "All"),
                       bsTooltip(id = "mountain_select", title = "Select a mountain for your expedition to see specific information.", 
                                 placement = "right", trigger = "hover"),
                       # tags$hr(),
                       
                       h4(tags$b("User Guide:")),
                       p("1. Start at Peak: Overview tab - understand the data & climbing risks."),
                       p("2. Choose Your Climb: Use the filter dropdown to view the 14 ranges. Alternatively, hover on mountains on the map."),
                       p("3. Click to Confirm: Select your mountain (filter or map), click to confirm."),
                       p("4. Weather Patterns: Analyze the scatter plot to understand dangerous temperature ranges."),
                       p("5. Seasonal Risks: Hover over petals in the rose plot to see fatality causes by month. Double-click on a specific cause in the legend to focus on its occurrences."),
                       p("6. Climber Nationalities: Hover over the bubbles plot to see nationalities of deceased climbers. Choose a cause of death in the filter to see which nationalities are more susceptible to that cause."),
                       p("7. Explore More: Choose a new mountain from the filter. Select 'All' in the filter to reset the map view."),
                       p("Tip: Use the zoom function on the map for a closer look.")
                ),
                column(width = 9,
                       leafletOutput("world_map"),
                       div(style = "border: 1px solid #ccc; padding: 10px; border-radius: 5px;",
                           bsTooltip(id = "world_map", title = "Click on a circle marker to choose a mountain. Select All from the filter on the left to Zoom Out.", 
                                     placement = "top", trigger = "hover"))
                )
              ),
              fluidRow(
                column(width = 12,
                       div(textOutput("total_deaths_text"), class = "death-text")
                )
              ),
              fluidRow(
                column(width = 6,
                       h3(tags$b("Expedition Risk by Temperature")),
                       p("Minimize Risk by identifying fatal temperatures."),
                       div(style = "border: 1px solid #ccc; padding: 10px; border-radius: 5px;",
                           
                           plotOutput("plot", height = "500px")
                       )
                ),
                column(width = 6,
                       h3(tags$b("Monthly Climbing Risk & Fatalities")),
                       p("Analyze monthly fatality trends & leading causes of fatalities."),
                       div(style = "border: 1px solid #ccc; padding: 10px; border-radius: 5px;",
                           bsTooltip(id = "rose_plot", title = "Double-click an option on the legend to select only that cause. Single-click to deselct a cause.", 
                                     placement = "left", trigger = "hover"),
                           plotlyOutput("rose_plot", height = "500px")
                       )
                )
              ),
              fluidRow(
                column(width = 12,
                       h3(tags$b("Nationalities with Highest Fatality Rates")),
                       p("Explore fatality trends by nationality and cause to better prepare for your climb."),
                       div(style = "border: 1px solid #ccc; padding: 10px; border-radius: 5px;",
                           selectInput("cause_of_death_select", "Select Cause of Death:",
                                       choices = c("All", 
                                                   unique(final_mountain_data$cause_of_death)
                                                   ),
                                       selected = "All"),
                           bsTooltip(id = "cause_of_death_select", title = "Select a fatality cause and analyze nationalities that are sussepitible to specific causes.", 
                                     placement = "right", trigger = "hover"),
                           plotlyOutput("bubble_plot", height = "500px"),
                       )
                )
              ),
              fluidRow(
                column(width = 12,
                       h3(tags$b("Expedition Planning Guide")),
                       p("Use the insights from the dashboard to plan your expedition effectively."),
                       br(),
                       fluidRow(
                         column(width = 4,
                                align = "center",
                                icon("map-marked-alt", size = 50),
                                h4("Mountain Selection"),
                                p("Tailor your expedition strategy to the specific risks and conditions of your target mountain.")
                         ),
                         column(width = 4,
                                align = "center",
                                icon("calendar-alt", size = 50),
                                h4("Seasonal Planning"),
                                p("Consider the seasonal trends to pick the optimal month for your climb.")
                         ),
                         column(width = 4,
                                align = "center",
                                icon("thermometer-full", size = 50),
                                h4("Temperature Analysis"),
                                p("Analyze temperature data to ensure safe climbing conditions.")
                         )
                       )
                )
              )
      ),
      tabItem(tabName = "data",
              fluidRow(
                column(width = 12,
                       h3(tags$b("Data Overview")),
                       p("The data was collected from two sources:a database of over 1,700 climber deaths on eight-thousanders (including mountain name, climber details, and fatality specifics) and a separate dataset with mountain characteristics (height, location). The ArcGIS API was used to pinpoint mountain locations, and the Open-Meteo API incorporated historical weather data (temperature, precipitation) for each peak."),
                       br(),
                       p(tags$b("Source:")),
                       p("1. Mountain Climbing Accidents Dataset:"),
                       tags$a(href = "https://www.kaggle.com/datasets/asaniczka/mountain-climbing-accidents-dataset/data", "Kaggle Dataset"),
                       br(),
                       br(),
                       p("2. List of Eight-thousanders in the World:"),
                       tags$a(href = "https://www.kaggle.com/datasets/codefantasy/list-of-mountains-in-the-world", "Kaggle Dataset"),
                       br(),
                       br(),
                       p("3. Mountain Location Data:"),
                       tags$a(href = "https://developers.arcgis.com/rest/", "ArcGIS Developers Documentation"),
                       br(),
                       br(),
                       p("4. Historical Weather Data for each peak:"),
                       tags$a(href = "https://open-meteo.com/en/docs/historical-weather-api#latitude=28&longitude=84", "Historical Weather API"),
                       br(),
                       br(),
                       dataTableOutput("data_table"),
                )
              )
      )
    )
  )
)