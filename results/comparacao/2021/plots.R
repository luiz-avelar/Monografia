pontuacao_galo <- tibble(
    Time = c(
        "Atletico-MG",
        "Atletico-MG",
        "Atletico-MG",
        "Atletico-MG",
        "Atletico-MG",
        "Atletico-MG"
    ),
    Rodada = c(
        as.integer(33),
        as.integer(34),
        as.integer(35),
        as.integer(36),
        as.integer(37),
        as.integer(38)
    ),
    "Pontuação observada" = c(
        as.integer(74),
        as.integer(77),
        as.integer(78),
        as.integer(81),
        as.integer(84),
        as.integer(84)
    ),
    Mediana  = c(
        57,
        59,
        60,
        62,
        64,
        66
    ),
    "2,5%" = c(
        41,
        42,
        44,
        46,
        47,
        48
    ),
    "97,5%" = c(
        72.000,
        75.000,
        76.000,
        78.000,
        80.525,
        83.000
    ),
    "Mediana "  = c(
        57,
        59,
        60,
        62,
        64,
        66
    ),
    "2,5% " = c(
        40,
        42,
        43,
        44,
        46,
        47
    ),
    "97,5% " = c(
        73.525,
        76.000,
        78.000,
        80.000,
        82.000,
        84.000
    )
)

set_flextable_defaults(
  font.size = 12, theme_fun = theme_vanilla,
  padding = 6,
  background.color = "#EFEFEF"
)

ft <- flextable(pontuacao_galo)
ft <- add_header_row(
  ft,
  colwidths = c(3, 3, 3),
  values = c("", "Modelo Binomial Negativa", "Modelo Poisson Misto Zero Inflado")
)
ft <- merge_at(ft, i = 1:6, j = 1)
ft <- align(ft, i = 1, part = "header", align = "center")
ft <- colformat_double(
  x = ft,
  big.mark = "", 
  decimal.mark = ",",
  digits = 2
)
ft <- colformat_int(
  x = ft,
  big.mark = ""
)

ft 

efeitos_fixos <- tibble(
  "Parâmetro" = c(
    "home",
    "mu_att",
    "mu_def",
    "sigma_att",
    "sigma_def",
    "bn_phi",
    "p_zero_home",
    "p_zero_away"
  ),
  "Mediana" = c(
     0.25,
     0.14,
    -0.15,
     0.21,
     0.07,
     96.84,
     NA,
     NA
  ),
  "2,5%" =  c(
     0.13,
    -0.11,
    -0.37,
     0.12,
     0.01,
     14.11,
     NA,
     NA
  ),
  "97,5%" = c(
    0.38,
    0.35,
    0.05,
    0.34,
    0.19,
    1708.00,
    NA,
    NA
  ),
  "Mediana " = c(
     0.19,
     0.06,
    -0.25,
     0.18,
     0.06,
     NA ,
     0.00,
     0.00
  ),
  "2,5% " =  c(
     0.10,
    -0.07,
    -0.38,
     0.12,
     0.02,
     NA,
     0.00,
     0.00
  ),
  "97,5% " = c(
    0.38,
    0.36,
    0.03,
    0.36,
    0.21,
    NA,
    0.02,
    0.10 
  )
)

ft <- flextable(efeitos_fixos)
ft <- add_header_row(
  ft,
  colwidths = c(1, 3, 3),
  values = c("", "Modelo Binomial Negativa", "Modelo Poisson Misto Zero Inflado")
)
# ft <- merge_at(ft, i = 1:6, j = 1)
ft <- align(ft, i = 1, part = "header", align = "center")
ft <- colformat_double(
  x = ft,
  big.mark = "", 
  decimal.mark = ",",
  digits = 2
)
ft <- colformat_int(
  x = ft,
  big.mark = ""
)

ft 