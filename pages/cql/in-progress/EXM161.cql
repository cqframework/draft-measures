/*CMS61 Adult MDD*/

using FHIR version '3.0.0'
include library MATGlobalCommonFunctions_FHIR version '4.0.000' called Global
include FHIRHelpers version '3.0.0' called FHIRHelpers

code "Suicide risk assessment (procedure)": '225337009' from "SNOMEDCT" display 'Suicide risk assessment (procedure)'
valueset "Emergency Department Visit": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Major Depressive Disorder-Active": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1491'
valueset "Office Visit": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Psych Visit - Diagnostic Evaluation": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1141'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Telehealth Services": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1031'

parameter "Measurement Period" Interval<DateTime>
context Patient


define "Denominator":
"Initial Population"

define "Initial Population":
"New or Recurrent Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
	with Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 17

define "Major Depressive Disorder Encounter":
( ["Encounter": "Psych Visit - Diagnostic Evaluation"]
	union ["Encounter": "Emergency Department Visit"]
	union ["Encounter": "Office Visit"]
	union ["Encounter": "Outpatient Consultation"]
	union ["Encounter": "Psych Visit - Psychotherapy"]
	union ["Encounter": "Psychoanalysis"]
	union ["Encounter": "Telehealth Services"] ) ValidEncounter
	where ValidEncounter.status = 'finished'
    and exists ValidEncounter.diagnosis in "Major Depressive Disorder-Active"

define "New or Recurrent Major Depressive Disorder Encounter":
"Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
	without "Major Depressive Disorder Encounter" PriorMDDEpisodeEncounter
		such that PriorMDDEpisodeEncounter !~ NewOrRecurrentMDDEncounter
			and PriorMDDEpisodeEncounter.period ends 104 days or less before day of start of NewOrRecurrentMDDEncounter.period
	where NewOrRecurrentMDDEncounter.period during "Measurement Period"

define "Numerator"
"New or Recurrent Major Depressive Disorder Encounter" NewOrRecurrentMDDEncounter
	with ["Procedure": "Suicide risk assessment (procedure)"] SuicideRiskAssessment
		such that SuicideRiskAssessment.performed during NewOrRecurrentMDDEncounter.period
      and SuicideRiskAssessment.status = 'completed'
