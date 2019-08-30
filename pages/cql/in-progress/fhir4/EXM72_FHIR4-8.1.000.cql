// for 2020 Reporting Year
library EXM72_FHIR4 version '8.1.000'
//STK 5

/*
Based on CMS72v8 - Antithrombotic Therapy By End of Hospital Day 2
Author: TJC
*/

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0'
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include SupplementalDataElements_FHIR4 version '1.0.0' called SDE
include TJC_Overall_FHIR4 version '4.0.000' called TJC

//QA
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
// NOTE: R4 code system URLs changed to be based on terminology.hl7.org...
codesystem "Diagnosis Role": 'http://terminology.hl7.org/CodeSystem/diagnosis-role'
//codesystem "Diagnosis Role": 'http://hl7.org/fhir/diagnosis-role'
codesystem "RequestIntent": 'http://terminology.hl7.org/CodeSystem/request-intent'
//codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'
codesystem "MedicationRequestCategory": 'http://terminology.hl7.org/CodeSystem/medicationrequest-category'
codesystem "ConditionClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'

//QA
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

//QA
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Order": 'order' from "RequestIntent" display 'Order'
code "Discharge": 'discharge' from "MedicationRequestCategory" display 'Discharge'

//QA
//NOTE: Created for condition.clinicalStatus which is codeableConcept
code "active": 'active' from "ConditionClinicalStatusCodes"
code "recurrence": 'recurrence' from "ConditionClinicalStatusCodes"
code "relapse": 'relapse' from "ConditionClinicalStatusCodes"
code "inactive": 'inactive' from "ConditionClinicalStatusCodes"
code "remission": 'remission' from "ConditionClinicalStatusCodes"
code "resolved": 'resolved' from "ConditionClinicalStatusCodes"

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

//QA
define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

/*
  define "Encounter with Principal Diagnosis and Age":
    "All Stroke Encounter" AllStrokeEncounter
    	with ["Patient"] BirthDate
    		such that Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(BirthDate.birthDate), start of FHIRHelpers.ToInterval(AllStrokeEncounter.period)) >= 18

        define "All Stroke Encounter":
        	"Non Elective Inpatient Encounter" NonElectiveEncounter
        		where Global.PrincipalDiagnosis(NonElectiveEncounter).code in "Hemorrhagic Stroke"
        		or Global.PrincipalDiagnosis(NonElectiveEncounter).code in "Ischemic Stroke"

              define "Non Elective Inpatient Encounter":
              	["Encounter": "Non-Elective Inpatient Encounter"] NonElectiveEncounter
              		where Global."LengthInDays"(FHIRHelpers.ToInterval(NonElectiveEncounter.period))<= 120
              			and NonElectiveEncounter.period ends during "Measurement Period"
*/
//QA
define "Denominator":
	TJC."Ischemic Stroke Encounter"

//QA
/*
  define "Ischemic Stroke Encounter":
    TJC."Encounter with Principal Diagnosis and Age" EncounterWithAge
      where Global.PrincipalDiagnosis(EncounterWithAge).code in "Ischemic Stroke"
*/
//QA
define "Denominator Exclusions":
	"Encounter Less Than Two Days"
		union "Encounter with Thrombolytic Therapy Medication or Procedures"
		union "Encounter with Thrombolytic Medication"
		union "Encounter with Comfort Measures"
		union "Encounter With An INR Greater Than 3.5"
		union "Encounter With Thrombolytic Therapy Prior to Arrival"
		union "Encounter With Thrombolytic Therapy Documented As Already Given"

//QA
    define "Encounter Less Than Two Days":
    	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    		where Global.HospitalizationWithObservationLengthofStay(IschemicStrokeEncounter)< 2

//QA - apply coalesce to effective for medication, performed for the procedure. Used coalesce to ensure we are getting the procedure.
//TODO should be effective and performed starts 24 hours.... not working
        define "Encounter with Thrombolytic Therapy Medication or Procedures":
        	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        		with "Thrombolytic Therapy Medication or Procedures" ThrombolyticTherapy
        			such that Coalesce(ThrombolyticTherapy.effective as dateTime, ThrombolyticTherapy.performed as dateTime) 24 hours or less before start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

