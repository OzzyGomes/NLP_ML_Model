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
#Train set
corpus = VCorpus(VectorSource(twitter$text))
#convertendo para letras minusculas 
corpus = tm_map(corpus, content_transformer(tolower))
#Remmovendo numeros
corpus = tm_map(corpus, removeNumbers)
#removendo potuação
corpus = tm_map(corpus, removePunctuation)
#removendo stopwords
corpus = tm_map(corpus, removeWords, stopwords("english"))
#fazendo uma stemnização
corpus = tm_map(corpus, stemDocument)
#removendo espaços em branco
corpus = tm_map(corpus, stripWhitespace)

# DTM Matrix para identificar quantas vezes cada palavra aparece no documento
dtm = DocumentTermMatrix(corpus)
inspect(dtm)


