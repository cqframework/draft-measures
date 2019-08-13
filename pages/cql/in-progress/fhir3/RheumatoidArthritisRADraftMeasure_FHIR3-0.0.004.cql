library RheumatoidArthritisRADraftMeasure_FHIR3 version '0.0.004'

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0'

include MATGlobalCommonFunctions_FHIR3 version '2.0.000' called Common

//include MATGlobalCommonFunctions version '3.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Adult Outpatient Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1065'
valueset "Dummy NCQA DQS encounter (grouping)": 'urn:oid:2.16.840.1.113762.1.4.1029.202'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rheumatoid Arthritis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1005'

code "Clinical disease activity index [CDAI]": '75842-5' from "LOINC" display 'Clinical disease activity index [CDAI]'
code "High activity": 'LA28786-4' from "LOINC" display 'High activity'
code "Low activity": 'LA28784-9' from "LOINC" display 'Low activity'
code "Moderate activity": 'LA9642-5' from "LOINC" display 'Moderate activity'
code "Remission": 'LA28783-1' from "LOINC" display 'Remission'
code "Rheumatoid arthritis disease activity level [CDAI]": '88982-4' from "LOINC" display 'Rheumatoid arthritis disease activity level [CDAI]'
code "Total score [CDAI]": '75847-4' from "LOINC" display 'Total score [CDAI]'

parameter "Measurement Period" Interval<DateTime>

context Patient

//define "SDE Ethnicity":
//	["Patient Characteristic Ethnicity": "Ethnicity"]

//define "SDE Payer":
//	["Patient Characteristic Payer": "Payer"]

//define "SDE Race":
//	["Patient Characteristic Race": "Race"]

//define "SDE Sex":
//	["Patient Characteristic Sex": "ONC Administrative Sex"]
	
define "Initial Population":
	Common.CalendarAgeInYearsAt(FHIRHelpers.ToDate(Patient.birthDate), end of "Measurement Period") >= 18
	  and exists "Has Rheumatoid Arthritis"
	  and exists "Patient Had At Least Two Encounters with a CDAI Performed at Least 90 Days Apart"

define "Has Rheumatoid Arthritis":
	[Condition: "Rheumatoid Arthritis"] RA
		where RA.verificationStatus = 'confirmed'
			and RA.assertedDate during "Measurement Period"
			
define "Patient Had At Least Two Encounters with a CDAI Performed at Least 90 Days Apart":
		"CDAI Assessment During Encounter" EarlierCDAI
			with "CDAI Assessment During Encounter" LaterCDAI
			such that LaterCDAI.effective 90 days or more after day of EarlierCDAI.effective

define "Face to Face Encounter During Measurement Period":
	( ["Encounter": "Adult Outpatient Visit"]
		union ["Encounter": "Dummy NCQA DQS encounter (grouping)"] ) Encounter
		where Encounter.status.value in { 'arrived', 'triaged', 'in-progress', 'onleave', 'finished' }
		and Encounter.period during day of "Measurement Period"

define "CDAI Assessment During Encounter":
	([Observation: "Clinical disease activity index [CDAI]"] CDAIPerformed
		with "Face to Face Encounter During Measurement Period" EncounterDuringMP
			such that CDAIPerformed.effective during EncounterDuringMP.period
		where  CDAIPerformed.status.value in { 'final', 'amended' }
			and CDAIPerformed.value is not null)
			
define "Denominator":
	"Initial Population"
	
define "Numerator":
	( "First CDAI Result of High Disease Activity" is not null
	and ( "Last CDAI Result of Moderate Disease Activity" is not null
	or "Last CDAI Result of Low Disease Activity or In Remission" is not null
	)
	)
	or ( "First CDAI Result of Moderate Disease Activity" is not null
	and "Last CDAI Result of Low Disease Activity or In Remission" is not null
	)
	or ( "First CDAI Result of Low Disease Activity or In Remission" is not null
	and "Last CDAI Result of Low Disease Activity or In Remission" is not null
	)
	
