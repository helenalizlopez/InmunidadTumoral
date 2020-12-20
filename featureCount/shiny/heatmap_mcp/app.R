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

########################################################################
##                                                                    ##
##              prueba 1: Solo con los genes de MCPcounter            ##
##                                                                    ##
########################################################################

options(repos = BiocManager::repositories())

getwd()

## LOAD FEATURE COUNTS
prueba1 = as.matrix(read.csv('./input_MCPcounter_2.csv', header=TRUE, row.names=1))

## LOAD METADA
meta = read.csv('./SAMPLE_INFO.txt', sep = '\t')

## MATCH DATA & METADATA ORDER
meta <- meta[-c(3404), ]
meta <- meta %>% slice(2331:3495)
meta <- meta %>% select(3, 4, 23)
result <- meta[-1]
row.names(result) <- meta$sample_name
order <- match(meta$sample_name, colnames(prueba1))
data <- prueba1[, unlist(order)]

# MEDIAN NORMALIZATION
dds <- DESeqDataSetFromMatrix(countData=data, colData=result, design = ~ sample_type)
dds_raw <- counts(dds)
dds <- estimateSizeFactors(dds)
SF <- sizeFactors(dds)
normalized_counts_median <- counts(dds, normalized=TRUE)

## ESTIMATE
first_output_HUGO <- MCPcounter.estimate(normalized_counts_median, featuresType = "HUGO_symbols")

matrix_HUGO = data.matrix(first_output_HUGO)

# TRANSPOSE MATRIX
transposed_matrix <- t(matrix_HUGO)

# CHANGE RANGE OF VALUES
aa <- apply(transposed_matrix, MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X)))

# HEATMAP
cols <- brewer.pal(11, "Spectral")
p_133P2_HUGO <- plot_ly(x=colnames(aa), 
                        y=rownames(aa), 
                        z = aa, 
                        width = 600,
                        height = 6000,
                        color = "Spectral",
                        type = "heatmap") %>%
    layout(margin = list(l=120))
p_133P2_HUGO


ui = shinyUI(fluidPage(plotly::plotlyOutput('plot', width='100%', height='100%')))

server = shinyServer(function(input, output, session) {
    output$plot = plotly::renderPlotly({ plotly::plot_ly(x=colnames(aa), 
                                                         y=rownames(aa), 
                                                         z = aa, 
                                                         width = 600,
                                                         height = 6000,
                                                         color = "Spectral",
                                                         type = "heatmap") %>%
            layout(margin = list(l=120))})
})

shinyApp(ui, server)
