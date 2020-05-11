library EXM66_FHIR4 version '9.3.000'

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
valueset "Knee Injury and Osteoarthritis Outcome Score for Joint Replacement [KOOSJR]": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1218'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/oid:2.16.840.1.114222.4.11.3591'
valueset "Primary TKA Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/oid:2.16.840.1.113883.3.464.1003.198.12.1007'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/oid:2.16.840.1.114222.4.11.836'

code "Activities of daily living score [KOOS]": '72100-1' from "LOINC" display 'Activities of daily living score [KOOS]'
code "Birthdate": '21112-8' from "LOINC" display 'Birth date'
code "Pain score [KOOS]": '72102-7' from "LOINC" display 'Pain score [KOOS]'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "Quality of life score [KOOS]": '72098-7' from "LOINC" display 'Quality of life score [KOOS]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Sport-recreation score [KOOS]": '72099-5' from "LOINC" display 'Sport-recreation score [KOOS]'
code "Symptoms score [KOOS]": '72101-9' from "LOINC" display 'Symptoms score [KOOS]'
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
      and exists ( "Total Knee Arthroplasty Procedure" )


define "Has Qualifying Encounters":
exists ( ( ["Encounter": "Outpatient Consultation"]
      union ["Encounter": "Office Visit"]
      union ["Encounter": "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"] ) ValidEncounters
          where ValidEncounters.period during "Measurement Period"
            		and ValidEncounters.status  = 'finished'
        )

define "Total Knee Arthroplasty Procedure":
["Procedure": "Primary TKA Procedure"] TKAProcedure
            where TKAProcedure.status = 'completed'
            and TKAProcedure.performed as Period starts 12 months or less before start of "Measurement Period"

define "Denominator":
"Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"
    or "Has Total Knee Arthroplasty with 2 or More Lower Body Fractures"
    or exists "Has Dementia Diagnosis"

define "Has Total Knee Arthroplasty with 2 or More Lower Body Fractures":
exists ( "Total Knee Arthroplasty Procedure" TKAProcedure
    where Count(["Condition": "Fracture - Lower Body"] LowerBodyFracture
          where LowerBodyFracture.clinicalStatus ~ ToConcept(Global."active")
          and LowerBodyFracture.verificationStatus ~ ToConcept(Global."confirmed")
          and Global."Prevalence Period"(LowerBodyFracture) starts less than 1 day on or before Global."Normalize Interval"(TKAProcedure.performed)
          )>= 2
      )

define "Has Dementia Diagnosis":
         ( ["Condition": "Severe dementia (disorder)"] Dementia
            where exists (Dementia.category C where FHIRHelpers.ToConcept(C) ~ "Problem List Item")
             and Dementia.clinicalStatus ~ ToConcept(Global."active")
            and Global."Prevalence Period"(Dementia) overlaps "Measurement Period"
      )


define "Numerator":
"Has TKA with Initial and Follow Up KOOS Assessments"
    or "Has TKA with Initial and Follow Up KOOSJr Assessments"
    or "Has TKA with Initial and Follow Up PROMIS10 Assessments"
    or "Has TKA with Initial and Follow Up VR12 Oblique Assessments"
    or "Has TKA with Initial and Follow Up VR12 Orthogonal Assessments"

define "Has TKA with Initial and Follow Up KOOS Assessments":
exists ( "Total Knee Arthroplasty Procedure" TotalKnee
      with "Time KOOS Total Assessment Completed" InitialKOOSAssessmentTime
          such that Global."Normalize Interval"(TotalKnee.performed) starts 90 days or less on or after day of InitialKOOSAssessmentTime
      with "Time KOOS Total Assessment Completed" FollowupKOOSAssessmentTime
            such that FollowupKOOSAssessmentTime in Interval[
                end of Global."Normalize Interval"(TotalKnee.performed) + 270 days,
                end of Global."Normalize Interval"(TotalKnee.performed) + 365 days]
          )

