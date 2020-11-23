library ChildrenWhoHaveDentalDecayorCavities version '9.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

valueset "Clinical Oral Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.125.12.1003'
valueset "Dental Caries": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.125.12.1004'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

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
  exists ["Patient"] BirthDate
    where Global."CalendarAgeInMonthsAt"(FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period") >= 6
      and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period") <20
      and exists "Qualifying Encounters"

define "Qualifying Encounters":
  ["Encounter": "Clinical Oral Evaluation"] ValidEncounter
    where Global."Normalize Interval"(ValidEncounter.period) during "Measurement Period"
      and ValidEncounter.status in { 'arrived', 'triaged', 'in-progress', 'on-leave', 'finished' }

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"

define "Numerator":
  exists ( ["Condition": "Dental Caries"] DentalCaries
    where (DentalCaries.clinicalStatus ~ ToConcept(Global."active")
      or DentalCaries.clinicalStatus ~ ToConcept(Global."recurrence")
      or DentalCaries.clinicalStatus ~  ToConcept(Global."relapse")
    and Global."Prevalence Period"(DentalCaries) overlaps "Measurement Period")
