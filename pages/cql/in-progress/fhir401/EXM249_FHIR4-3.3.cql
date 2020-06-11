library AppropriateUseofDXAScansinWomenUnder65YearsWhoDoNotMeettheRiskFactorProfileforOsteoporoticFracture version '3.3.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "observation-category": 'http://terminology.hl7.org/CodeSystem/observation-category' //new
codesystem "OMBEthnicityCategories": 'http://hl7.org/fhir/us/core/ValueSet/omb-ethnicity-category'//Could not find a CodeSystem url for this
codesystem "TimingAbbreviation": 'http://hl7.org/fhir/R4/v3/GTSAbbreviation/cs.html'//new

valueset "Ankylosing Spondylitis": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1045'
valueset "Aromatase Inhibitors": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.196.12.1265'
valueset "Average Number of Drinks per Drinking Day": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.106.12.1018'
valueset "BMI Ratio": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.600.1.1490'
valueset "Chronic Liver Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.199.12.1035'
valueset "Chronic Malnutrition": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.199.12.1036'
valueset "Current Tobacco Smoker": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.600.2390'
valueset "Cushings Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.117.12.1009'
valueset "DXA (Dual energy Xray Absorptiometry) Scan": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1051'
valueset "Ehlers Danlos Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1047'
valueset "End Stage Renal Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.526.3.353'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.837'
valueset "Female": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.560.100.2'
valueset "Gastric Bypass Surgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.198.12.1050'
valueset "Glucocorticoids (oral only)": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.196.12.1266'
valueset "History of hip fracture in parent": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1040'
valueset "Hyperparathyroidism": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.117.12.1016'
valueset "Hyperthyroidism": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.117.12.1015'
valueset "Lupus": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.117.12.1010'
valueset "Malabsorption Syndromes": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.199.12.1050'
valueset "Marfan's Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1048'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113762.1.4.1'
valueset "Osteogenesis Imperfecta": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1044'
valueset "Osteopenia": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1049'
valueset "Osteoporosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1038'
valueset "Osteoporotic Fractures": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1050'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services - Other": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1030'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psoriatic Arthritis": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1046'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.114222.4.11.836'
valueset "Rheumatoid Arthritis": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.113.12.1005'
valueset "Tobacco Use Screening": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.526.3.1278'
valueset "Type 1 Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/:oid:2.16.840.1.113883.3.464.1003.103.12.1020'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
//code "Every eight hours (qualifier value)": '307469008' from "SNOMEDCT" display 'Every eight hours (qualifier value)'
//code "Every eight to twelve hours (qualifier value)": '396140003' from "SNOMEDCT" display 'Every eight to twelve hours (qualifier value)'
//code "Every forty eight hours (qualifier value)": '396131002' from "SNOMEDCT" display 'Every forty eight hours (qualifier value)'
//code "Every four hours (qualifier value)": '225756002' from "SNOMEDCT" display 'Every four hours (qualifier value)'
//code "Every seventy two hours (qualifier value)": '396143001' from "SNOMEDCT" display 'Every seventy two hours (qualifier value)'
//code "Every six hours (qualifier value)": '307468000' from "SNOMEDCT" display 'Every six hours (qualifier value)'
//code "Every six to eight hours (qualifier value)": '396139000' from "SNOMEDCT" display 'Every six to eight hours (qualifier value)'
//code "Every thirty six hours (qualifier value)": '396126004' from "SNOMEDCT" display 'Every thirty six hours (qualifier value)'
//code "Every three to four hours (qualifier value)": '225754004' from "SNOMEDCT" display 'Every three to four hours (qualifier value)'
//code "Every three to six hours (qualifier value)": '396127008' from "SNOMEDCT" display 'Every three to six hours (qualifier value)'
//code "Every twelve hours (qualifier value)": '307470009' from "SNOMEDCT" display 'Every twelve hours (qualifier value)'
//code "Every twenty four hours (qualifier value)": '396125000' from "SNOMEDCT" display 'Every twenty four hours (qualifier value)'
//code "Every two to four hours (qualifier value)": '225752000' from "SNOMEDCT" display 'Every two to four hours (qualifier value)'
//code "Four times daily (qualifier value)": '307439001' from "SNOMEDCT" display 'Four times daily (qualifier value)'
code "Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment": '90265-0' from "LOINC" display 'Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment'
//code "Once daily (qualifier value)": '229797004' from "SNOMEDCT" display 'Once daily (qualifier value)'
//code "One to four times a day (qualifier value)": '396109005' from "SNOMEDCT" display 'One to four times a day (qualifier value)'
//code "One to three times a day (qualifier value)": '396108002' from "SNOMEDCT" display 'One to three times a day (qualifier value)'
//code "One to two times a day (qualifier value)": '396107007' from "SNOMEDCT" display 'One to two times a day (qualifier value)'
//code "Three times daily (qualifier value)": '229798009' from "SNOMEDCT" display 'Three times daily (qualifier value)'
//code "Twice a day (qualifier value)": '229799001' from "SNOMEDCT" display 'Twice a day (qualifier value)'
//code "Two to four times a day (qualifier value)": '396111001' from "SNOMEDCT" display 'Two to four times a day (qualifier value)'
code "vital-signs": 'vital-signs' from "observation-category" display 'Vital Signs' //new
code "survey": 'survey' from "observation-category" display 'Survey' //new
code "imaging": 'imaging' from "observation-category" display 'Imaging' //new
code "Non Hispanic or Latino": '2186-5' from "OMBEthnicityCategories" display 'Non Hispanic or Latino'
//timing-abbreviation
code "BID": 'BID' from "TimingAbbreviation" display 'BID'
code "TID": 'TID' from "TimingAbbreviation" display 'TID'
code "QID": 'QID' from "TimingAbbreviation" display 'QID'
code "AM": 'AM' from "TimingAbbreviation" display 'AM'
code "PM": 'PM' from "TimingAbbreviation" display 'PM'
code "QD": 'QD' from "TimingAbbreviation" display 'QD'
code "QOD": 'QOD' from "TimingAbbreviation" display 'QOD'
code "Q1H": 'Q1H' from "TimingAbbreviation" display 'Q1H'
code "Q2H": 'Q2H' from "TimingAbbreviation" display 'Q2H'
code "Q3H": 'Q3H' from "TimingAbbreviation" display 'Q3H'
code "Q4H": 'Q4H' from "TimingAbbreviation" display 'Q4H'
code "Q6H": 'Q6H' from "TimingAbbreviation" display 'Q6H'
code "Q8H": 'Q8H' from "TimingAbbreviation" display 'Q8H'
code "BED": 'BED' from "TimingAbbreviation" display 'BED'
code "WK": 'WK' from "TimingAbbreviation" display 'WK'
code "MO": 'MO' from "TimingAbbreviation" display 'MO'

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

