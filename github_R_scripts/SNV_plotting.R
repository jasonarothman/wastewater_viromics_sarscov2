library("gggenes")
library("ggplot2")
library("viridis")
library("patchwork")

data<-read.table("gggenes_test.txt", header = TRUE, sep = '\t')

pg1<-ggplot2::ggplot(data, ggplot2::aes(xmin = start, xmax = end, y = molecule,
                                        fill = gene, label = gene)) +
  theme_genes()+
  geom_gene_arrow(size =1, 
                  arrow_body_height = grid::unit(6,"mm"),
                  arrowhead_height = grid::unit(6,"mm"),
                  arrowhead_width = grid::unit(0,"mm")) +
  geom_gene_label(grow = FALSE) +
  ggplot2::scale_fill_brewer(palette = "Spectral") +
  
  theme(axis.title.x = element_text(face = "bold", size = 16),
        legend.text = element_text(face = "bold", size = 12),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        plot.margin = margin(-100,0,0,0, unit = "pt"),
        legend.title  = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face = "bold", size = 14, color = "black"),
        aspect.ratio = 1/9,
        legend.position = "none",
        panel.grid.major.y = element_blank()) +
  xlab("Genomic Position")

depth<-read.table("sars_cov2_genome_depth.txt", header = TRUE,sep = '\t')
p1<-ggplot(depth, aes(x = Position, y = Depth))+
  geom_area(fill = "black")
p2<- p1 + theme_bw()
p3<-p2 + theme(
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank())
p4<-p3 
p4<-p3 + ylab("Reads Per Base")  +
  theme(axis.title.x = element_blank(), 
        axis.title.y = element_text(face = "bold", size = 14), 
        legend.title  = element_text(face = "bold"), 
        axis.text.x = element_blank(),
        axis.text.y = element_text(face = "bold", size = 12, color = "black"),
        axis.ticks.x = element_blank()) +
  scale_y_continuous(n.breaks = 10, limits = c(0,2800),expand = c(0.001,0.001))

pcombined<-p4/pg1

snvs<-read.table("seq.txt", header = TRUE, sep = '\t')

ps1<-ggplot(snvs, aes(x = Position, y= (snvs$Times_greater_than_50pct/14))) + 
  geom_area(color= "black")   

ps2<-ps1 + theme_bw()
ps3<-ps2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
ps4<-ps3
ps5<-ps4 + theme(axis.title.x = element_blank(),
                 legend.text = element_text(face = "bold", size = 12),
                 axis.title.y = element_text(face = "bold", size = 14), 
                 legend.title  = element_text(face = "bold", size = 14),
                 axis.text.y = element_text(face = "bold", size = 12, color = "black"),
                 axis.text.x = element_blank(),
                 axis.ticks.x = element_blank())+
  scale_y_continuous(
    limits = c(0,0.85), expand = c(0.001,0.001)) + 
  expand_limits(y = 1)+
  ylab("Proportion of samples SNV detected")

pcombined<-p4/ps5/pg1 + patchwork::plot_layout(widths = 2)