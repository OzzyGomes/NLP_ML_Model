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
dim(dtm)

#função para converter em binario e em seguida em yes or no
convert <- function(x) 
{
  y <- ifelse(x > 0, 1,0)
  y <- factor(y, levels=c(0,1), labels=c("No", "Yes"))
  y
}  

#aplicando a função ao dataframe
datanaive = apply(dtm, 2, convert)

#transformando em dataframe
dataset = as.data.frame(as.matrix(datanaive))   
#adicionando mais uma coluna com o sentimento de cada frase
dataset$Class = factor(twitter$sentiment)

#Modelagem Naive Bayes
set.seed(31)
split = sample(2,nrow(dataset),prob = c(0.75,0.25),replace = TRUE)
train_set = dataset[split == 1,]
test_set = dataset[split == 2,] 

#Aplicando Naive Bayes
classifier_nb <- naiveBayes(train_set[1:1439],train_set$Class)

nb_predict <- predict(classifier_nb, type = "class", newdata = test_set[1:1439])

#verificando a acuracia do modelo
confusionMatrix(nb_predict, test_set$Class)
