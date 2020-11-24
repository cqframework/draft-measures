library EXM90_FHIR4 version '10.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include Hospice_FHIR4 version '2.0.000' called Hospice
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "LOINC": 'http://loinc.org'
codesystem "ConditionCategoryCodes": 'http://terminology.hl7.org/CodeSystem/condition-category'

valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Heart Failure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.376'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/oid:2.16.840.1.114222.4.11.836'

code "Birthdate": '21112-8' from "LOINC" display 'Birth date'
code "Activities of daily living score [KOOS]": '72100-1' from "LOINC" display 'Activities of daily living score [KOOS]'
code "Emotional score [MLHFQ]": '85609-6' from "LOINC" display 'Emotional score [MLHFQ]'
code "Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]": '86923-0' from "LOINC" display 'Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]'
code "Overall summary score [KCCQ-12]": '86924-8' from "LOINC" display 'Overall summary score [KCCQ-12]'
code "Overall summary score [KCCQ]": '71940-1' from "LOINC" display 'Overall summary score [KCCQ]'
code "Physical limitation score [KCCQ]": '72195-1' from "LOINC" display 'Physical limitation score [KCCQ]'
code "Physical score [MLHFQ]": '85618-7' from "LOINC" display 'Physical score [MLHFQ]'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "PROMIS-29 Anxiety score T-score": '71967-4' from "LOINC" display 'PROMIS-29 Anxiety score T-score'
code "PROMIS-29 Depression score T-score": '71965-8' from "LOINC" display 'PROMIS-29 Depression score T-score'
code "PROMIS-29 Fatigue score T-score": '71963-3' from "LOINC" display 'PROMIS-29 Fatigue score T-score'
code "PROMIS-29 Pain interference score T-score": '71961-7' from "LOINC" display 'PROMIS-29 Pain interference score T-score'
code "PROMIS-29 Physical function score T-score": '71959-1' from "LOINC" display 'PROMIS-29 Physical function score T-score'
code "PROMIS-29 Satisfaction with participation in social roles score T-score": '71957-5' from "LOINC" display 'PROMIS-29 Satisfaction with participation in social roles score T-score'
code "PROMIS-29 Sleep disturbance score T-score": '71955-9' from "LOINC" display 'PROMIS-29 Sleep disturbance score T-score'
code "Quality of life score [KCCQ]": '72189-4' from "LOINC" display 'Quality of life score [KCCQ]'
code "Self-efficacy score [KCCQ]": '72190-2' from "LOINC" display 'Self-efficacy score [KCCQ]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Social limitation score [KCCQ]": '72196-9' from "LOINC" display 'Social limitation score [KCCQ]'
code "Symptom stability score [KCCQ]": '72194-4' from "LOINC" display 'Symptom stability score [KCCQ]'
code "Total symptom score [KCCQ]": '72191-0' from "LOINC" display 'Total symptom score [KCCQ]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'
code "VR-36 Mental component summary (MCS) score - oblique method T-score": '71990-6' from "LOINC" display 'VR-36 Mental component summary (MCS) score - oblique method T-score'
code "VR-36 Mental component summary (MCS) score - orthogonal method T-score": '72008-6' from "LOINC" display 'VR-36 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-36 Physical component summary (PCS) score - oblique method T-score": '71989-8' from "LOINC" display 'VR-36 Physical component summary (PCS) score - oblique method T-score'
code "VR-36 Physical component summary (PCS) score - orthogonal method T-score": '72007-8' from "LOINC" display 'VR-36 Physical component summary (PCS) score - orthogonal method T-score'
code "Problem List Item": 'problem-list-item' from "ConditionCategoryCodes" display 'Problem List Item'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0)

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
      where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 18
  )
      and exists ( ["Condition": "Heart Failure"] HeartFailure
        where HeartFailure.verificationStatus ~ ToConcept(Global."confirmed") and
          Global."Prevalence Period"(HeartFailure) overlaps before "Measurement Period"
    )
    and exists ( "Follow Up Encounter" )

define "Follow Up Encounter":
  "Qualifying Encounters" OfficeVisit
    with "Initial Encounter" InitialVisit
      such that OfficeVisit.period starts 30 days or more after day of
      end of InitialVisit.period
        and OfficeVisit.period starts 180 days or less after day of
        end of InitialVisit.period

define "Qualifying Encounters":
  ["Encounter": "Office Visit"]ValidEncounter
      where ValidEncounter.status in {'finished','arrived','triaged','in-progress','on-leave'}
        and ValidEncounter.period during "Measurement Period"

define "Initial Encounter":
  First("Qualifying Encounters" QualifyingEncounter
      where QualifyingEncounter.period ends 180 days or more before
         end of "Measurement Period"
         sort by start of period
      )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"
    or exists ( ["Condition": "Severe dementia (disorder)"] Dementia
      where Dementia.verificationStatus ~ ToConcept(Global."confirmed") and
        Global."Prevalence Period"(Dementia) overlaps before "Measurement Period"
    )

