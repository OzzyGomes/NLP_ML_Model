#PACKAGES
library("janeaustenr")
library("dplyr")
library("tidytext")
library("ggplot2")

#carrregando textos

textos <- austen_books()

#transformando em um dataframe com a quantidade de palavras repetidas por livro
book_words <- textos %>% unnest_tokens(word,text) %>% group_by(book) %>% count(book, word, sort = TRUE)

#TF-IDF
books_tf_idf <- book_words %>% bind_tf_idf(word,book,n)

#Separa para ver palavras mais importantes por texto
sense_tf_idf <- books_tf_idf %>% filter(book == 'Sense & Sensibility')
mans_fild_tf_idf <- books_tf_idf %>% filter(book == 'Mansfield Park')

#Realiza gráfico com palavras mais importantes
#montando o dataframe
books_graph <- books_tf_idf %>% 
  group_by(book) %>% 
  slice_max(tf_idf, n = 15) %>% 
  ungroup() %>%
  mutate(word = reorder(word, tf_idf)) 

#montando o plot
books_graph %>% ggplot(aes(tf_idf, word, fill = book)) +
  geom_col(show.legend = FALSE) +
  labs(x = "tf-idf", y = NULL) +
  facet_wrap(~book, ncol = 2, scales = "free")
