library DiabetesHemoglobinA1cHbA1cPoorControl9 version '9.1.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include AdvancedIllnessandFrailtyExclusion_FHIR4 version '5.0.000' called FrailtyLTI
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE
include AdultOutpatientEncounters_FHIR4 version '2.0.000' called AdultOutpatientEncounters

valueset "Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "HbA1c Laboratory Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1013'
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
  exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) in Interval[18, 75)
  )
    and exists AdultOutpatientEncounters."Qualifying Encounters"
    and exists ( ["Condition": "Diabetes"] Diabetes
      where Diabetes.clinicalStatus ~ Global."active"
        and Global."Prevalence Period"(Diabetes) overlaps "Measurement Period"
        )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"
    or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"
    or ( exists ["Patient"] BirthDate
        where ( Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 65 )
          and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
    )

define "Numerator":
  "Has Most Recent HbA1c Without Result"
    or "Has Most Recent Elevated HbA1c"
    or "Has No Record Of HbA1c"

define "Has Most Recent Elevated HbA1c":
  "Most Recent HbA1c".value > 9 '%'

define "Has Most Recent HbA1c Without Result":
  "Most Recent HbA1c" is not null
    and "Most Recent HbA1c".value is null

define "Most Recent HbA1c":
  Last(["Observation": "HbA1c Laboratory Test"] RecentHbA1c
      where RecentHbA1c.status in {'final', 'amended', 'preliminary', 'corrected'}
      and end of Global."Normalize Interval"(RecentHbA1c.effective) during "Measurement Period"
      sort by end of Global."Normalize Interval"(effective)
  )

define "Has No Record Of HbA1c":
  not exists ( ["Observation": "HbA1c Laboratory Test"] NoHbA1c
      where ( NoHbA1c.status in {'final', 'amended', 'preliminary', 'corrected'}
         and end of Global."Normalize Interval"(NoHbA1c.effective) during "Measurement Period"
  ))