define "Time KOOS Total Assessment Completed":
from
    ["Observation": "Quality of life score [KOOS]"] KOOSLifeQuality,
    ["Observation": "Sport-recreation score [KOOS]"] KOOSSport,
    ["Observation": "Activities of daily living score [KOOS]"] KOOSActivityScore,
    ["Observation": "Symptoms score [KOOS]"] KOOSSymptoms,
    ["Observation": "Pain score [KOOS]"] KOOSPain
    where KOOSLifeQuality.status in {'final', 'amended','corrected'}
    and KOOSLifeQuality.value is not null
    and Global."Normalize Interval"(KOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KOOSSport.effective)
      and KOOSSport.status in {'final', 'amended','corrected'}
      and KOOSSport.value is not null
      and Global."Normalize Interval"(KOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KOOSActivityScore.effective)
      and KOOSActivityScore.status in {'final', 'amended','corrected'}
      and KOOSActivityScore.value is not null
      and Global."Normalize Interval"(KOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KOOSSymptoms.effective)
      and KOOSSymptoms.status in {'final', 'amended','corrected'}
      and KOOSSymptoms.value is not null
      and Global."Normalize Interval"(KOOSLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KOOSPain.effective)
      and KOOSPain.status in {'final', 'amended','corrected'}
      and KOOSPain.value is not null
    return Max({ KOOSLifeQuality.effective, KOOSSport.effective, KOOSActivityScore.effective, KOOSSymptoms.effective, KOOSPain.effective})

define "Has TKA with Initial and Follow Up KOOSJr Assessments":
exists ( "Total Knee Arthroplasty Procedure" TotalKnee
      with "KOOSJr Total Assessment Completed" InitialKOOSJrAssessment
        such that Global."Normalize Interval"(TotalKnee.performed) starts 90 days or less on or after day of InitialKOOSJrAssessment.effective
      with "KOOSJr Total Assessment Completed" FollowupKOOSJrAssessment
        such that FollowupKOOSJrAssessment.effective in Interval[
        end of Global."Normalize Interval"(TotalKnee.performed) + 270 days,
        end of Global."Normalize Interval"(TotalKnee.performed) + 365 days]
  )

define "KOOSJr Total Assessment Completed":
    ( ["Observation": "Knee Injury and Osteoarthritis Outcome Score for Joint Replacement [KOOSJR]"] KOOSJr
        where KOOSJr.status in {'final','amended','corrected'}
        and KOOSJr.value is not null
    )

define "Has TKA with Initial and Follow Up PROMIS10 Assessments":
exists ( "Total Knee Arthroplasty Procedure" TotalKnee
      with "Time PROMIS10 Total Assessment Completed" InitialPROMIS10AssessmentTime
        such that Global."Normalize Interval"(TotalKnee.performed) starts 90 days or less on or after day of InitialPROMIS10AssessmentTime
      with "Time PROMIS10 Total Assessment Completed" FollowupPROMIS10AssessmentTime
        such that FollowupPROMIS10AssessmentTime in Interval[
        end of Global."Normalize Interval"(TotalKnee.performed) + 270 days,
        end of Global."Normalize Interval"(TotalKnee.performed) + 365 days]
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

define "Has TKA with Initial and Follow Up VR12 Oblique Assessments":
exists ( "Total Knee Arthroplasty Procedure" TotalKnee
      with "Time VR12 Oblique Total Assessment Completed" InitialKneeAssessmentObliqueTime
        such that Global."Normalize Interval"(TotalKnee.performed) starts 90 days or less on or after day of InitialKneeAssessmentObliqueTime
      with "Time VR12 Oblique Total Assessment Completed" FollowupObliqueAssessmentTime
        such that FollowupObliqueAssessmentTime in Interval[
        end of Global."Normalize Interval"(TotalKnee.performed) + 270 days,
        end of Global."Normalize Interval"(TotalKnee.performed) + 365 days]
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

define "Has TKA with Initial and Follow Up VR12 Orthogonal Assessments":
exists ( "Total Knee Arthroplasty Procedure" TotalKnee
    with "Time VR12 Orthogonal Total Assessment Completed" InitialOrthogonalAssessmentTime
      such that Global."Normalize Interval"(TotalKnee.performed) starts 90 days or less on or after day of InitialOrthogonalAssessmentTime
    with "Time VR12 Orthogonal Total Assessment Completed" FollowupOrthogonalAssessmentTime
      such that FollowupOrthogonalAssessmentTime in Interval[
      end of Global."Normalize Interval"(TotalKnee.performed) + 270 days,
      end of Global."Normalize Interval"(TotalKnee.performed) + 365 days]
)

define "Time VR12 Orthogonal Total Assessment Completed":
from
    ["Observation": "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalAssessment,
    ["Observation": "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalAssessment
    where VR12MentalAssessment.status in {'final','amended','corrected'}
    and VR12MentalAssessment.value is not null
    and Global."Normalize Interval"(VR12MentalAssessment.effective) ends same day as end of Global."Normalize Interval"(VR12PhysicalAssessment.effective)
and VR12PhysicalAssessment.status in {'final','amended','corrected'}
      and VR12PhysicalAssessment.value is not null
    return Max({ VR12MentalAssessment.effective, VR12PhysicalAssessment.effective })
