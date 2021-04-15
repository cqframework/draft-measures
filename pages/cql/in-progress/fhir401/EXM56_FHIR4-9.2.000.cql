library EXM56_FHIR4 version '9.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include Hospice_FHIR4 version '2.0.000' called Hospice
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "LOINC": 'http://loinc.org'
codesystem "CPT": 'http://www.ama-assn.org/go/cpt'
codesystem "ConditionCategoryCodes": 'http://terminology.hl7.org/CodeSystem/condition-category'

valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Fracture - Lower Body": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.113.12.1037'
valueset "Hip Dysfunction and Osteoarthritis Outcome Score for Joint Replacement [HOOSJR]": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1210'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Primary THA Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1006'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

code "Activities of daily living score [HOOS]": '72095-3' from "LOINC" display 'Activities of daily living score [HOOS]'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Pain score [HOOS]": '72097-9' from "LOINC" display 'Pain score [HOOS]'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "Quality of life score [HOOS]": '72093-8' from "LOINC" display 'Quality of life score [HOOS]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Sport-recreation score [HOOS]": '72094-6' from "LOINC" display 'Sport-recreation score [HOOS]'
code "Symptoms score [HOOS]": '72096-1' from "LOINC" display 'Symptoms score [HOOS]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'
code "Problem List Item": 'problem-list-item' from "ConditionCategoryCodes" display 'Problem List Item'

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
Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 19
and "Has Qualifying Encounters"
      and exists ( "Total Hip Arthroplasty Procedure" )

define "Has Qualifying Encounters":
exists ( ( ["Encounter": "Outpatient Consultation"]
    union ["Encounter": "Office Visit"]
    union ["Encounter": "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"] ) ValidEncounters
      where ValidEncounters.period during "Measurement Period"
      and ValidEncounters.status  = 'finished'
  )

define "Total Hip Arthroplasty Procedure":
  ["Procedure": "Primary THA Procedure"] THAProcedure
  where THAProcedure.status = 'completed'
    and THAProcedure.performed as Period starts 12 months or less on or before start of "Measurement Period"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"
    or "Has Total Hip Arthroplasty with 2 or More Lower Body Fractures"
    or exists "Has Dementia Diagnosis"

define "Has Total Hip Arthroplasty with 2 or More Lower Body Fractures":
exists ( "Total Hip Arthroplasty Procedure" THAProcedure
    where Count(["Condition": "Fracture - Lower Body"] LowerBodyFracture
          //where LowerBodyFracture.clinicalStatus ~ ToConcept(Global."active")
          where LowerBodyFracture.verificationStatus ~ ToConcept(Global."confirmed")
          and Global."Prevalence Period"(LowerBodyFracture) starts less than 1 day on or before Global."Normalize Interval"(THAProcedure.performed)
          )>= 2
      )

define "Has Dementia Diagnosis":
   ( ["Condition": "Severe dementia (disorder)"] Dementia
      where exists (Dementia.category C where FHIRHelpers.ToConcept(C) ~ "Problem List Item")
       and Dementia.verificationStatus ~ ToConcept(Global."confirmed")
      and Global."Prevalence Period"(Dementia) overlaps "Measurement Period"
)

define "Numerator":
  ( "Has THA with Initial and Follow Up HOOS Assessments" )
    or ( "Has THA with Initial and Follow Up HOOSJr Assessments" )
    or ( "Has THA with Initial and Follow Up PROMIS10 Assessments" )
    or ( "Has THA with Initial and Follow Up VR12 Oblique Assessments" )
    or ( "Has THA with Initial and Follow Up VR12 Orthogonal Assessments" )

define "Has THA with Initial and Follow Up HOOS Assessments":
exists ( "Total Hip Arthroplasty Procedure" TotalHip
      with "Time HOOS Total Assessment Completed" InitialHipAssessmentHOOS
          such that Global."Normalize Interval"(TotalHip.performed) starts 90 days or less on or after day of InitialHipAssessmentHOOS
      with "Time HOOS Total Assessment Completed" FollowupHipAssessmentHOOS
            such that FollowupHipAssessmentHOOS in Interval[
                end of Global."Normalize Interval"(TotalHip.performed) + 270 days,
                end of Global."Normalize Interval"(TotalHip.performed) + 365 days]
          )

