SELECT DISTINCT patient_encounter.person_id
FROM patient_encounter
INNER JOIN person ON person.person_id = patient_encounter.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
WHERE 
billable_timestamp >= '2017-01-01 00:00.000'
AND billable_timestamp <='2017-12-31 23:59.999'
AND billable_ind = 'Y'
/* AND person.date_of_birth >= '1942-12-31'*/
AND DATEDIFF (YEAR, person.date_of_birth, patient_encounter.billable_timestamp) >= 18
and person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
/* AND diagnosis_code_id in ('E10', 'E11', '250%', '250', '250.02','250.03', '250.43', '250.71', '648.01', 'E11.22', 'E11.65', 'E11.9', 'O24.439')*/
AND NOT (person.first_name like '%test' or person.last_name like '%test')
GROUP BY patient_encounter.person_id
