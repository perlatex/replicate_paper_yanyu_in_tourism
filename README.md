# 旅游中的艳遇

本文档的目标是学习[《A structural model of liminal experience in tourism》](https://doi.org/10.1016/j.tourman.2018.09.015)的分析流程，形式上复现文中的表格，论文作者是中山大学张辉教授，他很慷慨地提供了相关数据，特此感谢。



# 内容

数据分析流程体现在文中表格内容上。为了方便查阅，文中每个表格的复现都对应一个独立的Rmd文件


| 表格           | 内容                                                         |
|----------------|--------------------------------------------------------------|
| [Table 1](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table01_2order_construct.Rmd)        | 样本概况                                                     |
| [Table 2](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table02_2order_construct.Rmd)        | 旅游体验场景的验证性因子分析（CFA）的结果                    |
| [Table 3](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table03_2order_construct.Rmd)        | 旅游体验场景的区别效度检验                                   |
| [Table 4](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table04_2order_construct.Rmd)       | 艳遇体验的探索性因子分析（EFA）和验证性因子分析（CFA）的结果 |
| [Table 5](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table05_2order_construct.Rmd)        | 艳遇体验的区别效度检验（平均提取方差AVE）                    |
| [Table 6](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table06_2order_construct.Rmd)       | 艳遇体验的区别效度检验（置信区间）                           |
| [Table 7](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table07_2order_construct.Rmd)       | 整体测量模型的验证性因子分析（CFA）的结果                    |
| [Table 8](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table08_2order_construct.Rmd)        | 所有构念的区别效度检验（平均提取方差AVE）                    |
| [Table 9](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table09_2order_construct.Rmd)        | 所有构念的区别效度检验（置信区间）                           |
| [Table 10](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table10_2order_construct.Rmd)       | 结构方程模型的标准化系数                                     |
| [Table 11](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table11_2order_construct.Rmd)       | 结构方程模型的中介效应检验                                   |
| [Table Appendix](https://github.com/perlatex/replicate_paper_yanyu_in_tourism/blob/main/Table_Appendix_A.Rmd) | 描述性统计                                                   |


# 数据

数据仅用于课堂方法论的教学，不得用于其他用途。

- `Liminal_Experience.sav`
- `variables.xlsx`


# 宏包

运行代码需要安装以下宏包：

`install.packages(c("tidyverse", "flextable", "pysch", "gtsummary", "lavaan", "semTools", "haven", "sjPlot", "corrr", "readxl", "scales"))`
