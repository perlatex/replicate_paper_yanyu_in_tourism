library(tidyverse)
library(gtsummary)
library(lavaan)

rawdf <- haven::read_sav("./data/Liminal_Experience.sav") %>% 
  drop_na()


d5 <- rawdf %>% 
  select(ex1:ex18) 


model_cfa <- '

  romance_and_relax =~ ex1 + ex11 + ex14 + ex2 + ex5 + ex15 + ex4
  chance_encounter  =~ ex10 + ex9 + ex8 + ex6 + ex7
  sense_of_loss     =~ ex17 + ex18 + ex16 
  aberration        =~ ex3 + ex13 + ex12
  
'

fit_cfa5 <- cfa(model = model_cfa, data = d5) 




constructs <- c(
    "romance_and_relax",
    "chance_encounter",
    "sense_of_loss",
    "aberration"
  )

# semTools::AVE 函数并不直接提供对于二阶因子的AVE的计算
AVE  <- semTools::AVE(fit_cfa5) 



# 构念之间的相关系数矩阵

m <- lavInspect(fit_cfa5, what = "cor.lv") 
m <- m[constructs, constructs]
m[upper.tri(m)] <- NA


table05 <- m %>% 
  as.data.frame() %>% 
  rownames_to_column(var = "name") %>% 
  filter(name %in% constructs) %>%
  select(name, any_of(constructs)) %>% 
  arrange(factor(name, levels = constructs)) %>% 
  set_names(c(" ", "1", "2", "3", "4")) %>% 

  knitr::kable(
    "latex",
    booktabs = TRUE,
    align = "l",
    caption = "Discriminant validity test of sub-dimensions of liminal experience (AVE test).",
    linesep = "",
    digits = 3
  ) %>%
  kableExtra::kable_styling(
    latex_options = c("HOLD_position"),
    position      = "center"
  ) %>%
  kableExtra::footnote("The bold diagonal elements are square roots of AVE for each construct. Below diagonal elements are the correlations between constructs.", threeparttable = T)


  