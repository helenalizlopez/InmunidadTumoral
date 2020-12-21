# Packages

library(MCPcounter)
library(gtools)
library(plotly)
library(Dict)
library(rlang)
library(stringr)
library(DESeq2)
library(RColorBrewer)
library(tidyverse)

all_ = as.matrix(read.csv('./MCPcounter_result_parcial.csv', header=TRUE, row.names=1))
partial_ = as.matrix(read.csv('./MCPcounter_result_completo.csv', header=TRUE, row.names=1))

all_normalized <- apply(all_, MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X)))
partial_normalized <- apply(partial_, MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X)))

u <- shinyUI(
  fluidPage(
    titlePanel("MCP Counter Results"),
    sidebarLayout(
      'Panel',
      position = "left",
      sidebarPanel("sidebar panel",
                   checkboxInput("donum1", "All Variables", value = F),
                   checkboxInput("donum2", "Scaled Matrix", value = F))),
   fluidRow(
     plotly::plotlyOutput('plot', width='2000', height='500'),
     DT::dataTableOutput("table")
     )
   )
)

s <- shinyServer(function(input, output) 
{
  set.seed(123)
  pt1 <- reactive({
    if (!input$donum1) return(NULL)
    return(2)
  })
  pt2 <- reactive({
    if (!input$donum2) return(NULL)
    return(2)
  })
  output$plot = plotly::renderPlotly({ 
    if (is.null(pt1())){ 
      plotly::plot_ly(x=rownames(partial_normalized), 
                      y=colnames(partial_normalized), 
                      z = t(partial_normalized),
                      color = "Spectral",
                      type = "heatmap") %>% layout(margin = list(l=120))
    }else {
      plotly::plot_ly(x=rownames(all_normalized), 
                      y=colnames(all_normalized), 
                      z = t(all_normalized),
                      color = "Spectral",
                      type = "heatmap") %>% layout(margin = list(l=120))
    }
  })
  
  output$table <- DT::renderDataTable(DT::datatable({
    if (is.null(pt1())){
      if (is.null(pt2())){
        data <- partial_
      }else{
        data <- partial_normalized
      }
    }else{
      if (is.null(pt2())){
        data <- all_
      }else{
        data <- all_normalized
      }
    }
    data
    }))
})

  
shinyApp(u,s)
