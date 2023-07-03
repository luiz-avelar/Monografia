library(tidyverse)
library(flextable)

set_flextable_defaults(
  font.size = 12, theme_fun = theme_vanilla,
  padding = 6,
  background.color = "#EFEFEF"
)

efeito_fixo_2020 <- tibble(
  Modelo = c(
    "Poisson Misto",
    "Poisson Misto",
    "Poisson Misto",
    "Poisson Misto",
    "Poisson Misto",

    "Poisson Misto com mistura",
    "Poisson Misto com mistura",
    "Poisson Misto com mistura",
    "Poisson Misto com mistura",
    "Poisson Misto com mistura"
  
  )
  Parâmetro = c(
    home,
    mu_att,
    mu_def,
    sigma_att,
    sigma_def,
  ),
  Mediana = c(

  ),
  Desvio-padrão = c(

  ),
  "2,5%" = c(

  ),
  "97,5%" = c(

  )
                mean se_mean   sd    2.5%     25%     50%     75%   97.5%  
home             0.27    0.00 0.06    0.14    0.23    0.27    0.31    0.40 
mu_att           0.23    0.01 0.12    0.00    0.15    0.23    0.31    0.44 
mu_def          -0.18    0.01 0.11   -0.38   -0.26   -0.18   -0.11    0.04 
sigma_att        0.21    0.00 0.06    0.11    0.17    0.20    0.24    0.34 
sigma_def        0.11    0.00 0.05    0.04    0.08    0.11    0.14    0.22 

home             0.28    0.00    0.06    0.15    0.23    0.28    0.32    0.40   870 1.00
mu_att           0.24    0.01    0.12   -0.01    0.16    0.24    0.32    0.47   201 1.02
mu_def          -0.19    0.01    0.12   -0.41   -0.27   -0.20   -0.12    0.06   149 1.02
sigma_att        0.21    0.00    0.06    0.10    0.17    0.21    0.24    0.35   622 1.00
sigma_def        0.11    0.00    0.05    0.04    0.07    0.10    0.14    0.21   259 1.00

home                 0.27    0.00  0.07     0.13     0.23    0.27    0.31    0.40   362 1.00
mu_att               0.22    0.01  0.12    -0.02     0.14    0.23    0.30    0.46   141 1.02
mu_def              -0.17    0.01  0.11    -0.39    -0.24   -0.17   -0.09    0.07   121 1.01
sigma_att            0.21    0.00  0.06     0.10     0.17    0.20    0.24    0.34   585 1.00
sigma_def            0.10    0.00  0.05     0.02     0.06    0.09    0.13    0.21   146 1.00

home                   0.27 1.000000e-02 7.000000e-02          0.12          0.23          0.28  3.200000e-01  4.000000e-01    37
mu_att1               -0.24 2.000000e-02 3.300000e-01         -1.14         -0.27         -0.16 -8.000000e-02 -1.000000e-02   471
mu_att3                0.27 1.000000e-02 2.000000e-01          0.03          0.19          0.27  3.400000e-01  4.800000e-01   187
mu_def1                0.31 4.000000e-02 5.400000e-01          0.01          0.05          0.14  2.400000e-01  2.260000e+00   207
mu_def3               -0.24 2.000000e-02 3.800000e-01         -1.56         -0.23         -0.16 -9.000000e-02 -1.000000e-02   303
)

