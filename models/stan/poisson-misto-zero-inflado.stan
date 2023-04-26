// define os dados (o que vai vir do banco de dados)
data {
  // numero de times
  int<lower=1> G;
  // numero de jogos
  int<lower=1> T;
  // codigo do time da casa
  int<lower=0, upper=T> h[G];
  // codigo do time visitante
  int<lower=0, upper=T> a[G];
  // numero de gols da casa
  int<lower=0> y1[G];
  // numero de gols visitante
  int<lower=0> y2[G];
}

// Parametros (o que sera estimado no modelo)
parameters {
  // Efeitos fixos e aleatorios
  real <lower=0, upper=1> p_zero_home;
  real <lower=0, upper=1> p_zero_away;
  real home;
  real mu_att;
  real mu_def;
  real<lower=0> sigma_att;
  real<lower=0> sigma_def;
  // Definido por causa da restricao de que a ultima posicao tem que ser zero (auxiliar)
  vector[T - 1] att_raw;
  vector[T - 1] def_raw;
}

transformed parameters {
  vector[T] att;
  vector[T] def;
  
  for (t in 1:(T-1)) {
    att[t] = att_raw[t];
    def[t] = def_raw[t];
  }
  
  att[T] = 0;
  def[T] = 0; 
  
}

model {
  for (g in 1:G) {
    if (y1[g] == 0) {
      target += log_sum_exp(/* Structural zero */ 
                              bernoulli_lpmf(1 | p_zero_home), 
                            /* Poisson zero */ 
                              bernoulli_lpmf(0 | p_zero_home) + 
                              poisson_log_lpmf(y1[g] | home + att[h[g]] + def[a[g]])
      ); 
      
    } else {
     target += bernoulli_lpmf(0 | p_zero_home) + poisson_log_lpmf(y1[g] | home + att[h[g]] + def[a[g]]);
    
    }
    
    if (y2[g] == 0) {
      target += log_sum_exp(/* Structural zero */ 
                              bernoulli_lpmf(1 | p_zero_away), 
                            /* Poisson zero */ 
                              bernoulli_lpmf(0 | p_zero_away) + 
                              poisson_log_lpmf(y2[g] | att[a[g]] + def[h[g]])
      ); 
    } else {
      target += bernoulli_lpmf(0 | p_zero_away) + poisson_log_lpmf(y2[g] | att[a[g]] + def[h[g]]);
    }
    
  }
  // Usa o _raw para conseguir colocar a priori
  // Distribuicao do efeitos aleatórios
  for (t in 1:(T - 1)) {
    att_raw[t] ~ normal(mu_att, sigma_att);
    def_raw[t] ~ normal(mu_def, sigma_def);
  }
  // Efeito fixo eh comum as todas observacoes
  // Efeito aleatoria eh particular a algumas observacoes
  
  // Priori dos parametros de interesse
  home ~ normal(0, 2);
  mu_att ~ normal(0, 2);
  mu_def ~ normal(0, 2);
  sigma_att ~ cauchy(0, 2.5);
  sigma_def ~ cauchy(0, 2.5);
  // p_zero_home ~ beta(2, 5);
  // p_zero_away ~ beta(2, 5);
}
generated quantities {
  vector[G] y1_tilde;
  vector[G] y2_tilde;
  vector[G] log_lik;
  for (g in 1:G) {
    y1_tilde[g] = poisson_log_rng(home + att[h[g]] + def[a[g]]);
    y2_tilde[g] = poisson_log_rng(att[a[g]] + def[h[g]]);
    log_lik[g]  = poisson_log_lpmf(y1[g] | home + att[h[g]] + def[a[g]]) + 
      poisson_log_lpmf(y2[g] | att[a[g]] + def[h[g]]);
  } 
}