define "Numerator":
  ( "Has Encounter with Initial and Follow Up PROMIS10 Assessments" )
    or ( "Has Encounter with Initial and Follow Up PROMIS29 Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR12 Oblique Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR12 Orthogonal Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR36 Oblique Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR36 Orthogonal Assessments" )
    or ( "Has Encounter with Initial and Follow Up MLHFQ Assessments" )
    or ( "Has Encounter with Initial and Follow Up KCCQ12 Assessments" )
    or ( "Has Encounter with Initial and Follow Up KCCQ Domain Score Assessments" )
    or ( "Has Encounter with Initial and Follow Up KCCQ Total Score Assessments" )

define "Has Encounter with Initial and Follow Up PROMIS10 Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time PROMIS10 Total Assessment Completed" InitialPROMIS10Time
        with "Time PROMIS10 Total Assessment Completed" FollowupPROMIS10Time
          such that FollowupPROMIS10Time in Interval[date from InitialPROMIS10Time + 30 days, date from InitialPROMIS10Time + 180 days]) PROMIS10Assessments
        such that PROMIS10Assessments 14 days or less on or before
        end of Encounter.period
  ) is not null

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

define "Has Encounter with Initial and Follow Up PROMIS29 Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time PROMIS29 Total Assessment Completed" InitialPROMIS29Time
        with "Time PROMIS29 Total Assessment Completed" FollowupPROMIS29Time
          such that FollowupPROMIS29Time in Interval[date from InitialPROMIS29Time + 30 days, date from InitialPROMIS29Time + 180 days]) PROMIS29Assessments
        such that PROMIS29Assessments 14 days or less on or before
        end of Encounter.period
  ) is not null

define "Time PROMIS29 Total Assessment Completed":
  from
    ["Observation": "PROMIS-29 Sleep disturbance score T-score"] Promis29Sleep,
    ["Observation": "PROMIS-29 Satisfaction with participation in social roles score T-score"] Promis29SocialRoles,
    ["Observation": "PROMIS-29 Physical function score T-score"] Promis29Physical,
    ["Observation": "PROMIS-29 Pain interference score T-score"] Promis29Pain,
    ["Observation": "PROMIS-29 Fatigue score T-score"] Promis29Fatigue,
    ["Observation": "PROMIS-29 Depression score T-score"] Promis29Depression,
    ["Observation": "PROMIS-29 Anxiety score T-score"] Promis29Anxiety
    where Promis29Sleep.status in {'final', 'amended','corrected'}
      and Promis29Sleep.value is not null
      and Global."Normalize Interval"(Promis29Sleep.effective) ends same day as end of Global."Normalize Interval"(Promis29SocialRoles.effective)
      and Promis29SocialRoles.status in {'final', 'amended','corrected'}
      and Promis29SocialRoles.value is not null
      and Global."Normalize Interval"(Promis29Sleep.effective) ends same day as end of Global."Normalize Interval"(Promis29Physical.effective)
      and Promis29Physical.status in {'final', 'amended','corrected'}
      and Promis29Physical.value is not null
      and Global."Normalize Interval"(Promis29Sleep.effective) ends same day as end of Global."Normalize Interval"(Promis29Pain.effective)
      and Promis29Pain.status in {'final', 'amended','corrected'}
      and Promis29Pain.value is not null
      and Global."Normalize Interval"(Promis29Sleep.effective) ends same day as end of Global."Normalize Interval"(Promis29Fatigue.effective)
      and Promis29Fatigue.status in {'final', 'amended','corrected'}
      and Promis29Fatigue.value is not null
      and Global."Normalize Interval"(Promis29Sleep.effective) ends same day as end of Global."Normalize Interval"(Promis29Depression.effective)
      and Promis29Depression.status in {'final', 'amended','corrected'}
      and Promis29Depression.value is not null
      and Global."Normalize Interval"(Promis29Sleep.effective) ends same day as end of Global."Normalize Interval"(Promis29Anxiety.effective)
      and Promis29Anxiety.status in {'final', 'amended','corrected'}
      and Promis29Anxiety.value is not null
    return Max({ Promis29Sleep.effective, Promis29SocialRoles.effective, Promis29Physical.effective, Promis29Pain.effective, Promis29Fatigue.effective, Promis29Depression.effective, Promis29Anxiety.effective })

