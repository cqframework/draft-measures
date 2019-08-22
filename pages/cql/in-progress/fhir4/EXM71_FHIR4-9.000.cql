library AnticoagulationTherapyforAtrialFibrillationFlutter version '9.1.000'

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

valueset "Anticoagulant Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.200'
valueset "Atrial Ablation": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.203'
valueset "Atrial Fibrillation/Flutter": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.202'
valueset "Discharge To Acute Care Facility": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.209'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Left Against Medical Advice": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.308'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Expired": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.309'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

code "Birthdate": '21112-8' from "LOINC" display 'Birth date'
code "Dead": '419099009' from "SNOMEDCT" display 'Dead'
code "Discharge": 'discharge' from "MedicationRequestCategory" display 'Discharge'
code "Order": 'order' from "RequestIntent" display 'Order'

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

define "Reason for Not Giving Anticoagulant at Discharge":
	["MedicationRequest": medication in "Anticoagulant Therapy"] NoAnticoagulant
		where FHIRHelpers.ToBoolean(NoAnticoagulant.doNotPerform) is true
			and (singleton from NoAnticoagulant.reasonCode in "Medical Reason"
				or singleton from NoAnticoagulant.reasonCode in "Patient Refusal")
					and exists (NoAnticoagulant.category C where FHIRHelpers.ToConcept(C) ~ "Discharge")

define "Anticoagulant Therapy at Discharge":
	["MedicationRequest": medication in "Anticoagulant Therapy"] AnticoagulantDischarge
		where exists (AnticoagulantDischarge.category C where FHIRHelpers.ToConcept(C) ~ "Discharge")
			and AnticoagulantDischarge.intent in {'order', 'plan'}

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

define "Encounter with Atrial Ablation Procedure":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["Procedure": "Atrial Ablation"] AtrialAblation
			such that FHIRHelpers.ToDateTime(AtrialAblation.performed as dateTime) starts before start of FHIRHelpers.ToInterval(IschemicStrokeEncounter.period)

define "Numerator":
	"Denominator" Encounter
		with "Anticoagulant Therapy at Discharge" DischargeAnticoagulant
			such that DischargeAnticoagulant.authorDatetime during Encounter.relevantPeriod

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
		with ["Diagnosis": "Atrial Fibrillation/Flutter"] AtrialFibrillationFlutter
			such that AtrialFibrillationFlutter.prevalencePeriod starts on or before
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
