library("DBI")
library("RPostgreSQL")
library("ggplot2")

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname="shop_app_development",
  user="shop_app_user", password="")

rs <- dbSendQuery(con, "SELECT categories.name,
  COUNT(products.id) FROM categories INNER JOIN
  products ON products.category_id = categories.id
  GROUP BY categories.id, categories.name")

chunk <- fetch(rs, n=-1)
ggplot(chunk, aes(x = name, y = count)) +
  geom_bar() + coord_flip()
