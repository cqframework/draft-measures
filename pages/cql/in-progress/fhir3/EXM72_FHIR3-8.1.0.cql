// for 2020 Reporting Year
library EXM72_FHIR3 version '8.1.000'

/*
Based on CMS72v8 - Antithrombotic Therapy by End of Hospital Day 2
Author: TJC
*/

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR3 version '4.0.000' called Global
include TJC_Overall_FHIR3 version '3.6.000' called TJC
include SupplementalDataElements_FHIR3 version '1.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'
codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'

valueset "Antithrombotic Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.201'
valueset "Comfort Measures": 'https://cts.nlm.nih.gov/fhir/ValueSet/1.3.6.1.4.1.33895.1.3.0.45'
valueset "Emergency Department Visit": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Hemorrhagic Stroke": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.212'
valueset "INR": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.21'
valueset "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.21'
valueset "Ischemic Stroke": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.247'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "Non-Elective Inpatient Encounter": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.424'
valueset "Observation Services": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1111.143'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Thrombolytic (t-PA) Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.226'
valueset "Ticagrelor Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.39'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Order": 'order' from "RequestIntent" display 'Order'
//Should this be added to the FHIRHelpers?

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

define "Numerator":
	"Encounter with Antithrombotic Therapy"

define "Denominator":
	TJC."Ischemic Stroke Encounter"

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

  define "Encounter with Principal Diagnosis and Age":
  	"All Stroke Encounter" AllStrokeEncounter
  		with ["Patient"] BirthDate
  			such that AgeInYearsAt(AllStrokeEncounter.period.start) >= 18

        define "All Stroke Encounter":
        	"Non Elective Inpatient Encounter" NonElectiveEncounter
        		where Global.PrincipalDiagnosis(NonElectiveEncounter).code in "Hemorrhagic Stroke"
        		or Global.PrincipalDiagnosis(NonElectiveEncounter).code in "Ischemic Stroke"

            define "Non Elective Inpatient Encounter":
            	["Encounter": "Non-Elective Inpatient Encounter"] NonElectiveEncounter
            		where Global."LengthInDays"(FHIRHelpers.ToInterval(NonElectiveEncounter.period))<= 120
            			and NonElectiveEncounter.period ends during "Measurement Period"


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
			such that Coalesce(start of ComfortMeasures.performed, ComfortMeasures.authoredOn)during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

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
          such that INR.issued in TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))
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
			such that NoAntithrombotic.effective during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

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
			such that PriorTPA.onset during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
			  and PriorTPA.clinicalStatus in { 'active', 'recurrence', 'relapse' }
				// NOTE: Feedback at Digitial Quality Summit 2019 indicates verificationStatus may be difficult for implementers to retrieve
				//and PriorTPA.verificationStatus = 'confirmed'
