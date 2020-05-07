library DiabetesEyeExam version '9.1.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include AdvancedIllnessandFrailtyExclusion_FHIR4 version '5.0.000' called FrailtyLTI
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'
codesystem "ObservationCategoryCodes": 'http://hl7.org/fhir/ValueSet/observation-category'

valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Diabetic Retinopathy": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.526.3.327'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.836'
valueset "Retinal or Dilated Eye Exam": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.115.12.1088'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

//ObservationCategory CodeSystem
code "exam": 'exam' from "ObservationCategoryCodes" display 'Exam'

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

define "Diabetic Retinopathy Overlapping Measurement Period":
  exists ( ["Condition": "Diabetic Retinopathy"] Retinopathy
    where Retinopathy.clinicalStatus ~ ToConcept(Global."active")
    //where Retinopathy.clinicalStatus in {ToConcept(Global."active"), ToConcept(Global."recurrence"), ToConcept(Global."relapse")}
      and  Global."Prevalence Period"(Retinopathy) overlaps "Measurement Period"
  )

define "Numerator":
  ( "Diabetic Retinopathy Overlapping Measurement Period"
      and exists ( "Retinal Exam in Measurement Period" )
  )
    or ( not ( "Diabetic Retinopathy Overlapping Measurement Period" )
        and exists ( "Retinal Exam in Measurement Period or Year Prior" )
    )

define "Initial Population":
  exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) in Interval[18, 75)
  )
    and exists ( "Qualifying Encounters" )
    and exists ( ["Condition": "Diabetes"] Diabetes
      where Diabetes.clinicalStatus ~ ToConcept(Global."active")
        and Global."Prevalence Period"(Diabetes) overlaps "Measurement Period"
    )

define "Qualifying Encounters":
  ( ["Encounter": "Office Visit"]
    union ["Encounter": "Annual Wellness Visit"]
    union ["Encounter": "Preventive Care Services - Established Office Visit, 18 and Up"]
    union ["Encounter": "Preventive Care Services-Initial Office Visit, 18 and Up"]
    union ["Encounter": "Home Healthcare Services"]
    union ["Encounter": "Ophthalmological Services"] ) ValidEncounter
      where ValidEncounter.status = 'finished'
        and ValidEncounter.period during "Measurement Period"

define "Retinal Exam in Measurement Period":
  ["Observation": "Retinal or Dilated Eye Exam"] RetinalExam
    where RetinalExam.status in {'final', 'amended', 'preliminary', 'corrected'}
      and RetinalExam.category.coding ~ {"exam"}
      and end of Global."Normalize Interval"(RetinalExam.effective) during "Measurement Period"

define "Retinal Exam in Measurement Period or Year Prior":
  ["Observation": "Retinal or Dilated Eye Exam"] RetinalExam
    where RetinalExam.status in {'final', 'amended', 'preliminary', 'corrected'}
      and RetinalExam.category.coding ~ {"exam"}
      and end of Global."Normalize Interval"(RetinalExam.effective) between (start of "Measurement Period" - 1 year) and
        end of "Measurement Period"

define "Denominator Exclusions":
  Hospice."Has Hospice"
    or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"
    or ( exists ["Patient"] BirthDate
        where ( Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 65 )
          and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
    )
