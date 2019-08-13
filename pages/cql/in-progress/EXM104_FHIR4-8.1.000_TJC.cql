// for 2020 Reporting Year
library "Discharged on Antithrombotic Therapy" version '8.1.000'
//STK 2

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0'
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include SupplementalDataElements_FHIR4 version '1.0.0' called SDE
include TJC_Overall_FHIR4 version '4.0.000' called TJC

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
// NOTE: R4 code system URLs changed to be based on terminology.hl7.org...
codesystem "Diagnosis Role": 'http://terminology.hl7.org/CodeSystem/diagnosis-role'
//codesystem "Diagnosis Role": 'http://hl7.org/fhir/diagnosis-role'
codesystem "RequestIntent": 'http://terminology.hl7.org/CodeSystem/request-intent'
//codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'
codesystem "MedicationRequestCategory": 'http://terminology.hl7.org/CodeSystem/medicationrequest-category'

valueset "Antithrombotic Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.201'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Order": 'order' from "RequestIntent" display 'Order'
code "Discharge": 'discharge' from "MedicationRequestCategory" display 'Discharge'

parameter "Measurement Period" Interval<DateTime>

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
	["MedicationRequest": medication in "Antithrombotic Therapy"] Antithrombotic
	  where exists (Antithrombotic.category C where FHIRHelpers.ToConcept(C) ~ "Discharge")
	    and Antithrombotic.intent = 'order'

define "Denominator":
	TJC."Ischemic Stroke Encounter"

define "Numerator":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Antithrombotic Therapy at Discharge" DischargeAntithrombotic
			such that FHIRHelpers.ToDateTime(DischargeAntithrombotic.authoredOn) during IschemicStrokeEncounter.period

define "Antithrombotic Not Given at Discharge":
	["MedicationRequest": medication in "Antithrombotic Therapy"] NoAntithromboticDischarge
			where FHIRHelpers.ToBoolean(NoAntithromboticDischarge.doNotPerform) is true
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
			such that FHIRHelpers.ToDateTime(NoDischargeAntithrombotic.authoredOn) during IschemicStrokeEncounter.period

/*define "Encounter With Ticagrelor During Hospitalization":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": medication in TJC."Ticagrelor Therapy"] Ticagrelor
			such that Ticagrelor.effective starts during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)*/
//Looking for Ticagrelor as discharge medication, include a corrected defintion in 2021 CQL based measure

define "Encounter With Ticagrelor at Discharge":
  TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    with "Ticagrelor Therapy at Discharge" DischargeTicagrelor
      such that FHIRHelpers.ToDateTime(DischargeTicagrelor.authoredOn) during IschemicStrokeEncounter.period


define "Ticagrelor Therapy at Discharge":
  ["MedicationRequest": medication in TJC."Ticagrelor Therapy"] Ticagrelor
    where exists (Ticagrelor.category C where FHIRHelpers.ToConcept(C) ~ "Discharge")
      and Ticagrelor.intent = 'order'


define "Denominator Exceptions":
	"Encounter With No Antithrombotic At Discharge"
		union "Encounter With Ticagrelor at Discharge"
