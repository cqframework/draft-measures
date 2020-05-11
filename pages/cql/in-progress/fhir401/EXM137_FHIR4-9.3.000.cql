library InitiationandEngagementofAlcoholandOtherDrugDependenceTreatment version '9.3.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "Alcohol and Drug Dependence": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.106.12.1001'
valueset "Alcohol and Drug Dependence Treatment": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.106.12.1005'
valueset "Detoxification Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1059'
valueset "Discharge Services - Hospital Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1007'
valueset "Discharge Services - Hospital Inpatient Same Day Discharge": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1006'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Inpatient Visit - Initial": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1004'
valueset "Hospital Observation Care - Initial": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113762.1.4.1'
valueset "Opiate Antagonists": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.198.12.1132'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.3591'
valueset "Psych Visit - Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.836'
valueset "Telehealth Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1031'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Counselling": '409063005' from "SNOMEDCT" display 'Counselling'

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

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"
    or exists "Prior Diagnosis of Dependence"

define "Qualifying Encounters":
  ( ["Encounter": "Office Visit"]
    union ["Encounter": "Emergency Department Visit"]
    union ["Encounter": "Detoxification Visit"]
    union ["Encounter": "Hospital Observation Care - Initial"]
    union ["Encounter": "Hospital Inpatient Visit - Initial"]
    union ["Encounter": "Discharge Services - Hospital Inpatient Same Day Discharge"]
    union ["Encounter": "Discharge Services - Hospital Inpatient"]
    union ["Encounter": "Telehealth Services"] ) ValidEncounters
    where ValidEncounters.status = 'finished'
      and Global."Normalize Interval"(ValidEncounters.period) during "Measurement Period"

define "Continuation of Treatment Event":
  ("Dependence Treatment Intervention"
          union "Telehealth Encounter") ContinuedTreatment
    with ( "Treatment Initiation With Medication Order" ) TreatmentEvent
      such that Global."Normalize Interval"(ContinuedTreatment.performed) starts 34 days or less after TreatmentEvent.authoredOn

define "Initial Population":
  exists ["Patient"] BirthDate
    where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 13
      and "First Dependence Diagnosis During Measurement Period" is not null

define "Prior Diagnosis of Dependence":
  ["Condition": "Alcohol and Drug Dependence"] PriorDependenceDiagnosis
    with ( "First Dependence Diagnosis During Measurement Period" ) FirstDiagnosed
      such that Global."Prevalence Period"(PriorDependenceDiagnosis) starts 60 days or less before start of Global."Prevalence Period"(FirstDiagnosed)

  define "Has Dependence Treatment Intervention Continued":
    Count(("Dependence Treatment Intervention"
            union "Telehealth Encounter")ContinuedTreatment
        with("Dependence Treatment Intervention Initiated")InitiatedTreatment
          such that Global."Normalize Interval"(ContinuedTreatment.performed) starts 34 days or less after start of Global."Normalize Interval"(InitiatedTreatment.performed)
    )>= 2

define "Telehealth Encounter":
  ["Encounter": "Telehealth Services"] Telehealth
    where Telehealth.status = 'finished'
      return "Procedure" {performed: Telehealth.period}

define "Dependence Treatment Intervention":
(["Procedure": "Alcohol and Drug Dependence Treatment"]
    union ["Procedure": "Psych Visit - Psychotherapy"]) DependenceIntervention
      where DependenceIntervention.status = 'finished'
        and DependenceIntervention.category = "Counselling"

define "Has Treatment Initiation With Medication and Continuation of Treatment with Encounters":
  Count(("Dependence Treatment Intervention"
          union "Telehealth Encounter")ContinuedTreatment
      with("Treatment Initiation With Medication Order")InitiatedTreatment
        such that Global."Normalize Interval"(ContinuedTreatment.performed) starts 34 days or less after InitiatedTreatment.authoredOn
  )>= 2

define "Stratification 1":
  exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate),
      end of "Measurement Period" ) in Interval[13, 17]
  )

define "Stratification 2":
  exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate),
      end of "Measurement Period" ) >= 18
  )

define "Treatment with Single Medication Order During Measurement Period":
  ["MedicationRequest": "Opiate Antagonists"] MedicationOrderOpiate
    where MedicationOrderOpiate.authoredOn during "Measurement Period"

define "Numerator 2":
  "Has Dependence Treatment Intervention Continued"
    or exists ( "Treatment with Single Medication Order During Measurement Period" ContinuedTreatment
        with "Dependence Treatment Intervention Initiated" InitiatedMedicationTreatment
          such that ContinuedTreatment.authoredOn 34 days or less after start of Global."Normalize Interval"(InitiatedMedicationTreatment.performed)
    )
    or "Has Treatment Initiation With Medication and Continuation of Treatment with Encounters"
    or ( exists "Continuation of Treatment Event"
        and exists ( "Treatment with Single Medication Order During Measurement Period" ContinuedTreatment
            with ( "Treatment Initiation With Medication Order" ) InitiatedTreatment
              such that ContinuedTreatment.authoredOn 34 days or less after day of InitiatedTreatment.authoredOn
        )
    )

define "Numerator 1":
  exists "Dependence Treatment Intervention Initiated"
    or exists "Treatment Initiation With Medication Order"

define "First Dependence Diagnosis During Measurement Period":
  First(["Condition": "Alcohol and Drug Dependence"] InitialDependenceDiagnosis
      with("Qualifying Encounters")ValidEncounter
        such that Global."Prevalence Period"(InitialDependenceDiagnosis) starts during Global."Normalize Interval"(ValidEncounter.period)
          and Global."Prevalence Period"(InitialDependenceDiagnosis) starts 48 days or more before day of
          end of "Measurement Period"
          and InitialDependenceDiagnosis.clinicalStatus ~ ToConcept(Global."active")
      sort by start of Global."Normalize Interval"(onset) asc
  )

define "Dependence Treatment Intervention Initiated":
  ( ("Dependence Treatment Intervention"
          union "Telehealth Encounter") TreatmentInitiatedWithIntervention
      with ( "First Dependence Diagnosis During Measurement Period" ) FirstDiagnosed
        such that Global."Normalize Interval"(TreatmentInitiatedWithIntervention.performed) starts 14 days or less after day of start of Global."Prevalence Period"(FirstDiagnosed)
  )

define "Treatment Initiation With Medication Order":
  ( ( ["MedicationRequest": "Opiate Antagonists"] ) TreatmentInitiatedWithMedication
      with ( "First Dependence Diagnosis During Measurement Period" ) FirstDiagnosed
        such that TreatmentInitiatedWithMedication.authoredOn 14 days or less on or after day of start of Global."Prevalence Period"(FirstDiagnosed)
          and TreatmentInitiatedWithMedication.status in {'active', 'completed'}

  )
