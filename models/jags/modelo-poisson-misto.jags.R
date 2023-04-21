{   
  for(g in 1:G) {  
    y1[g] ~  dpois(lambda1[g])
    lambda1[g] = exp(home + att[h[g]] + def[a[g]]) # h e a são passados nos dados
    
    y2[g] ~  dpois(lambda2[g])
    lambda2[g] = exp(att[a[g]] + def[h[g]])
  }
  
  for(t in 1:(T-1)) {
    att_raw[t] ~ dnorm(mu_att, tau_att)  ## tau = 1/sigma2
    def_raw[t] ~ dnorm(mu_def, tau_def)
    att[t] = att_raw[t]
    def[t] = def_raw[t]
  }
  
  att[T] = 0
  def[T] = 0
  
  tau_eff = 1/sigma_sq_eff ## sigma_sq_eff passado nos dados
  
  mu_att ~ dnorm(0, tau_eff)
  mu_def ~ dnorm(0, tau_eff)
  
  tau_att ~ dgamma(a_att, b_att) ## a_att e b_att vem nos dados
  tau_def ~ dgamma(a_def, b_def)
}