# Summiting-Risks-Analyzing-fatalities-in-the-world-s-eight-thousanders.
This project, Summing Risks: Analyzing Fatalities in the World’s Eight-Thousanders, aims to provide actionable insights for mountaineers, expedition organizers, and safety experts regarding the risks associated with climbing the world's highest peaks. By analyzing data on fatalities over the past few decades, the project seeks to uncover patterns in geography, nationality, time frame, and climatic conditions to better inform expedition planning and enhance safety in high-altitude mountaineering.

## Key Features:
1. Interactive Dashboard: Built using R Shiny, the dashboard offers dynamic visualizations to help users explore fatality data across various eight-thousanders.
2. Data-Driven Insights: The dashboard features visualizations related to the number of fatalities, mountain ranges, and seasonal variations in risk, enabling users to make data-driven decisions when planning expeditions.
3. Climatic Data: The analysis also includes climate data, extracted through web scraping and spatial data from ArcGIS, to identify trends related to temperature, snowfall, and precipitation at key mountain locations.

## Target Audience
The primary audience for this project includes mountaineers, expedition organizers, and outdoor enthusiasts. These users may have varying levels of experience and rely on detailed data to make informed decisions regarding the risks associated with climbing high-altitude peaks. Secondary audiences include researchers, safety experts, and organizations involved in mountain rescue and expedition planning.

## Data Sources:

1. Mountain Climbing Accidents Dataset (1985-2023): Includes information about climbers who lost their lives on eight-thousanders, covering details such as nationality, cause of death, and the specific mountain range.
2. List of Mountains in the World Dataset: Provides data on the location and height of the world’s eight-thousanders.
3. City-Specific Climate Data: Includes monthly climate data for cities located near key mountain ranges, which will be used to identify temperature patterns and weather conditions during fatalities.

## Technical Details:
The interactive dashboard was developed using the following technologies and packages:

1. shiny: Framework for building the interactive web application.
2. shinydashboard: Used for creating the clean, professional layout of the dashboard.
3. leaflet: For embedding interactive maps that visualize geographic data.
4. ggplot2 & plotly: To create dynamic visualizations and plots that communicate insights clearly.
5. dplyr: For efficient data manipulation and preprocessing.
6. shinyWidgets: For adding interactive elements to enhance user engagement.
7. readxl: To import Excel data into R.
8. tm: Used for processing text data related to the cause of fatalities.
