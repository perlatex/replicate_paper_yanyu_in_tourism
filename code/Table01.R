library(tidyverse)
library(scales)

rawdf <- haven::read_sav("./data/Liminal_Experience.sav") %>%
  drop_na() %>%
  filter(gender %in% c(1, 2)) %>%
  filter(edu %in% c(1, 2, 3))


d1 <- rawdf %>%
  select(gender, age, edu, income, time) %>%
  mutate(
    gender = factor(gender,
      levels = c(1, 2),
      labels = c("male", "female")
    ),
    age = factor(age,
      levels = c(1, 2, 3, 4),
      labels = c(
        "under 20",
        "21-30",
        "31-40",
        "above 41"
      )
    ),
    edu = factor(edu,
      levels = c(1, 2, 3),
      labels = c(
        "senior high school and below",
        "university",
        "master and above"
      )
    ),
    income = factor(income,
      levels = c(1, 2, 3, 4, 5),
      labels = c(
        "under 1500",
        "1500-3000",
        "3001-5000",
        "5001-7500",
        "above 7501"
      )
    ),
    time = factor(time,
      levels = c(1, 2, 3, 4),
      labels = c(
        "1",
        "2-3",
        "4-5",
        "> 6"
      )
    )
  )





table01 <- d1 %>%
  pivot_longer(cols = everything()) %>%
  summarise(Frequency = n(), .by = c(name, value)) %>%
  mutate(
    Percent = scales::label_percent(accuracy = 0.01)(Frequency / sum(Frequency)),
    .by = name
  ) %>%
  arrange(name, value) %>%
  knitr::kable(
    "latex",
    booktabs = TRUE,
    align = "lllr",
    caption = "Sample profile.",
    linesep = "",
    digits = 3
  ) %>%
  kableExtra::column_spec(1, bold = T, width = "5em") %>%
  kableExtra::collapse_rows(
    columns = 1,
    valign = "top",
    latex_hline = "none"
  ) %>%
  kableExtra::kable_styling(
    latex_options = c("HOLD_position"),
    position      = "center"
  )
