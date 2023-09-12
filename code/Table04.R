library(tidyverse)
library(gtsummary)

rawdf <- haven::read_sav("./data/Liminal_Experience.sav") %>% 
  drop_na()

pairs <- readxl::read_excel("./data/variables.xlsx") %>% 
  select(colname, long_name) %>% 
  deframe()



# 随机选择，一半做EFA，一半做CFA
set.seed(1024)
library(psych)

d4 <- rawdf %>% 
  select(ex1:ex18) %>% 
  mutate(id = row_number())

d4a  <- d4 %>% 
  slice_sample(prop = 0.5)

d4b <- anti_join(d4, d4a, by = join_by(id))
d4a <- d4a %>% select(-id)
d4b <- d4b %>% select(-id)




## efa
fit_efa4 <- d4a %>% 
  fa(nfactors = 4, 
     rotate   = "varimax", 
     fm       = "pa", 
     scores   = TRUE, 
     e.values = TRUE, 
     values   = TRUE)



# 特征值选择大于1的
constructs <- c(
  "romance_and_relax",  
  "chance_encounter", 
  "sense_of_loss", 
  "aberration"
  )

d4_efa_eigenvalue <- tibble(
  items = constructs,
  eigenvalue = fit_efa4$e.values[1:4]
)
  



# 方差解释度
d4_efa_variance <- fit_efa4$Vaccounted %>%  
  as_tibble() %>%  
  slice(2) %>% 
  set_names(constructs) %>% 
  pivot_longer(cols = everything(), 
               names_to = "items",
               values_to = "variance explained")





# 因子载荷
d4_efa_loadings <- fit_efa4$loadings %>%  
  unclass() %>%  
  as.data.frame() %>%  
  rownames_to_column("items") %>%  
  rowwise() %>% 
  mutate(loadings_efa = max(c_across(-items))) %>% 
  ungroup() %>% 
  select(items, loadings_efa)





## cfa
model_cfa <- '

  romance_and_relax =~ ex1 + ex11 + ex14 + ex2 + ex5 + ex15 + ex4
  chance_encounter  =~ ex10 + ex9 + ex8 + ex6 + ex7
  sense_of_loss     =~ ex17 + ex18 + ex16 
  aberration        =~ ex3 + ex13 + ex12
  
'

fit_cfa4 <- cfa(model = model_cfa, data = d4b) 


d4_cfa_loadings <- fit_cfa4 %>% 
  parameterestimates(standardized = TRUE) %>%  
  filter(op == "=~") %>% 
  select(items = rhs, loadings_cfa = std.all)





## 合并成大表
CR    <- semTools::compRelSEM(fit_cfa4)
AVE   <- semTools::AVE(fit_cfa4)

d4_cfa_CR_AVE <- tibble(
  items = names(CR),
  CR   = CR,
  AVE  = AVE
 )



tbl_orders <- c(
  "romance_and_relax",
  "ex1",
  "ex14",
  "ex11",
  "ex2",
  "ex15",
  "ex5",
  "ex4",
  
  "chance_encounter", 
  "ex10",
  "ex9",
  "ex8",
  "ex6",
  "ex7",
  
  "sense_of_loss", 
  "ex16",
  "ex17",
  "ex18",
  
  "aberration",
  "ex3",
  "ex13",
  "ex12"
  )



table04 <- d4_efa_loadings %>%
  left_join(d4_cfa_loadings, by = join_by(items)) %>% 
  dplyr::add_row(tibble(items = constructs), .before = 1) %>%  
  left_join(d4_efa_eigenvalue, by = join_by(items)) %>% 
  left_join(d4_efa_variance, by = join_by(items)) %>% 
  left_join(d4_cfa_CR_AVE, by = join_by(items)) %>% 
  arrange(factor(items, levels = tbl_orders)) %>% 
  mutate(items = recode(items, !!!pairs)) %>% 
  relocate(loadings_cfa, .before = CR) %>% 
  
  knitr::kable(
    "latex", 
    booktabs = TRUE, 
    align = "l", 
    caption = 'EFA and CFA results of liminal experience.',
    linesep = "",
    digits = 3
  ) %>%
  kableExtra::kable_styling(
    latex_options = c("HOLD_position"),
    position      = "center"
  ) 








