library(ggplot2)
library(reshape2)
library(rcartocolor)

data<-read.table("top_ten_taxa.txt", header = TRUE, row.names = 1,
                 sep= '\t', check.names = FALSE)
var<-read.table("sewage_sequencing_all_samples_metadata.txt", header = TRUE,
                sep ='\t', check.names = FALSE)

melted<-melt(data)
for_plotting<-cbind(melted,var)

safe_pal<-carto_pal(11,"Safe")
p1<-ggplot(for_plotting, aes(x = reorder(as.factor(Collection_date),Days_from_first_sample), value, fill = variable)) + 
  geom_bar(position = "fill",stat = "identity") + 
  scale_fill_manual(values = safe_pal)
p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + labs(x = "Sampling Date", y = "Relative Abundance", fill = "Virus") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
    axis.text.x = element_text(angle = 90, h = 1, v = .5, color = "Black", size=8),
    axis.title = element_text(face = "bold", size = 14))
p5<-p4 + facet_wrap(~Plant_enriched, ncol = 4, scales = "free_x")
p6<-p5 + theme(panel.spacing.x = unit(0, "lines"), panel.border = element_blank(),
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 14),
               legend.title = element_text(face = "bold", size = 14),
               legend.text = element_text(face = "bold", size = 12),
               legend.position = "bottom")
p6