# Edge swapping randomization
# http://www.sciencemag.org/content/298/5594/824
# 相互エッジ（<=>）の数、単方向エッジ（=>）の数、出次数、入次数を保存し、多重エッジや自己ループが生成されないように、ネットワークをランダム化するアルゴリズム
# 使い方は末尾参照
edge_swapping_randomization <- function(g){
  err_max <- 1000
  n_v <- vcount(g)
  is_directed_bool <- 1
  
  g <- simplify(g,remove.multiple=T,remove.loops=T)
  
  if(is_directed(g) == F) {
    g <- as.directed(g)
    is_directed_bool <- 0
  }
  
  g_one_way <- delete_edges(g,subset(E(g),which_mutual(g,eids=E(g))==T))
  g_mutual <- delete_edges(g,subset(E(g),which_mutual(g,eids=E(g))==F))
  
  m_rand <- as.matrix(as_adjacency_matrix(g))
  mutual_list <- as.data.frame(as_edgelist(as.undirected(g_mutual),names=F))
  one_way_list <- as.data.frame(as_edgelist(g_one_way,names=F))
  
  # for swapping mutual links
  err <- 0
  while(nrow(mutual_list) > 1 && err < err_max){
    repeat{
      idx <- sample(1:nrow(mutual_list),2)
      p1 <- mutual_list[idx[[1]],1]
      a1 <- mutual_list[idx[[1]],2]
      p2 <- mutual_list[idx[[2]],1]
      a2 <- mutual_list[idx[[2]],2]
      
      if((p1 != p2 && p1 != a2 && a1 != a2 && p2 != a1 && m_rand[p1,a2] == 0 && m_rand[a2,p1] == 0 && m_rand[p2,a1] == 0 && m_rand[a1,p2] == 0) || err >= err_max) {
        break
      }
      else {
        err <- err + 1
      }
    }
    
    if(err < err_max){
      err <- 0
      
      m_rand[p1,a1] <- 0
      m_rand[a1,p1] <- 0
      m_rand[p2,a2] <- 0
      m_rand[a2,p2] <- 0
      
      m_rand[p1,a2] <- 1
      m_rand[a2,p1] <- 1
      m_rand[p2,a1] <- 1
      m_rand[a1,p2] <- 1
      
      mutual_list <- mutual_list[-idx,]
    }
  }
  
  # for swapping one-way links
  err <- 0
  while(nrow(one_way_list) > 1 && err < err_max){
    repeat{
      idx <- sample(1:nrow(one_way_list),2)
      p1 <- one_way_list[idx[[1]],1]
      a1 <- one_way_list[idx[[1]],2]
      p2 <- one_way_list[idx[[2]],1]
      a2 <- one_way_list[idx[[2]],2]
      
      if((p1 != p2 && p1 != a2 && a1 != a2 && p2 != a1 && m_rand[p1,a2] == 0 && m_rand[p2,a1] == 0) || err >= err_max) {
        break
      }
      else {
        err <- err + 1
      }
    }
    
    if(err < err_max){
      err <- 0
      
      m_rand[p1,a1] <- 0
      m_rand[p2,a2] <- 0
      
      m_rand[p1,a2] <- 1
      m_rand[p2,a1] <- 1
      
      one_way_list <- one_way_list[-idx,]
    }
  }
  
  g_rand <- graph_from_adjacency_matrix(m_rand)
  
  if(is_directed_bool == 0){
    return(as.undirected(g_rand))
  }
  else {
    return(g_rand)
  }
}
