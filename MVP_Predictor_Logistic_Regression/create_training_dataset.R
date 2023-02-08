Sys.setenv("VROOM_CONNECTION_SIZE" = 262144)
library("nbastatR")
library("dplyr")
library("tidyverse")

gamedata <- game_logs(seasons = 2013:2022)
gamedata <- mutate(gamedata, isWin = case_when(outcomeGame == "W" ~ 1,
                                               outcomeGame == "L" ~ 0), isGame = 1)
gamedata %>% select(outcomeGame, isWin)
gamedata <- gamedata  %>% group_by(yearSeason) %>% group_split(gamedata)
training_data = tibble()
for(x in 1:10) {
  print("SEASON 1")
  print("-----------------------------------------")
  wins <- aggregate(gamedata[[x]]$isWin, list(gamedata[[x]]$namePlayer), sum)
  total_games <- aggregate(gamedata[[x]]$isGame, list(gamedata[[x]]$namePlayer), sum)
  pts <- aggregate(gamedata[[x]]$pts, list(gamedata[[x]]$namePlayer), mean)
  ast <- aggregate(gamedata[[x]]$ast, list(gamedata[[x]]$namePlayer), mean)
  reb <- aggregate(gamedata[[x]]$treb, list(gamedata[[x]]$namePlayer), mean)
  new_df <- tibble(
    names = pts$Group.1,
    pts = pts$x,
    ast = ast$x,
    reb = reb$x,
    wins = wins$x,
    total_games = total_games$x,
    win_pct = wins/total_games,
    year = 2012+x
  )
  training_data <- bind_rows(training_data, new_df)
}
training_data
#write.csv(training_data, "MVP_Model_Training_data.csv", row.names = FALSE)
```