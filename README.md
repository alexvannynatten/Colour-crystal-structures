# Colour-crystal-structures

This R code makes it possible to colour protein crystal structures based evolutionary, structural, or functional site-assocaited data (ex. dN/dS). It generates a sequence selection file (.scf) that can be imported and visualized in UCSF Chimera.

![Rhodopsin interior vs exterior dN/dS](https://github.com/alexvannynatten/Colour-crystal-structures/blob/24ce7bd5517303ca5057a8f25ad3ced33e57bfb1/rho_dnds_col.png)

## Required:

- UCSF Chimera 1.15 or UCSF Chimera X
- R
- Data (discrete or continuous for each site in tsv format)
- Crystal structure (with sites numbered to match data file)

## Use:

1. Ensure that the numbering for your site-associated values and PDB file are consistent 

2. Set bin values and colour scale based on the site-assocaited values for your protein (example uses a log scale)

3. "structure_site_col.scf" output file can be mapped to crystal structure as follows: 

	i. For USCF Chimera 1.15: Tools > Sequence > Sequence > File > Load SCF/Seqsel File...)

	ii. For UCSF Chimera X: Tools > Sequence > Show Sequence Viewer. In sequence viewer: left click on sequence > File > Load Sequence Colouring File... (make sure "Also color associated structure" is selected)

## R code:

```r
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
