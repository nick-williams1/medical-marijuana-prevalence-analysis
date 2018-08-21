library(readr)
library(forcats)

#loading in data

rdas_2002_2003 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2002_2003.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))
rdas_2004_2005 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2004_2005.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))
rdas_2006_2007 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2006_2007.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))
rdas_2008_2009 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2008_2009.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))
rdas_2010_2011 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2010_2011.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))
rdas_2012_2013 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2012_2013.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))
rdas_2014_2015 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2014_2015.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))
rdas_2015_2016 <- read_csv("C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/raw_data/rdas_2015_2016.csv", 
                           col_types = cols("STATE FIPS CODE (NUMERIC)" = col_character()))

#binding all data

rdasAllYears <- rdas_2002_2003 %>%
  bind_rows(rdas_2004_2005) %>%
  bind_rows(rdas_2006_2007) %>%
  bind_rows(rdas_2008_2009) %>%
  bind_rows(rdas_2010_2011) %>%
  bind_rows(rdas_2012_2013) %>% 
  bind_rows(rdas_2014_2015) %>%
  bind_rows(rdas_2015_2016) %>%
  rename(
    code = 'STATE FIPS CODE (NUMERIC)',
    age = 'AGE CATEGORY RECODE (3 LEVELS)',
    use = 'Column %',
    did_use = 'MARIJUANA - PAST MONTH USE',
    standard_error = 'Column % SE',
    lower_limit = 'Column % CI (lower)',
    upper_limit = 'Column % CI (upper)'
  )
  
#cleaning time...

rdasAllYears <- rdasAllYears %>% 
  filter(did_use == '1 - Used within the past month') %>% 
  select(year, code, state, age, use, 
         standard_error, lower_limit, upper_limit) %>% 
  filter(age != 'Overall', 
         state != 'overall') %>% 
  separate(age, c('agegrp', 'age'), 
           sep = "-")

rdasAllYears$lower_limit <- as.double(rdasAllYears$lower_limit)
rdasAllYears$upper_limit <- as.double(rdasAllYears$upper_limit)

rdasAllYears <- rdasAllYears %>% 
  mutate(
    prevalence = use * 100,
    se = standard_error * 100,
    ci_lower = lower_limit * 100,
    ci_upper = upper_limit * 100) %>% 
  select(state, code, year, agegrp, 
         age, prevalence, se, ci_lower, ci_upper) %>% 
  filter(state != 'District of Columbia')

for (i in 1:nrow(rdasAllYears)) {
  if (rdasAllYears$age[i] == " 12") {
    rdasAllYears[i, "age"] <- '12-17'
  } else if (rdasAllYears$age[i] == " 18") {
      rdasAllYears[i, "age"] <- '18-25'
  } else if (rdasAllYears$age[i] == " 26 or Older") {
      rdasAllYears[i, "age"] <- '26+'
  }
}

rdasAllYears <- rdasAllYears %>% 
  group_by(year) %>% 
  arrange(agegrp) %>% 
  arrange(state) 

rdasAllYears_split <-  rdasAllYears %>% 
  separate(year, c('year_start', 'year_end', 
                   sep = "-")) %>% 
  select(-'-')

#exporting cleaned data to csv files

write.csv(rdasAllYears, "C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/clean_data/rdas_pastmonthmj_2002_2016.csv", 
          row.names = FALSE)
write.csv(rdasAllYears_split, "C:/Users/niwi8/OneDrive/Documents/Practicum/MML_analysis/RDAS_data/clean_data/rdas_pastmonthmj_splityears_2002_2016.csv", 
          row.names = FALSE)
