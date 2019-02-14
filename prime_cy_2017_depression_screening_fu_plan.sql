SELECT DISTINCT
	 patient.med_rec_nbr /*,
	 person.date_of_birth,
	 CAST ( MAX (depression_PHQ_9_.encDate) AS datetime) encDate,
	 MAX(depression_PHQ_9_.txt_total_score) PHQ_9_total_score */
	 /* MAX (aip.txt_description) patient_plan, MAX (aip.txt_diagnosis_code_id) patient_diagnosis, MAX (patient_diagnosis.description)
 */
 FROM depression_PHQ_9_
 INNER JOIN patient_ ON patient_.person_id = depression_PHQ_9_.person_id
 INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient_diagnosis on patient_diagnosis.person_id = depression_PHQ_9_.person_id
 INNER JOIN patient on patient.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
/* INNER JOIN assessment_impression_plan_ aip on aip.enc_id = depression_PHQ_9_.enc_id */
/* INNER JOIN mch_depression_PHQ_9_83_  on person.person_id = mch_depression_PHQ_9_83_.person_id and mch_depression_PHQ_9_83_.enc_id = depression_PHQ_9_.enc_id
*/ WHERE 
	 /* patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 and */ person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
	 /* AND NOT(aip.txt_description like 'declined'
		OR aip.txt_description like 'refused'
		OR aip.txt_description like 'not interested'
		OR aip.txt_description like 'uninterested')*/
	/* AND mch_depression_PHQ_9_83_.chk_patient_declined != 1*/
	AND (patient_.full_name not like '%test%' or patient_.full_name not like '%MCHC%')
 GROUP BY  patient.med_rec_nbr /* , person.date_of_birth, */, patient_diagnosis.description, patient_diagnosis.create_timestamp 
 HAVING (COUNT(patient_encounter.billable_timestamp) >= 2 AND NOT patient_diagnosis.description like 'bipolar' AND (patient_diagnosis.create_timestamp <= CAST (MAX (depression_PHQ_9_.encDate)as datetime) or (patient_diagnosis.create_timestamp >= '2017-01-01' and patient_diagnosis.create_timestamp <= '2017-12-31')))
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
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
/* INNER JOIN assessment_impression_plan_ aip on aip.person_id = person.person_id */
INNER JOIN mch_depression_PHQ_9_83_  on person.person_id = mch_depression_PHQ_9_83_.person_id
 WHERE 
	 /* patient_.person_id = depression_PHQ_9_.person_id
	 AND patient_.person_id = patient.person_id
	 and */ person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-01-01'
	 AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 18 
	 AND billable_ind = 'Y'
	 AND mch_depression_PHQ_9_83_.chk_patient_declined = 0
	 /* AND NOT(aip.txt_description like 'declined'
		OR aip.txt_description like 'refused'
		OR aip.txt_description like 'not interested'
		OR aip.txt_description like 'uninterested') */
	AND (patient_.full_name not like '%test%' or patient_.full_name not like '%MCHC%')
 GROUP BY  patient.med_rec_nbr/*, person.date_of_birth*/ , patient_diagnosis.description, patient_diagnosis.create_timestamp
 HAVING (COUNT(patient_encounter.billable_timestamp) >= 2 AND NOT patient_diagnosis.description like 'bipolar' AND (patient_diagnosis.create_timestamp <= CAST (MAX (depression_PHQ_9_.encDate)as datetime) or (patient_diagnosis.create_timestamp >= '2017-01-01' and patient_diagnosis.create_timestamp <= '2017-12-31')))
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
	 AND mch_depression_PHQ_9_83_.chk_patient_declined = 0
	 /* AND NOT(aip.txt_description like 'declined'
		OR aip.txt_description like 'refused'
		OR aip.txt_description like 'not interested'
		OR aip.txt_description like 'uninterested') */
	AND (patient_.full_name not like '%test%' or patient_.full_name not like '%MCHC%')
 GROUP BY  patient.med_rec_nbr/*, person.date_of_birth*/ , patient_diagnosis.description, patient_diagnosis.create_timestamp
 HAVING (COUNT(patient_encounter.billable_timestamp) >= 2 AND NOT patient_diagnosis.description like 'bipolar' AND (patient_diagnosis.create_timestamp <= CAST (MAX (depression_PHQ_9_.encDate)as datetime) or (patient_diagnosis.create_timestamp >= '2017-01-01' and patient_diagnosis.create_timestamp <= '2017-12-31')))
