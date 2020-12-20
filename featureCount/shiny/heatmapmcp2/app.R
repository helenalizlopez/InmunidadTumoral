

library(plotly)
library(RColorBrewer)
########################################################################
##                                                                    ##
##              prueba 1: Solo con los genes de MCPcounter            ##
##                                                                    ##
########################################################################

options(repos = BiocManager::repositories())

getwd()

aa <- read.csv("./mymatrix.txt", sep = ' ')

aa <- as.matrix(aa)
ui = shinyUI(fluidPage(plotly::plotlyOutput('plot', width='100%', height='100%')))

server = shinyServer(function(input, output, session) {
    output$plot = plotly::renderPlotly({ plotly::plot_ly(x=colnames(aa), 
                                                         y=rownames(aa), 
                                                         z = aa, 
                                                         width = 600,
                                                         height = 6000,
                                                         color = "Spectral",
                                                         type = "heatmap") %>% layout(margin = list(l=120))})
})

shinyApp(ui, server)
