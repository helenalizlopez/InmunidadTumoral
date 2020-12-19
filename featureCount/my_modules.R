
# Función de normalización
DESeq_normalization <- function(x, y){
  dds <- DESeqDataSetFromMatrix(countData=x, colData=y, design = ~ sample_type)
  dds_raw <- counts(dds)
  dds <- estimateSizeFactors(dds)
  SF <- sizeFactors(dds)
  normalized_counts_median <- counts(dds, normalized=TRUE)
  return(normalized_counts_median)
}


# Función para generar heatmap
heatmap_plot <- function(data){
  heatmap_final <- plot_ly(x=colnames(data), 
                          y=rownames(data), 
                          z = data, 
                          width = 600,
                          height = 6000,
                          color = "Spectral",
                          type = "heatmap") %>%
    layout(margin = list(l=120))
  return(heatmap_final)
}