results <- tibble(
  Ano = c(
    as.integer(2022),
    as.integer(2022),
    as.integer(2022),
    as.integer(2022),
    as.integer(2021),
    as.integer(2021),
    as.integer(2021),
    as.integer(2021),
    as.integer(2020),
    as.integer(2020),
    as.integer(2020),
    as.integer(2020)
  ),
  Modelo = c(
    "Poisson Misto", 
    "Binomial Negativa Misto", 
    "Poisson Misto Zero Inflado", 
    "Poisson Misto com Mistura",
    "Poisson Misto", 
    "Binomial Negativa Misto", 
    "Poisson Misto Zero Inflado", 
    "Poisson Misto com Mistura",
    "Poisson Misto", 
    "Binomial Negativa Misto", 
    "Poisson Misto Zero Inflado", 
    "Poisson Misto com Mistura"
  ),
  EQM = c( # Pontuação
    54.25, 
    52.9, 
    52.55, 
    42.55,
    61.6,
    69.5,
    62.2,
    49.9,
    42.75,
    42,
    44.55,
    35
  ),
  "Viés" = c( # Pontuação
    -0.35, 
    -0.2, 
    -0.25, 
    -0.35,
    -0.3,
    -0.2,
    -0.2,
    -0.3,
    -0.25,
    -0.4,
    -0.35,
    -0.3
  ),
  "EQM " = c( # Gols
    round(0.7463816, 2),
    round(1.186842, 2),
    round(0.9039474, 2),
    round(0.9013158, 2),
    round(0.6526316, 2),
    round(1.135855, 2),
    round(2.051316, 2) ,
    round(2.060855, 2),
    round(2.065789, 2),
    round(0.9394737, 2),
    round(2.689474, 2),
    round(0.9223684, 2)
  ),
  "Viés " = c( # gols
    round(-0.5506579, 2),
    round(-1.044737, 2),
    round(-0.04605263, 2),
    round(-0.06973684, 2),
    round(-0.5473684, 2),
    round(-0.04539474, 2),
    round(0.9565789, 2),
    round(0.9467105, 2),
    round(0.9342105, 2),
    round(-0.06052632, 2),
    round(0.4368421, 2),
    round(-0.075, 2)
  ),
  elpd_loo = c( # Estimate
    -1026.7,
    -1027.4,
    -1026.9,
    -1027.2,
    -1017.4,
    -1017.5,
    -1018.0,
    -1016.1,
    -1060.0,
    -1061.0,
    -1060.6,
    -1062.2
  ),
  # p_loo = c( # Estimate
  #   21.7,
  #   21.1,
  #   21.7,
  #   23.4,
  #   18.3,
  #   15.9,
  #   18.5,
  #   19.6,
  #   19.7,
  #   19.3,
  #   18.9,
  #   22.7
  # ),
  looic = c( # Estimate
    2053.4,
    2054.8,
    2053.8,
    2054.4,
    2034.8,
    2035.0,
    2035.9,
    2032.2,
    2120.0,
    2122.1,
    2121.2,
    2124.4 
  ),
  
  "elpd_loo " = c( #SE
    15.7,
    15.6,
    15.6,
    15.7,
    17.1,
    16.9,
    17.0,
    16.9,
    17.8,
    17.6,
    17.6,
    17.8
  ),
  
  # "p_loo " = c( # SE
  #   1.2,
  #   1.2,
  #   1.2,
  #   1.3,
  #   1.1,
  #   0.9,
  #   1.1,
  #   1.2,
  #   1.2,
  #   1.1,
  #   1.1,
  #   1.3
  # ),
  
  "looic " = c( # SE
    31.3,
    31.1,
    31.3,
    31.3,
    34.2,
    33.9,
    34.0,
    33.9,
    35.5,
    35.3,
    35.3,
    35.7
  )
)

results_2020 <- results |> filter(Ano == 2020) |> select(-Ano)
results_2021 <- results |> filter(Ano == 2021) |> select(-Ano)
results_2022 <- results |> filter(Ano == 2022) |> select(-Ano)

# 2020
ft_2020 <- flextable(results_2020)
ft_2020 <- add_header_row(
  ft_2020,
  colwidths = c(1, 2, 2, 2, 2),
  values = c("", "Pontuação", "Gols", "LOO - Estimação", "LOO - Erro padrão")
)
ft_2020 <- align(ft_2020, i = 1, part = "header", align = "center")
# ft_2020 <- merge_at(ft_2020, i = 1:4, j = 1)
# ft_2020 <- merge_at(ft_2020, i = 5:8, j = 1)
# ft_2020 <- merge_at(ft_2020, i = 9:12, j = 1)
ft_2020 <- colformat_double(
  x = ft_2020,
  big.mark = "", 
  decimal.mark = ",",
  digits = 2
)
ft_2020 <- colformat_int(
  x = ft_2020,
  big.mark = ""
)

ft_2020

# 2021
ft_2021 <- flextable(results_2021)
ft_2021 <- add_header_row(
  ft_2021,
  colwidths = c(1, 2, 2, 2, 2),
  values = c("", "Pontuação", "Gols", "LOO - Estimação", "LOO - Erro padrão")
)
ft_2021 <- align(ft_2021, i = 1, part = "header", align = "center")
# ft_2021 <- merge_at(ft_2021, i = 1:4, j = 1)
# ft_2021 <- merge_at(ft_2021, i = 5:8, j = 1)
# ft_2021 <- merge_at(ft_2021, i = 9:12, j = 1)
ft_2021 <- colformat_double(
  x = ft_2021,
  big.mark = "", 
  decimal.mark = ",",
  digits = 2
)
ft_2021 <- colformat_int(
  x = ft_2021,
  big.mark = ""
)

ft_2021 

# 2022
ft_2022 <- flextable(results_2022)
ft_2022 <- add_header_row(
  ft_2022,
  colwidths = c(1, 2, 2, 2, 2),
  values = c("", "Pontuação", "Gols", "LOO - Estimação", "LOO - Erro padrão")
)
ft_2022 <- align(ft_2022, i = 1, part = "header", align = "center")
# ft_2022 <- merge_at(ft_2022, i = 1:4, j = 1)
# ft_2022 <- merge_at(ft_2022, i = 5:8, j = 1)
# ft_2022 <- merge_at(ft_2022, i = 9:12, j = 1)
ft_2022 <- colformat_double(
  x = ft_2022,
  big.mark = "", 
  decimal.mark = ",",
  digits = 2
)
ft_2022 <- colformat_int(
  x = ft_2022,
  big.mark = ""
)

ft_2022
