/* select person_id from assessment_impression_plan_ aip */
/* select person_id from assessment_impression_plan_ aip */
  SELECT DISTINCT
	 patient.med_rec_nbr
	 /* person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis */
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id
WHERE 
	 /* patient_.person_id = depression_PHQ_9_.person_id */
	 /* AND patient_.person_id = patient.person_id 
	 AND */ 
	 person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND depression_PHQ_9_.txt_total_score is NOT NULL
	 AND (aip.txt_description like 'depression'
		OR aip.txt_description like 'Momentum'
		OR aip.txt_description like 'La Selva'
		OR aip.txt_description like 'psych'
		OR aip.txt_description like 'crisis line'
		OR aip.txt_description like 'mental health'
		OR aip.txt_description like 'behavioral'
		OR aip.txt_description like 'counseling'
		OR aip.txt_description like'suicide'
		OR aip.txt_description like '%depression%'
		OR aip.txt_description like 'Carolyn'
		OR aip.txt_description like 'Sasha'
		OR aip.txt_description like 'Tonya'
		OR aip.txt_description like 'SI'
		OR aip.txt_description like 'psychiatry'
		OR aip.txt_description like '%cutting%'
		OR aip.txt_description like '%IBH%'
		OR aip.txt_description like 'integrative behavioral health'
		OR aip.txt_description like 'suicide attempt')
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
	 AND (patient_.full_name not like '%test%' or patient_.full_name not like '%MCHC%')
 GROUP BY  patient.med_rec_nbr /* , person.date_of_birth */
 HAVING MAX(depression_PHQ_9_.txt_total_score) >= '9'
 UNION
 SELECT DISTINCT
	 patient.med_rec_nbr
	 /* person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score
	 MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis */
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
/* INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id */
/* INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id */
 WHERE 
	 patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND depression_PHQ_9_.txt_total_score is NOT NULL
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
	 AND (patient_.full_name not like '%test%' or patient_.full_name not like '%MCHC%')
 GROUP BY  patient.med_rec_nbr, person.date_of_birth
 HAVING COUNT(patient_encounter.billable_timestamp) >= 2  AND MAX(depression_PHQ_9_.txt_total_score) < '9' 
 UNION
 SELECT DISTINCT
	 patient.med_rec_nbr
	 /* person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MIN (patient_medication.start_date) medication_start_date,
	 patient_medication.medication_name medication_name */
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
 INNER JOIN person_payer on person_payer.person_id = person.person_id
 /* INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id */
 INNER JOIN patient_medication on patient_medication.person_id = depression_PHQ_9_.person_id
/* INNER JOIN patient_diagnosis on patient_diagnosis.person_id = depression_PHQ_9_.person_id*/
 WHERE 
	/* patient_.person_id = patient.person_id 
	AND */ 
	person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	AND depression_PHQ_9_.txt_total_score is NOT NULL
	AND (patient_medication.medication_name like '%Cymbalta%' 
		OR patient_medication.medication_name like '%Zoloft%' 
		OR patient_medication.medication_name like '%Prozac%' 
		OR patient_medication.medication_name like '%Lexapro%'  
		OR patient_medication.medication_name like '%bupropion' 
		OR patient_medication.medication_name like '%Celexa%'  
		OR patient_medication.medication_name like '%citalopram%'
		OR patient_medication.medication_name like '%sertraline%'
		OR patient_medication.medication_name like'%Wellbutrin%'
		OR patient_medication.medication_name like '%fluoxetine%'
		OR patient_medication.medication_name like '%Abilify%'
		OR patient_medication.medication_name like '%Xanax%'
		OR patient_medication.medication_name like '%Effexor%'
		OR patient_medication.medication_name like '%venlafaxine%'
		OR patient_medication.medication_name like '%Pristiq%'
		OR patient_medication.medication_name like '%Paxil%'
		OR patient_medication.medication_name like '%trazodone%'
		OR patient_medication.medication_name like '%duloxetine%'
		OR patient_medication.medication_name like '%mirtazapine%'
		OR patient_medication.medication_name like '%Remeron%'
		OR patient_medication.medication_name like '%Vibryd%'
		OR patient_medication.medication_name like '%paroxetine%'
		OR patient_medication.medication_name like '%triptyline%'
		OR patient_medication.medication_name like '%Seroquel%'
		OR patient_medication.medication_name like '%alprazolam%'
		OR patient_medication.medication_name like '%Deplin%'
		OR patient_medication.medication_name like '%Zyprexa'
		OR patient_medication.medication_name like '%quetiapine%'
		OR patient_medication.medication_name like '%aripiprazole%'
		OR patient_medication.medication_name like '%tramadol%'
		OR patient_medication.medication_name like '%Desyrel%'
		OR patient_medication.medication_name like '%Fetzima%'
		OR patient_medication.medication_name like '%Trintellix%'
		OR patient_medication.medication_name like '%Alprazolam%Intensol%'
		OR patient_medication.medication_name like '%Niravam%'
		OR patient_medication.medication_name like '%Oleptro%'
		OR patient_medication.medication_name like '%Aplenzin%'
		OR patient_medication.medication_name like '%doxepin'
		OR patient_medication.medication_name like '%Forfivo%')
	AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	AND patient_medication.start_date >= '20170101'
	AND patient_medication.start_date <= '20171231'
	AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18
	AND billable_ind = 'Y'
	AND (patient_.full_name not like '%test%' or patient_.full_name not like '%MCHC%')
 GROUP BY  patient.med_rec_nbr /* , person.date_of_birth, patient_medication.medication_name*/
 HAVING COUNT(patient_encounter.billable_timestamp) >= 2  AND MAX(depression_PHQ_9_.txt_total_score) >= '9'
 UNION
SELECT DISTINCT
	 patient.med_rec_nbr /* ,
	 person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score,
	 MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis, MAX (patient_diagnosis.description)
 */ FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient_diagnosis on patient_diagnosis.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
/* INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id */
/* INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id */
INNER JOIN mch_depression_PHQ_9_83_  on mch_depression_PHQ_9_83_.enc_id = depression_PHQ_9_.enc_id
 WHERE 
	 /* patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 and */ person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
	 AND (mch_depression_PHQ_9_83_.chk_patient_declined = 0 or mch_depression_PHQ_9_83_.chk_patient_declined = 1)
	 /* AND NOT(aip.txt_description like 'declined'
		OR aip.txt_description like 'refused'
		OR aip.txt_description like 'not interested'
		OR aip.txt_description like 'uninterested') */
	AND (patient_.full_name not like '%test%' or patient_.full_name not like '%MCHC%')
 GROUP BY  patient.med_rec_nbr/*, person.date_of_birth*/ , patient_diagnosis.description, patient_diagnosis.create_timestamp
 HAVING (COUNT(patient_encounter.billable_timestamp) >= 2 AND NOT patient_diagnosis.description like 'bipolar' AND (patient_diagnosis.create_timestamp <= CAST (MAX (depression_PHQ_9_.encDate)as datetime) or (patient_diagnosis.create_timestamp >= '2017-01-01' and patient_diagnosis.create_timestamp <= '2017-12-31')))

 