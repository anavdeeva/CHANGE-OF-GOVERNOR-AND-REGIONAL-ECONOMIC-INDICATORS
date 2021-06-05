clear all

import delimited "C:\Users\User\Downloads\Данные кр - Лист1 (15).csv", encoding(UTF-8) parselocale(ru_RU) clear 

encode region, generate(index)
drop if year == 2000 | year == 2001 | year == 2002 | year == 2019 | index == 12 | index == 77  | index == 18  

xtset index year
xtsum age tenure grp_pc_growth grp_growth crime_rate population unemp_growth ur_result turnout 

*Изменения по годам и по регионам:
tab year gov_change
tab index gov_change
xtsum

*Описательные статистики:
sum grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth ur_result_prev turnout_prev age tenure if year == 2003 | year == 2004
sum grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth ur_result_prev turnout_prev age tenure if year == 2005 | year == 2006 | year == 2007 | year == 2008 | year == 2009 | year == 2010 | year == 2011 | year == 2012
sum grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth ur_result_prev turnout_prev age tenure if year == 2013 | year == 2014 | year == 2015 | year == 2016 | year == 2017 | year == 2018 

*Распределения:
kdensity grp_pc_prev_growth, normal
kdensity poverty_prev_growth, normal
kdensity crime_rate_prev, normal
kdensity pop_growth_prev, normal

graph box age tenure

*Базовые модели:
xtlogit gov_change grp_pc_prev_growth
est store Model_0
margins, dydx(*)
xtlogit gov_change grp_pc_prev_growth, fe
est store Model_1
margins, dydx(*)
xtlogit gov_change grp_pc_prev_growth i.year, fe
est store Model_2
margins, dydx(*)

*Базовые модели с различными экономическими переменными:
xtlogit gov_change invest_growth_prev
est store Model_3
margins, dydx(*)
xtlogit gov_change poverty_prev_growth
est store Model_4
margins, dydx(*)

*Модели с разными контрольными переменными:
xtlogit gov_change grp_pc_prev_growth age tenure i.year, fe
est store Model_5
margins, dydx(*)

xtlogit gov_change grp_pc_prev_growth  pop_growth_prev poverty_prev_growth crime_rate_prev  age tenure i.year, fe 
est store Model_6
margins, dydx(*)

xtlogit gov_change grp_pc_prev_growth ur_part ur_result_prev turnout_prev age tenure i.year, fe 
est store Model_7
margins, dydx(*)

*Полная модель:
xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure , fe 
est store Model_8
margins, dydx(*)

xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure i.year, fe 
est store Model_9
margins, dydx(*)

esttab Model_0 Model_2 Model_5 Model_6 Model_7 Model_9

*Тест Хаусмана:
xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure, fe
est store fe
xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure, re
est store re
hausman fe re

*Полные модели по различным подпериодам:
xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure if year == 2005 | year == 2006 | year == 2007 | year == 2008 | year == 2009 | year == 2010 | year == 2011 | year == 2012, fe 
est store Model_10
margins, dydx(*)
xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure i.year if year == 2005 | year == 2006 | year == 2007 | year == 2008 | year == 2009 | year == 2010 | year == 2011 | year == 2012, fe 
est store Model_11
margins, dydx(*)

xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure if year == 2013 | year == 2014 | year == 2015 | year == 2016 | year == 2017 | year == 2018 , fe 
est store Model_12
margins, dydx(*)
xtlogit gov_change grp_pc_prev_growth  pop_growth_prev crime_rate_prev poverty_prev_growth  ur_part ur_result_prev turnout_prev age tenure i.year if year == 2013 | year == 2014 | year == 2015 | year == 2016 | year == 2017 | year == 2018 , fe 
est store Model_13
margins, dydx(*)

esttab Model_10 Model_11 Model_12 Model_13 
