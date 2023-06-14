library(tidyverse)
library(rstan)
library(glue)
library(shinystan)

data <- read.csv("data/2014_partidas_tidy.csv", header = TRUE)
data <- data |> arrange(round, home_team_id, away_team_id)

prg <- stan_model(file = "models/stan/poisson-misto-zero-inflado.stan")

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

summary_parameters <- summary(fit_sim, pars = c("p_zero_home", "p_zero_away", "home", "mu_att", "mu_def", "sigma_att", "sigma_def"), probs = c(0.1, 0.9))$summary
## media dos efeitos aleatorios
print(summary_parameters)


shinystan::launch_shinystan(fit_sim)

