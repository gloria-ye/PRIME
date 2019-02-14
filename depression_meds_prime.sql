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
 INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
 INNER JOIN patient_medication on patient_medication.person_id = depression_PHQ_9_.person_id
/* INNER JOIN patient_diagnosis on patient_diagnosis.person_id = depression_PHQ_9_.person_id*/
 WHERE 
	patient_.person_id = patient.person_id
	AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
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
 GROUP BY  patient.med_rec_nbr, person.date_of_birth, patient_medication.medication_name
 HAVING MAX(depression_PHQ_9_.txt_total_score) >= '9'
 