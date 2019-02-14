/* remission */
SELECT depression_PHQ_9_.person_id, 
		depression_PHQ_9_.txt_total_score, 
		person.date_of_birth
FROM depression_PHQ_9_
INNER JOIN 
	(SELECT depression_PHQ_9_.person_id, 
		IESD.min_phq_9_score initial_PHQ_9_score_IESD, 
		MAX(depression_PHQ_9_.txt_total_score) most_recent_followup_score, 
		MAX (depression_PHQ_9_.create_timestamp) most_recent_PHQ_9_date
	FROM depression_PHQ_9_

	INNER JOIN (select  patient_encounter.person_id,
		MIN (depression_PHQ_9_.txt_total_score) min_phq_9_score,
		MIN (depression_PHQ_9_.create_timestamp) initial_phq_9_date
		FROM patient_encounter
		INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
		WHERE depression_PHQ_9_.encDate >= '20170101' 
		AND depression_PHQ_9_.encDate <= '2017131'
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		GROUP BY patient_encounter.person_id
		HAVING COUNT(patient_encounter.billable_timestamp) >= 2
		) IESD ON IESD.person_id = depression_PHQ_9_.person_id

	INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id

	WHERE DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) >= 120
	AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) <= 240
	GROUP BY depression_PHQ_9_.person_id, IESD.min_phq_9_score) remission ON remission.person_id = depression_PHQ_9_.person_id
INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id	
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN patient_encounter on patient_encounter.person_id = person.person_id
WHERE depression_PHQ_9_.create_timestamp = remission.most_recent_PHQ_9_date
AND depression_PHQ_9_.txt_total_score = remission.most_recent_followup_score
AND remission.most_recent_followup_score < 5
AND depression_PHQ_9_.txt_total_score is NOT NULL
AND DATEDIFF (YEAR, person.date_of_birth, '20170101') >=12
AND person.first_name not like '%test%'
AND person.first_name not like '%MCHC%'
AND person.last_name not like '%test%'
AND person.last_name not like '%MCHC%'
AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
GROUP BY depression_PHQ_9_.person_id, depression_PHQ_9_.txt_total_score, person.date_of_birth
HAVING COUNT(patient_encounter.billable_timestamp) >= 2

/* response */
SELECT depression_PHQ_9_.person_id, 
		depression_PHQ_9_.txt_total_score, 
		person.date_of_birth
FROM depression_PHQ_9_
INNER JOIN 
	(SELECT depression_PHQ_9_.person_id, 
		IESD.min_phq_9_score initial_PHQ_9_score_IESD, 
		MAX(depression_PHQ_9_.txt_total_score) most_recent_followup_score, 
		MAX (depression_PHQ_9_.create_timestamp) most_recent_PHQ_9_date
	FROM depression_PHQ_9_

	INNER JOIN 
		(select  patient_encounter.person_id,
			MIN (depression_PHQ_9_.create_timestamp) initial_phq_9_date,
			MIN (depression_PHQ_9_.txt_total_score) min_phq_9_score
		FROM patient_encounter
		INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
		WHERE depression_PHQ_9_.encDate >= '20170101' 
		AND depression_PHQ_9_.encDate <= '20171231'
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		GROUP BY patient_encounter.person_id
		HAVING COUNT(patient_encounter.billable_timestamp) >= 2
		) IESD ON IESD.person_id = depression_PHQ_9_.person_id

	INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id
	WHERE DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) >= 120
	AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) <= 240
	
	GROUP BY depression_PHQ_9_.person_id, IESD.min_phq_9_score) response ON response.person_id = depression_PHQ_9_.person_id
	
INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id	
WHERE depression_PHQ_9_.create_timestamp = response.most_recent_PHQ_9_date
/* AND (response.initial_PHQ_9_score_IESD - response.most_recent_followup_score )/response.initial_PHQ_9_score_IESD <= -0.5 */
AND response.most_recent_followup_score * 2 <= response.initial_PHQ_9_score_IESD 
AND depression_PHQ_9_.txt_total_score = response.most_recent_followup_score
AND depression_PHQ_9_.txt_total_score is NOT NULL
AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
AND DATEDIFF (YEAR, person.date_of_birth, '20170101') >=12
AND person.first_name not like '%test%'
AND person.first_name not like '%MCHC%'
AND person.last_name not like '%test%'
AND person.last_name not like '%MCHC%'
GROUP BY depression_PHQ_9_.person_id, depression_PHQ_9_.txt_total_score, person.date_of_birth
HAVING COUNT(patient_encounter.create_timestamp) >= 2

/* PHQ-9 score during follow-up period */
SELECT depression_PHQ_9_.person_id, depression_PHQ_9_.txt_total_score, person.date_of_birth
FROM depression_PHQ_9_
INNER JOIN 
	(SELECT depression_PHQ_9_.person_id, MAX (depression_PHQ_9_.create_timestamp) most_recent_PHQ_9_date
	FROM depression_PHQ_9_

	INNER JOIN (select  patient_encounter.person_id,
		MIN (depression_PHQ_9_.create_timestamp) initial_phq_9_date
		FROM patient_encounter
		INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
		WHERE depression_PHQ_9_.encDate >= '20170101' 
		AND depression_PHQ_9_.encDate <= '20171231'
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		GROUP BY patient_encounter.person_id
		HAVING COUNT(patient_encounter.billable_timestamp) >= 2
		) IESD ON IESD.person_id = depression_PHQ_9_.person_id

	INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id

	WHERE DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) >= 120
	AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) <= 240
	GROUP BY depression_PHQ_9_.person_id) followup ON followup.person_id = depression_PHQ_9_.person_id
	--HAVING COUNT(patient_encounter.billable_timestamp) >= 2
INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id	
INNER JOIN person_payer on person_payer.person_id = person.person_id
INNER JOIN patient_encounter on patient_encounter.person_id = person.person_id
WHERE depression_PHQ_9_.create_timestamp = followup.most_recent_PHQ_9_date
AND depression_PHQ_9_.txt_total_score is NOT NULL
AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
AND DATEDIFF (YEAR, person.date_of_birth, '20170101') >=12
GROUP BY depression_PHQ_9_.person_id, depression_PHQ_9_.txt_total_score, person.date_of_birth
HAVING COUNT(patient_encounter.billable_timestamp) >= 2


/* denominator*/
select  patient_encounter.person_id,
		MIN (depression_PHQ_9_.create_timestamp) initial_phq_9_date
		FROM patient_encounter
		INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
		INNER JOIN person ON person.person_id = patient_encounter.person_id
		INNER JOIN person_payer on person_payer.person_id = person.person_id
		WHERE depression_PHQ_9_.encDate >= '20170101' 
		AND depression_PHQ_9_.encDate <= '20171231'
		AND person_payer.payer_name in ('Blue Cross Of CA Wrap', 'Blue Cross Of California', 'CHDP', 'CHDP Medi Cal', 'Medi Medi Crossover', 'MediCal FFS', 'SCFHP', 'SCFHP Wrap', 'ZZBlue Cross Of CA Wrap', 'ZZCHDP Medi Cal', 'ZZMediCal FFS', 'ZZSCFHP Wrap')
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		AND depression_PHQ_9_.txt_total_score is NOT NULL
		AND DATEDIFF (YEAR, person.date_of_birth, '20170101') >=12
		AND person.first_name not like '%test%'
		AND person.first_name not like '%MCHC%'
		AND person.last_name not like '%test%'
		AND person.last_name not like '%MCHC%'
		GROUP BY patient_encounter.person_id
		HAVING COUNT(patient_encounter.billable_timestamp) >= 2
