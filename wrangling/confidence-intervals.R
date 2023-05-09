library(tidyverse)
library(rstan)
library(glue)
library(shinystan)

data <- read.csv("data/2014_partidas_tidy.csv", header = TRUE)
data <- data |> arrange(round, home_team_id, away_team_id)

prg <- stan_model(file = "models/stan/modelo-poisson-misto.stan")

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

# Turn scores in to points

for (i in 1:G) {
  for (j in 1:sample_size) {
    
    home_team_score <- list_of_results$y1_tilde[j, i]
    away_team_score <- list_of_results$y2_tilde[j, i]
    
    if (home_team_score > away_team_score) {
      home_team_points <- 3
      away_team_points <- 0
    } else if (home_team_score < away_team_score) {
      home_team_points <- 0
      away_team_points <- 3
    } else {
      home_team_points <- 1
      away_team_points <- 1
    }
    
    list_of_results$y1_tilde[j, i] <- home_team_points
    list_of_results$y2_tilde[j, i] <- away_team_points
  }
}

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
    team_points,
    "2.5%",
    "50%",
    "97.5%"
  ) |>
  rename(
    lower_bound = "2.5%",
    median      = "50%",
    upper_bound = "97.5%"
  )

ggplot(data = predict_data, mapping = aes(x = round)) + 
  geom_line(mapping = aes(y = team_points), color = "red") +
  geom_line(mapping = aes(y = median), color = "blue") + 
  geom_ribbon(mapping = aes(ymin = lower_bound, ymax = upper_bound), linetype=2, alpha=0.1) + 
  facet_wrap(~ team)
