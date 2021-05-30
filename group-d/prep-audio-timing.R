library(stringr)
library(readr)

audio.files <- list.files('group-d/info/audio', pattern=".mp3")

for(f in audio.files){
  p <- str_split(f, "\\.")[[1]][1]
  words <- str_split(p, "_")[[1]]
  write_lines(words, path=paste0('group-d/info/audio/', p,'.txt'))
}
