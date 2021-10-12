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

write.table(aa_val[c(1,4,5,6,7)], "chimera_col_data.scf", 
	col.names = F, row.names = F, sep="\t")

barplot(rev(cut_df$Bins), col=rev(cut_df$Colours), space = -1, 
	ylab="dN/dS", 
	ylim = c(min(aa_val[2]), max(aa_val[2])), 
	log="y")