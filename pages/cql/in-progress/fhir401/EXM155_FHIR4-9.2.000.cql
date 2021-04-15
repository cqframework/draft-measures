library EXM155_FHIR4 version '9.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include Hospice_FHIR4 version '2.0.000' called Hospice
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

valueset "BMI percentile": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.121.12.1012'
valueset "Counseling for Nutrition": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.195.12.1003'
valueset "Counseling for Physical Activity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1035'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Height": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.121.12.1014'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'
valueset "Preventive Care Services - Group Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Weight": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.121.12.1015'

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
Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") in Interval[3,17)
  and exists ( "Qualifying Encounter" )

define "Qualifying Encounter":
([Encounter: "Office Visit"]
  union ["Encounter": "Preventive Care Services-Individual Counseling"]
  union ["Encounter": "Preventive Care Services, Initial Office Visit, 0 to 17"]
  union ["Encounter": "Preventive Care, Established Office Visit, 0 to 17"]
  union ["Encounter": "Preventive Care Services - Group Counseling"]
  union ["Encounter": "Home Healthcare Services"]) ValidEncounter
  		where ValidEncounter.period during "Measurement Period"
    		and ValidEncounter.status  = 'finished'

define "Denominator":
"Initial Population"

define "Denominator Exclusions":
Hospice."Has Hospice"
    or exists ( "Pregnancy Diagnosis Which Overlaps Measurement Period" )

define "Pregnancy Diagnosis Which Overlaps Measurement Period":
["Condition": "Pregnancy"] Pregnancy
    where Pregnancy.clinicalStatus ~ (Global."active")
      and Global."Prevalence Period"(Pregnancy) overlaps "Measurement Period"

define "Numerator 1":
exists ( "BMI Percentile in Measurement Period" )
    and exists ( "Height in Measurement Period" )
    and exists ( "Weight in Measurement Period" )

define "BMI Percentile in Measurement Period":
["Observation": "BMI percentile"] BMIPercentile
  where BMIPercentile.status in {'final', 'amended', 'corrected', 'preliminary'}
    and Global."Normalize Interval"(BMIPercentile.effective) during "Measurement Period"
    and BMIPercentile.value is not null

define "Height in Measurement Period":
["Observation": "Height"] Height
  where Height.status in {'final', 'amended', 'corrected', 'preliminary'}
    and Global."Normalize Interval"(Height.effective) during "Measurement Period"
    and Height.value is not null

define "Weight in Measurement Period":
["Observation": "Weight"] Weight
  where Weight.status in {'final', 'amended', 'corrected', 'preliminary'}
    and Global."Normalize Interval"(Weight.effective) during "Measurement Period"
    and Weight.value is not null

define "Numerator 2":
exists ["Procedure": "Counseling for Nutrition"] NutritionCounseling
  where NutritionCounseling.status = 'completed'
  and Global."Normalize Interval"(NutritionCounseling.performed) during "Measurement Period"

define "Numerator 3":
exists ["Procedure": "Counseling for Physical Activity"] ActivityCounseling
      where ActivityCounseling.status = 'completed'
      and Global."Normalize Interval"(ActivityCounseling.performed) during "Measurement Period"

define "Stratifaction 1":
Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") in Interval[3, 11]

define "Stratifaction 2":
Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") in Interval[12, 17)
