########## Reporting with RMarkdown, remember to open and run XQuartz when call this file in .Rmd to be able to open View() function##########
library("dplyr")

#install.packages("rworldmap") first time used it but after installation commented it
library("rworldmap")  # this is for quick mapping to replace ggplot2

#install.packages("rworldxtra") # for high resolution maps; note: first time used it but after installation commented it
library("rworldxtra")


library("RColorBrewer")

####### plotting Worldbank data from https://data.worldbank.org/indicator/SP.DYN.LE00.IN #####
life_exp <- read.csv(
  "data/API_SP.DYN.LE00.IN_DS2_en_csv_v2_1068806.csv",
  skip =4, stringsAsFactors = FALSE # skip first 4 rows
)

View(life_exp)

# find the country with longest life expectancy in 2015
longest_le <- life_exp %>%
  filter(X2015 == max(X2015, na.rm = T)) %>%
  select(Country.Name, X2015) %>%
  mutate(expectancy = round(X2015, 1))

View(longest_le)

# find the country with shortest life expectancy in 2015
shortest_le <- life_exp %>%
  filter(X2015 == min(X2015, na.rm = T)) %>%
  select(Country.Name, X2015) %>%
  mutate(expectancy = round(X2015, 1))

View(shortest_le)

# calculate range in life expectancy
le_difference <- longest_le$expectancy - shortest_le$expectancy
print(le_difference)

# add a table on 10 countries with greatest gain in life expectancy
top_10_gain <- life_exp %>%
  mutate(gain = X2015 - X1960) %>%
  top_n(10, wt = gain) %>% # to filter top 10
  arrange(-gain) %>% # sort gain column from big to small
  mutate(gain_str = paste(format(round(gain, 1), nsmall =1), "years")) %>%
  select(Country.Name, gain_str)

View(top_10_gain)

# use of rworldmap package for mapping
mapped_data <- joinCountryData2Map(
  life_exp,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)
  
  

