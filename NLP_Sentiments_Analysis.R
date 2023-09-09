#Segundo test - Project Gutenberg
library("dplyr")
library("tidytext")
library("ggplot2")
library("lexiconPT")
library("janeaustenr")
library("stringr")
library("tidyr")
library("wordcloud")

#tipos de sentimentos
#o afinm classifica as palavras em um range de -5 até 5 onde -5 é a palavra
# muito negativa e 5 muito positiva 
get_sentiments("afinn")
# o bing clasifica as palavras de maneira categorica, positiva e negativa
get_sentiments("bing")
# o nrc traz uma gama de sentimento para cada tipo de palavra
get_sentiments("nrc")

tidy_books <- austen_books() %>% group_by(book) %>% unnest_tokens(word, text)

#buscar alegria
nrc_joy <- get_sentiments("nrc") %>%  filter(sentiment == "joy")

#Realizar inner join com o livro EMMA para entender sentimentos
book <- tidy_books %>% filter(book == 'Emma') %>% inner_join(nrc_joy) %>% count(word, sort = TRUE)

#usando o sistema bing para calcular o sentimento em polaridade
jane_austen_sentiment <- tidy_books %>% inner_join(get_sentiments("bing"))

persuasion <- jane_austen_sentiment %>% filter(book == "Persuasion")

#ifelse para criar uma coluna dummie 
persuasion <- persuasion %>% mutate(
  net_sentiment = ifelse(sentiment=="negative",-1,1))

# somando os dummies e assim verificando o sentimento do texto
sum(persuasion$net_sentiment)

#word cloud
mansfield <- tidy_books %>% filter(book == "Mansfield Park")

mansfield %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red", "green"),
                   scale=c(1,.5),
                   max.words = 100)
