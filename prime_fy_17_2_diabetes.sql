/* 1.1.3.d - NQF 0059: Comprehensive Diabetes Care: HbA1c Poor Control (>9.0%) (HEDIS, eCQM)
Specification Source: HEDIS 2017, NQF 0059 CMS 122v6.1 */

/* Numerator: Patients whose most recent HbA1c level is greater than 9.0% or is missing a result, or for whom an
HbA1c test was not done during the measurement period. The outcome is an out of range result of an HbA1c test,
indicating poor control of diabetes.*/
DECLARE @StartDate date='2017-07-01',@StopDate date='2018-06-30'
SELECT DISTINCT patient.med_rec_nbr, MAX (lab_results_obx.observ_value) as last_A1c_test_result, MAX (lab_results_obx.obs_date_time)
FROM patient_diagnosis
INNER JOIN patient_encounter ON patient_encounter.enc_id = patient_diagnosis.enc_id 
INNER JOIN person ON person.person_id = patient_diagnosis.person_id
INNER JOIN patient ON patient.person_id = patient_diagnosis.person_id
INNER JOIN lab_results_obx on lab_results_obx.person_id = patient_diagnosis.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
WHERE 
CAST (billable_timestamp as DATE) >= @StartDate
AND CAST (billable_timestamp as DATE) <= @StopDate 
AND billable_ind = 'Y'
AND person.date_of_birth >= '1943-06-30'
AND person.date_of_birth <='2000-06-30'
and person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
AND diagnosis_code_id in ('E10', 'E11', '250%', '250', '250.02','250.03', '250.43', '250.71', '648.01', 'E11.22', 'E11.65', 'E11.9', 'O24.439')
AND lab_results_obx.obs_date_time >= @StartDate
AND lab_results_obx.obs_date_time <= @StopDate
and lab_results_obx.obs_id like '%A1c%'
AND (lab_results_obx.observ_value > '9.0' or (lab_results_obx.observ_value >= '10.0' and LEN(lab_results_obx.observ_value) >=4))
AND NOT (person.first_name like '%test' or person.last_name like '%test')
GROUP BY patient.med_rec_nbr

/** ADD IN first of the 2 required Medi-Cal encountrous must occur during the first 6 months of the measurement year **/

HAVING COUNT(patient_encounter.billable_timestamp) >= 2
/*119*/

/* Denominator: Patients 18-75 years of age by the end of the measurement period who had a diagnosis of diabetes
(type 1 or type 2) during the measurement period or the year prior to the measurement period. */
SELECT DISTINCT patient_diagnosis.person_id, COUNT(patient_encounter.billable_timestamp)as number_of_encounters
FROM patient_diagnosis
INNER JOIN patient_encounter ON patient_encounter.enc_id = patient_diagnosis.enc_id 
INNER JOIN person ON person.person_id = patient_diagnosis.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN payer_mstr on payer_mstr.payer_id = person_payer.payer_id
WHERE 
billable_timestamp >= '2017-07-01 00:00.000'
AND billable_timestamp <='2018-06-30 23:59.999'
AND billable_ind = 'Y'
AND person.date_of_birth >= '1943-06-30'
AND person.date_of_birth <='2000-06-30' 
and person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
AND diagnosis_code_id in ('E10', 'E11', '250%', '250', '250.02','250.03', '250.43', '250.71', '648.01', 'E11.22', 'E11.65', 'E11.9', 'O24.439')
AND NOT (person.first_name like '%test' or person.last_name like '%test')
GROUP BY patient_diagnosis.person_id
HAVING COUNT(patient_encounter.billable_timestamp) >= 2
/*445*/




