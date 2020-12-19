
#####################################################################################################################################
###                                                                                                                               ###
###                                        Primer fichero: preparación de los datos                                               ###
###                                                                                                                               ###
#####################################################################################################################################

# En primer lugar vamos a unificar todos los datos en una matriz 

library(qdapRegex)
# Leer todos los ficheros
dir_list <- list.files('./files',full.names = TRUE)
dir_list[1]

N <- length(dir_list)
x <- list()
for(i in 1:N) {
  print(paste(i,'/',N)
  )
  sample_name <- qdapRegex::ex_between(dir_list[i], './files/', '.RNA-Seq')[[1]]
  pd2 = read.csv(dir_list[i], sep = '\t', header = FALSE)
  values <- list(pd2[,2])
  Ps <- values  
  x[[sample_name]] <- Ps
}

mydf <- data.frame(x)

# Los genes se representarán en las filas y las muestras en las columnas
rownames(mydf) <- pd2[[1]]

my_names <- c()
for (i in dir_list){
  sample_name <- qdapRegex::ex_between(i, './files/', '.RNA-Seq')[[1]]
  print(sample_name)
  my_names <- c(my_names, sample_name)
}
colnames(mydf) <- my_names

#Guardamos la matriz en un csv
write.csv(mydf,'./input_MCPcounter_completo.csv')


#Posteriormente de la matriz anterior filtraremos los genes que aparecen en la libreria de MCPcounter
mcpcounter_genes = read.csv('./genes.txt', sep = '\t', header = TRUE)
mcpcounter_genes

genes_list <- mcpcounter_genes[,1]

#Filtrar
mydf2 <- mydf[rownames(mydf) %in% genes_list, ]

mydf2
colnames(mydf2) <- my_names

#Guardamos la matriz en un archivo
write.csv(mydf2,'./input_MCPcounter_parcial.csv')
