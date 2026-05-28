if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(c("tximport", "DESeq2", "pheatmap", "VennDiagram", "matrixStats", "ggrepel", "dplyr", "ggplot2", "clusterProfiler"))

library(tximport)        # Importar cuantificaciones RSEM
library(DESeq2)          # Expresión diferencial
library(ggplot2)         
library(ggrepel)         # Etiquetas sin solapamiento en volcano
library(pheatmap)        # Heatmaps
library(grid)            # Renderizar objetos Venn
library(dplyr)           
library(matrixStats)     # rowVars para heatmap
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(c("clusterProfiler"))
BiocManager::install("AnnotationDbi", force = TRUE)
BiocManager::install("GO.db")
BiocManager::install("enrichplot")
BiocManager::install("rtracklayer")

BASE_DIR <- "C:/Users/Mariana Rozo/Downloads/proyecto_toxo/Conteos"
setwd(BASE_DIR)

col_28DPI  <- "#2E86AB" 
col_120DPI <- "#7B2FBE"   
heatmap_pal <- colorRampPalette(c("#08306B", "#2171B5", "#4DBBBD", "#F7F7F7", "#9970AB", "#40004B"))(100)
volcano_cols <- c("Up in 120DPI" = "#7B2FBE", "Down in 120DPI" = "#2E86AB", "Not significant" = "grey75")

theme_sci <- function() {
  theme_classic(base_size = 13) +
    theme(
      plot.title    = element_text(hjust = 0.5, face = "bold", size = 14),
      plot.subtitle = element_text(hjust = 0.5, color = "grey40", size = 11),
      axis.title    = element_text(face = "bold"),
      legend.title  = element_text(face = "bold"),
      legend.background = element_rect(fill = "white", color = "grey85"),
      legend.margin = margin(4, 8, 4, 8),
      panel.grid.major = element_line(color = "grey92"),
      plot.margin = margin(15, 15, 15, 15)
    )
}

files <- list.files(path = BASE_DIR, pattern = "\\.genes\\.results$", recursive = FALSE, full.names = TRUE)
if (length(files) == 0) stop("No se encontraron archivos .genes.results en ", BASE_DIR)

get_meta_local <- function(f) {
  fname <- basename(f)
  parts <- strsplit(fname, "_")[[1]]
  data.frame(
    file        = f,
    tratamiento = parts[1],
    muestra     = paste0("muestra", parts[2]),
    run         = tools::file_path_sans_ext(parts[3]),
    sample_id   = tools::file_path_sans_ext(fname),
    stringsAsFactors = FALSE
  )
}

meta <- do.call(rbind, lapply(files, get_meta_local))
rownames(meta) <- meta$sample_id
names(files)   <- meta$sample_id

txi <- tximport(files, type = "rsem", txIn = FALSE, txOut = FALSE)
txi$length[txi$length == 0] <- 1

colData <- data.frame(
  condition = factor(meta$tratamiento, levels = c("28DPI", "120DPI")),
  muestra   = factor(meta$muestra),
  run       = factor(meta$run),
  row.names = meta$sample_id
)

dds <- DESeqDataSetFromTximport(txi, colData = colData, design = ~ condition)
keep <- rowSums(counts(dds)) >= 10
dds  <- dds[keep, ]
dds <- DESeq(dds)
res <- results(dds, contrast = c("condition", "120DPI", "28DPI"), alpha = 0.05)
res_df <- as.data.frame(res)
res_df$gene <- rownames(res_df)

res_df <- res_df %>%
  mutate(
    significance = case_when(
      padj < 0.05 & log2FoldChange >  2 ~ "Up in 120DPI",
      padj < 0.05 & log2FoldChange < -2 ~ "Down in 120DPI",
      TRUE                               ~ "Not significant"
    )
  )

sig_up   <- res_df %>% filter(significance == "Up in 120DPI")
sig_down <- res_df %>% filter(significance == "Down in 120DPI")
rld <- rlog(dds, blind = FALSE)

