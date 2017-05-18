require(networkD3)

load(file = "network.RData")
load(file = "adjacency.RData")
centralitytypes <- c("None","Degree","Closeness","Eigenvector")