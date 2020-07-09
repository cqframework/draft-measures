library AppropriateTreatmentforUpperRespiratoryInfectionURI version '9.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.6.1'

valueset "Antibiotic Medications for Pharyngitis": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.196.12.1001'
valueset "Comorbid Conditions for Respiratory Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.102.12.1025'
valueset "Competing Conditions for Respiratory Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.102.12.1017'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Observation Care - Initial": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Upper Respiratory Infection": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.102.12.1022'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

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
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    with ["Patient"] BirthDate
      such that Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 3
    return EncounterWithURI

define "Encounter with Upper Respiratory Infection":
  from
    "Qualifying Encounter" QualifyingEncounter,
    ["Condition": "Upper Respiratory Infection"] URI
    where (Global."Prevalence Period"(URI) starts during QualifyingEncounter.period
      or Global."Prevalence Period"(URI) overlaps before QualifyingEncounter.period)
        and (URI.clinicalStatus ~ Global."active"
          or URI.clinicalStatus ~ Global."recurrence"
          or URI.clinicalStatus ~ Global."relapse")
            return QualifyingEncounter

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "In Hospice"
    union "Encounter with Upper Respiratory Infection and Antibiotics Active 30 Days Prior"
    union "Encounter with Competing Diagnosis for Upper Respiratory Infection"
    union "Encounter with Comorbid Condition for Upper Respiratory Infection Prior"

define "In Hospice":
  "Initial Population" InitialPopulation
    where Hospice."Has Hospice"

define "Encounter with Upper Respiratory Infection and Antibiotics Active 30 Days Prior":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
      with ["MedicationRequest": "Antibiotic Medications for Pharyngitis"] ActiveAntibiotic // Not sure if the below timing is correct
      such that (ActiveAntibiotic.status in {'active', 'completed'} //This was "Medication, Active", what status to we want for this?
        and not (ActiveAntibiotic.intent in {'plan', 'proposal'}))
        and ( exists ActiveAntibiotic.dosageInstruction.timing T where Global."Normalize Interval"(T.repeat.bounds) overlaps Interval[Global."ToDate" (  start of Global."Normalize Interval"(EncounterWithURI.period)  - 30 days ), Global."ToDate"(start of Global."Normalize Interval"(EncounterWithURI.period) - 1 day)])
        return EncounterWithURI

define "Encounter with Competing Diagnosis for Upper Respiratory Infection":
     "Encounter with Upper Respiratory Infection" EncounterWithURI
        with ["Condition": "Competing Conditions for Respiratory Conditions"] CompetingCondition
          such that (CompetingCondition.clinicalStatus ~ Global."active"
            or CompetingCondition.clinicalStatus ~ Global."recurrence"
            or CompetingCondition.clinicalStatus ~ Global."relapse")
          and Global."Prevalence Period"(CompetingCondition) starts 3 days or less on or after day of start of EncounterWithURI.period
        return EncounterWithURI

define "Encounter with Comorbid Condition for Upper Respiratory Infection Prior":
  ( "Encounter with Upper Respiratory Infection" EncounterWithURI
      with ["Condition": "Comorbid Conditions for Respiratory Conditions"] ComorbidCondition
        such that (ComorbidCondition.clinicalStatus ~ Global."active"
            or ComorbidCondition.clinicalStatus ~ Global."recurrence"
            or ComorbidCondition.clinicalStatus ~ Global."relapse") //Are these the status attributes we want for this?
        and start of Global."Prevalence Period"(ComorbidCondition) in Interval[Global."ToDate"(start of Global."Normalize Interval"(EncounterWithURI.period) - 1 year), Global."ToDate"(start of Global."Normalize Interval"(EncounterWithURI.period))]
      return EncounterWithURI
  )

define "Numerator":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    without ["MedicationRequest": "Antibiotic Medications for Pharyngitis"] OrderedAntibiotic
      such that (OrderedAntibiotic.status in {'active', 'completed'}
        and not (OrderedAntibiotic.intent in {'plan', 'proposal'}))
      and OrderedAntibiotic.authoredOn 3 days or less on or after start of EncounterWithURI.period
    return EncounterWithURI

define "Qualifying Encounter":
  ( ["Encounter": "Office Visit"]
    union ["Encounter": "Emergency Department Visit"]
    union ["Encounter": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter": "Hospital Observation Care - Initial"]
    union ["Encounter": "Preventive Care Services - Established Office Visit, 18 and Up"]
    union ["Encounter": "Telephone Visits"]
    union ["Encounter": "Preventive Care Services-Initial Office Visit, 18 and Up"] ) ValidEncounter
    where ValidEncounter.period during "Measurement Period"
      and ValidEncounter.status in {'in-progress', 'finished'}

define "Stratification 1":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    with ["Patient"] BirthDate
      such that Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 3
        and Global."CalendarAgeInYearsAt" (FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) <= 17
    return EncounterWithURI

define "Stratification 2":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    with ["Patient"] BirthDate
      such that Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) in Interval[18, 64]
    return EncounterWithURI

define "Stratification 3":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    with ["Patient"] BirthDate
      such that Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 65
    return EncounterWithURI
