library(ggplot2)

# DF
datos <- data.frame(origen=c(rep("Ruta 126", 7), rep("Ruta 131", 6), rep("Ruta 132", 6)), 
                    destino=c("San José", "Jericó", "Guadarrama", "San Juan Norte", "San Juan Sur", "Río Conejo", "Loma Larga",
                              "Cartago", "Copalchí", "El Alumbre", "San Juan Norte", "San Juan Sur", "Loma Larga",
                              "San Juan Norte", "Calle Valverde", "Calle Abarca", "San Juan Sur", "Río Conejo", "Loma Larga"),
                    subsidio=c("","-345","-135","-400","-325","-155","400", "", "230", "255", "515", "530", "2150", rep("",6)))

# Levels to factor
datos$destino <- factor(datos$destino, levels = c("San José", "Cartago","Jericó", "Copalchí", "Guadarrama", "El Alumbre", "San Juan Norte",  "Calle Valverde", "Calle Abarca", "San Juan Sur", "Río Conejo", "Loma Larga"))
datos$origen <- factor(datos$origen, levels = c("Ruta 126", "Ruta 132", "Ruta 131"))

# Groups for geom_text
etiqueta1 <- c("San José", "Cartago","Jericó", "Copalchí", "Guadarrama", "El Alumbre", "Calle Valverde", "Calle Abarca", "Río Conejo")
etiqueta2 <- c("San Juan Norte", "San Juan Sur", "Loma Larga")

# group for geom_label
text1 <- c("-345","-135","-400","-325","-155","400")
text2 <- c("230", "255", "515", "530", "2150")

# Plot
ggplot(datos, aes(destino, origen, group=origen)) +
  geom_line(size=10, aes(color=origen)) +
  geom_segment(aes(x=7, xend=7, y= 1, yend=3), size=1, color="grey20", linetype=3) +
  geom_segment(aes(x=10, xend=10, y= 1, yend=3), size=1, color="grey20", linetype=3) +
  geom_segment(aes(x=12, xend=12, y= 1, yend=3), size=1, color="grey20", linetype=3) +
  geom_segment(aes(x=11, xend=11, y= 1, yend=2), size=1, color="grey20", linetype=3) +
  geom_point(size=6) +
  scale_color_manual("", values = c("steelblue3", "tomato2", "forestgreen")) +
  geom_text(data= subset(datos, destino %in% etiqueta1), aes(label=destino), nudge_y = .25, size=3, angle=45, fontface="bold") +
  geom_text(data= subset(datos, destino %in% etiqueta2 & origen== "Ruta 126"), aes(label=destino), nudge_y = -.2, size=4, fontface="bold") +
  geom_label(data= subset(datos, subsidio %in% text1 & origen== "Ruta 126"), aes(label=subsidio), nudge_y = -.5, size=4, fontface="bold") +
  geom_label(data= subset(datos, subsidio %in% text2 & origen== "Ruta 131"), aes(label=subsidio), nudge_y = .52, size=4, fontface="bold") +
  
  labs(x="", y="") +
  theme_minimal() +
  theme(panel.grid = element_blank()) +
  theme(axis.text = element_blank()) +
  theme(legend.text = element_text(size = 14)) +
  theme(legend.position = "bottom") + 
  guides(color = guide_legend(nrow=3, reverse = T)) +
  theme(plot.margin = unit(c(3,.5,3,.5), "cm"))