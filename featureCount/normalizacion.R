
#####################################################################################################################################
###                                                                                                                               ###
###                                        Segundo fichero: Normalizar los datos                                                  ###
###                                                                                                                               ###
#####################################################################################################################################

## Paquetes

library(DESeq2)
library(tidyverse)
library(data.table)
source('my_modules.R')

                                ###########################################################
                                ###          Solo con los genes de MCPcounter           ###
                                ###########################################################

data = as.matrix(read.csv('input_MCPcounter_parcial.csv', header=TRUE, row.names=1))
data

meta_data = read.csv('SAMPLE_INFO.txt', sep = '\t')
meta_data <- meta_data[-c(3404), ]
meta_data <- meta_data %>% slice(2331:3495)
meta_data <- meta_data %>% select(3, 4, 23)

meta_data_ <- meta_data[-1]
row.names(meta_data_) <- meta_data$sample_name

order <- match(meta_data$sample_name, colnames(data))
final_data <- data[, unlist(order)]

normalized_count <- DESeq_normalization(final_data, meta_data_)

write.csv(normalized_count,'normalized_count_parcial.csv')

                                ###########################################################
                                ###          Con todos los genes de MCPcounter          ###
                                ###########################################################

data = as.matrix(read.csv('input_MCPcounter_completo.csv', header=TRUE, row.names=1))
data

meta_data = read.csv('SAMPLE_INFO.txt', sep = '\t')
meta_data <- meta_data[-c(3404), ]
meta_data <- meta_data %>% slice(2331:3495)
meta_data <- meta_data %>% select(3, 4, 23)

meta_data_ <- meta_data[-1]
row.names(meta_data_) <- meta_data$sample_name

order <- match(meta_data$sample_name, colnames(data))
final_data <- data[, unlist(order)]

normalized_count <- DESeq_normalization(final_data, meta_data_)

write.csv(normalized_count,'normalized_count_completo.csv')



