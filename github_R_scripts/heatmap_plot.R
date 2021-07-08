library(pheatmap)

data<-read.table("heatmap_test.txt", 
                 header = TRUE, sep='\t', row.names = 1, check.names = FALSE)
matrix<-data.matrix(data)
p1<-pheatmap(matrix, cluster_cols = FALSE, cluster_rows = FALSE,
             color = c("white","blue","purple","red"), gaps_row = c(18,33,38,51,64,71), 
             gaps_col = c(1,6,7),
             border_color = "black", 
             cellheight = 10, cellwidth = 16,
             fontsize_col = 16,
             drop_levels = TRUE,
             labels_row = as.expression(newnames_row),
             labels_col = as.expression(newnames_col))
newnames_row <- lapply(
  rownames(data),
  function(x) bquote(bold(.(x))))
newnames_col <- lapply(
  colnames(data),
  function(x) bquote(bold(.(x))))
