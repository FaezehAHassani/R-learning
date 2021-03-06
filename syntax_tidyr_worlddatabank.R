######### TIDYR ##################
########################################################
# install dplyr
install.packages("dplyr")
library("dplyr")

install.packages("tidyverse") # this package includes ggplot2 for visualisation
library("tidyverse")

install.packages("ggrepel") # to define geom_text_repel command
library("ggrepel")

# replace a cell value in df with NA
install.packages("naniar")
library("naniar")

library('scales') # adding this library removed the error: Error in check_breaks_labels(breaks, labels) : object 'percent' not found

############## load new csv file: World Data Bank ############################
  
wb_data <- read.csv(
  "world_bank_data.csv",
  stringsAsFactors = F
  # skip = 3 to skip the first 5 rows of data
  )
View(wb_data)

indicator_of_interest <- "Government expenditure on education, US$ (millions)"
expenditure_plot_data <- wb_data %>%
 rename(indicator = Series) %>%
 rename(X2010 = X2010..YR2010.) %>%
 rename(X2013 = X2013..YR2013.) %>%
 rename(X2014 = X2014..YR2014.) %>%
 rename(X2015 = X2015..YR2015.) %>%
 rename(X2016 = X2016..YR2016.) %>%
 rename(X2017 = X2017..YR2017.) %>%
 rename(X2018 = X2018..YR2018.) %>%
 filter(indicator == indicator_of_interest)

# to replce ".." valuses in the data frame to NA
expenditure_plot_data <- expenditure_plot_data %>%  
 replace_with_na(replace = list(X2010 = c(".."))) %>%
 replace_with_na(replace = list(X2013 = c(".."))) %>%
 replace_with_na(replace = list(X2014 = c(".."))) %>%
 replace_with_na(replace = list(X2015 = c(".."))) %>%
 replace_with_na(replace = list(X2016 = c(".."))) %>%
 replace_with_na(replace = list(X2017 = c(".."))) %>%
 replace_with_na(replace = list(X2018 = c("..")))

View(expenditure_plot_data)

# remove NA from data
expenditure_plot_data_noNA <- expenditure_plot_data %>% 
 drop_na(X2010) %>%
 drop_na(X2013) %>% 
 drop_na(X2014) %>% 
 drop_na(X2015) %>% 
 drop_na(X2016) %>% 
 drop_na(X2017) %>% 
 drop_na(X2018)  

# all the X2010-2018 columns are in string format however they should be converted to numbers
expenditure_plot_data_noNA$X2010 <- as.numeric(expenditure_plot_data_noNA$X2010)
expenditure_plot_data_noNA$X2013 <- as.numeric(expenditure_plot_data_noNA$X2013)
expenditure_plot_data_noNA$X2014 <- as.numeric(expenditure_plot_data_noNA$X2014)
expenditure_plot_data_noNA$X2015 <- as.numeric(expenditure_plot_data_noNA$X2015)
expenditure_plot_data_noNA$X2016 <- as.numeric(expenditure_plot_data_noNA$X2016)
expenditure_plot_data_noNA$X2017 <- as.numeric(expenditure_plot_data_noNA$X2017)
expenditure_plot_data_noNA$X2018 <- as.numeric(expenditure_plot_data_noNA$X2018)

# check if the column are numbers now for example for X2018?
expenditure_plot_data_noNA$X2018

View(expenditure_plot_data_noNA)

options(max.print = 99999) # when the number of points are alot it the show() command return the error of reaching mx.print, this command increase the maximum number

show(expenditure_chart) # if the plot doesn't show up automatically you can use this command
print(expenditure_chart) # if the plot doesn't show up automatically you can use this command

# plotting with ggplot2 
ggplot(data = expenditure_plot_data_noNA) +
  geom_text_repel( # add text to data points
    mapping = aes(x = X2010 / 100, y = X2018 /100, label = Country.Code), # define columns related to x and y
  ) +
  scale_x_continuous() + # scale_x_continuous(label = percent) will add % sign to the values on x_axis
  scale_y_continuous() +
  labs(title = indicator_of_interest, y = "Expenditure 2018", x = "Expenditure 2010")

