library DocumentationofCurrentMedicationsintheMedicalRecord version '9.1.000'

using FHIR version '3.0.0'
using QDM version '5.4'
include FHIRHelpers version '3.0.0' called FHIRHelpers

include MATGlobalCommonFunctions version '4.0.000' called Global

codesystem "LOINC": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.6.96'

valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Medical or Other reason not done": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1.1502'
valueset "Medications Encounter Code Set": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1.1834'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Documentation of current medications (procedure)": '428191000124101' from "SNOMEDCT" display 'Documentation of current medications (procedure)'

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

define "Medications Not Documented for Medical Reason":
	["Procedure, Not Performed": "Documentation of current medications (procedure)"] NotPerformed
		where NotPerformed.negationRationale in "Medical or Other reason not done"

define "Denominator Exceptions":
	"Qualifying Encounters During Measurement Period" EncounterDuringMeasurementPeriod
		with "Medications Not Documented for Medical Reason" MedicationsNotDocumented
			such that MedicationsNotDocumented.authorDatetime during EncounterDuringMeasurementPeriod.period

define "Medications Documented During Qualifying Encounter":
	"Qualifying Encounters During Measurement Period" QualifyingEncounterDuringMeasurementPeriod
		with ["Procedure": "Documentation of current medications (procedure)"] MedicationsDocumented
			such that MedicationsDocumented.performed during QualifyingEncounterDuringMeasurementPeriod.period
			and MedicationsDocumented.status = 'completed'

define "Numerator":
	"Medications Documented During Qualifying Encounter"

define "Initial Population":
	"Qualifying Encounters During Measurement Period" QualifyingEncounter
		where Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 18

define "Qualifying Encounters During Measurement Period":
	["Encounter": "Medications Encounter Code Set"] QualifyingEncounter
		where QualifyingEncounter.period during "Measurement Period"
		and QualifyingEncounter.status = 'finished'
