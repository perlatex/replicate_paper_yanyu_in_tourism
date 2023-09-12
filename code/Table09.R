library(tidyverse)
library(gtsummary)
library(lavaan)


rawdf <- haven::read_sav("./data/Liminal_Experience.sav") %>% 
  drop_na()



model <- '
 # first order factor
   Ambient  =~ Ambient1 + Ambient2 + Ambient3 + Ambient4
   Space    =~ Space1 + Space2 + Space3 + Space4 + Space5 + Space6
   Signs    =~ Signs1 + Signs2 + Signs3 + Signs4 + Signs5 + Signs6

   Social_tourscape  =~ Social1 + Social2 + Social3 + Social4 + Social5

   Socially_symbolic_tourscape  =~ Symbol1 + Symbol2 + Symbol3

   Natural_tourscape  =~ Nature1 + Nature2 + Nature3

   Emotional_arousal =~ em1 + em2 + em3 + em4 + em5

   Experience_seeking       =~ es1  + es2
   Thrill_adventure_seeking =~ tas1 + tas2
   Disinhibition            =~ dis1 + dis2
    
   Destination_familiarity =~ fm1 + fm2 + fm3 

   romance_and_relax        =~ ex1  + ex11 + ex14 + ex2 + ex5 + ex15 + ex4
   chance_encounter         =~ ex10 + ex9  + ex8  + ex6 + ex7
   sense_of_loss            =~ ex17 + ex18 + ex16
   aberration               =~ ex3  + ex13 + ex12


# second order factor
  Physical_tourscape  =~ Ambient + Space + Signs

  Sensation_seeking =~ Experience_seeking + Thrill_adventure_seeking + Disinhibition

  Liminal_experience  =~ romance_and_relax + chance_encounter + sense_of_loss + aberration


'

fit_cfa9 <- cfa(model, data = rawdf)




# 区分效度
table09 <- fit_cfa9 %>% 
  semTools::discriminantValidity() %>%  
  select(lhs, rhs, est, ci.lower, ci.upper) %>%

  knitr::kable(
    "latex", 
    booktabs = TRUE, 
    align = "l", 
    caption = 'Discriminant validity test of all constructs (confidence interval test).',
    linesep = "",
    digits = 3
  ) %>%
  kableExtra::kable_styling(
    latex_options = c("HOLD_position"),
    position      = "center"
  ) 
