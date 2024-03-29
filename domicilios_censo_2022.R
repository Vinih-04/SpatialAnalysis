# Carregar pacotes
library(dplyr)
library(sf)
library(geobr)
library(ggplot2)
library(ggmap)
library(ggthemes)

# Importar shapefile das Regiões Administrativas do DF

ras <- c('Plano Piloto', 'Taguatinga', 'Riacho Fundo', 'Núcleo Bandeirante',
         'Guará', 'Cruzeiro', 'Candangolândia', 'Lago Norte', 
         'Lago Sul', 'Arniqueira', 'SIA', 'SCIA', 'Sudoeste/Octogonal', 'Sudoeste/Octogonal', 'Vicente Pires')

df_map = st_read(dsn = "C:\\Users\\vinih\\OneDrive\\Documentos\\DF_Malha_Preliminar_2022\\DF_Malha_Preliminar_2022.shp") %>%
  filter(NM_SUBDIST %in% ras, CD_SETOR != '530010805060504P', CD_SETOR != '530010805380078P',CD_SETOR != '530010805060495P')



# Importar arquivo Censo 2022
dados <- read_excel("Agregados_preliminares_por_setores_censitarios_DF (1).xlsx") %>%
  select(1,23,24,27) %>%
  rename(Total_pessoas=v0001, Total_moradias=v0002, Media_pessoas_moradia=v0005) %>%
  filter(Media_pessoas_moradia > 0)



# Mesclar arquivos
dados_completos = left_join(x = df_map, 
                   y = dados, 
                   by = 'CD_SETOR')



# Visualização mapa

  ggplot(dados_completos) +
    geom_sf(aes(fill = Media_pessoas_moradia), color = "grey", lwd = 0.15) +
    scale_fill_fermenter(
      name = "",
      palette = "RdYlBu",
      breaks = seq(0, 5, 0.7),
      direction = -1) +
    labs(
      title = "Média de Moradores Por Domicílios no Distrito Federal",
      caption = "Fonte: Censo Demográfico de 2022.") +
    theme_map(base_family = "HelveticaNeue") +
    theme(
      legend.position = c(.01,.2),
      legend.justification = 0.5,
      legend.key.size = unit(1, "cm"),
      legend.key.width = unit(1, "cm"),
      legend.text = element_text(size = 10),
      legend.margin = margin(),
      plot.margin = margin(10, 5, 5, 10),
      plot.title = element_text(size = 30, hjust = 0.5),
      plot.subtitle = element_text(size = 18, hjust = 0.5),
      plot.caption = element_text(hjust = 0, size=12)
    )
  