pca_data   <- plotPCA(rld, intgroup = "condition", returnData = TRUE)
percentVar <- round(100 * attr(pca_data, "percentVar"))
p_pca <- ggplot(pca_data, aes(x = PC1, y = PC2, color = condition, shape = condition)) +
  geom_point(size = 5, alpha = 0.9) +
  scale_color_manual(values = c("28DPI" = col_28DPI, "120DPI" = col_120DPI), name = "Condición") +
  scale_shape_manual(values = c("28DPI" = 16, "120DPI" = 17), name = "Condición") +
  labs(
    title    = "PCA",
    subtitle = expression( "· 28DPI vs 120DPI"),
    x        = paste0("PC1: ", percentVar[1], "% varianza explicada"),
    y        = paste0("PC2: ", percentVar[2], "% varianza explicada")
  ) +
  theme_sci()
p_pca
ggsave("PCA_28DPI_120DPI.pdf", p_pca, width = 7, height = 6)

top_genes <- res_df %>% filter(!is.na(padj), significance != "Not significant") %>% arrange(padj) %>% slice_head(n = 20)
res_df_plot <- res_df %>% filter(!is.na(log2FoldChange), !is.na(padj))

p_volcano <- ggplot(res_df_plot, aes(x = log2FoldChange, y = -log10(padj), color = significance)) +
  geom_point(alpha = 0.5, size = 1.8) +
  scale_color_manual(values = volcano_cols, name = expression(bold("Expresión (120DPI vs 28DPI)"))) +
  geom_vline(xintercept = c(-2, 2), linetype = "dashed", color = "grey40", linewidth = 0.6) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "grey40", linewidth = 0.6) +
  annotate("text", x = max(res_df_plot$log2FoldChange, na.rm = TRUE) * 0.85, y = max(-log10(res_df_plot$padj), na.rm = TRUE) * 0.95, label = paste0("Up: ", nrow(sig_up)), color = col_120DPI, fontface = "bold", size = 4) +
  annotate("text", x = min(res_df_plot$log2FoldChange, na.rm = TRUE) * 0.85, y = max(-log10(res_df_plot$padj), na.rm = TRUE) * 0.95, label = paste0("Down: ", nrow(sig_down)), color = col_28DPI, fontface = "bold", size = 4) +
  labs(title = "Volcano Plot · 120DPI vs 28DPI", subtitle = expression( " padj < 0.05 · log"[2]*"FC > 2"), x = expression(log[2]~"Fold Change"), y = expression(-log[10]~"(padj)")) +
  theme_sci()
p_volcano

ggsave("Volcano_28DPI_120DPI.pdf", p_volcano, width = 9, height = 7)

top_var <- order(rowVars(assay(rld)), decreasing = TRUE)[1:min(100, nrow(rld))]
mat      <- assay(rld)[top_var, ]
mat      <- mat - rowMeans(mat)  
annotation_col <- data.frame(Condición = colData$condition, row.names = rownames(colData))
ann_colors <- list(Condición = c("28DPI" = col_28DPI, "120DPI" = col_120DPI))

p_heatmap <- pheatmap(
  mat, color = heatmap_pal, annotation_col = annotation_col, annotation_colors = ann_colors,
  show_rownames = FALSE, show_colnames = TRUE, cluster_rows = TRUE, cluster_cols = TRUE, border_color = NA,
  main = "Top 100 genes variables 120DPI vs 28DPI", fontsize = 11, fontsize_col = 10, angle_col = 45,
  legend_breaks = c(min(mat), 0, max(mat)), legend_labels = c("Baja expresión", "Media", "Alta expresión")
)
p_heatmap
grid::grid.newpage(); grid::grid.draw(p_heatmap$gtable)
ggsave(filename = paste0(BASE_DIR, "/Heatmap_top100_28DPI_120DPI.pdf"), plot = p_heatmap$gtable, width = 9, height = 11)

write.csv(res_df,   "DEG_resultados_completos_120DPI_vs_28DPI.csv", row.names = FALSE)
write.csv(sig_up,   "DEG_upregulados_120DPI.csv",   row.names = FALSE)
write.csv(sig_down, "DEG_downregulados_120DPI.csv",  row.names = FALSE)


#Análisis funcional.
