 SELECT DISTINCT patient.med_rec_nbr, MAX(tobacco_usage_.txt_tobacco_use_status) FROM tobacco_usage_
 INNER JOIN patient_ ON patient_.person_id = tobacco_usage_.person_id
 INNER JOIN person ON person.person_id = tobacco_usage_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = tobacco_usage_.person_id
 INNER JOIN patient on patient.person_id = tobacco_usage_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
WHERE 
	 patient_.person_id = tobacco_usage_.person_id
	 AND patient_.person_id = patient.person_id
	 AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND tobacco_usage_.txt_tobacco_use_status like '%no/%' 
	 AND patient_encounter.billable_timestamp >= '2017-01-01 00:00.000'
     AND patient_encounter.billable_timestamp <='2017-12-31 23:59.999'
      And billable_ind = 'y'
	 AND CAST (tobacco_usage_.enc_date AS datetime) >= '2016-01-01'
	 AND CAST (tobacco_usage_.enc_date AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, tobacco_usage_.enc_date)>= 18 
	 AND NOT (person.first_name like '%test' or person.last_name like '%test')
 GROUP BY  patient.med_rec_nbr
 HAVING COUNT(patient_encounter.billable_timestamp) >= 2 
 
 Union
 SELECT DISTINCT patient.med_rec_nbr, MAX(tobacco_usage_.txt_tobacco_use_status) FROM tobacco_usage_
 INNER JOIN patient_ ON patient_.person_id = tobacco_usage_.person_id
 INNER JOIN person ON person.person_id = tobacco_usage_.person_id 
 INNER JOIN patient_encounter on patient_encounter.person_id = tobacco_usage_.person_id
 INNER JOIN patient on patient.person_id = tobacco_usage_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
Inner Join tobacco_cessation_discuss_ on person.person_id = tobacco_cessation_discuss_.person_id
WHERE 
	 patient_.person_id = tobacco_usage_.person_id
	 AND patient_.person_id = patient.person_id
	 AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
	 AND tobacco_usage_.txt_tobacco_use_status like '%yes%' 
	 AND patient_encounter.billable_timestamp >= '2017-01-01 00:00.000'
     AND patient_encounter.billable_timestamp <='2017-12-31 23:59.999'
      And billable_ind = 'y'
	 AND CAST (tobacco_usage_.enc_date AS datetime) >= '2016-01-01'
	 AND CAST (tobacco_usage_.enc_date AS datetime) <= '2017-12-31'
	 AND DATEDIFF(YEAR,person.date_of_birth, tobacco_usage_.enc_date)>= 18 
	 AND NOT (person.first_name like '%test' or person.last_name like '%test')
	 And tobacco_cessation_discuss_.create_timestamp >='2016-01-01'
 GROUP BY  patient.med_rec_nbr
 HAVING COUNT(patient_encounter.billable_timestamp) >= 2 
 


/*Denominator*/

SELECT DISTINCT patient_encounter.person_id, COUNT(patient_encounter.billable_timestamp)as number_of_encounters
FROM patient_encounter
INNER JOIN person ON person.person_id = patient_encounter.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
WHERE 
billable_timestamp >= '2017-01-01 00:00.000'
AND billable_timestamp <='2017-12-31 23:59.999'
AND billable_ind = 'Y'
AND DATEDIFF(YEAR,person.date_of_birth, patient_encounter.billable_timestamp)>= 18  
and person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
AND NOT (person.first_name like '%test' or person.last_name like '%test')
GROUP BY patient_encounter.person_id
HAVING COUNT(patient_encounter.billable_timestamp) >= 2 
