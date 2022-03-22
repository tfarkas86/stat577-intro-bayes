################################################################
##                                                            ##
##  bcarotene_analysis.r                                      ##
##                                                            ##
##    Demonstration file for beta-carotene analysis project   ##
##    Dr. Fletcher G.W. Christensen                           ##
##    26 March 2018                                           ##
##                                                            ##
################################################################

library(R2OpenBUGS)

bc_path <- "c:\\[data]\\School\\UNM\\Teaching\\577\\"
BUGS_path <- "c:\\OpenBUGS323\\OpenBUGS.exe"

bc_datafile <- "bcarotene.csv"
bc_modelfile <- "bcarotene_model.txt"

setwd(bc_path)


##  Set MCMC parameters.
chains <- 1           ##  One chain of MCMC values is obtained
burn_in <- 1000       ##  The first 1000 iterates from the MCMC chain are discarded
iterations <- 10000   ##  10,000 values are sampled from the posterior distribution
thin <- 1             ##  No thinning is performed


##  Import beta-carotene data an store it in new variable names for use with OpenBUGS.
bc_data <- read.csv(bc_datafile)

ptid <- bc_data$ptid
month <- bc_data$month
bcarot <- bc_data$bcarot
vite <- bc_data$vite
dose <- bc_data$dose
age <- bc_data$age
male <- bc_data$male
bmi <- bc_data$bmi
chol <- bc_data$chol
cauc <- bc_data$cauc
vauc <- bc_data$vauc


##  Define new variables for OpenBUGS to use.
n <- dim(bc_data)[1]
n_patients <- length( unique(ptid) )

intercept <- rep(1,n)
tx <- intercept - (month<4)


##  Define the design matrix for the model and specify the number of covariates, for use in OpenBUGS.
x <- cbind(intercept,tx,age)
n_covariates <- dim(x)[2]
tau_b <- 1

##  Establish data and parameter lists for use with OpenBUGS; define function for generating initial parameter values.
data <- list( "bcarot", "n", "n_patients", "n_covariates", "ptid", "x", "tau_b" )
inits <- function() {
  list( beta = rnorm( n_covariates, 0, 1 ),
        gamma = rnorm( n_patients, 0, 1 ),
        tau_bc = runif( 1, 0, 2 ),
        tau_g = runif( 1, 0, 2 ) )
}
parameters <- c( "beta", "gamma", "sigma_bc", "sigma_g" )

##  Run OpenBUGS to obtain posterior iterates for specified parameters.
##    (Remember you need to set "debug" to FALSE or close your OpenBUGS window to import posterior sample to R)
bcarotene.sim <- bugs( data, inits, parameters,
                       working.directory=bc_path, model.file=bc_modelfile, OpenBUGS.pgm=BUGS_path,
                       n.chains=chains, n.burnin=burn_in, n.iter=iterations+burn_in, n.thin=thin,
                       debug=TRUE )

## Assign variable names to posterior samples.
posterior_betas <- bcarotene.sim$sims.list$beta
posterior_gammas <- bcarotene.sim$sims.list$gamma
posterior_sigmas <- cbind( bcarotene.sim$sims.list$sigma_bc, bcarotene.sim$sims.list$sigma_g )