define "Osteopenia Before Measurement Period":
  ["Condition": "Osteopenia"] OsteopeniaDiagnosis
    where OsteopeniaDiagnosis.clinicalStatus in {ToConcept(Global."active"), ToConcept(Global."recurrence"), ToConcept(Global."relapse")}
    and Global."Prevalence Period"(OsteopeniaDiagnosis) starts before start "Measurement Period"

define "Numerator":
  exists ["Observation": "DXA (Dual energy Xray Absorptiometry) Scan"] DXA
    where singleton from (DXA.category) = "imaging"
    and DXA.status in {'resitered', 'final', 'amended', 'corrected'}
    and Global."Normalize Interval"(DXA.effective) during "Measurement Period"

define "Osteoporotic Fracture From Patient History":
   ["Condition": "Osteoporotic Fractures"] PathologicalFracture
      where PathologicalFracture.clinicalStatus in {ToConcept(Global."active"), ToConcept(Global."recurrence"), ToConcept(Global."relapse")}
      and Global."Prevalence Period"(PathologicalFracture) starts before start "Measurement Period"


define "Qualifying Encounter":
  ( ["Encounter": "Office Visit"]
    union ["Encounter": "Preventive Care Services - Established Office Visit, 18 and Up"]
    union ["Encounter": "Preventive Care Services - Other"]
    union ["Encounter": "Preventive Care Services-Initial Office Visit, 18 and Up"]
    union ["Encounter": "Outpatient Consultation"] ) ValidEncounter
    where ValidEncounter.status = 'finished'
    and ValidEncounter.period during "Measurement Period"

define "Combination Risk Factors Applicable Any Time":
  ( ["Condition": "Rheumatoid Arthritis"]
    union ["Condition": "Hyperthyroidism"]
    union ["Condition": "Malabsorption Syndromes"]
    union ["Condition": "Chronic Liver Disease"]
    union ["Condition": "Chronic Malnutrition"] ) CombinationRiskDiagnosis
    where CombinationRiskDiagnosis.clinicalStatus in {ToConcept(Global."active"), ToConcept(Global."recurrence"), ToConcept(Global."relapse")}
    and Global."Prevalence Period"(CombinationRiskDiagnosis) starts before
    end "Measurement Period"

define "Glucocorticoid Medication Active":
  ["MedicationRequest": "Glucocorticoids (oral only)"] Glucocorticoid
    where Glucocorticoid.status in {'active', 'completed'}
    and Glucocorticoid.authoredOn before
    end of "Measurement Period"