define "Time HOOS Total Assessment Completed":
from
    ["Observation": "Quality of life score [HOOS]"] HOOSLifeQuality,
    ["Observation": "Sport-recreation score [HOOS]"] HOOSSport,
    ["Observation": "Activities of daily living score [HOOS]"] HOOSActivityScore,
    ["Observation": "Symptoms score [HOOS]"] HOOSSymptoms,
    ["Observation": "Pain score [HOOS]"] HOOSPain
    where HOOSLifeQuality.status in {'final', 'amended','corrected'}
    and HOOSLifeQuality.value is not null
    and Global."Normalize Interval"(HOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(HOOSSport.effective)
      and HOOSSport.status in {'final', 'amended','corrected'}
      and HOOSSport.value is not null
      and Global."Normalize Interval"(HOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(HOOSActivityScore.effective)
      and HOOSActivityScore.status in {'final', 'amended','corrected'}
      and HOOSActivityScore.value is not null
      and Global."Normalize Interval"(HOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(HOOSSymptoms.effective)
      and HOOSSymptoms.status in {'final', 'amended','corrected'}
      and HOOSSymptoms.value is not null
      and Global."Normalize Interval"(HOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(HOOSPain.effective)
      and HOOSPain.status in {'final', 'amended','corrected'}
      and HOOSPain.value is not null
    return Max({ HOOSLifeQuality.effective, HOOSSport.effective, HOOSActivityScore.effective, HOOSSymptoms.effective, HOOSPain.effective})

define "Has THA with Initial and Follow Up HOOSJr Assessments":
  exists ( "Total Hip Arthroplasty Procedure" TotalHip
      with "HOOSJr Total Assessment Completed" InitialHipAssessment
        such that Global."Normalize Interval"(TotalHip.performed) starts 90 days or less on or after day of InitialHipAssessment.effective
      with "HOOSJr Total Assessment Completed" FollowupHipAssessment
        such that FollowupHipAssessment.effective in Interval[
        end of  Global."Normalize Interval"(TotalHip.performed) + 270 days,
        end of  Global."Normalize Interval"(TotalHip.performed) + 365 days]
  )

define "HOOSJr Total Assessment Completed":
  ( ["Observation": "Hip Dysfunction and Osteoarthritis Outcome Score for Joint Replacement [HOOSJR]"] HOOSJr
      where HOOSJr.status in {'final','amended','corrected'}
      and HOOSJr.value is not null
  )

define "Has THA with Initial and Follow Up PROMIS10 Assessments":
  exists ( "Total Hip Arthroplasty Procedure" TotalHip
      with "Time PROMIS10 Total Assessment Completed" InitialHipAssessmentPROMIS10
        such that Global."Normalize Interval"(TotalHip.performed) starts 90 days or less on or after day of InitialHipAssessmentPROMIS10
      with "Time PROMIS10 Total Assessment Completed" FollowupHipAssessmentPROMIS10
        such that FollowupHipAssessmentPROMIS10 in Interval[
        end of Global."Normalize Interval"(TotalHip.performed) + 270 days,
        end of Global."Normalize Interval"(TotalHip.performed) + 365 days]
  )

define "Time PROMIS10 Total Assessment Completed":
  from
    ["Observation": "PROMIS-10 Global Mental Health (GMH) score T-score"] Promis10MentalScore,
    ["Observation": "PROMIS-10 Global Physical Health (GPH) score T-score"] Promis10PhysicalScore
    where Promis10MentalScore.status in {'final','amended','corrected'}
    and Promis10MentalScore.value is not null
      and Global."Normalize Interval"(Promis10MentalScore.effective) ends same day as end of Global."Normalize Interval"(Promis10PhysicalScore.effective)
and Promis10PhysicalScore.status in {'final','amended','corrected'}
and Promis10PhysicalScore.value is not null
    return Max({Promis10MentalScore.effective, Promis10PhysicalScore.effective})

define "Has THA with Initial and Follow Up VR12 Oblique Assessments":
  exists ( "Total Hip Arthroplasty Procedure" TotalHip
      with "Time VR12 Oblique Total Assessment Completed" InitialHipAssessmentOblique
        such that Global."Normalize Interval"(TotalHip.performed) starts 90 days or less on or after day of InitialHipAssessmentOblique
      with "Time VR12 Oblique Total Assessment Completed" FollowupHipAssessmentOblique
        such that FollowupHipAssessmentOblique in Interval[
        end of Global."Normalize Interval"(TotalHip.performed) + 270 days,
        end of Global."Normalize Interval"(TotalHip.performed) + 365 days]
  )

define "Time VR12 Oblique Total Assessment Completed":
  from
    ["Observation": "VR-12 Mental component summary (MCS) score - oblique method T-score"] VR12MentalAssessment,
    ["Observation": "VR-12 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
    where VR12MentalAssessment.status in {'final','amended','corrected'}
    and VR12MentalAssessment.value is not null
    and Global."Normalize Interval"(VR12MentalAssessment.effective) ends same day as end of Global."Normalize Interval"(VR12PhysicalAssessment.effective)
and VR12PhysicalAssessment.status in {'final','amended','corrected'}
      and VR12PhysicalAssessment.value is not null
    return Max({ VR12MentalAssessment.effective, VR12PhysicalAssessment.effective })

define "Has THA with Initial and Follow Up VR12 Orthogonal Assessments":
  exists ( "Total Hip Arthroplasty Procedure" TotalHip
      with "Time VR12 Orthogonal Total Assessment Completed" InitialHipAssessmentOrthogonal
        such that Global."Normalize Interval"(TotalHip.performed) starts 90 days or less on or after day of InitialHipAssessmentOrthogonal
      with "Time VR12 Orthogonal Total Assessment Completed" FollowupHipAssessmentOrthogonal
        such that FollowupHipAssessmentOrthogonal in Interval[
        end of Global."Normalize Interval"(TotalHip.performed) + 270 days,
        end of Global."Normalize Interval"(TotalHip.performed) + 365 days]
  )

define "Time VR12 Orthogonal Total Assessment Completed":
  from
    ["Observation": "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalOrthogonal,
    ["Observation": "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalOrthogonal
      where VR12MentalOrthogonal.status in {'final','amended','corrected'}
      and VR12MentalOrthogonal.value is not null
      and Global."Normalize Interval"(VR12MentalOrthogonal.effective) ends same day as end of Global."Normalize Interval"(VR12PhysicalOrthogonal.effective)
  and VR12PhysicalOrthogonal.status in {'final','amended','corrected'}
        and VR12PhysicalOrthogonal.value is not null
      return Max({ VR12MentalOrthogonal.effective, VR12PhysicalOrthogonal.effective })
