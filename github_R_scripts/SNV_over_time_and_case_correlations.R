library(ggplot2)
library(tidyverse)
library(reshape2)
library(zoo)
library(lubridate)
library(Hmisc)

#Plotting SNVs over time.
data<-read.table("htp_snvs_over_time_test.txt", header = TRUE,sep = '\t')

p1<-ggplot(data = data, aes(x = reorder(as.factor(Date),Days_from_first_sample), 
                            y = overall_snv)) +
  geom_line(group = 1, size = 1)+
  geom_point(size = 2)
p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3
p5<-p4 + facet_wrap(~position)
p6<-p5 + ylab("Proportion of SNVs at Position") + 
  xlab("Sampling Date") +
  theme(axis.title.y = element_text(face = "bold", size = 16), 
        axis.title.x = element_text(face = "bold", size = 16), 
        legend.title  = element_text(face = "bold", size = 16),
        legend.text = element_text(face = "bold", size = 16),
        plot.margin = margin(10,10,10,40, unit = "pt"),
        axis.text.y = element_text(face = "bold", size = 12, color = "black"),
        axis.text.x = element_text(face = "bold", size = 12, color = "black", 
                                   v = +0.5, h = 0.5,angle = 90),
        panel.grid.major = element_line(),
        panel.spacing.x = unit(1.5, "lines"),
        strip.background = element_blank(),
        strip.text = element_text(face = "bold", size = 16, color = "black"))+
  scale_y_continuous(limits = c(-0.05,1.05),expand = c(0.001,0))
p6

#COVID cases and wastewater correlations.
data<-read.table("covid_counts_ddpcr_county.txt", header = TRUE,
                 sep = '\t')
data$Date<-lubridate::mdy(data$Date)
data<-data %>%
  filter(area == "Los Angeles" | area == "Orange" | area == "San Diego") %>%
  group_by(area) %>%
  mutate(average = rollapply(cases,7, mean, fill = "right"))

p1<-ggplot(data, aes(x = as.numeric(Rolling_average), 
                     y = as.numeric(COVID_per_100ml*10), 
                     fill = "Black", group = Plant)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "black", fill = "gray")

p2<-p1 + facet_wrap(~Plant, scales = "free") + theme_bw()
p3<-p2 + ylab("SARS-CoV-2 N1 Gene Copies/L") + 
  xlab("Rolling 7-Day Average Reported COVID-19 Cases Within County of WTP") + 
  theme(axis.title.y = element_text(face = "bold", size = 16), 
        axis.title.x = element_text(face = "bold", size = 16), 
        legend.title  = element_blank(),
        legend.text = element_blank(),
        legend.position = "none",
        plot.margin = margin(20,20,20,20, unit = "pt"),
        axis.text.y = element_text(face = "bold", size = 12, color = "black"),
        axis.text.x = element_text(face = "bold", size = 12, color = "black", 
                                   v = 1, h = 0.5),
        panel.grid.major = element_line(),
        panel.spacing.x = unit(1.5, "lines"),
        strip.background = element_blank(),
        strip.text = element_text(face = "bold", size = 12, color = "black"))+
  scale_x_continuous(limits = function(x){c(0,max(0.1,x))})
p3

HTP<-data %>%
  filter(Plant == "HTP")
x<-as.matrix((HTP$COVID_per_100ml*10))
y<-as.matrix(HTP$Rolling_average)
z<-as.matrix(HTP$Counts)
pcor<-rcorr(x,y, type = "pearson")

JW<-data %>%
  filter(Plant == "JWPCP")
x<-as.matrix((JW$COVID_per_100ml*10))
y<-as.matrix(JW$Rolling_average)
pcor<-rcorr(x,y, type = "pearson")

NC<-data %>%
  filter(Plant == "NC")
x<-as.matrix((NC$COVID_per_100ml*10))
y<-as.matrix(NC$Rolling_average)
pcor<-rcorr(x,y, type = "pearson")

SB<-data %>%
  filter(Plant == "SB")
x<-as.matrix((SB$COVID_per_100ml*10))
y<-as.matrix(SB$Rolling_average)
pcor<-rcorr(x,y, type = "pearson")

OC<-data %>%
  filter(Plant == "OC")
x<-as.matrix((OC$COVID_per_100ml*10))
y<-as.matrix(OC$Rolling_average)
pcor<-rcorr(x,y, type = "pearson")


PL<-data %>%
  filter(Plant == "PL")
x<-as.matrix((PL$COVID_per_100ml*10))
y<-as.matrix(PL$Rolling_average)
pcor<-rcorr(x,y, type = "pearson")

SJ<-data %>%
  filter(Plant == "SJ")
x<-as.matrix((SJ$COVID_per_100ml*10))
y<-as.matrix(SJ$Rolling_average)
pcor<-rcorr(x,y, type = "pearson")