//QA - Added parenthesis to ensur where statement is for the procedure only
              define "Thrombolytic Therapy Medication or Procedures":
              	"Thrombolytic Medication"
              		union (( ["Procedure": "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy"] ) ThrombolyticProcedure
              		  where ThrombolyticProcedure.status = 'completed'
                  )
//QA
        define "Encounter with Thrombolytic Medication":
        	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        		with "Thrombolytic Medication" Thrombolytic
        			such that Thrombolytic.effective starts during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

//QA
              define "Thrombolytic Medication":
              	["MedicationAdministration": medication in "Thrombolytic (t-PA) Therapy"] ThrombolyticMedicationAdministration
              	where ThrombolyticMedicationAdministration.status = 'completed'

//QA
        define "Encounter with Comfort Measures":
        	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        		with TJC."Intervention Comfort Measures" ComfortMeasures
        			such that FHIRHelpers.ToDateTime(Coalesce(ComfortMeasures.performed as dateTime, ComfortMeasures.authoredOn))during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

//QA
        define "Encounter With An INR Greater Than 3.5":
            TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
              with ["Observation": "INR"] INR
                  such that INR.issued during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))
                        and FHIRHelpers.ToQuantity(INR.value) > 3.5

//QA
        define "Encounter With Thrombolytic Therapy Prior to Arrival":
        	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        		where Global.EncounterDiagnosis(IschemicStrokeEncounter).code in "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"

//QA - do not use onset, needed recordedDate to show when the diagnosis was documented, not when it begins.
        define "Encounter With Thrombolytic Therapy Documented As Already Given":
        	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
        		with [Condition: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
        			such that PriorTPA.recordedDate during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
        			  and FHIRHelpers.ToConcept(PriorTPA.clinicalStatus) in { "active", "recurrence", "relapse" }
        				// NOTE: Feedback at Digitial Quality Summit 2019 indicates verificationStatus may be difficult for implementers to retrieve
        				//and PriorTPA.verificationStatus = 'confirmed'
                //issue is we are comparing a codeable concept with a string, are the code values on the list? cerate alias before "Prior" to validate.

//QA
define "Numerator":
	"Encounter with Antithrombotic Therapy"

//QA - added "and Antithrombotic.status = 'completed'"
  define "Encounter with Antithrombotic Therapy":
  	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
  		with ["MedicationAdministration": medication in "Antithrombotic Therapy"] Antithrombotic
  			such that Antithrombotic.effective starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))
          and Antithrombotic.status = 'completed'

//QA
define "Denominator Exceptions":
	"No Antithrombotic Ordered Day Of or Day After Hospital Arrival"
		union "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival"

//QA
    define "No Antithrombotic Ordered Day Of or Day After Hospital Arrival":
    	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    		with "No Antithrombotic Ordered" NoAntithrombotic
    			such that NoAntithrombotic.effective as Period during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

//QA
          define "No Antithrombotic Ordered":
          	"No Antithrombotic Ordered for Medical Reason or Patient Refusal"
          		union "No Antithrombotic Administered"

//QA
              define "No Antithrombotic Ordered for Medical Reason or Patient Refusal":
                ["MedicationRequest": medication in "Antithrombotic Therapy"] NoAntithromboticOrder
                  where FHIRHelpers.ToBoolean(NoAntithromboticOrder.doNotPerform) is true
                    and NoAntithromboticOrder.reasonCode in "Medical Reason"
                			or NoAntithromboticOrder.reasonCode in "Patient Refusal"

//QA - changed to status not-done, removed complete
              define "No Antithrombotic Administered":
              	["MedicationAdministration": medication in "Antithrombotic Therapy"] NoAntithromboticGiven
              		where NoAntithromboticGiven.reasonCode in "Medical Reason"
              			or NoAntithromboticGiven.reasonCode in "Patient Refusal"
              				and NoAntithromboticGiven.status = 'not-done'

//QA - added "and Ticagrelor.status = 'completed'"
    define "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival":
    	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
    		with ["MedicationAdministration": medication in "Ticagrelor Therapy"] Ticagrelor
    			such that Ticagrelor.effective starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))
            and Ticagrelor.status = 'completed'
