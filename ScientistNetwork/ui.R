#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Network Analysis of Network Scientists"),
  helpText("The network represents coauthorship between network scientists. Each node represents a network scientist and the edges represent collaboration between network scientists. The size of each node represents a centrality measure, and the thickness of each edge represents the frequency of collaborations between two scientists."),
  hr(),
  
  sidebarLayout(
      sidebarPanel(
          selectInput('centrality',"Type of Centrality:",centralitytypes),
          sliderInput('spread',"Spread of the Network:",
                      min = -3,max = 3,value = 0,step = 1),
          sliderInput('opacity',"Opacity of the Network:",
                      min = 0, max = 1,value = 0.9),
          numericInput('font',"Font Size of the Names:",
                       min = 8, value = 14),
          submitButton(text="Apply Changes"),
          hr(),
          em("Created by Jun Taek Lee"),
          br(),
          em("Reference:"),
          br(),
          em("M. E. J. Newman, Phys. Rev. E 74, 036104 (2006)"),
          width=3
      ),
      mainPanel(
          forceNetworkOutput('plot')
  )
  )
))
