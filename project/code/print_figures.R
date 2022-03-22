# Traceplot Figure Outputs
# Cuz R Notebooks not working

# betacarotene over time model
png("Dropbox/stat577/project/figures/bc_overtime_trace.png")
traceplot(fit_bc1, ask = FALSE, mfrow = c(3, 3), 
          width = 5000, height= 5000)
dev.off()


# vitmain E dose model
png("Dropbox/stat577/project/figures/ve_trace.png")
traceplot(fit_ve1, ask = FALSE, mfrow = c(3, 3), 
          width = 5000, height= 5000)
dev.off()

# vitamin E correlaton model
png("Dropbox/stat577/project/figures/ve_corr_trace.png")
traceplot(fit_cor1, ask = FALSE, mfrow = c(3, 3), 
          width = 5000, height= 5000)
dev.off()

# betacarotene interaction model
png("Dropbox/stat577/project/figures/bc_int_trace.png")
traceplot(fit_bc_int1, ask = FALSE, mfrow = c(3, 3), 
          width = 5000, height= 5000)
dev.off()