define "Has Encounter with Initial and Follow Up VR12 Oblique Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time VR12 Oblique Total Assessment Completed" InitialVR12ObliqueTime
        with "Time VR12 Oblique Total Assessment Completed" FollowupVR12ObliqueTime
          such that FollowupVR12ObliqueTime in Interval[date from InitialVR12ObliqueTime + 30 days, date from InitialVR12ObliqueTime + 180 days]) VR12ObliqueAssessments
        such that VR12ObliqueAssessments 14 days or less on or before
        end of Encounter.period
  ) is not null

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


define "Has Encounter with Initial and Follow Up VR12 Orthogonal Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time VR12 Orthogonal Total Assessment Completed" InitialVR12OrthogonalTime
        with "Time VR12 Orthogonal Total Assessment Completed" FollowupVR12OrthogonalTime
          such that FollowupVR12OrthogonalTime in Interval[date from InitialVR12OrthogonalTime + 30 days, date from InitialVR12OrthogonalTime + 180 days]) VR12OrthogonalAssessments
        such that VR12OrthogonalAssessments 14 days or less on or before
        end of Encounter.period
  ) is not null

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

define "Has Encounter with Initial and Follow Up VR36 Oblique Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time VR36 Oblique Total Assessment Completed" InitialVR36ObliqueTime
        with "Time VR36 Oblique Total Assessment Completed" FollowupVR36ObliqueTime
          such that FollowupVR36ObliqueTime in Interval[date from InitialVR36ObliqueTime + 30 days, date from InitialVR36ObliqueTime + 180 days]) VR36ObliqueAssessments
        such that VR36ObliqueAssessments 14 days or less on or before
        end of Encounter.period
  ) is not null

define "Time VR36 Oblique Total Assessment Completed":
  from
    ["Observation": "VR-36 Mental component summary (MCS) score - oblique method T-score"] VR36MentalAssessment,
    ["Observation": "VR-36 Physical component summary (PCS) score - oblique method T-score"] VR36PhysicalAssessment
    where VR36MentalAssessment.status in {'final','amended','corrected'}
       and VR36MentalAssessment.value is not null
       and Global."Normalize Interval"(VR36MentalAssessment.effective) ends same day as end of Global."Normalize Interval"(VR36PhysicalAssessment.effective)
       and VR36PhysicalAssessment.status in {'final','amended','corrected'}
       and VR36PhysicalAssessment.value is not null
    return Max({ VR36MentalAssessment.effective, VR36PhysicalAssessment.effective })

define "Has Encounter with Initial and Follow Up VR36 Orthogonal Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time VR36 Orthogonal Total Assessment Completed" InitialVR36OrthogonalTime
        with "Time VR36 Orthogonal Total Assessment Completed" FollowupVR36OrthogonalTime
          such that FollowupVR36OrthogonalTime in Interval[date from InitialVR36OrthogonalTime + 30 days, date from InitialVR36OrthogonalTime + 180 days]) VR36OrthogonalAssessments
        such that VR36OrthogonalAssessments 14 days or less on or before
        end of Encounter.period
  ) is not null

define "Time VR36 Orthogonal Total Assessment Completed":
  from
    ["Observation": "VR-36 Mental component summary (MCS) score - orthogonal method T-score"] VR36MentalAssessment,
    ["Observation": "VR-36 Physical component summary (PCS) score - orthogonal method T-score"] VR36PhysicalAssessment
    where VR36MentalAssessment.status in {'final','amended','corrected'}
       and VR36MentalAssessment.value is not null
       and Global."Normalize Interval"(VR36MentalAssessment.effective) ends same day as end of Global."Normalize Interval"(VR36PhysicalAssessment.effective)
       and VR36PhysicalAssessment.status in {'final','amended','corrected'}
       and VR36PhysicalAssessment.value is not null
    return Max({ VR36MentalAssessment.effective, VR36PhysicalAssessment.effective })

define "Has Encounter with Initial and Follow Up MLHFQ Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time MLHFQ Total Assessment Completed" InitialMLHFQTime
        with "Time MLHFQ Total Assessment Completed" FollowupMLHFQTime
          such that FollowupMLHFQTime in Interval[date from InitialMLHFQTime + 30 days, date from InitialMLHFQTime + 180 days]) MLHFQAssessments
        such that MLHFQAssessments 14 days or less on or before
        end of Encounter.period
  ) is not null

define "Time MLHFQ Total Assessment Completed":
  from
    ["Observation": "Physical score [MLHFQ]"] MLHFQPhysical,
    ["Observation": "Emotional score [MLHFQ]"] MLHFQEmotional
    where MLHFQPhysical.status in {'final','amended','corrected'}
       and MLHFQPhysical.value is not null
       and Global."Normalize Interval"(MLHFQPhysical.effective) ends same day as end of Global."Normalize Interval"(MLHFQEmotional.effective)
       and MLHFQEmotional.status in {'final','amended','corrected'}
       and MLHFQEmotional.value is not null
    return Max({ MLHFQPhysical.effective, MLHFQEmotional.effective })

