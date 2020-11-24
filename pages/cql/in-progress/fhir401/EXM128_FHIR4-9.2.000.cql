library AntidepressantMedicationManagement version '9.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Antidepressant Medication": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1213'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Major Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1007'
valueset "Nursing Facility Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psych Visit - Diagnostic Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1496'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Telephone Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1082'
valueset "Telephone Management": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1053'

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
  exists (["Patient"] Patient
      where Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") >= 18)
    and "Has Initial Major Depression Diagnosis"
    and exists "Qualifying Encounters"

define "Has Initial Major Depression Diagnosis":
  exists ( ["Condition": "Major Depression"] MajorDepression
    let AntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
      where MajorDepression.clinicalStatus ~ ToConcept(Global."active")
        and (start of Global."Prevalence Period"(MajorDepression) within 60 days of AntidepressantDispensed.whenHandedOver
        and AntidepressantDispensed.whenHandedOver is not null))

define "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period":
  First(["MedicationDispense": "Antidepressant Medication"] Antidepressant
      where Antidepressant.status in {'active', 'completed', 'on-hold'}
        and Antidepressant.whenHandedOver in Interval[start of "Measurement Period" - 245 days, start of "Measurement Period" + 120 days]
      sort by whenHandedOver)


define "Qualifying Encounters":
  ( ["Encounter": "Office Visit"]
    union ["Encounter": "Preventive Care Services - Established Office Visit, 18 and Up"]
    union ["Encounter": "Preventive Care Services-Initial Office Visit, 18 and Up"]
    union ["Encounter": "Home Healthcare Services"]
    union ["Encounter": "Telephone Management"]
    union ["Encounter": "Telephone Evaluation"]
    union ["Encounter": "Annual Wellness Visit"]
    union ["Encounter": "Nursing Facility Visit"]
    union ["Encounter": "Psych Visit - Diagnostic Evaluation"]
    union ["Encounter": "Psych Visit - Psychotherapy"] ) ValidEncounter
    let AntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
    where start of ValidEncounter.period within 60 days of AntidepressantDispensed.whenHandedOver
      and ValidEncounter.status in { 'arrived', 'triaged', 'in-progress', 'onleave', 'finished' }

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"
    or exists ( ["MedicationRequest": "Antidepressant Medication"] OnAntiDepressant
        let AntidepressantDispensed: "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period"
          where OnAntiDepressant.status = 'active'
          and exists (OnAntiDepressant.dosageInstruction.timing T 
                    where T.repeat.bounds as Period overlaps Interval[AntidepressantDispensed.whenHandedOver - 105 days, AntidepressantDispensed.whenHandedOver])
          and AntidepressantDispensed.whenHandedOver is not null
    )

define "Numerator 1":
  "Cumulative Medication Duration Greater Than or Equal to 84 Days"

define "Cumulative Medication Duration Greater Than or Equal to 84 Days":
  "Cumulative Medication Duration"("Antidepressant Medication Period In 114 Days After Initial Dispense")>= 84

define "Active Antidepressant":
["MedicationRequest": "Antidepressant Medication"] ActiveAntidepressant
where ActiveAntidepressant.status = 'active'

define "Antidepressant Medication Period In 114 Days After Initial Dispense":
  from
    "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period" InitialAntidepressantDipsensed,
    "Active Antidepressant".dosageInstruction.timing.repeat.bounds ActiveAntidepressant
    where ActiveAntidepressant.start 114 days or less on or after day of InitialAntidepressantDipsensed.whenHandedOver
      return ActiveAntidepressant intersect Interval[InitialAntidepressantDipsensed.whenHandedOver, InitialAntidepressantDipsensed.whenHandedOver + 114 days]

define "Numerator 2":
  "Cumulative Medication Duration Greater Than or Equal to 180 Days"

define "Cumulative Medication Duration Greater Than or Equal to 180 Days":
  "Cumulative Medication Duration"("Antidepressant Medication Period In 231 Days After Initial Dispense")>= 180

define "Antidepressant Medication Period In 231 Days After Initial Dispense":
from  
    "Antidepressant Dispensed 245 Days Before or 120 Days After Start of Measurement Period" InitialAntidepressantDipsensed,
    "Active Antidepressant".dosageInstruction.timing.repeat.bounds ActiveAntidepressant
    where ActiveAntidepressant.start 231 days or less on or after day of InitialAntidepressantDipsensed.whenHandedOver
      return ActiveAntidepressant intersect Interval[InitialAntidepressantDipsensed.whenHandedOver, InitialAntidepressantDipsensed.whenHandedOver + 231 days]


define function "Cumulative Medication Duration"(Medication List<Interval<DateTime>>):
  Sum((collapse(Medication))CumulativeAntidepressant
      return all duration in days of CumulativeAntidepressant
  )