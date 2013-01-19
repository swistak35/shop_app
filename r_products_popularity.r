library("ggplot2")
library("RCurl")
library("rjson")

myJSON <- getURL("http://localhost:3000/admin/orders/order_items.json?bot_token=foobar")
jsonList <- fromJSON(paste(myJSON, ""))

names <- unlist(lapply(jsonList, function(x) x$name))
df <- as.data.frame(table(names)) # magic counting function 'table'

ggplot(df, aes(x=names, y=Freq, group=1)) +
  geom_point() + coord_flip() + # chart as points, flip 90 degrees
  geom_line(y=mean(df$Freq), colour="red") + # red line - mean
  geom_line(y=median(df$Freq), colour="blue") # blue line - median