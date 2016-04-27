clear
set more off
use drugs.dta

*Section 1: Creating the Necessary Variables

*Youth Drug Use Variables
gen y_cig14 = 0 if CIGTRY>=14
replace y_cig14 = 1 if CIGTRY<14

gen y_cig18 = 0 if CIGTRY>=18 
replace y_cig18 = 0 if y_cig14==1
replace y_cig18 = 1 if CIGTRY<18 & CIGTRY>=14

gen y_alc14 = 0 if ALCTRY>=14
replace y_alc14 = 1 if ALCTRY<14

gen y_alc18 = 0 if ALCTRY>=18
replace y_alc18 = 0 if y_alc14==1
replace y_alc18 = 1 if ALCTRY<18 & ALCTRY>=14

gen y_mj14 = 0 if MJAGE>=14
replace y_mj14 = 1 if MJAGE<14

gen y_mj18 = 0 if MJAGE>=18
replace y_mj18 = 0 if y_mj14==1
replace y_mj18 = 1 if MJAGE<18 & MJAGE>=14

gen y_minor14 = y_cig14 + y_alc14 + y_mj14

gen y_minor18 = y_cig18 + y_alc18 + y_mj18
replace y_minor18=0 if y_minor14>0

gen youth_drug14=0 if y_minor14==0
replace youth_drug14=1 if y_minor14>0

gen youth_drug18=0 if y_minor18==0
replace youth_drug18=1 if y_minor18>0

*Adult Hard Drug Use
gen ad_coc = COCFLAG

gen ad_her = HERFLAG

gen ad_crk = CRKFLAG

gen ad_mth = MTHFLAG

gen ad_total = ad_coc + ad_crk + ad_her + ad_mth

gen ad_hard=0 if ad_total==0
replace ad_hard=1 if ad_total>0

*Adult Minor Drug Use
gen ad_cig=0 if IRCIGRC>2
replace ad_cig=1 if IRCIGRC<=2

gen ad_alc=0 if IRALCRC>2
replace ad_alc=1 if IRALCRC<=2

gen ad_mj=0 if IRMJRC>2
replace ad_mj=1 if IRMJRC<=2

gen ad_total2= ad_cig + ad_alc + ad_mj
gen ad_minor=0 if ad_total2==0
replace ad_minor=1 if ad_total2>0

*Adult Drug Use Multinomial Dependent Variable

gen ad_drug_type=1 if ad_hard==0 & ad_minor==0
replace ad_drug_type=2 if ad_hard==0 & ad_minor==1
replace ad_drug_type=3 if ad_hard==1

*Control Variables

*Income
gen fam_inc=IRFAMIN3

*Employment Status
gen empstat=1 if EMPSTATY<3
replace empstat=0 if EMPSTATY>2

*Social Environment/Drug Availability
gen coc_hard=1 if RKDIFCOC<4
replace coc_hard=0 if RKDIFCOC==4
replace coc_hard=0 if RKDIFCOC==5

gen crk_hard=1 if RKDIFCRK<4
replace crk_hard=0 if RKDIFCRK==4
replace crk_hard=0 if RKDIFCRK==5

gen her_hard=1 if RKDIFHER<4
replace her_hard=0 if RKDIFHER==4
replace her_hard=0 if RKDIFHER==5

gen church=0 if SNRLGSVC<5
replace church=1 if SNRLGSVC==5
replace church=1 if SNRLGSVC==6

gen no_steal=0 if SNYSTOLE<=5
replace no_steal=1 if SNYSTOLE==1

gen no_drug_sell=0 if SNYSELL<=5
replace no_drug_sell=1 if SNYSELL==1

gen no_violent=0 if SNYATTAK<=5
replace no_violent=1 if SNYATTAK==1

gen no_buy=0 if RSKSELL==1
replace no_buy=1 if RSKSELL==2

gen soc_env = coc_hard + crk_hard + her_hard + church + no_steal + no_drug_sell + no_violent + no_buy

*Age
gen age=18 if AGE2==7
replace age=19 if AGE2==8
replace age=20 if AGE2==9
replace age=21 if AGE2==10
replace age=22.5 if AGE2==11
replace age=24.5 if AGE2==12
replace age=27.5 if AGE2==13
replace age=32 if AGE2==14
replace age=42 if AGE2==15
replace age=57 if AGE2==16
replace age=65 if AGE2==17

*Mental/Physical Health
gen ment_hlth=K6SCMON

gen overgood_hlth=1 if HEALTH<4
replace overgood_hlth=0 if HEALTH==4
replace overgood_hlth=0 if HEALTH==5

*Geography (Population Density)
gen pop_dens=1 if PDEN==1
replace pop_dens=0 if PDEN==2

*Gender
gen male=1 if IRSEX==1
replace male=0 if IRSEX==2

*Race (non-hispanic white is the base category)
gen black=0
replace black=1 if NEWRACE2==2

gen hisp=0
replace hisp=1 if NEWRACE2==7

gen asian_pac=0
replace asian=1 if NEWRACE2==5
replace asian=1 if NEWRACE2==4

gen nat_am=0
replace nat_am=1 if NEWRACE2==3

