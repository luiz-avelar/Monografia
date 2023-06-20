data {
  int<lower=1> G; // Numero total de jogos
  int<lower=1> T; // Numero de total times
  int<lower=1> C; // Numero de componentes
  int<lower=0, upper=T> h[G]; // Indice do time que joga em casa no G-esimo jogo
  int<lower=0, upper=T> a[G]; // Indice do time que joga como visitante no G-esimo jogo
  int<lower=0> y1[G]; // Numero de gols marcados no G-esimo jogo pelo time que joga em casa
  int<lower=0> y2[G]; // Numero de gols marcados no G-esimo jogo pelo time que joga como visitante
}

parameters {
  real home;
  real<lower=-3, upper=0> mu_att1;
  real<lower=0, upper=3> mu_att3;
  real<lower=0, upper=3> mu_def1;
  real<lower=-3, upper=0> mu_def3;
  real<lower=0> sigma_att[C];
  real<lower=0> sigma_def[C];
  vector[T] att_raw;
  vector[T] def_raw;
  simplex[3] pi_att[T];
  simplex[3] pi_def[T];
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
  real m_att[C];
  real m_def[C];
  // vector[G] lambda1;
  // vector[G] lambda2;
  // vector[G] m_y1;
  // vector[G] m_y2;
  
  home ~ normal(0, 4);
  mu_att1 ~ normal(0, 10) T[-3,0];
  mu_att3 ~ normal(0, 10) T[0,3];
  mu_def1 ~ normal(0, 10) T[0,3];
  mu_def3 ~ normal(0, 10) T[-3,0];
  
  sigma_att ~ cauchy(0, 2.5);
  sigma_def ~ cauchy(0, 2.5);
  
  
  for (t in 1:T) {
    pi_att[t] ~ dirichlet(rep_vector(1, C));
    pi_def[t] ~ dirichlet(rep_vector(1, C));
    
    m_att[1] = log(pi_att[t, 1]) + normal_lpdf(att[t] |  mu_att1, sigma_att[1]);
    m_att[2] = log(pi_att[t, 2]) + normal_lpdf(att[t] |  0, 0.01);
    m_att[3] = log(pi_att[t, 3]) + normal_lpdf(att[t] |  mu_att3, sigma_att[3]);
    m_def[1] = log(pi_def[t, 1]) + normal_lpdf(def[t] |  mu_def1, sigma_def[1]);
    m_def[2] = log(pi_def[t, 2]) + normal_lpdf(def[t] |  0, 0.01);
    m_def[3] = log(pi_def[t, 3]) + normal_lpdf(def[t] |  mu_def3, sigma_def[3]);
    
    
    target += log_sum_exp(m_att) + log_sum_exp(m_def);
  }
  
  for (g in 1:G) {
    y1[g] ~ poisson_log(home + att[h[g]] + def[a[g]]);
    y2[g] ~ poisson_log(att[a[g]] + def[h[g]]);
  }
  
}

// generated quantities {
//   vector[G] y1_tilde;
//   vector[G] y2_tilde;
//   vector[G] log_lik;
//   for (g in 1:G) {
//     y1_tilde[g] = poisson_log_rng(home + att[h[g]] + def[a[g]]);
//     y2_tilde[g] = poisson_log_rng(att[a[g]] + def[h[g]]);
//     log_lik[g] = poisson_log_lpmf(y1[g] | home + att[h[g]] + def[a[g]]) +
//       poisson_log_lpmf(y2[g] | att[a[g]] + def[h[g]]);
//   } 
// }