define "First CDAI with Result During Measurement Period":
	First("CDAI with Result During Measurement Period" CDAIduringMP
	where CDAIduringMP.effective during "Measurement Period"
	sort by effective
	)
	
define "Last CDAI Assessment with Result During Measurement Period":
	Last("CDAI with Result During Measurement Period" CDAIduringMP
	where CDAIduringMP.effective during "Measurement Period"
	sort by effective
	)

define "CDAI with Result During Measurement Period":
	"CDAI Assessment During Encounter" CDAIduringVisit
		where ( exists ( CDAIduringVisit.component Component1
					where ( FHIRHelpers.ToConcept(Component1.code) ~ "Rheumatoid arthritis disease activity level [CDAI]"
							and ( Component1.value ~ "High activity"
									or Component1.value ~ "Moderate activity"
									or Component1.value ~ "Low activity"
									or Component1.value ~ "Remission"
							)
					)
			)
		)
			or ( exists ( CDAIduringVisit.component Component2
						where ( Component2.code ~ "Total score [CDAI]"
								and Component2.value >= 0
						)
				)
			)





define "First CDAI Result of High Disease Activity":
	"First CDAI with Result During Measurement Period" FirstCDAIMP
		where ( exists ( FirstCDAIMP.component Component1
					where ( Component1.code ~ "Rheumatoid arthritis disease activity level [CDAI]"
							and ( Component1.value ~ "High activity" )
					)
			)
		)
			or ( exists ( FirstCDAIMP.component Component2
						where ( Component2.code ~ "Total score [CDAI]"
								and Component2.value >= 22.1
						)
				)
			)

define "First CDAI Result of Moderate Disease Activity":
	"First CDAI with Result During Measurement Period" FirstCDAIMP
		where ( exists ( FirstCDAIMP.component Component1
					where ( Component1.code ~ "Rheumatoid arthritis disease activity level [CDAI]"
							and ( Component1.value ~ "Moderate activity" )
					)
			)
		)
			or ( exists ( FirstCDAIMP.component Component2
						where ( Component2.code ~ "Total score [CDAI]"
								and Component2.value >= 10.1
								and Component2.value < 22
						)
				)
			)

define "Last CDAI Result of Moderate Disease Activity":
	"Last CDAI Assessment with Result During Measurement Period" LastCDAIMP
		where ( exists ( LastCDAIMP.component Component1
					where ( Component1.code ~ "Rheumatoid arthritis disease activity level [CDAI]"
							and ( Component1.value ~ "Moderate activity" )
					)
			)
		)
			or ( exists ( LastCDAIMP.component Component2
						where ( Component2.code ~ "Total score [CDAI]"
								and Component2.value >= 10.1
								and Component2.value < 22
						)
				)
			)

define "First CDAI Result of Low Disease Activity or In Remission":
	"First CDAI with Result During Measurement Period" FirstCDAIMP
		where ( exists ( FirstCDAIMP.component Component1
					where ( Component1.code ~ "Rheumatoid arthritis disease activity level [CDAI]"
							and ( Component1.value ~ "Low activity"
									or Component1.value ~ "Remission"
							)
					)
			)
		)
			or ( exists ( FirstCDAIMP.component Component2
						where ( Component2.code ~ "Total score [CDAI]"
								and Component2.value >= 0
								and Component2.value <= 10.0
						)
				)
			)

define "Last CDAI Result of Low Disease Activity or In Remission":
	"Last CDAI Assessment with Result During Measurement Period" LastCDAIMP
		where ( exists ( LastCDAIMP.component Component1
					where ( Component1.code ~ "Rheumatoid arthritis disease activity level [CDAI]"
							and ( Component1.value ~ "Low activity"
									or Component1.value ~ "Remission"
							)
					)
			)
		)
			or ( exists ( LastCDAIMP.component Component2
						where ( Component2.code ~ "Total score [CDAI]"
								and Component2.value <= 10.0
								and Component2.value >= 0
						)
				)
			)





