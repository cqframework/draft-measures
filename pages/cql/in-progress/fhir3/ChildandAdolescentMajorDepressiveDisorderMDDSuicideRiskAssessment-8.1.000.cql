library EXM177_FHIR3 version '8.1.000'

using FHIR version '3.0.0'
using QDM version '5.4'

include MATGlobalCommonFunctions_FHIR version '4.0.000' called Global
include FHIRHelpers version '3.0.0' called FHIRHelpers

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'https://snomed.info/sct'

valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Group Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1187'
valueset "Major Depressive Disorder-Active": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1491'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Psych Visit - Diagnostic Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Family Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet2.16.840.1.113883.3.526.3.1018'
valueset "Psych Visit - Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1496'
valueset "Psychoanalysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1141'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Telehealth Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1031'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Suicide risk assessment (procedure)": '225337009' from "SNOMEDCT" display 'Suicide risk assessment (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
	["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
	["Patient Characteristic Payer": "Payer"]

define "SDE Race":
	["Patient Characteristic Race": "Race"]

define "SDE Sex":
	["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator":
	"Initial Population"

define "Major Depressive Disorder Encounter":
	( ["Encounter": "Office Visit"]
		union ["Encounter": "Outpatient Consultation"]
		union ["Encounter": "Psych Visit - Diagnostic Evaluation"]
		union ["Encounter": "Psych Visit - Family Psychotherapy"]
		union ["Encounter": "Psych Visit - Psychotherapy"]
		union ["Encounter": "Psychoanalysis"]
		union ["Encounter": "Group Psychotherapy"]
		union ["Encounter": "Telehealth Services"] ) ValidEncounter
		where ValidEncounter.status = 'finished'
				and Global.EncounterDiagnosis(ValidEncounter).code in "Major Depressive Disoder-Active"

define "Numerator":
"Major Depressive Disorder Encounter" MDDEncounter
	with ["Procedure": "Suicide risk assessment (procedure)"] SuicideRiskAssessment
		such that SuicideRiskAssessment.performed during MDDEncounter.period
		and SuicideRiskAssessment.status = 'completed'


define "Initial Population":
	"Major Depressive Disorder Encounter" MDDEncounter
			where Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 6
				and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")< 17
