library HybridHospitalWideRemission version '0.2.031'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include SupplementalDataElements_FHIR4 version '1.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

valueset "Bicarbonate Lab Test":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.139'
valueset "Body Temperature LOINC":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.152'
valueset "Body Weight":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.159'
valueset "Creatinine Lab Test":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.2363'
valueset "Emergency Department Visit":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Glucose Lab Test":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.134'
valueset "Hematocrit lab test":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.114'
valueset "Medicare payer":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1104.10'
valueset "Potassium Lab Test":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.117'
valueset "Sodium Lab Test V":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.119'
valueset "White Blood Cells Count Lab Test":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.129'

code "Heart rate": '8867-4' from "LOINC" display 'Heart rate'
code "Oxygen saturation in Arterial blood by Pulse oximetry": '59408-5' from "LOINC" display 'Oxygen saturation in Arterial blood by Pulse oximetry'
code "Respiratory rate": '9279-1' from "LOINC" display 'Respiratory rate'
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

define "Initial Population":
  "Inpatient Encounters"

define "Inpatient Encounters":
  from
    [Encounter: "Encounter Inpatient"] InpatientEncounter,
    [Coverage: "Medicare payer"] Payer,
    [Patient] Birthdate
    where (Payer.period overlaps before InpatientEncounter.period
    or start of Payer.period same as start of InpatientEncounter.period)
      and end of Payer.period != start of InpatientEncounter.period
      and Global."HospitalizationWithObservationLengthofStay"(InpatientEncounter) < 365
      and InpatientEncounter.period ends during "Measurement Period"
      and Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(Birthdate.birthDate), start of InpatientEncounter.period ) >= 65
    return InpatientEncounter

define "Results":
  {
  // First physical exams
    firstHR: "FirstPhysicalExam"([Observation: "Heart rate"]),  //Warnings for direct reference codes are not a concern. Logic will still work. Confirmed during FHIR Call 2/4/20
    firstSBP: "FirstPhysicalExam"([Observation: "Systolic blood pressure"]),
    firstRR: "FirstPhysicalExam"([Observation: "Respiratory rate"]),
    firstTemp: "FirstPhysicalExam"([Observation: "Body Temperature LOINC"]),
    firstO2Sat: "FirstPhysicalExam"([Observation: "Oxygen saturation in Arterial blood by Pulse oximetry"]),
  // Weight uses lab test timing
    firstWeight: "FirstPhysicalExamWithUsingLabTiming"([Observation: "Body Weight"]),

  // First lab tests
    firstHemat: "FirstLabTest"([Observation: "Hematocrit lab test"]),
    firstWBC: "FirstLabTest"([Observation: "White Blood Cells Count Lab Test"]),
    firstPotass: "FirstLabTest"([Observation: "Potassium Lab Test"]),
    firstSodium: "FirstLabTest"([Observation: "Sodium Lab Test V"]),
    firstBicarb: "FirstLabTest"([Observation: "Bicarbonate Lab Test"]),
    firstCreat: "FirstLabTest"([Observation: "Creatinine Lab Test"]),
    firstGlucose: "FirstLabTest"([Observation: "Glucose Lab Test"])
  }

define function "FirstLabTest"(LabList List<FHIR.Observation>):
  "Inpatient Encounters" Encounter
    let firstlab: First(LabList Lab
        where Lab.issued during Interval[start of Encounter.period - 1440 minutes, start of Encounter.period + 1440 minutes]
        sort by issued
    )
    return {
      Encounterid: Encounter.id,
      FirstResult: firstlab.value as Quantity,
      Timing: firstlab.issued
    }

define function "FirstPhysicalExam"(ExamList List<FHIR.Observation>):
  "Inpatient Encounters" Encounter
    let firstexam: First(ExamList Exam
        where Exam.effective starts during Interval[start of Encounter.period - 1440 minutes, start of Encounter.period + 120 minutes]
        sort by start of effective
    )
    return {
      Encounterid: Encounter.id,
      FirstResult: firstexam.value as Quantity,
      Timing: firstexam.effective
    }

define function "FirstPhysicalExamWithUsingLabTiming"(ExamList List<FHIR.Observation>):
  "Inpatient Encounters" Encounter
    let firstexamwithlabtiming: First(ExamList Exam
        where Exam.effective starts during Interval[start of Encounter.period - 1440 minutes, start of Encounter.period + 1440 minutes]
        sort by start of effective
    )
    return {
      Encounterid: Encounter.id,
      FirstResult: firstexamwithlabtiming.value as Quantity,
      Timing: firstexamwithlabtiming.effective
    }
