#installing required packages - uncomment if any installation is required
# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("shinythemes")
# install.packages("shinyWidgets")
# install.packages("leaflet")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("DT")
# install.packages("readxl")
# install.packages("plotly")
# install.packages("tm")
# install.packages("shinyBS")

#loading required libraries
library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(ggplot2)
library(DT)
library(readxl)
library(plotly)
library(tm)
library(shinyBS)

final_mountain_data <- read_excel("final_mountain_data.xlsx")
