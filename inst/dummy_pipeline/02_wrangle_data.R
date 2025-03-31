processed_data <-
  read.csv("./internal/compiled_data.csv") #input

processed_data$new <- NA

write.csv(processed_data,
          "./internal/processed_data.csv") #output
