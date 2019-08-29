library EXM71_FHIR3 version '9.1.000'

/*
Based on CMS71v9 - Anticoagulation Therapy for Atrial Fibrillation/Flutter
Author: TJC
*/

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0'
include MATGlobalCommonFunctions_FHIR3 version '4.0.000' called Global
include TJC_Overall_FHIR3 version '3.6.000' called TJC
include SupplementalDataElements_FHIR3 version '1.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

valueset "Anticoagulant Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.200'
valueset "Atrial Ablation": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.203'
valueset "Atrial Fibrillation/Flutter": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.202'
valueset "Comfort Measures": 'https://cts.nlm.nih.gov/fhir/ValueSet/1.3.6.1.4.1.33895.1.3.0.45'
valueset "Discharge To Acute Care Facility": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.209'
valueset "Emergency Department Visit": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Hemorrhagic Stroke": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.212'
valueset "Ischemic Stroke": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.247'
valueset "Left Against Medical Advice": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.308'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "Non-Elective Inpatient Encounter": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.424'
valueset "Observation Services": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1111.143'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Expired": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.309'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
	SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
	SDE."SDE Sex"

define "Reason for Not Giving Anticoagulant at Discharge":
	["MedicationRequest"] NoAnticoagulant
	 where (NoAnticoagulant.medication as CodeableConcept) in "Anticoagulant Therapy"
	 		and (singleton from NoAnticoagulant.reasonCode in "Medical Reason"
				or singleton from NoAnticoagulant.reasonCode in "Patient Refusal")

define "Anticoagulant Therapy at Discharge":
	["MedicationRequest": "Anticoagulant Therapy"]

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

define "Encounter with Atrial Ablation Procedure":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["Procedure": "Atrial Ablation"] AtrialAblation
			such that AtrialAblation.performed Period starts before start of IschemicStrokeEncounter.period

define "Numerator":
	"Denominator" Encounter
		with "Anticoagulant Therapy at Discharge" DischargeAnticoagulant
			such that DischargeAnticoagulant.authoredOn during Encounter.period

define "Current Diagnosis Atrial Fibrillation or Flutter":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where exists ( IschemicStrokeEncounter.diagnoses Diagnosis
				where Diagnosis in "Atrial Fibrillation/Flutter"
		)

define "Denominator":
	"Encounter with Atrial Ablation Procedure"
		union "History of Atrial Fibrillation or Flutter"
		union "Current Diagnosis Atrial Fibrillation or Flutter"

define "Denominator Exceptions":
	"Denominator" Encounter
		with "Reason for Not Giving Anticoagulant at Discharge" NoDischargeAnticoagulant
			such that NoDischargeAnticoagulant.authorDatetime during Encounter.relevantPeriod

define "History of Atrial Fibrillation or Flutter":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["Condition": "Atrial Fibrillation/Flutter"] AtrialFibrillationFlutter
			such that FHIRHelpers.ToDateTime(AtrialFibrillationFlutter.Period as dateTime) starts on or before
			end of IschemicStrokeEncounter.relevantPeriod

define "Denominator Exclusions":
	( "Denominator" Encounter
			where Encounter.dischargeDisposition in "Discharge To Acute Care Facility"
				or Encounter.dischargeDisposition in "Left Against Medical Advice"
				or Encounter.dischargeDisposition in "Patient Expired"
				or Encounter.dischargeDisposition in "Discharged to Home for Hospice Care"
				or Encounter.dischargeDisposition in "Discharged to Health Care Facility for Hospice Care"
	)
		union "Comfort Measures during Hospitalization"

define "Comfort Measures during Hospitalization":
	"Denominator" Encounter
		with TJC."Intervention Comfort Measures" ComfortMeasure
			such that Coalesce(start of ComfortMeasure.relevantPeriod, ComfortMeasure.authorDatetime)during Global."HospitalizationWithObservation"(Encounter)
