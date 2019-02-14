SELECT DISTINCT person.first_name, person.last_name, cast (person.date_of_birth as date)date_of_birth, MIN (patient_encounter.billable_timestamp), hospital /*,  MAX (patient_encounter.billable_timestamp)date_seen */
from person
INNER JOIN patient ON patient.person_id = person.person_id
INNER JOIN patient_diagnosis on patient_diagnosis.person_id = person.person_id
INNER JOIN patient_encounter on patient_encounter.person_id = person.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
INNER JOIN OB_postpartPregHx_extended_ on OB_postpartPregHx_extended_.person_id = person.person_id
WHERE 
/* patient_encounter .billable_timestamp >= DATEADD (WEEK, -41, '2017-01-01')
and patient_encounter.billable_timestamp <= DATEADD (WEEK, -41, '2017-12-30') */
 CAST (OB_postpartPregHx_extended_.txt_preg_outcome_date as datetime)  >= '2017-01-01'
and CAST (OB_postpartPregHx_extended_.txt_preg_outcome_date as datetime) <= '2017-12-31'
and patient_encounter.billable_timestamp <= DATEADD (WEEK, -41, '2017-12-31')
and person_payer.payer_name in ('FPACT' /*, 'Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap'*/)
AND diagnosis_code_id in ('O09.211', 'O09.291', 'O09.511', 'O09.521', 'O09.891', 'O23.41', 'O23.591', 'O23.91','O24.410', 'O24.419', 'O24.911', 'O26.21', 'O26.841', 'O26.891', 'O30.001', 'O41.8X10', 'O99.011', 'O99.331', 'Z34.01', 'Z34.81', 'Z34.91', 'O09.212', 'O09.512', 'O09.522', 'O09.892', 'O16.2', 'O23.42', 'O24.410', 'O24.419', 'O26.02', 'O26.12', 'O26.892', 'O26.92', 'O30.002', 'O36.0120', 'O43.112', 'O43.192', 'O44.42', 'O99.012', 'O99.712', 'Z33.1', 'Z34.02', 'Z34.82', 'Z34.92', '644.03', 'O09.893', 'O12.03', 'O13.3', 'O14.93', 'O16.3', 'O23.43', 'O23.93', 'O24.410', 'O26.03', 'O26.613', 'O26.843', 'O36.0130', 'O36.5930', 'O36.63X0', 'O36.8130', 'O43.113', 'O99.013', 'O99.343', 'Z34.03', 'Z34.83', 'Z34.93')/*'E10', 'E11', '250%', '250', '250.02','250.03', '250.43', '250.71', '648.01', 'E11.22', 'E11.65', 'E11.9', 'O24.439')*/
And hospital in ('ECH', 'El Camino')
GROUP BY person.first_name, person.last_name, person.date_of_birth, person_payer.payer_name, hospital