# sort expenditure_plot_data_noNA based on year
long_year_data <- expenditure_plot_data_noNA %>%
  gather(
    key = year, # year is the new column
    value = value, # value is the new column
    X2010:X2018 # all columns between X2010 and X will be gathered
  )
View(long_year_data)

# make data set for a country of interest
senegal_plot_data <- long_year_data %>%
  filter(
    indicator_of_interest == indicator,
    Country.Code == "SEN" # Senegal
  ) %>%
  mutate(year = as.numeric(substr(x = year, 2, 5))) # remove X from X2010-2018 columns name: substr(x = "column name of choice, starting number of character in the column name, stopping character number in the column name)
View(senegal_plot_data)

# plot senegal_plot_data
chart_title <- paste(indicator_of_interest, "in Senegal")
ggplot(data = senegal_plot_data) + # when I assign ggplot to a name: senegal_plot <- ggplot, for some reason the plot is not shown automatically!
  geom_line(mapping = aes(x = year, y = value / 100)) +
  # scale_y_continuous(labels = percent) +
  labs(title = chart_title, x = "Year", y = "Percent of education expenditure")

# use original wb_data to make new wide_data
wide_data <- wb_data %>%
  rename(X2010 = X2010..YR2010.) %>%
  rename(X2013 = X2013..YR2013.) %>%
  rename(X2014 = X2014..YR2014.) %>%
  rename(X2015 = X2015..YR2015.) %>%
  rename(X2016 = X2016..YR2016.) %>%
  rename(X2017 = X2017..YR2017.) %>%
  rename(X2018 = X2018..YR2018.) %>%
  replace_with_na(replace = list(X2010 = c(".."))) %>%
  replace_with_na(replace = list(X2013 = c(".."))) %>%
  replace_with_na(replace = list(X2014 = c(".."))) %>%
  replace_with_na(replace = list(X2015 = c(".."))) %>%
  replace_with_na(replace = list(X2016 = c(".."))) %>%
  replace_with_na(replace = list(X2017 = c(".."))) %>%
  replace_with_na(replace = list(X2018 = c(".."))) %>%
  drop_na(X2010) %>%
  drop_na(X2013) %>% 
  drop_na(X2014) %>% 
  drop_na(X2015) %>% 
  drop_na(X2016) %>% 
  drop_na(X2017) %>% 
  drop_na(X2018) %>%
  gather(
    key = year, 
    value = value, 
    X2010:X2018
  ) %>%
  select(-Series.Code) %>%
  replace_with_na(replace = list(Series = "")) %>% # a few cells in Series coumn were empty, first I assigned NA to thos cells, then in the next command I excluded those rows containing NA
  drop_na(Series) %>%
  spread(
    key = Series,
    value = value
  ) 
View(wide_data)

wide_data$`Unemployment, female (% of female labor force)`

# plot unemployment verus literacy rate for female from wide_data data frame
wide_data$"Adult literacy rate, population 15+ years, female (%)" <- as.numeric( wide_data$"Adult literacy rate, population 15+ years, female (%)") 
wide_data$"Unemployment, female (% of female labor force)" <- as.numeric( wide_data$"Unemployment, female (% of female labor force)") 
x_var <- "Adult literacy rate, population 15+ years, female (%)"
y_var <- "Unemployment, female (% of female labor force)"
options(max.print = 99999)

lit_plot_data <- wide_data %>%
 mutate(
   lit_percent_2014 = wide_data[, x_var] / 100,
   employ_percent_2014 = wide_data[, y_var] /100
 ) %>%
   filter(year == "X2014")

ggplot(data = lit_plot_data) +
  geom_point(mapping = aes(x= lit_percent_2014, y = employ_percent_2014)) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = percent) +
  labs(
    x = x_var,
    y = y_var,
    title = "Female literacy versus female unemployment"
  )

####### commands to get help
# is.data.frame(expenditure_plot_data) return TRUE
# ? aes #aesthetic mapping
# ? geom_tex
# ? labels
#? scale_x_continuous
# ? ggproto
#? geom_text_repel
#? spread
#? as.numeric

 