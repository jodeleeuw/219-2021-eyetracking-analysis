library(readr)
library(dplyr)
library(tidyr)
library(readtextgrid)

textgridfiles <- list.files('group-d/info/audio/timing_files/', full.names = T, pattern = ".TextGrid")

extract_timing <- function(file){
  df <- read_textgrid(file)
  
  num_tokens <- df %>%
    filter(tier_num == 1, text != "") %>%
    nrow()
  
  if(num_tokens == 6) {
    speech_list <- c("verb","noun_article", "noun", "with", "instrument_article", "instrument")
    token_list <- c(1,2,3,4,5,6)
  } else if(num_tokens == 7) {
    speech_list <- c("verb", "verb", "noun_article", "noun", "with", "instrument_article", "instrument")
    token_list <- c(1,1,2,3,4,5,6)
  } else {
    print(file)
    return()
  }
  
  out <- df %>%
    filter(tier_num == 1, text != "") %>%
    select(file, text, xmin, xmax) %>%
    mutate(speech_type = speech_list, token = token_list) %>%
    group_by(file, speech_type, token) %>%
    summarize(duration = (max(xmax) - min(xmin))*1000, onset = min(xmin)*1000) %>%
    ungroup() %>%
    mutate(sound = str_replace(file, ".TextGrid", ".mp3")) %>%
    select(sound, speech_type, onset, duration) %>%
    pivot_wider(names_from = speech_type, values_from = c(onset, duration))
  return(out)
}

result <- lapply(textgridfiles,extract_timing)

result.df <- bind_rows(result)

write_csv(result.df, 'group-d/info/audio_timing.csv')