define "Has Encounter with Initial and Follow Up KCCQ12 Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time KCCQ12 Total Assessment Completed" InitialKCCQ12Time
        with "Time KCCQ12 Total Assessment Completed" FollowupKCCQ12Time
          such that FollowupKCCQ12Time in Interval[date from InitialKCCQ12Time + 30 days, date from InitialKCCQ12Time + 180 days]) KCCQ12Assessments
        such that KCCQ12Assessments 14 days or less on or before
        end of Encounter.period
  ) is not null

define "Time KCCQ12 Total Assessment Completed":
    from
      ["Observation": "Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]"] KCCQ12Item,
      ["Observation": "Overall summary score [KCCQ-12]"] KCCQ12Summary
      where KCCQ12Item.status in {'final','amended','corrected'}
         and KCCQ12Item.value is not null
         and Global."Normalize Interval"(KCCQ12Item.effective) ends same day as end of Global."Normalize Interval"(KCCQ12Summary.effective)
         and KCCQ12Summary.status in {'final','amended','corrected'}
         and KCCQ12Summary.value is not null
      return Max({ KCCQ12Item.effective, KCCQ12Summary.effective })

define "Has Encounter with Initial and Follow Up KCCQ Domain Score Assessments":
  ( "Initial Encounter" Encounter
      with ( "Time KCCQ Domain Assessment Completed" InitialKCCQAssessmentTime
        with "Time KCCQ Domain Assessment Completed" FollowupKCCQAssessmentTime
          such that FollowupKCCQAssessmentTime in Interval[date from InitialKCCQAssessmentTime + 30 days, date from InitialKCCQAssessmentTime + 180 days]) KCCQAssessments
        such that KCCQAssessments 14 days or less on or before
        end of Encounter.period
  ) is not null

define "Time KCCQ Domain Assessment Completed":
  from
    ["Observation": "Quality of life score [KCCQ]"] KCCQLifeQuality,
    ["Observation": "Symptom stability score [KCCQ]"] KCCQSymptomStability,
    ["Observation": "Self-efficacy score [KCCQ]"] KCCQSelfEfficacy,
    ["Observation": "Total symptom score [KCCQ]"] KCCQSymptoms,
    ["Observation": "Physical limitation score [KCCQ]"] KCCQPhysicalLimits,
    ["Observation": "Social limitation score [KCCQ]"] KCCQSocialLimits
      where KCCQLifeQuality.status in {'final','amended','corrected'}
         and KCCQLifeQuality.value is not null
         and Global."Normalize Interval"(KCCQLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KCCQSymptomStability.effective)
         and KCCQSymptomStability.status in {'final','amended','corrected'}
         and KCCQSymptomStability.value is not null
         and Global."Normalize Interval"(KCCQLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KCCQSelfEfficacy.effective)
         and KCCQSelfEfficacy.status in {'final','amended','corrected'}
         and KCCQSelfEfficacy.value is not null
         and Global."Normalize Interval"(KCCQLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KCCQSymptoms.effective)
         and KCCQSymptoms.status in {'final','amended','corrected'}
         and KCCQSymptoms.value is not null
         and Global."Normalize Interval"(KCCQLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KCCQPhysicalLimits.effective)
         and KCCQPhysicalLimits.status in {'final','amended','corrected'}
         and KCCQPhysicalLimits.value is not null
         and Global."Normalize Interval"(KCCQLifeQuality.effective) ends same day as end of Global."Normalize Interval"(KCCQSocialLimits.effective)
         and KCCQSocialLimits.status in {'final','amended','corrected'}
         and KCCQSocialLimits.value is not null
    return Max({ KCCQLifeQuality.effective, KCCQSymptomStability.effective, KCCQSelfEfficacy.effective, KCCQSymptoms.effective, KCCQPhysicalLimits.effective, KCCQSocialLimits.effective })

define "Has Encounter with Initial and Follow Up KCCQ Total Score Assessments":
  ( "Initial Encounter" Encounter
      with ( "KCCQ Total Assessment Completed" InitialKCCQTotalScore
        with "KCCQ Total Assessment Completed" FollowupKCCQTotalScore
          such that FollowupKCCQTotalScore.relevantDatetime in Interval[date from InitialKCCQTotalScore.relevantDatetime + 30 days, date from InitialKCCQTotalScore.relevantDatetime + 180 days]) KCCQTotalScoreAssessments
        such that KCCQTotalScoreAssessments.relevantDatetime 14 days or less on or before
        end of Encounter.period
  ) is not null

define "KCCQ Total Assessment Completed":
  ["Assessment, Performed": "Overall summary score [KCCQ]"] KCCQSummaryScore
      where KCCQSummaryScore.status in {'final','amended','corrected'}
         and KCCQSummaryScore.value is not null
