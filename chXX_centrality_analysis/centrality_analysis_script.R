# install igraph package for network analysis
install.packages("igraph")
# load igraph package
library(igraph)

## General
# load edgelist file
d <- read.table("ecoli_ppi_Hu_etal_2009.txt")
# generate the network (graph object)
g <- simplify(graph.data.frame(d,directed=F),remove.multiple=T,remove.loops=T)

# display the netwrok
# plot(g)
g_example <- graph.ring(10)
plot(g_example,vertex.size=15,vertex.color="Pink",edge.color="gray80",edge.width=6)

# extract the largest weakly-connected compornent
cls <- clusters(g,"weak")
g <- delete.vertices(g,subset(V(g),cls$membership!=which(cls$csize==max(cls$csize))[[1]]))

# global network property
# number of nodes
vcount(g)
# number of links
ecount(g)
# node degree
deg <- degree(g)
# average degree
mean(deg)
# Degree distribution (log-log plot)
plot(0:max(degree(g)),degree.distribution(g),log="xy",xlab="k",ylab="P(k)")
# average shortest path length
average.path.length(g)
# diameter
diameter(g)
# clustering coefficient
cc <- transitivity(g,type="local",isolates="zero")
# average clustering coefficnet
mean(cc)
# global clustering coefficient (ADVANCED TOPICS 2.A in Network Science).
transitivity(g,type="global")

## Evaluating gene essentiality-nodal property associations in a protein interaction network
# gene essentiality
ess <- read.table("ecoli_proteins_essentiality_Baba2006MSB.txt",header=T)

# degree centrality
nprop <- data.frame(V(g)$name,degree(g))
# clustering coefficient
nprop <- data.frame(V(g)$name,transitivity(g,type="local",isolates="zero"))
# closeness centrality
nprop <- data.frame(V(g)$name,closeness(g))
# Katz centrality
nprop <- data.frame(V(g)$name,alpha_centrality(g,alpha = 0.5))
# betweenness centrality
nprop <- data.frame(V(g)$name,betweenness(g))
# eigenvector centraliry
nprop <- data.frame(V(g)$name,evcent(g)$vector)
# page rank
nprop <- data.frame(V(g)$name,page.rank(g)$vector)

# assign the labels
names(nprop) <- c("gene","nodal_property")

# merge the data
d <- merge(ess,nprop,by="gene")

# boxplot
boxplot(d$nodal_property~d$essential,xlab="Essentiality",ylab="Nodal property")

# centrality of essential genes
ess_nprop <- d[d$essential=="E",]$nodal_property
# centrality of non-essential genes
noness_nprop <- d[d$essential=="N",]$nodal_property

# wilcoxon test
wilcox.test(ess_nprop,noness_nprop)

# ROC curve
library(pROC)
d2 <- d[d$essential!="n",]
d2$essential <- ifelse(d2$essential == "E",1,0)
plot.roc(d2$essential,d2$nodal_property,print.auc=T)
