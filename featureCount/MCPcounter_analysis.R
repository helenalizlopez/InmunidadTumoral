

#####################################################################################################################################
###                                                                                                                               ###
###                                      Tercer fichero: Analisis con MCPcounter                                                  ###
###                                                                                                                               ###
#####################################################################################################################################

# Packages

library(MCPcounter)
library(gtools)
library(plotly)
library(Dict)
library(rlang)
library(stringr)
library(DESeq2)
library(frma)
library(RColorBrewer)
library(tidyverse)

###########################################################
###          Solo con los genes de MCPcounter          ###
###########################################################

normalized_count_simple <- read.csv("./normalized_count_parcial.csv", sep = ',', header=TRUE, row.names=1)

# MCPcounter estimate: matrix with abundance estimates from an expression matrix
estimate_output <- MCPcounter.estimate(normalized_count_simple, featuresType = "HUGO_symbols")
estimate_output_matrix = data.matrix(estimate_output)

# Se transpone para que la visualización sea más sencilla
transposed_matrix <- t(estimate_output_matrix)
write.csv(normalized_count,'MCPcounter_result_parcial.csv')

final_output <- apply(transposed_matrix, MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X)))

# Visualización final: heatmap
plot1 <- plot_ly(x=colnames(final_output), 
                        y=rownames(final_output), 
                        z = final_output, 
                        width = 600,
                        height = 6000,
                        color = "Spectral",
                        type = "heatmap") %>%
  layout(margin = list(l=120))
plot1


###########################################################
###          Solo con los genes de MCPcounter          ###
###########################################################

normalized_count_simple <- read.csv("./normalized_count_completo.csv.csv", sep = ',', header=TRUE, row.names=1)


estimate_output <- MCPcounter.estimate(normalized_count_simple, featuresType = "HUGO_symbols")
estimate_output_matrix = data.matrix(estimate_output)
transposed_matrix <- t(estimate_output_matrix)
write.csv(normalized_count,'MCPcounter_result_completo.csv')


final_output <- apply(transposed_matrix, MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X)))

plot1 <- plot_ly(x=colnames(final_output), 
                 y=rownames(final_output), 
                 z = final_output, 
                 width = 600,
                 height = 6000,
                 color = "Spectral",
                 type = "heatmap") %>%
  layout(margin = list(l=120))
plot1
