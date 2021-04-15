library BloodPressureFHIR version '0.1.001'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include SupplementalDataElementsFHIR4 version '2.0.0' called SDE
include MATGlobalCommonFunctionsFHIR4 version '5.0.000' called Global
include AdultOutpatientEncountersFHIR4 version '2.0.000' called AdultOutpatientEncounters
include Hospice version '2.0.000' called Hospice
include AdvancedIllnessandFrailtyExclusionFHIR4 version '5.0.000' called AdvancedIllness

codesystem "ActEncounterCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
codesystem "LOINC": 'http://loinc.org'

valueset "Adult Outpatient Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1065'
valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Chronic Kidney Disease, Stage 5": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1002'
valueset "Dialysis Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1013'
valueset "Discharged to Health Care Facility for Hospice Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.209'
valueset "ED": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1085'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "End Stage Renal Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.353'
valueset "ESRD Monthly Outpatient Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1014'
valueset "Essential Hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.104.12.1011'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hospice care ambulatory": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1108.15'
valueset "Kidney Transplant": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1012'
valueset "Kidney Transplant Recipient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1029'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Vascular Access for Dialysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1011'

code "ACUTE": 'ACUTE' from "ActEncounterCode" display 'ACUTE'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Blood pressure panel with all children optional": '85354-9' from "LOINC" display 'Blood pressure panel with all children optional'
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "EMER": 'EMER' from "ActEncounterCode" display 'EMER'
code "IMP": 'IMP' from "ActEncounterCode" display 'IMP'
code "NONAC": 'NONAC' from "ActEncounterCode" display 'NONAC'
code "PRENC": 'PRENC' from "ActEncounterCode" display 'PRENC'
code "SS": 'SS' from "ActEncounterCode" display 'SS'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'

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

define "Essential Hypertension Diagnosis":
  [Condition: "Essential Hypertension"] Hypertension
              where Hypertension.verificationStatus ~ ToConcept(Global."confirmed")
              and (Global."Prevalence Period"(Hypertension) overlaps Interval[start of "Measurement Period" - 1 year, end of "Measurement Period"])

define "Initial Population":
  Global.CalendarAgeInYearsAt(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") between 18 and 84
              and exists "Essential Hypertension Diagnosis"
              and exists AdultOutpatientEncounters."Qualifying Encounters"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"
      or exists "Pregnancy Or Renal Diagnosis Exclusions"
       or (exists "End Stage Renal Disease Procedures"
       or exists "End Stage Renal Disease Encounter")
        or Global."CalendarAgeInYearsAt"(ToDateTime(Patient.birthDate), start of "Measurement Period")>=65
               and AdvancedIllness."Has Spent More Than 90 Days in Long Term Care"
               or AdvancedIllness."Advanced Illness and Frailty Exclusion Including Over Age 80"

define "Pregnancy Or Renal Diagnosis Exclusions":
  ([Condition: "Pregnancy"]
              union [Condition: "End Stage Renal Disease"]
              union [Condition: "Kidney Transplant Recipient"]
              union [Condition: "Chronic Kidney Disease, Stage 5"]) PregnancyESRDDiagnosis
              where PregnancyESRDDiagnosis.verificationStatus ~ ToConcept(Global."confirmed")
              and (Global."Prevalence Period"(PregnancyESRDDiagnosis) overlaps "Measurement Period")

define "End Stage Renal Disease Procedures":
  ([Procedure: "Vascular Access for Dialysis"]
            union [Procedure: "Kidney Transplant"]
            union [Procedure: "Dialysis Services"]) ESRDProcedure
            where ESRDProcedure.status = 'completed'
            and Global."Normalize Interval"(ESRDProcedure.performed) starts before end of "Measurement Period"

define "End Stage Renal Disease Encounter":
  [Encounter: "ESRD Monthly Outpatient Services"] ESRDEncounter
            where ESRDEncounter.status in {'arrived', 'triaged', 'in-progress', 'onleave', 'finished'}
            and ESRDEncounter.period starts before end of "Measurement Period"

define "Numerator":
  "Has Diastolic Blood Pressure Less Than 90"
            and "Has Systolic Blood Pressure Less Than 140"

define "Blood Pressure Days":
  (("Qualifying Diastolic Blood Pressure Reading" DBPExam
            return date from DBPExam.effective)
            intersect ("Qualifying Systolic Blood Pressure Reading" SBPExam
            return date from SBPExam.effective))

define "Most Recent Blood Pressure Day":
  Max("Blood Pressure Days")

define "Qualifying Diastolic Blood Pressure Reading":
  [Observation: "Blood pressure panel with all children optional"] BloodPressure
            where BloodPressure.status.value in {'final', 'amended'}
            and Global."Normalize Interval"(BloodPressure.effective) during "Measurement Period"
            and not ((GetEncounter(BloodPressure.encounter)).class.code.value in {'EMER', 'IMP', 'ACUTE', 'NONAC', 'PRENC', 'SS'})
            and exists (BloodPressure.component DiastolicBP
            where FHIRHelpers.ToConcept(DiastolicBP.code) ~ "Diastolic blood pressure"
            and DiastolicBP.value.unit = 'mm[Hg]')

define "Qualifying Systolic Blood Pressure Reading":
  [Observation: "Blood pressure panel with all children optional"] BloodPressure
              where BloodPressure.status.value in {'final', 'amended'}
              and Global."Normalize Interval"(BloodPressure.effective) during "Measurement Period"
              and not ((GetEncounter(BloodPressure.encounter)).class.code.value in {'EMER', 'IMP', 'ACUTE', 'NONAC', 'PRENC', 'SS'})
              and exists (BloodPressure.component SystolicBP
              where FHIRHelpers.ToConcept(SystolicBP.code) ~ "Diastolic blood pressure"
              and SystolicBP.value.unit = 'mm[Hg]')

define "Has Diastolic Blood Pressure Less Than 90":
  "Lowest Diastolic Reading on Most Recent Blood Pressure Day".component.value <90

define "Lowest Systolic Reading on Most Recent Blood Pressure Day":
  First("Qualifying Systolic Blood Pressure Reading" DBPReading
      where DBPReading.effective same day as "Most Recent Blood Pressure Day"
      sort by(value as Quantity)
  )

define "Has Systolic Blood Pressure Less Than 140":
  "Lowest Systolic Reading on Most Recent Blood Pressure Day".component.value <140

define "Lowest Diastolic Reading on Most Recent Blood Pressure Day":
  First("Qualifying Diastolic Blood Pressure Reading" DBPReading
      where DBPReading.effective same day as "Most Recent Blood Pressure Day"
      sort by(value as Quantity)
  )

define function "GetEncounter"(reference Reference ):
  singleton from ([Encounter] x where x.id = Global."GetId"(reference.reference))
