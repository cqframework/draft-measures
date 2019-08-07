// for 2020 Reporting Year
library "Discharged on Antithrombotic Therapy" version '8.1.000'

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0'
include MATGlobalCommonFunctions version '4.0.000' called Global
include TJC_Overall version '3.6.000' called TJC
include SupplementalDataElements_FHIR version '1.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "Diagnosis Role": 'http://hl7.org/fhir/diagnosis-role'
codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'
// NOTE: This is an R4 code system
codesystem "MedicationRequestCategory": 'http://terminology.hl7.org/CodeSystem/medicationrequest-category'

valueset "Antithrombotic Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.201'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

// NOTE: This is an R4 code
code "Discharge": 'discharge' from "MedicationRequestCategory"

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
	["MedicationRequest": "Antithrombotic Therapy"] Antithrombotic
	  where exists (Antithrombotic.category C where FHIRHelpers.ToConcept(C) ~ "Discharge")
	    and Antithrombotic.intent = 'order'

define "Denominator":
	TJC."Ischemic Stroke Encounter"

define "Numerator":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Antithrombotic Therapy at Discharge" DischargeAntithrombotic
			such that DischargeAntithrombotic.authoredOn during IschemicStrokeEncounter.period

define "Encounter With Procedure":
  ["Encounter": "Inpatient"] E
	  with ["Procedure", "SCIP"] P
		  such that P.performed during E.period
			// Translator would output
		  //such that (P.performed as dateTime) during E.period
			//  or (P.performed as Period) during E.period

define "Antithrombotic Not Given at Discharge":
	["MedicationRequest": "Antithrombotic Therapy"] NoAntithromboticDischarge
	  // STU3
		where exists (NoAntithromboticDischarge.extension E where E.url = 'http://hl7.org/fhir/us/davinci-deqm/STU3/StructureDefinition/extension-doNotPerform' and E.value is true)
		// R4
		//where NoAntithromboticDischarge.doNotPerform is true
			and (singleton from NoAntithromboticDischarge.reasonCode in "Medical Reason"
				or singleton from NoAntithromboticDischarge.reasonCode in "Patient Refusal")

// NOTE: On the assumption that status of not-taken is the closest to what the measure is looking for, this is the expression:
// TODO: Request discussion w/ Pharmacy regarding how medications not prescribed at discharged would be documented
//define "Antithrombotic Not Given at Discharge R4":
//  ["MedicationStatement": "Antithrombotic Therapy"] AntithromboticTherapy
//	  where AntithromboticTherapy.status = 'not-taken'
//		  and (AntithromboticTherapy.statusReason in "Medical Reason"
//				or AntithrombtoicTherapy.statusReason in "Patient Refusal")

// If it's documented as a checkbox, it may be represented as an observation
//define "Antithrombotic Not Given at Discharge (Observation)":
//  ["Observation": "Medication Not Given At Discharge"] O
//	  where O.value in "Antithrombotic Therapy"

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
