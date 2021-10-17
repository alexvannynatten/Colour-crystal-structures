# R Script ---
# Colours protein structure by site-associated values for UCSF Chimera
# by alexander van nynatten - 2021

# Tab-delimited file with sites in first column and values in second
aa_df <- read.table('vert_rho_dnds.tsv', sep = '\t', header = TRUE)

# Bin widths and colours for the range of site-associated values
col_df <- data.frame(
			Bins = c(0.001, 0.01, 0.1, 1, 10),
			Colours = c('#00284c', 
						'#21377e', 
						'#5a42a3', 
						'#a441b0', 
						'#ff008c')
			)

# Bins each site and assigns colour by the site-associated value
aa_df$Hex_col <- cut(as.numeric(aa_df[[2]]), 
					breaks = c(0,col_df$Bins),
					labels = col_df$Colours
					)

# Converts HEX colours to RGB values and makes dataframe for output
out_df <- data.frame(
			Site = aa_df[1], 
			Model = 0,
			Red = col2rgb(as.character(aa_df$Hex_col))[1, ],
			Green = col2rgb(as.character(aa_df$Hex_col))[2, ],
			Blue = col2rgb(as.character(aa_df$Hex_col))[3, ]
			)

# Writes a .scf file that is can be imported into UCSF Chimera
write.table(out_df, "structure_site_col.scf", 
			col.names = F, row.names = F, sep="\t"
			)

# Plots the colour palette for the legend
barplot(rev(col_df$Bins), col=rev(col_df$Colours), 
		space = -1, 
		ylab="dN/dS", 
		ylim = c(0.0001, 10), 
		log="y"
		)