define "Has Independent Risk Factors Applicable Any Time":
  exists ( ["Condition": "Type 1 Diabetes"]
    union ["Condition": "End Stage Renal Disease"]
    union ["Condition": "Osteogenesis Imperfecta"]
    union ["Condition": "Ankylosing Spondylitis"]
    union ["Condition": "Psoriatic Arthritis"]
    union ["Condition": "Ehlers Danlos Syndrome"]
    union ["Condition": "Cushings Syndrome"]
    union ["Condition": "Marfan's Syndrome"]
    union ["Condition": "Hyperparathyroidism"]
    union ["Condition": "Lupus"] ) IndependentRiskDiagnosis
    where IndependentRiskDiagnosis.clinicalStatus in {ToConcept(Global."active"), ToConcept(Global."recurrence"), ToConcept(Global."relapse")}
    and Global."Prevalence Period"(IndependentRiskDiagnosis) starts before
    end "Measurement Period"

define "Age Dependent Combination Risk Factors":
  "Combination Risk Factors Applicable Any Time"
    union "Osteoporotic Fracture From Patient History"
    union "Parent History of Hip Fracture Assessment"
    union "Osteopenia Before Measurement Period"
    union "First Tobacco Use Screening Indicating Current Smoker"
    union "First Average Number of Drinks Assessments Indicating More Than Two Per Day"
    union "First BMI in Measurement Period Less Than or Equal to 20 kg m2"
    union ("SDE Ethnicity" Ethnicity
          where Ethnicity = "Non Hispanic or Latino") //Not sure if this is the correct way to do this. Added codesystem and code above.

define "First BMI in Measurement Period Less Than or Equal to 20 kg m2":
  "First BMI in Measurement Period" FirstBMI
    where FirstBMI.value <= 20 'kg/m2'// type of value?

define "Initial Population": //Had to change alias from BirthDate to Patient
  exists ["Patient"] Patient
    where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period" ) in Interval[50, 64 )
      and //exists ( ["Patient Characteristic Sex": "Female"] )
          Patient.gender = 'female'
      and exists "Qualifying Encounter"

define "Denominator Exclusions":
  "Has Age Dependent Combination Risk Factors"
    or "Has Osteoporosis Before Measurement Period"
    or "Has Independent Risk Factors Applicable Any Time"
    or "Has Independent Risk Factors Before Measurement Period"

define "Has Age Dependent Combination Risk Factors":
  singleton from ( ["Patient"] Patient
      let Age: Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period" ),
      NumberOfRiskFactors: Count("Age Dependent Combination Risk Factors")+ ( if "Glucocorticoids Greater Than 5 MG per Day for 90 or More Days" then 1
          else 0
      )
      return ( ( Age between 50 and 54
            and NumberOfRiskFactors >= 4
        )
          or ( Age between 55 and 59
              and NumberOfRiskFactors >= 3
          )
          or ( Age between 60 and 63
              and NumberOfRiskFactors >= 2
          )
      )
  )

define "Glucocorticoids Dosage Per Day":
  ( distinct ( flatten ( "Glucocorticoids Daily Dosage Per Medication" GlucocorticoidsDailyDosage
        return all GlucocorticoidsDailyDosage.daysInPeriod
    )
  ) ) Day
    return {
      medicationDay: Day,
      totalDailyDosage: Sum("Glucocorticoids Daily Dosage Per Medication" GlucocorticoidsDailyDosagePerDay
          where Day in GlucocorticoidsDailyDosagePerDay.daysInPeriod
          return all GlucocorticoidsDailyDosagePerDay.dailyDosage
      )
    }

define "Glucocorticoids Greater Than 5 MG per Day for 90 or More Days":
  Count("Glucocorticoids Dosage Per Day" GlucocorticoidsDosage
      where GlucocorticoidsDosage.totalDailyDosage >= 5 'mg/d'
  )>= 90

define "First Average Number of Drinks Assessments Indicating More Than Two Per Day":
  { First(["Observation": "Average Number of Drinks per Drinking Day"] AverageDrinks
      where Global."Normalize Interval"(AverageDrinks.effective) during "Measurement Period"
        and AverageDrinks.value > 2 '{drinks}/d'
        and AverageDrinks.status in {'final', 'amended'}
      sort by start of Global."Normalize Interval"(effective)
  )}

