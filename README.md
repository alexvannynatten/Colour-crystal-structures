# Colour-crystal-structures

This R code makes it possible to colour protein crystal structures based evolutionary, structural, or functional data associated with specific sites (ex. dN/dS). It generates a sequence selection file (.scf) that can be imported and visualized in UCSF Chimera (Tools > Sequence > Sequence > File > Load SCF/Seqsel File...).  

![Rhodopsin interior vs exterior dN/dS](https://github.com/alexvannynatten/Colour-crystal-structures/blob/201f783f508dc85ac6aff6967cdab7d1ab375350/rho_dnds.png)

## Required:

- UCSF Chimera 1.15+ (https://www.cgl.ucsf.edu/chimera/download.html)
- R
- Data (discrete or continuous for each site in tsv format)
- Crystal structure (with sites numbered to match data file)

## R code:

```r
aa_val <- read.table('rho_dnds.tsv', sep = '\t', header = TRUE)

# Number of bins and colour scheme can be modified
cut_df <- data.frame(
	Bins = c(0.005, 0.05, 0.5, 5),
	Colours = c('#004784', '#3f72aa', '#78a4a5', '#9edc66')
	)

aa_val$Bin_Colour <-cut(as.numeric(aa_val[[2]]), 
	breaks = c(0,cut_df$Bins),
	labels = cut_df$Colours)

aa_val$model <- 0

for(i in 1:nrow(aa_val)){
	j <- col2rgb(as.character(aa_val$Bin_Colour[i]))
	aa_val$Red[i] <- j[[1]]
	aa_val$Green[i] <- j[[2]]
	aa_val$Blue[i] <- j[[3]]
}

write.table(aa_val[c(1,4,5,6,7)], "rho_dnds_col.scf", 
	col.names = F, row.names = F, sep="\t")

barplot(rev(cut_df$Bins), col=rev(cut_df$Colours), space = -1, 
	ylab="dN/dS", 
	ylim = c(min(aa_val[2]), max(aa_val[2])), 
	log="y")
