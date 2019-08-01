// for 2020 Reporting Year
library AntithromboticTherapyByEndofHospitalDay2 version '8.1.000'

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
valueset "INR": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.21'
valueset "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.21'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Thrombolytic (t-PA) Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.226'
valueset "Ticagrelor Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.39'
valueset "Observation Services": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1111.143'
valueset "Emergency Department Visit": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Order": 'order' from "RequestIntent" display 'Order'
code "Discharge": 'discharge' from "MedicationRequestCategory" display 'Discharge'
//Should this be added to the FHIRHelpers?

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
	SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
	SDE."SDE Sex"

define "Numerator":
	"Encounter with Antithrombotic Therapy"

define "Denominator":
	TJC."Ischemic Stroke Encounter"

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

//Done
define "Thrombolytic Medication":
	["MedicationAdministration": medication in "Thrombolytic (t-PA) Therapy"] ThrombolyticMedicationAdministration
	where ThrombolyticMedicationAdministration.status = 'completed'

//Done
define "Thrombolytic Therapy Medication or Procedures":
	"Thrombolytic Medication"
		union ( ["Procedure": "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy"] ) ThrombolyticProcedure
		where ThrombolyticProcedure.status = 'completed'
		// Noticed we didn't use "procedure in" prior to the value set, as the medeication resource does. Why is that?

//Done
define "No Antithrombotic Administered":
	["MedicationAdministration": medication in "Antithrombotic Therapy"] NoAntithromboticGiven
		where NoAntithromboticGiven.reasonNotGiven in "Medical Reason"
			or NoAntithromboticGiven.reasonNotGiven in "Patient Refusal"
				and NoAntithromboticGiven.status = 'completed'
/*
CQL definition below, following is FHIR

define "No Antithrombotic Ordered for Medical Reason or Patient Refusal":
	["Medication, Not Ordered": "Antithrombotic Therapy"] NoAntithromboticOrder
		where NoAntithromboticOrder.negationRationale in "Medical Reason"
			or NoAntithromboticOrder.negationRationale in "Patient Refusal"
*/

	 // TODO: Tracker for QI-core to add doNotPerform extension for MedicationRequest and suggest to the base Resource
define "No Antithrombotic Ordered for Medical Reason or Patient Refusal":
((  ["MedicationRequest": medication in "Antithrombotic Therapy"]
) MedicationOrder
where MedicationOrder.intent = 'order'
	and GetExtension(MedicationOrder.extension, 'http://example.org/fhir/extensions/doNotPerform').value is true
	//MedicationOrder.doNotPerform is true // Needs a QI-Core extension to support, look at resource further, what is the tracker number so we can follow up on that extension.
)


define "No Antithrombotic Ordered":
	"No Antithrombotic Ordered for Medical Reason or Patient Refusal"
		union "No Antithrombotic Administered"

//Done
define "Encounter with Comfort Measures":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with TJC."Intervention Comfort Measures" ComfortMeasures
			such that FHIRHelpers.ToDateTime(Coalesce(ComfortMeasures.performed as dateTime, ComfortMeasures.authoredOn))during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

//Done
define "Encounter with Thrombolytic Medication":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Thrombolytic Medication" Thrombolytic
			such that Thrombolytic.effective starts during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

//Done
define "Encounter with Thrombolytic Therapy Medication or Procedures":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Thrombolytic Therapy Medication or Procedures" ThrombolyticTherapy
			such that ThrombolyticTherapy.effective starts 24 hours or less before start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

//Done
define "Encounter Less Than Two Days":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where Global.HospitalizationWithObservationLengthofStay(IschemicStrokeEncounter)< 2

//Done
define "Encounter With Thrombolytic Therapy Prior to Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where Global.EncounterDiagnosis(IschemicStrokeEncounter).code in "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"

define "Denominator Exclusions":
	"Encounter Less Than Two Days"
		union "Encounter with Thrombolytic Therapy Medication or Procedures"
		union "Encounter with Thrombolytic Medication"
		union "Encounter with Comfort Measures"
		union "Encounter With An INR Greater Than 3.5"
		union "Encounter With Thrombolytic Therapy Prior to Arrival"
		union "Encounter With Thrombolytic Therapy Documented As Already Given"

//Done
define "Encounter With An INR Greater Than 3.5":
    TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        with ["Observation": "INR"] INR
          such that (INR.issued in TJC."CalendarDayOfOrDayAfter"FHIRHelpers.ToInterval(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))
                and INR.value > 3.5

//Done
define "Encounter with Antithrombotic Therapy":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": medication in "Antithrombotic Therapy"] Antithrombotic
			such that Antithrombotic.effective starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

//Done
define "No Antithrombotic Ordered Day Of or Day After Hospital Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "No Antithrombotic Ordered" NoAntithrombotic
			such that FHIRHelpers.ToInterval(NoAntithrombotic.effective) during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

//Done
define "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": medication in "Ticagrelor Therapy"] Ticagrelor
			such that Ticagrelor.effective starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

//Done
define "Denominator Exceptions":
	"No Antithrombotic Ordered Day Of or Day After Hospital Arrival"
		union "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival"

//Done
define "Encounter With Thrombolytic Therapy Documented As Already Given":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with [Condition: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
			such that FHIRHelpers.ToDateTime(PriorTPA.onset) during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
			  and PriorTPA.clinicalStatus in { 'active', 'recurrence', 'relapse' }
				// NOTE: Feedback at Digitial Quality Summit 2019 indicates verificationStatus may be difficult for implementers to retrieve
				//and PriorTPA.verificationStatus = 'confirmed'
