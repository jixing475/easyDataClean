
<!-- README.md is generated from README.Rmd. Please edit that file -->

# easyDataClean

<!-- badges: start -->
<!-- badges: end -->

The goal of easyDataClean is to …

# Misc

## df_to_subsetList

这个函数主要是按照行来切分数据框, 比如 100 行的 df, 按照每五行来切分,
就可以切成 20 个小的数据框, 存成 list, 方便调用 future_map
函数来进行并行计算

思路: group_by

input: 你想要切分的子数据框数目 output: 含有一系列结构相同的子数据框的
list

``` r
library(tidyverse)

df_to_subsetList <- function(df, group_num = 3) {
  
  df_list <- 
  df %>%
    dplyr::mutate(split_group = rep(
      1:group_num,
      each = nrow(.) / group_num,
      len = nrow(.)
    )) %>%
    
    
    dplyr::group_by(split_group) %>%
    tidyr::nest() %>%
    
    
    dplyr::select(split_group, data) %>%
    printy::super_split(split_group) %>%
    purrr::map(~ .x[["data"]][[1]])
  
  return(df_list)
}


iris %>% 
  df_to_subsetList(group_num = 4) 
```

## transfer

一个 R 版本的在线传输函数

先看一下 shell 版本的

``` bash
# curl --upload-file demo.rds https://transfer.sh/`basename "demo.rds"` 
```

``` r
df = iris



transfer.sh <- function(obj, type = "rds") {
  # type: rds or feather
  
  if (type == "rds"){
    tmp_file <- tempfile() %>% paste0(".rds")
    readr::write_rds(obj, tmp_file)
  } else {
    tmp_file <- tempfile() %>% paste0(".feather")
    arrow::write_feather(obj, tmp_file)
  }
  
  download_url <- 
  stringr::str_glue('curl --upload-file {tmp_file} https://transfer.sh/`basename "{tmp_file}"` ') %>%
    system(intern = TRUE)
  
  return(download_url)
}


df %>% 
  transfer.sh(type = "feather")

# df_new <- readr::read_rds("https://transfer.sh/saV5ft/file70602fa86c81.rds")
```

## ref

[easystats/datawizard: Magic potions to clean and transform your data
🧙](https://github.com/easystats/datawizard)
