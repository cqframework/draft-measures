library DiabetesMedicalAttentionforNephropathy version '9.3.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include AdvancedIllnessandFrailtyExclusion_FHIR4 version '5.0.000' called FrailtyLTI
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE
include AdultOutpatientEncounters_FHIR4 version '2.0.000' called AdultOutpatientEncounters

valueset "ACE Inhibitor or ARB or ARNI": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1139'
valueset "Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Diabetic Nephropathy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1004'
valueset "Dialysis Education": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1016'
valueset "Dialysis Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1013'
valueset "ESRD Monthly Outpatient Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1014'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Glomerulonephritis and Nephrotic Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1018'
valueset "Hypertensive Chronic Kidney Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1017'
valueset "Kidney Failure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1028'
valueset "Kidney Transplant": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1012'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Other Services Related to Dialysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1015'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Proteinuria": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1003'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Urine Protein Tests": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1024'
valueset "Vascular Access for Dialysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1011'

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
    and exists ( AdultOutpatientEncounters."Qualifying Encounters" )
    and exists ( ( ["Condition": "Diabetes"] Diabetes
      where Diabetes.clinicalStatus ~ Global."active"
        and Global."Prevalence Period"(Diabetes) overlaps "Measurement Period"
        )
    )

define "Denominator":
"Initial Population"

define "Denominator Exclusions":
Hospice."Has Hospice"
  or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"
  or (exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >=65)
        and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
    )

define "Numerator":
exists ( "Active ACE or ARB Medications" )
  or exists ( "Nephropathy Diagnoses" )
  or exists ( "Nephropathy Screenings" )
//check to see if written correctly
define "Active ACE or ARB Medications":
["MedicationRequest": "ACE Inhibitor or ARB or ARNI"] ACEorARBMedication
  where ACEorARBMedication.status in {'active','completed'}
  and exists (ACEorARBMedication.dosageInstruction.timing T
  where T.repeat.bounds as Period overlaps "Measurement Period")

define "Nephropathy Diagnoses":
( ["Condition": "Hypertensive Chronic Kidney Disease"]
    union ["Condition": "Kidney Failure"]
    union ["Condition": "Glomerulonephritis and Nephrotic Syndrome"]
    union ["Condition": "Diabetic Nephropathy"]
    union ["Condition": "Proteinuria"] ) NephropathyDiagnoses
    where NephropathyDiagnoses.clinicalStatus ~ Global."active"
    and Global."Prevalence Period"(NephropathyDiagnoses) overlaps "Measurement Period"

define "Nephropathy Screenings":
( "Renal Procedures"
    union "Renal Interventions"
    union "End Stage Renal Disease Encounter"
    union "Protein Urea Lab Test") ScreeningNephropathy
    where Global."Normalize Interval"(ScreeningNephropathy.performed) during "Measurement Period"
    and ScreeningNephropathy.status = 'completed'

define "Renal Procedures":
( ["Procedure": "Kidney Transplant"]
      union ["Procedure": "Vascular Access for Dialysis"]
      union ["Procedure": "Dialysis Services"]
  )

define "Renal Interventions":
["Procedure": "Other Services Related to Dialysis"]
    union ["Procedure": "Dialysis Education"]

define "End Stage Renal Disease Encounter":
["Encounter": "ESRD Monthly Outpatient Services"]

define "Protein Urea Lab Test":
["Observation": "Urine Protein Tests"] ProteinUreaResult
    where ProteinUreaResult.value is not null
    and ProteinUreaResult.status = 'final'
