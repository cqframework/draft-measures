// for 2020 Reporting Year
library EXM104 version '8.1.000'

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0'
include MATGlobalCommonFunctions version '4.0.000' called Global
include TJC_Overall version '3.6.000' called TJC
include SupplementalDataElements_FHIR version '1.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "Diagnosis Role": 'http://hl7.org/fhir/diagnosis-role'
codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'

valueset "Antithrombotic Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.201'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
	SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
	SDE."SDE Sex"

define "Antithrombotic Therapy at Discharge":
	["MedicationRequest"] Antithrombotic
	 where (Antithrombotic.medication as CodeableConcept) in "Antithrombotic Therapy"
	 		and Antithrombotic.intent = 'order'

define "Denominator":
	TJC."Ischemic Stroke Encounter"

define "Numerator":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Antithrombotic Therapy at Discharge" DischargeAntithrombotic
			such that DischargeAntithrombotic.authoredOn during IschemicStrokeEncounter.period

define "Antithrombotic Not Given at Discharge":
	["MedicationRequest"] NoAntithromboticDischarge
		where (NoAntithromboticDischarge.medication as CodeableConcept) in "Antithrombotic Therapy"
			and (singeleton from NoAntithromboticDischarge.reasonCode in "Medical Reason"
				or singelton from NoAntithromboticDischarge.reasonCode in "Patient Refusal")

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

define "Denominator Exclusions":
	TJC."Ischemic Stroke Encounters with Discharge Disposition"
		union TJC."Comfort Measures during Hospitalization"

define "Encounter With No Antithrombotic At Discharge":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Antithrombotic Not Given at Discharge" NoDischargeAntithrombotic
			such that NoDischargeAntithrombotic.authoredOn during IschemicStrokeEncounter.period

define "Encounter With Ticagrelor During Hospitalization":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": medication in TJC."Ticagrelor Therapy"] Ticagrelor
			such that Ticagrelor.effective starts during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

define "Denominator Exceptions":
	"Encounter With No Antithrombotic At Discharge"
		union "Encounter With Ticagrelor During Hospitalization"
