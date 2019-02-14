/*remission*/
SELECT depression_PHQ_9_.person_id, depression_PHQ_9_.txt_total_score, person.date_of_birth
FROM depression_PHQ_9_
INNER JOIN 
	(SELECT depression_PHQ_9_.person_id, MAX (depression_PHQ_9_.create_timestamp) most_recent_PHQ_9_date
	FROM depression_PHQ_9_

	INNER JOIN (select  patient_encounter.person_id,
		MIN (depression_PHQ_9_.create_timestamp) initial_phq_9_date
		FROM patient_encounter
		INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
		WHERE depression_PHQ_9_.encDate >= '20160401' 
		AND depression_PHQ_9_.encDate <= '20170331'
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		GROUP BY patient_encounter.person_id
		) IESD ON IESD.person_id = depression_PHQ_9_.person_id

	INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id

	WHERE DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) >= 120
	AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) <= 240
	GROUP BY depression_PHQ_9_.person_id) remission ON remission.person_id = depression_PHQ_9_.person_id
INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id	
WHERE depression_PHQ_9_.create_timestamp = remission.most_recent_PHQ_9_date
AND depression_PHQ_9_.txt_total_score < 5
AND DATEDIFF (YEAR, person.date_of_birth, '20160401') >=12

/*response*/
SELECT depression_PHQ_9_.person_id, depression_PHQ_9_.txt_total_score, person.date_of_birth
FROM depression_PHQ_9_
INNER JOIN 
	(SELECT depression_PHQ_9_.person_id, IESD.min_phq_9_score initial_PHQ_9_score_IESD, MAX(depression_PHQ_9_.txt_total_score) most_recent_followup_score, MAX (depression_PHQ_9_.create_timestamp) most_recent_PHQ_9_date
	FROM depression_PHQ_9_

	INNER JOIN (select  patient_encounter.person_id,
		MIN (depression_PHQ_9_.create_timestamp) initial_phq_9_date,
		MIN (depression_PHQ_9_.txt_total_score) min_phq_9_score
		FROM patient_encounter
		INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
		WHERE depression_PHQ_9_.encDate >= '20160401' 
		AND depression_PHQ_9_.encDate <= '20170331'
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		GROUP BY patient_encounter.person_id
		) IESD ON IESD.person_id = depression_PHQ_9_.person_id

	INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id

	WHERE DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) >= 120
	AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) <= 240
	
	GROUP BY depression_PHQ_9_.person_id, IESD.min_phq_9_score) response ON response.person_id = depression_PHQ_9_.person_id
	
INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id	
WHERE depression_PHQ_9_.create_timestamp = response.most_recent_PHQ_9_date
/* AND (response.initial_PHQ_9_score_IESD - response.most_recent_followup_score )/response.initial_PHQ_9_score_IESD >= 0.5 */
AND response.most_recent_followup_score * 2 <= response.initial_PHQ_9_score_IESD 
AND depression_PHQ_9_.txt_total_score is NOT NULL
AND DATEDIFF (YEAR, person.date_of_birth, '20160401') >=12

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
		WHERE depression_PHQ_9_.encDate >= '20160401' 
		AND depression_PHQ_9_.encDate <= '20170331'
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		GROUP BY patient_encounter.person_id
		) IESD ON IESD.person_id = depression_PHQ_9_.person_id

	INNER JOIN patient_encounter on patient_encounter.person_id = depression_PHQ_9_.person_id

	WHERE DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) >= 120
	AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) <= 240
	GROUP BY depression_PHQ_9_.person_id) followup ON followup.person_id = depression_PHQ_9_.person_id
INNER JOIN person ON person.person_id = depression_PHQ_9_.person_id	
WHERE depression_PHQ_9_.create_timestamp = followup.most_recent_PHQ_9_date
AND depression_PHQ_9_.txt_total_score is NOT NULL
AND DATEDIFF (YEAR, person.date_of_birth, '20160401') >=12



/* denominator*/
select  patient_encounter.person_id,
		MIN (depression_PHQ_9_.create_timestamp) initial_phq_9_date
		FROM patient_encounter
		INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
		INNER JOIN person ON person.person_id = patient_encounter.person_id
		WHERE depression_PHQ_9_.encDate >= '20160401' 
		AND depression_PHQ_9_.encDate <= '20170331'
		AND depression_PHQ_9_.txt_total_score > 9
		AND patient_encounter.billable_ind = 'Y'
		AND DATEDIFF (DAY, patient_encounter.enc_timestamp, depression_PHQ_9_.create_timestamp) < 15
		AND DATEDIFF (DAY, depression_PHQ_9_.create_timestamp, patient_encounter.enc_timestamp) < 15
		AND depression_PHQ_9_.txt_total_score is NOT NULL
		AND DATEDIFF (YEAR, person.date_of_birth, '20160401') >=12
		GROUP BY patient_encounter.person_id