define "First BMI in Measurement Period": // "Physical Exam, Performed" = "Observation" w/ category = vital-signs? http://hl7.org/fhir/valueset-observation-category.html
  { First(["Observation": "BMI Ratio"] BMI //See if there is a BMI profile**
      where singleton from (BMI.category) = "vital-signs"
        and Global."Normalize Interval"(BMI.effective) during "Measurement Period"
        and BMI.status in {'final', 'amended'}
        and BMI.value is not null //do we have to specify value type here?
      sort by start of Global."Normalize Interval"(effective)
  )}

define "First Tobacco Use Screening Indicating Current Smoker":
  { First(["Observation": "Tobacco Use Screening"] TobaccoScreen
      where TobaccoScreen.value in "Current Tobacco Smoker"
        and Global."Normalize Interval"(TobaccoScreen.effective) during "Measurement Period"
        and TobaccoScreen.status in {'final', 'amended'}
      sort by start of Global."Normalize Interval"(effective)
  )}

define "Parent History of Hip Fracture Assessment":
  ["Observation": "History of hip fracture in parent"] ParentFractureHistory
    where Global."Normalize Interval"(ParentFractureHistory.effective) before start of "Measurement Period"
      and ParentFractureHistory.status in {'final', 'amended'}

define "Osteoporosis Fracture Probability Assessment":
  ["Observation": "Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment"] ProbabilityAssessment
    where ProbabilityAssessment.value >= 8.4 '%'
      and Global."Normalize Interval"(ProbabilityAssessment.effective) before start of "Measurement Period"
       and ProbabilityAssessment.status in {'final', 'amended'}

define "Has Osteoporosis Before Measurement Period":
  exists ["Condition": "Osteoporosis"] OsteoporosisDiagnosis
    where Global."Prevalence Period"(OsteoporosisDiagnosis) overlaps before "Measurement Period"
      and OsteoporosisDiagnosis.clinicalStatus in {ToConcept(Global."active"), ToConcept(Global."recurrence"), ToConcept(Global."relapse")}

define "Glucocorticoids Daily Dosage Per Medication": //Most changes made using guidance from QI Core IG for Medication, Active
  "Glucocorticoid Medication Active" MedicationGlucocorticoid
    let dosesPerDay: "DosesPerDay"(FHIRHelpers.ToCode(singleton from (MedicationGlucocorticoid.dosageInstruction.timing.code.coding))), //"Singleton from" used here because we were getting "list" errors when trying to use functions
    dailyDosage: "GetMedicationDailyDose"((singleton from MedicationGlucocorticoid.dosageInstruction.doseAndRate.rate as FHIR.SimpleQuantity), dosesPerDay),
    medPeriod: singleton from MedicationGlucocorticoid.dosageInstruction.timing.repeat.bounds as Period //From QI Core IG for Medication, Active
      intersect Interval[start of (singleton from MedicationGlucocorticoid.dosageInstruction.timing.repeat.bounds as Period),
      end of "Measurement Period"]
    return Tuple {
      code: MedicationGlucocorticoid.medication as FHIR.CodeableConcept, //Should this be constrained to a CodeableConcept
      daysInPeriod: expand { medPeriod } per day,
      dailyDosage: dailyDosage
    }

define "Has Independent Risk Factors Before Measurement Period":
  exists  (["Procedure": "Gastric Bypass Surgery"] GastricBypass
                  where GastricBypass.status in {'in-progress', 'on-hold', 'completed'}
                  and Global."Normalize Interval"(GastricBypass.performed) starts before start "Measurement Period")
              or exists (["MedicationRequest": "Aromatase Inhibitors"] AromataseOrder
                where AromataseOrder.status in {'active', 'completed'}
                and AromataseOrder.authoredOn before start of "Measurement Period")
        or exists "Osteoporosis Fracture Probability Assessment"


define function "GetMedicationDailyDose"(dosage Quantity, dosesPerDay Decimal):
  dosage * System.Quantity { value: dosesPerDay, unit: '/d' }

define function "DosesPerDay"(frequency System.Code): //Codes replaced with TimingAbbreviation codes
  case
    when frequency ~ "BID" then 2.0
    when frequency ~ "TID" then 3.0
    when frequency ~ "QID" then 4.0
    when frequency ~ "AM" then 1.0
    when frequency ~ "PM" then 1.0
    when frequency ~ "QD" then 1.0
    when frequency ~ "QOD" then 0.5
    when frequency ~ "Q1H" then 24.0
    when frequency ~ "Q2H" then 12.0
    when frequency ~ "Q3H" then 8.0
    when frequency ~ "Q4H" then 6.0
    when frequency ~ "Q6H" then 4.0
    when frequency ~ "Q8H" then 3.0
    when frequency ~ "BED" then 1.0
    when frequency ~ "WK" then 0.143
    when frequency ~ "MO" then 0.033
    else null
  end
