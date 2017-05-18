setwd("~/Documents/Grinnell College/2016-2017/Spring/MAT397/Network/netsci/")

source("https://bioconductor.org/biocLite.R")
biocLite(c("GO.db","impute","preprocessCore"))

require(networkD3)
require(igraph)
require(plyr)
require(foreach)
require(WGCNA)

#http://www-personal.umich.edu/~mejn/netdata/

g<-read.graph("netscience/netscience.gml",format=c("gml"))
adjacency <- get.adjacency(g,sparse = F)
#######################
save(adjacency,file = "ScientistNetwork/adjacency.RData")
#######################
members <- V(g)$label
network <- igraph_to_networkD3(g,members)
colnames(network$nodes) <- c("id","label")
network$nodes$group <- rep("1",dim(network$nodes)[1])
network$links <- foreach(x=1:dim(network$links)[1],.combine='rbind') %do%
    c(min(network$links$source[x],network$links$target[x]),
      max(network$links$source[x],network$links$target[x]),
      network$links$value[x])
network$links <- data.frame(network$links)
colnames(network$links) <- c("source","target","value")
rownames(network$links) <- NULL
network$links <- network$links[order(network$links$source),]
network$nodes <- network$nodes[sapply(c(1:dim(network$nodes)[1]),
                                      function(x) 
                                          ((x %in% network$links$source) | (x %in% network$links$target))),]
numnodes <- dim(network$nodes)[1]
network$links$source <- mapvalues(network$links$source,
                                  from=network$nodes$id,
                                  to=(c(1:numnodes)-1))
network$links$target <- mapvalues(network$links$target,
                                  from=network$nodes$id,
                                  to=(c(1:numnodes)-1))
network$nodes$id <- c(1:numnodes)
##################
save(network,file = "ScientistNetwork/network.RData")
##################

closeness <- sapply(c(1:numnodes),
                    function(x) 
                        1/sum(network$links$value[network$links$source==x]))
closeness[which(is.infinite(closeness))] <- min(closeness)
closeness <- (closeness/min(closeness)+100)/10
network$nodes$size <- closeness

forceNetwork(Links = network$links, Nodes = network$nodes,
             Source = "source", Target = "target",
             Value = "value", Group = "group",
             NodeID = "label", Nodesize = "size", 
             opacity = 0.8,zoom = T,fontSize = 14,charge = -20)



