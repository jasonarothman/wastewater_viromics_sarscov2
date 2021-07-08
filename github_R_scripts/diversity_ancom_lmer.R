library(vegan)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lmerTest)
library(reshape2)

#Reading in data, diversity analyses
data<-read.table("unenriched_samples_virus_counts_table.txt", 
                 header = TRUE, sep = '\t', quote = "", row.names = 1)

data<- data[complete.cases(data), ]

column_sums <- colSums(data)
data_norm <- apply(data, 1, '/', column_sums)

data_nmds <- metaMDS(data_norm, distance = 'bray', autotransform = F, 
                     k = 2, noshare = F, trymax = 100, parallel = 6)
nmds_scores<-scores(data_nmds)
nmds_df<-as.data.frame(nmds_scores)
var<-read.table("unenriched_samples_metadata.txt", header = TRUE, row.names = 1, sep ='\t')
attach(var)
for_plotting<-cbind(nmds_df, var)

p1<-ggplot(for_plotting, aes(NMDS1, NMDS2, color = Plant)) + 
  geom_point(color= "black", size = 2.5) + 
  geom_point(aes(color=Plant), size=2) + 
  scale_color_brewer(palette = "Dark2")

p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + stat_ellipse()
p5<-p4 + theme(axis.title.y = element_text(face = "bold", size = 16), 
               axis.title.x = element_text(face = "bold", size = 16), 
               legend.title  = element_text(face = "bold", size = 16),
               legend.text = element_text(face = "bold", size = 14),
               axis.text.y = element_text(face = "bold", size = 12, color = "black"),
               axis.text.x = element_text(face = "bold", size = 12, color = "black", 
                                          v = 1, h = 0.5),
               panel.grid.major = element_line(),
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 12, color = "black"))
p5

bray<- vegdist(data_norm, method = 'bray')

ad<-adonis(data_norm ~ Plant, 
           data = var, parallel = 4, 
           method = "bray")
ad

shannon<-diversity(data_norm, index = "shannon")

for_plotting<-cbind(nmds_df,var,shannon)
p1<-ggplot(for_plotting, aes(x=Plant, y=shannon, fill = Plant)) + 
  geom_boxplot(color= "black", outlier.shape = NA, size = 1) +
  scale_fill_brewer(palette = "Dark2")
p2<- p1 + theme_bw()
p3<-p2 + theme(panel.grid.minor = element_blank())
p4<-p3 + ylab("Shannon Index") + xlab("Wastewater Treatment Plant") +
  theme(axis.title.y = element_text(face = "bold", size = 16), 
        axis.title.x = element_text(face = "bold", size = 16), 
        legend.title  = element_text(face = "bold", size = 16),
        legend.text = element_text(face = "bold", size = 14),
        axis.text.y = element_text(face = "bold", size = 12, color = "black"),
        axis.text.x = element_text(face = "bold", size = 12, color = "black", 
                                   v = 1, h = 0.5),
        panel.grid.major = element_line(),
        strip.background = element_blank(),
        strip.text = element_text(face = "bold", size = 12, color = "black"))
p4

shapiro.test(shannon)
hist(shannon)
qqnorm(shannon)

shannon_aov<-aov(shannon~Plant, data = for_plotting)
shannon_aov
summary(shannon_aov)
TukeyHSD(shannon_aov)

bray.df<-as.data.frame(as.matrix(bray))
bray_means<-as.data.frame(((rowMeans(bray.df))))
names(bray_means)[1]<-"Dissimilarity"

#Longitudinal diversity analyses.
plant_alpha_lm<-lmer(shannon~Days_from_first_sample + (1|Plant), data = for_plotting)
summary(plant_alpha_lm)

plant_beta_lm<-lmer(Dissimilarity~Days_from_first_sample + (1|Plant), data = for_plotting)
summary(plant_beta_lm)

#Longitudinal LMERs on individual viruses.
data_norm<-t(data_norm)
data_norm<-as.data.frame(data_norm)
data_norm$mean<-rowMeans(data_norm)
data_norm <-data_norm %>%
  rownames_to_column("Sample") %>%
  filter(data_norm$mean > 0.0001) %>%
  subset(., select = -c(mean))
