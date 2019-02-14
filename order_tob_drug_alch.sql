select DISTINCT order_.actClass, order_.actCode, order_.actDiagnosis, order_.actText
from order_
where (actClass = 'REFR' or actClass = 'EDU' or actClass = 'INSTRUCT')
and (actDiagnosis like 'Tobacco Abuse'
or actDiagnosis like '%tobacco smoker%'
or actDiagnosis like 'History of drug dependence/abuse'
or actDiagnosis like 'Drug use'
or actDiagnosis like 'Drug dependence%'
or actDiagnosis like 'Drug abuse%'
or actDiagnosis like '%drug screening%'
or actDiagnosis like '%Substance Use%'
or actDiagnosis like '%tobabcco use%'
or actDiagnosis like '%alcohol abuse%'
or actDiagnosis like '%alcohol use%')
