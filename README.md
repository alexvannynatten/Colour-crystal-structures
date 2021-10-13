# Colour-crystal-structures

This R code makes it possible to colour protein crystal structures based evolutionary, structural, or functional data associated with specific sites (ex. dN/dS). It generates a sequence selection file (.scf) that can be imported and visualized in UCSF Chimera.

![Rhodopsin interior vs exterior dN/dS](https://github.com/alexvannynatten/Colour-crystal-structures/blob/b9f60c5636dec16aa6edfd5ea5cce685b61c1b02/rhodopsin_dnds_col.png)

## Required:

- UCSF Chimera 1.15 or UCSF Chimera X
- R
- Data (discrete or continuous for each site in tsv format)
- Crystal structure (with sites numbered to match data file)

## Use:

chimera_col_data.scf output file can be mapped to crystal structure as follows: 

For USCF Chimera 1.15: Tools > Sequence > Sequence > File > Load SCF/Seqsel File...)

For UCSF Chimera X: Tools > Sequence > Show Sequence Viewer. In sequence viewer: left click on sequence > File > Load Sequence Colouring File... (make sure "Also color associated structure" is selected)

## R code:

```r
aa_val <- read.table('rho_dnds.tsv', sep = '\t', header = TRUE)

# Number of bins and colour scheme can be modified
cut_df <- data.frame(
	Bins = c(0.001, 0.01, 0.1, 1, 10),
	Colours = c('#00284c', '#21377e', '#5a42a3', '#a441b0', '#ff008c')
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

write.table(aa_val[c(1,4,5,6,7)], "chimera_col_data.scf", 
	col.names = F, row.names = F, sep="\t")

barplot(rev(cut_df$Bins), col=rev(cut_df$Colours), space = -1, 
	ylab="dN/dS", 
	ylim = c(0.0001, 10), 
	log="y")
