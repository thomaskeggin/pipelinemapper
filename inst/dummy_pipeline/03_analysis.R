processed_data <-
  read.csv("./internal/processed_data.csv") #input

some_analysis_steps <-
  processed_data

saveRDS(some_analysis_steps,
        "./results/model_outputs.rds") #output

png("./plots/a_nice_plot.png") #output
plot(some_analysis_steps)
dev.off()
