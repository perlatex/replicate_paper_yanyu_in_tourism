library(tidyverse)
library(gtsummary)
library(lavaan)

rawdf <- haven::read_sav("./data/Liminal_Experience.sav") %>% 
  drop_na()



model <- '

 # first order construct
   Ambient  =~ Ambient1 + Ambient2 + Ambient3 + Ambient4
   Space    =~ Space1 + Space2 + Space3 + Space4 + Space5 + Space6
   Signs    =~ Signs1 + Signs2 + Signs3 + Signs4 + Signs5 + Signs6

   Social_tourscape   =~ Social1 + Social2 + Social3 + Social4 + Social5
   Socially_symbolic_tourscape =~ Symbol1 + Symbol2 + Symbol3
   Natural_tourscape =~ Nature1 + Nature2 + Nature3

 # second order construct
   Physical_tourscape  =~ Ambient + Space + Signs

'

fit_cfa3 <- cfa(model, data = rawdf)


constructs <- c(
    "Physical_tourscape",
    "Social_tourscape",
    "Socially_symbolic_tourscape",
    "Natural_tourscape"
  )




# semTools::AVE 函数并不直接提供对于二阶因子的AVE的计算
AVE  <- semTools::AVE(fit_cfa3) 

# 构念之间的相关系数矩阵
m <- lavInspect(fit_cfa3, what = "cor.lv") 
m <- m[constructs, constructs]
m[upper.tri(m)] <- NA



table03 <- m %>% 
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
    caption = "Discriminant validity test of tourscape.",
    linesep = "",
    digits = 3
  ) %>%
  kableExtra::kable_styling(
    latex_options = c("HOLD_position"),
    position      = "center"
  ) %>%
  kableExtra::footnote("The bold diagonal elements are square roots of AVE for each construct. Below diagonal elements are the correlations between constructs.", threeparttable = T)






