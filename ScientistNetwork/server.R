#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  nodeData <- reactive({
      if (input$centrality=="Closeness") {
          centrality <- sapply(c(1:dim(network$nodes)[1]),
                               function(x) 
                                   1/(sum(network$links$value[network$links$source==x])+
                                          sum(network$links$value[network$links$target==x])))
          centrality[which(is.infinite(centrality))] <- min(centrality)
          centrality <- (centrality/min(centrality))+9
      } else if (input$centrality=="Degree") {
          centrality <- sapply(c(1:dim(network$nodes)[1]),
                               function(x)
                                   length(network$links$value[network$links$source==x])+
                                   length(network$links$value[network$links$target==x]))
          centrality <- (centrality+1)/min(centrality+1)+10
      } else if (input$centrality=="Eigenvalue") {
          centrality <- eigen(adjacency)
          centrality <- log(centrality$vectors[,1]+10)
          centrality <- (centrality/min(centrality))^180*10
      } else {
          centrality <- rep(10,dim(network$nodes)[1])
      }
      nodes <- network$nodes
      nodes$size <- centrality
      nodes
  })
  
  linkData <- reactive({
      network$links
  })
  
  output$plot <- renderForceNetwork({
      nodes <- nodeData()
      links <- linkData()
      links$value <- links$value/min(links$value)
      forceNetwork(Links = links, Nodes = nodes,
                   Source = "source", Target = "target",
                   Value = "value", Group = "group",
                   NodeID = "label", Nodesize = "size", 
                   opacity = input$opacity,zoom = T,
                   fontSize = input$font,
                   charge = input$spread-4,radiusCalculation =  JS("d.nodesize"))
  })
})