data_norm = setNames(data.frame(t(data_norm[,-1])),data_norm[,1])

melted<-melt(data_norm)

lmertest<-melted %>%
  split(.$variable) %>%
  map(~lmer(value ~ Days_from_first_sample + (1|Plant), data = .)) %>%
  map(summary) %>% 
  map(coef)
pvalues<-map_dbl(lmertest,10)
p_ordered<-(sort(pvalues))
padj<-p.adjust(p_ordered, method = "fdr")
padj
padj_df<-as.data.frame(padj)
padj_df<-padj_df %>%
  filter(padj < 0.05)
padj_df<-rownames_to_column(padj_df, "names")

plotting<-melted %>%
  filter(variable %in% padj_df$names)

for_plotting<-cbind(var,plotting)

p1<-ggplot(data = for_plotting, aes(x = Days_from_first_sample, 
                                    y = value, color = Plant, group = variable)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "black") + 
  scale_color_brewer(palette = "Dark2")

p2<-p1 + facet_wrap(~variable, scales = "free") + theme_bw()

p3<-p2 + theme(axis.title.y = element_text(face = "bold", size = 16), 
               axis.title.x = element_text(face = "bold", size = 16), 
               legend.title  = element_text(face = "bold", size = 16),
               legend.text = element_text(face = "bold", size = 14),
               axis.text.y = element_text(face = "bold", size = 12, color = "black"),
               axis.text.x = element_text(face = "bold", size = 12, color = "black", 
                                          v = 1, h = 0.5),
               panel.grid.major = element_line(),
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 12, color = "black"))

p4<-p3 + labs(x = "Days from first sample", y = "Relative abundance")
p4

#ANCOM analyses.
ancom_table<-read.table("unenriched_samples_virus_counts_0.0001RA.txt", 
                        header = TRUE, sep = '\t',row.names = 1)
var<-read.table("unenriched_samples_metadata.txt", header = TRUE,
                sep = '\t')
prepro<-feature_table_pre_process(feature_table = ancom_table,meta_data = var,sample_var = "Sample", group_var = NULL,
                                  out_cut = 0.05, zero_cut = 0.90, lib_cut = 1, neg_lb = FALSE)

feature_table = prepro$feature_table 
meta_data = prepro$meta_data 
struc_zero = prepro$structure_zeros 

ancom_results<-ANCOM(feature_table = feature_table, meta_data = meta_data,
                     struc_zero = struc_zero, main_var = "Plant",
                     p_adj_method = "BH", alpha = 0.05, adj_formula = NULL,
                     rand_formula = NULL)

data<-read.table("ancom_boxplot_data_combined.txt", header = TRUE, 
                 row.names = 1, sep = '\t', check.names = FALSE)
melted<-melt(data)
var<-read.table("ancom_metadata.txt", header = TRUE,
                sep = '\t', row.names = 1)
for_plotting<-cbind(melted,var)

p1<-ggplot(for_plotting, aes(Plant, value, fill = Plant)) + 
  geom_boxplot() +
  scale_fill_brewer(palette = "Dark2")
p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + labs(x = "Treatment Plant", y = "Relative Abundance") +
  theme(axis.text.x = element_text(angle = 45, h = 1, v = 1, color = "Black", face = "bold", 
                                   size = 8), panel.grid.major = element_blank())

p5<-p4 + facet_wrap(~variable, ncol = 6, scales = "free", 
                    labeller = label_wrap_gen(width = 20))

p6<-p5 + theme(axis.title.y = element_text(face = "bold", size = 16), 
               axis.title.x = element_text(face = "bold", size = 16), 
               legend.title  = element_text(face = "bold", size = 16),
               legend.text = element_text(face = "bold", size = 14),
               axis.text.y = element_text(face = "bold", size = 12, color = "black"),
               axis.text.x = element_text(face = "bold", size = 10, color = "black", 
                                          v = 1, h = 1),
               panel.grid.major = element_line(),
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 12, color = "black"))

