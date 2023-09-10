#packages
library("readxl")
library("tm")
library("wordcloud")
library("e1071")
library("gmodels")
library("SnowballC")
library("caret")
library("dplyr")

# Pegando os dados
twitter <- read.csv2('twitter_validation.csv',sep = ',', header = FALSE)

#selecionando apenas as colunas V# e V4 do dataframe e filtrando positivo e negativo
twitter <- twitter %>% select(V3,V4) %>% filter(V3 == c('Positive', 'Negative'))

#renomeando colunas
colnames(twitter) <- c('sentiment', 'text')

#transformando em corpus TM
corpus <- VCorpus(VectorSource(twitter$text))

