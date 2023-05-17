library(tidyverse)
library(rstan)
library(glue)
library(shinystan)
library("loo")


data <- read.csv("data/2014_partidas_tidy.csv", header = TRUE)
data <- data |> arrange(round, home_team_id, away_team_id)

prg <- stan_model(file = "models/stan/binomial-negativa-misto.stan")

iter <- 4000
G <- 380
T <- 20

rounds <- G / (T/2)

dados_list <- list(
  G  = G,
  T  = T,
  h  = data$home_team_id,
  a  = data$away_team_id,
  y1 = data$home_team_score,
  y2 = data$away_team_score
)

fit_sim <- sampling(prg, data = dados_list, chains = 1, iter = iter, cores = 1, refresh = 100)

list_of_results <- extract(fit_sim, pars = c("y1_tilde", "y2_tilde"))
sample_size <- dim(list_of_results$y1_tilde)[1]

home_team_results <- as_tibble(t(list_of_results$y1_tilde))
away_team_results <- as_tibble(t(list_of_results$y2_tilde))

data_by_team <- data |> 
  pivot_longer(
    cols = ends_with("name")
  ) |>
  rename(team = value) 

data_home_team <- data_by_team |>
  filter(name == "home_team_name") |>
  select(
    round,
    team,
    starts_with("home_team")
  ) |>
  rename_with(~ gsub("home_", "", .x, fixed = TRUE)) |>
  cbind(home_team_results)

data_away_team <- data_by_team |>
  filter(name == "away_team_name") |>
  select(
    round,
    team,
    starts_with("away_team")
  ) |>
  rename_with(~ gsub("away_", "", .x, fixed = TRUE)) |>
  cbind(away_team_results) 

predict_data <- rbind(data_home_team, data_away_team) |>
  group_by(team) |>
  mutate(team_points = order_by(round, cumsum(team_points))) |>
  mutate(across(V1:V2000, ~order_by(round, cumsum(.x)))) |>
  ungroup()

prep_quantis_data <- predict_data |>
  select(
    V1:V2000
  ) |> as.matrix()

quantis <- apply(prep_quantis_data, MARGIN = 1, FUN = quantile, probs = c(0.025, 0.5, 0.975))
quantis <- t(quantis)

predict_data <- cbind(predict_data, quantis) |>
  select(
    round,
    team,
    team_score,
    "2.5%",
    "50%",
    "97.5%"
  ) |>
  rename(
    lower_bound = "2.5%",
    median      = "50%",
    upper_bound = "97.5%"
  )

# Erro quadratico medio
## Para o numero de gols

EQM_gols <- predict_data |>
  select(
    team_score,
    median,
  ) |>
  summarise(
    EQM = mean((team_score - median) ^ 2)
  )

# LOO

loo1 <- loo(fit_sim, save_psis = TRUE)
