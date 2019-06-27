library AntithromboticTherapyByEndofHospitalDay2 version '8.1.000'

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0' called FHIRHelpers
include MATGlobalCommonFunctions version '4.0.000' called Global
include TJC_Overall version '3.6.000' called TJC
include SupplementalDataElements_FHIR version '1.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

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

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

context Patient

define "SDE Ethnicity":
	["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
	["Patient Characteristic Payer": "Payer"]

define "SDE Race":
	["Patient Characteristic Race": "Race"]

define "SDE Sex":
	["Patient Characteristic Sex": "ONC Administrative Sex"]

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

//Done?
define "Thrombolytic Therapy Medication or Procedures":
	"Thrombolytic Medication"
		union ( ["Procedure": "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy"] ) ThrombolyticProcedure
		where ThrombolyticProcedure.status = 'completed'

//Done? No, need to define status, remove negationRationale
define "No Antithrombotic Administered":
	["MedicationAdministration.reasonNotGiven": medication in "Antithrombotic Therapy"] NoAntithromboticGiven
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
define "No Antithrombotic Ordered for Medical Reason or Patient Refusal"
((  ["MedicationRequest": medication in "Antithrombotic Therapy"]
) MedicationOrder
where MedicationOrder.intent = 'order'
	and GetExtension(MedicationOrder.extension, 'http://example.org/fhir/extensions/doNotPerform').value is true
	//MedicationOrder.doNotPerform is true // Needs a QI-Core extension to support
)


define "No Antithrombotic Ordered":
	"No Antithrombotic Ordered for Medical Reason or Patient Refusal"
		union "No Antithrombotic Administered"

define "Encounter with Comfort Measures":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with TJC."Intervention Comfort Measures" ComfortMeasures
			such that Coalesce(start of ComfortMeasures.relevantPeriod, ComfortMeasures.authorDatetime)during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

define "Encounter with Thrombolytic Medication":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Thrombolytic Medication" Thrombolytic
			such that Thrombolytic.relevantPeriod starts during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

define "Encounter with Thrombolytic Therapy Medication or Procedures":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Thrombolytic Therapy Medication or Procedures" ThrombolyticTherapy
			such that ThrombolyticTherapy.relevantPeriod starts 24 hours or less before start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

define "Encounter Less Than Two Days":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where TJC."HospitalizationWithObservationLengthofStay"(IschemicStrokeEncounter)< 2

define "Encounter With Thrombolytic Therapy Prior to Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where exists IschemicStrokeEncounter.diagnoses Diagnosis
			where Diagnosis in "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"

define "Denominator Exclusions":
	"Encounter Less Than Two Days"
		union "Encounter with Thrombolytic Therapy Medication or Procedures"
		union "Encounter with Thrombolytic Medication"
		union "Encounter with Comfort Measures"
		union "Encounter With An INR Greater Than 3.5"
		union "Encounter With Thrombolytic Therapy Prior to Arrival"
		union "Encounter With Thrombolytic Therapy Documented As Already Given"

define "Encounter With An INR Greater Than 3.5":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["Laboratory Test, Performed": "INR"] INR
			such that INR.resultDatetime during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))
				and INR.result > 3.5

//Done
define "Encounter with Antithrombotic Therapy":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": "Antithrombotic Therapy"] Antithrombotic
			such that Antithrombotic.relevantPeriod starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

define "No Antithrombotic Ordered Day Of or Day After Hospital Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "No Antithrombotic Ordered" NoAntithrombotic
			such that NoAntithrombotic.authorDatetime during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

//Done
define "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": "Ticagrelor Therapy"] Ticagrelor
			such that Ticagrelor.relevantPeriod starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

define "Denominator Exceptions":
	"No Antithrombotic Ordered Day Of or Day After Hospital Arrival"
		union "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival"

define "Encounter With Thrombolytic Therapy Documented As Already Given":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with [Diagnosis: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
			such that PriorTPA.authorDatetime during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
