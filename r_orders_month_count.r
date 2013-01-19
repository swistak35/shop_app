library("DBI")
library("RPostgreSQL")
library("ggplot2")

args <- commandArgs(TRUE)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname="shop_app_development",
  user="shop_app_user", password="")
rs <- dbSendQuery(con, "SELECT COUNT(id) AS count,
  to_char(ordered_at, 'YYYY-MM-DD') AS day FROM orders
  WHERE ordered_at IS NOT NULL AND ordered_at < (current_date - 14)
  GROUP BY day ORDER BY day;")
chunk <- fetch(rs, n=-1)

path = sprintf("public/charts/%s.png", args)
png(path, width = 1000, height = 600)
ggplot(chunk, aes(x=day, y=count, group=1)) +
  geom_point() + geom_line()
dev.off()