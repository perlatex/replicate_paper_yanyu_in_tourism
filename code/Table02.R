library(tidyverse)
library(gtsummary)
library(lavaan)

rawdf <- haven::read_sav("./data/Liminal_Experience.sav") %>% 
  drop_na()

pairs <- readxl::read_excel("./data/variables.xlsx") %>% 
  select(colname, long_name) %>% 
  deframe()



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

fit_cfa2 <- cfa(model, data = rawdf)



constructs <- c(
    "Physical_tourscape",
    "Social_tourscape",
    "Socially_symbolic_tourscape",
    "Natural_tourscape"
  )



CR <- semTools::compRelSEM(
  fit_cfa2, 
  dropSingle = FALSE,
  higher = c("Physical_tourscape") # 二阶因子
  ) 

# semTools::AVE 函数并不直接提供对于二阶因子的AVE的计算
AVE  <- semTools::AVE(fit_cfa2) 


d2_CR_AVE <- tibble(
  items = names(CR),
  CR    = CR#,
  #AVE   = AVE
 ) %>% 
  filter(items %in% constructs) %>% 
  arrange(factor(items, levels = constructs))



tbl_orders <- c(
  "Physical_tourscape", "Ambient", "Space", "Signs" ,
  "Social_tourscape", "Social1", "Social2", "Social3", "Social4", "Social5",
  "Socially_symbolic_tourscape", "Symbol1" , "Symbol2" , "Symbol3",
  "Natural_tourscape", "Nature1" , "Nature2" , "Nature3"
  )


table02 <- fit_cfa2 %>% 
  parameterestimates(standardized = TRUE) %>% 
  filter(op == "=~") %>% 
  filter(lhs %in% constructs) %>% 
  arrange(factor(lhs, levels = constructs)) %>% 
  select(items = rhs, Loading = std.all) %>% 
  dplyr::add_row(tibble(items = constructs), .before = 1) %>%  
  left_join(d2_CR_AVE, by = join_by(items)) %>% 
  arrange(factor(items, levels = tbl_orders)) %>% 
  mutate(items = recode(items, !!!pairs)) %>% 
  
  knitr::kable(
    "latex", 
    booktabs = TRUE, 
    align = "l", 
    caption = 'CFA results of tourscape.',
    linesep = "",
    digits = 3
  ) %>%
  kableExtra::kable_styling(
    latex_options = c("HOLD_position"),
    position      = "center"
  ) 