gen mult_race=0
replace mult_race=1 if NEWRACE2==6

global race_macro black hisp asian_pac nat_am mult_race

*Marital Status
gen married=0
replace married=1 if IRMARIT==1

*Young Children in House
gen young_kids=0 if IRKI17_2==1
replace young_kids=1 if IRKI17_2>1

*Education
gen high_sch=0 if IREDUC2<8
replace high_sch=1 if IREDUC2>=8

*Dropping Missing Obs
drop if fam_inc==.
drop if empstat==.
drop if soc_env==.
drop if age==.
drop if overgood_hlth==.
drop if ment_hlth==.
drop if pop_dens==.
drop if male==.
drop if married==.
drop if young_kids==.
drop if high_sch==.
drop if black==.
drop if hisp==.
drop if asian_pac==.
drop if nat_am==.
drop if mult_race==.
drop if ad_drug_type==.
drop if youth_drug14==.
drop if youth_drug18==.
drop if y_minor18==.
drop if y_minor14==.

*Macros for Control Variables
global cont_full fam_inc empstat soc_env age overgood_hlth ment_hlth pop_dens male married young_kids high_sch $race_macro
global cont_1 age male fam_inc high_sch
global cont_2 age male fam_inc soc_env empstat married young_kids pop_dens
global youth_drug youth_drug14 youth_drug18

*Section 2: Running the Regressions

*Generation 1 (between 30-50), Control 1

mlogit ad_drug_type $youth_drug /// 
$cont_1 ///
if age>=30 & age<=50, vce(robust)
estat ic
mfx, predict(outcome(1)) nose force
mfx, predict(outcome(3)) nose force
fitstat

*Generation 2 (over 50), Control 1

mlogit ad_drug_type $youth_drug /// 
$cont_1 ///
if age>50, vce(robust)
estat ic
mfx, predict(outcome(1)) nose force
mfx, predict(outcome(3)) nose force
fitstat


*Generation 1 (between 30-50), Control 2

mlogit ad_drug_type $youth_drug /// 
$cont_2 /// 
if age>=30 & age<=50, vce(robust)
estat ic
mfx, predict(outcome(1)) nose force
mfx, predict(outcome(3)) nose force
fitstat

*Generation 2 (over 50), Control 2

mlogit ad_drug_type $youth_drug ///
$cont_2 /// 
if age>50, vce(robust)
estat ic
mfx, predict(outcome(1)) nose force
mfx, predict(outcome(3)) nose force
fitstat

*Generation 1 (between 30-50), Full Model
*note: complete mfx command (with standard errors included) starred out to save computing time.

mlogit ad_drug_type $youth_drug ///
$cont_full /// 
if age>=30 & age<=50, vce(robust)
eststo gen_1
estat ic
mfx, predict(outcome(1)) nose force
mfx, predict(outcome(3)) nose force
*mfx, varlist(youth_drug14 youth_drug18 age male married black hisp) predict(outcome(1)) force
*mfx, varlist(youth_drug14 youth_drug18 age male married black hisp) predict(outcome(3)) force
fitstat

*Generation 2 (over 50), Full Model

mlogit ad_drug_type $youth_drug ///
$cont_full /// 
if age>50, vce(robust)
eststo gen_2
estat ic
mfx, predict(outcome(1)) nose force
mfx, predict(outcome(3)) nose force
*mfx, varlist(youth_drug14 youth_drug18 age male married black hisp) predict(outcome(1)) force
*mfx, varlist(youth_drug14 youth_drug18 age male married black hisp) predict(outcome(3)) force
fitstat

*Pooled Model, Full Model

mlogit ad_drug_type $youth_drug ///
$cont_full /// 
if age>=30, vce(robust)
eststo gen_pool
estat ic
mfx, predict(outcome(1)) nose force
mfx, predict(outcome(3)) nose force
*mfx, varlist(youth_drug14 youth_drug18 age male married black hisp) predict(outcome(1)) force
*mfx, varlist(youth_drug14 youth_drug18 age male married black hisp) predict(outcome(3)) force
fitstat

*Section 3: Summary Statistics/Reporting Results

sum $youth_drug /// 
$cont_full /// 
ad_drug_type

count

count if youth_drug14==0 & age>=30 & age<=50
count if youth_drug14==1 & age>=30 & age<=50

count if youth_drug18==0 & age>=30 & age<=50
count if youth_drug18==1 & age>=30 & age<=50

count if ad_drug_type==1 & age>=30 & age<=50
count if ad_drug_type==2 & age>=30 & age<=50
count if ad_drug_type==3 & age>=30 & age<=50

count if youth_drug14==0 & age>50
count if youth_drug14==1 & age>50

count if youth_drug18==0 & age>50
count if youth_drug18==1 & age>50

count if ad_drug_type==1 & age>50
count if ad_drug_type==2 & age>50
count if ad_drug_type==3 & age>50

*esttab gen_1 gen_2 gen_pool using model_results.csv, se star(* 0.10 ** 0.05 *** 0.01) noobs replace

*Notes:
	*Estimates table starred out because the table we use in the poster was heavily edited.
	*The likelihood ratio test for a structural difference between generations was done by hand so it does not appear in this do file.
