/* ADD in denominator exclusion for pt declined active diagnosis of depression and bipolar. (ACTIVE under probem status) */

/* select person_id from assessment_impression_plan_ aip */
  SELECT DISTINCT
	 patient.med_rec_nbr,
	 person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id
WHERE 
	 patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND depression_PHQ_9_.txt_total_score is NOT NULL
	 AND (aip.txt_description like 'depression' or aip.txt_description like 'Momentum' or aip.txt_description like 'La Selva' or aip.txt_description like 'psych' or aip.txt_description like 'crisis line' or  aip.txt_description like 'mental health' or aip.txt_description like 'behavioral' or aip.txt_description like 'counseling'or aip.txt_description like'suicide' or aip.txt_description like '%depression%' or aip.txt_description like 'Carolyn' or aip.txt_description like 'Sasha' or aip.txt_description like 'Tonya' or aip.txt_description like 'SI' or aip.txt_description like 'psychiatry' or aip.txt_description like '%cutting%' or aip.txt_description like '%IBH%' or aip.txt_description like 'integrative behavioral health' or aip.txt_description like 'suicide attempt')
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
 GROUP BY  patient.med_rec_nbr, person.date_of_birth
 HAVING MAX(depression_PHQ_9_.txt_total_score) >= '9'
 UNION
 SELECT DISTINCT
	 patient.med_rec_nbr,
	 person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id
 WHERE 
	 patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND depression_PHQ_9_.txt_total_score is NOT NULL
	 /* AND (aip.txt_description like 'depression' or aip.txt_description like 'Momentum' or aip.txt_description like 'La Selva' or aip.txt_description like 'psych' or aip.txt_description like 'crisis line' or  aip.txt_description like 'mental health' or aip.txt_description like 'behavioral' or aip.txt_description like 'counseling'or aip.txt_description like'suicide' or aip.txt_description like '%depression%' or aip.txt_description like 'Carolyn' or aip.txt_description like 'Sasha' or aip.txt_description like 'Tonya' or aip.txt_description like 'SI' or aip.txt_description like 'psychiatry' or aip.txt_description like '%cutting%' or aip.txt_description like '%IBH%' or aip.txt_description like 'integrative behavioral health' or aip.txt_description like 'suicide attempt')*/
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
 GROUP BY  patient.med_rec_nbr, person.date_of_birth
 HAVING MAX(depression_PHQ_9_.txt_total_score) < '9' 
 UNION
 SELECT DISTINCT
	 patient.med_rec_nbr,
	 person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MAX (patient_medication.medication_name) medication_name
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
INNER JOIN patient_medication on patient_medication.person_id = depression_PHQ_9_.person_id
INNER JOIN patient_diagnosis on patient_diagnosis.person_id = depression_PHQ_9_.person_id
 WHERE 
	 patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND depression_PHQ_9_.txt_total_score is NOT NULL
	 /* AND (aip.txt_description like 'depression' or aip.txt_description like 'Momentum' or aip.txt_description like 'La Selva' or aip.txt_description like 'psych' or aip.txt_description like 'crisis line' or  aip.txt_description like 'mental health' or aip.txt_description like 'behavioral' or aip.txt_description like 'counseling'or aip.txt_description like'suicide' or aip.txt_description like '%depression%' or aip.txt_description like 'Carolyn' or aip.txt_description like 'Sasha' or aip.txt_description like 'Tonya' or aip.txt_description like 'SI' or aip.txt_description like 'psychiatry' or aip.txt_description like '%cutting%' or aip.txt_description like '%IBH%' or aip.txt_description like 'integrative behavioral health' or aip.txt_description like 'suicide attempt')*/
	 /* AND patient_medication.medication_name in ('Cymbalta', 'Zoloft', 'Prozac', 'Lexapro', 'bupropion%', 'Celexa', '%citalopram', 'sertraline', 'Wellbutrin%', 'fluoxetine', 'Abilify', 'Xanax', 'Effexor%', 'venlafaxine', 'Pristiq', 'Paxil', 'trazodone', 'duloxetine', 'mirtazapine', 'Remeron', 'Vibryd', 'paroxetine', '%triptyline', 'Seroquel%', 'alprazolam', 'Deplin', 'Zyprexa', 'quetiapine', 'aripiprazole', 'tramadol', 'Desyrel%', 'Fetzima', 'Trintellix', 'Alprazolam Intensol', 'Niravam', 'Oleptro', 'Aplenzin', 'doxepin', 'Forfivo%')*/
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
 GROUP BY  patient.med_rec_nbr, person.date_of_birth
 HAVING MAX(depression_PHQ_9_.txt_total_score) < '9'
 
 SELECT DISTINCT
	 patient.med_rec_nbr,
	 person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis, MAX (patient_diagnosis.description)
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient_diagnosis on patient_diagnosis.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id
 WHERE 
	 patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 and person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND depression_PHQ_9_.txt_total_score is NOT NULL
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
	 AND NOT(aip.txt_description like 'declined' or aip.txt_description like 'refused' or aip.txt_description like 'not interested' or aip.txt_description like 'uninterested')
 GROUP BY  patient.med_rec_nbr, person.date_of_birth, patient_diagnosis.description, patient_diagnosis.create_timestamp
 HAVING (NOT patient_diagnosis.description like 'bipolar' AND (patient_diagnosis.create_timestamp <= CAST (MAX (depression_PHQ_9_.encDate)as datetime) or (patient_diagnosis.create_timestamp >= '2017-01-01' and patient_diagnosis.create_timestamp <= '2017-12-31')))
 
 
 
 
 
 
 SELECT DISTINCT
	 patient.med_rec_nbr,
	 person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id
 WHERE 
	 patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND depression_PHQ_9_.txt_total_score is NOT NULL
	 AND (aip.txt_description like 'depression' or aip.txt_description like 'Momentum' or aip.txt_description like 'La Selva' or aip.txt_description like 'psych' or aip.txt_description like 'crisis line' or  aip.txt_description like 'mental health' or aip.txt_description like 'behavioral' or aip.txt_description like 'counseling'or aip.txt_description like'suicide' or aip.txt_description like '%depression%' or aip.txt_description like 'Carolyn' or aip.txt_description like 'Sasha' or aip.txt_description like 'Tonya' or aip.txt_description like 'SI' or aip.txt_description like 'psychiatry' or aip.txt_description like '%cutting%' or aip.txt_description like '%IBH%' or aip.txt_description like 'integrative behavioral health' or aip.txt_description like 'suicide attempt')
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2016-04-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-03-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
 GROUP BY  patient.med_rec_nbr, person.date_of_birth
 HAVING MIN(depression_PHQ_9_.txt_total_score) > '9' and MAX(depression_PHQ_9_.txt_total_score) < '5'