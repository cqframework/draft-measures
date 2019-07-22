library AnticoagulationTherapyforAtrialFibrillationFlutter version '9.1.000'

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR version '2.0.000' called Global
include SupplementalDataElements_FHIR version '1.0.0' called SDE
include VTEICU_FHIR version '2.4.000' called VTEICU
include TJC_Overall version '3.6.000' called TJC /* I don't think  this has been updated to FHIR yet */

codesystem "LOINC": 'http://loinc.org'


valueset "Anticoagulant Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.200'
valueset "Atrial Ablation": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.203'
valueset "Atrial Fibrillation/Flutter": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.202'
valueset "Discharge To Acute Care Facility": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.207'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Left Against Medical Advice": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.308'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Expired": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.309'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'


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

define "Reason for Not Giving Anticoagulant at Discharge":
  	[MedicationAdministration: "Anticoagulant Therapy"] NoAnticoagulant
  		where (singleton from NoAnticoagulant.reasonNotGiven in 'Patient Refusal' or
      singleton from NoAnticoagulant.reasonCode in 'Patient Refusal') or
      NoAnticoagulant.statusReason =  'Medical Reason'

define "Anticoagulant Therapy at Discharge":
    [MedicationAdministration: "Anticoagulant Therapy"] AnticoagulantDischarge
		where AnticoagulantDischarge.status = 'completed'

define "Initial Population":
			TJC."Encounter with Principal Diagnosis and Age"

define "Encounter with Atrial Ablation Procedure":
			TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
					with [Procedure: "Atrial Ablation"] AtrialAblation
						such that AtrialAblation.relevantPeriod starts before start of IschemicStrokeEncounter.relevantPeriod
						and AtrialAblation.status = 'completed'


/* do I need status for this definition? Is it sufficent that status is captured in "anticoagulant therapy at discharge?" */
define "Numerator":
		  "Denominator" Encounter
					with "Anticoagulant Therapy at Discharge" DischargeAnticoagulant
							such that DischargeAnticoagulant.effective-time during Encounter


define "Current Diagnosis Atrial Fibrillation or Flutter":
		TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where exists ( IschemicStrokeEncounter.diagnosis.condition Diagnosis  /*is this the right way to handle this? */
		       where Diagnosis in "Atrial Fibrillation/Flutter"
					 and IschemicStrokeEncounter.status = 'completed'
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
					with [Diagnosis: "Atrial Fibrillation/Flutter"] AtrialFibrillationFlutter
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
