
# load data
external_data_1 <-
  read.csv("./external/data_source_1.csv") #input

# load data
external_data_2 <-
  read.csv("./external/data_source_2.csv") #input

# write data
write.csv(rbind(external_data_1,external_data_2),
          "./internal/compiled_data.csv") #output
