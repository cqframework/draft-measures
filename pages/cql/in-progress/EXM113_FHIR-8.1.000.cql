// for 2020 Reporting Year
//PC01-Elective Delivery
library EXM113 version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0'
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include SupplementalDataElements_FHIR4 version '1.0.0' called SDE



codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
//Yanyan, I added this and it fixed some errors
codesystem "ObservationCategoryCodes":  'http://terminology.hl7.org/CodeSystem/observation-category'


valueset "Artificial Rupture of Membranes": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.57'
valueset "Cesarean Birth":  'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.282'
valueset "Classical Cesarean Birth": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.421'
valueset "Conditions Possibly Justifying Elective Delivery Prior to 39 Weeks Gestation":  'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.286'
valueset "Cornual Ectopic Pregnancy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.12'
valueset "Delivery Procedures": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.59'
valueset "Dinoprostone": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.56'
valueset "Encounter Inpatient": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Estimated Gestational Age at Delivery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.26'
valueset "Labor": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.281'
valueset "Medical Induction of Labor": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.288'
valueset "Metroplasty": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.25'
valueset "Myomectomy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.422'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Oxytocin": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.55'
valueset "Perforation of Uterus": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.14'
valueset "Time of Delivery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.28'
valueset "Transabdominal Cerclage": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.18'
valueset "Uterine Horn": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.24'
valueset "Uterine Rupture": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.16'
valueset "Uterine Window": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.137'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Exam": 'exam' from "ObservationCategoryCodes" display 'Exam'

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
	SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
	SDE."SDE Sex"

//define "Numerator":
//    "Delivery Encounter With Cesarean Birth Without Labor or History of Uterine Surgery"
//      union "Delivery Encounter With Medical Induction While Not In Labor"
define "Numerator":
  "Delivery Encounter With Cesarean Birth Without Labor or History of Uterine Surgery"
    union "Delivery Encounter With Medical Induction While Not In Labor"

//define "Denominator":
//      "Delivery Encounter Near Term"
define "Denominator":
  	"Delivery Encounter Near Term"

//define "Initial Population":
//      "Delivery Encounter with Age Range"
define "Initial Population":
    "Delivery Encounter with Age Range"

//define "Denominator Exclusion":
//  "Delivery Encounter with Justifying Conditions"
define "Denominator Exclusions":
    "Delivery Encounter with Justifying Conditions"

//Yanyan need help here:

//define "Delivery Encounter with Age Range":
//  "Encounter with Age Range" EncounterWithQualifyingAge
//    with ["Procedure, Performed": "Delivery Procedures"] DeliveryProcedure
//      such that DeliveryProcedure.relevantPeriod starts during EncounterWithQualifyingAge.relevantPeriod
define "Delivery Encounter with Age Range":
      "Encounter with Age Range" EncounterWithQualifyingAge
        with ["Procedure": "Delivery Procedures"] DeliveryProcedure
          such that DeliveryProcedure.status = 'completed'
              and DeliveryProcedure.performed as Period starts during EncounterWithQualifyingAge.period
//identified issue for R4 Procedure Performed has multiple datatypes

//define "Encounter with Age Range":
//  Global."Inpatient Encounter" EncounterInpatient
//    with ["Patient Characteristic Birthdate": "Birth date"] BirthDate
//      such that Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of EncounterInpatient.relevantPeriod)>= 8
//        and Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of EncounterInpatient.relevantPeriod)< 65
define "Encounter with Age Range":
            Global."Inpatient Encounter" EncounterInpatient
              with ["Patient"] BirthDate
                such that Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(BirthDate.birthDate), start of EncounterInpatient.period)>= 8
                  and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(BirthDate.birthDate), start of EncounterInpatient.period)< 65

//define "Delivery Encounter Near Term":
//    from
//    "Delivery Encounter with Age Range" QualifyingEncounter,
//    "Last Gestational Age Prior To Or At the Same Time of Delivery" GestationalAge,
//    "Delivery Time" Delivery
//         where Delivery.authorDatetime during QualifyingEncounter.relevantPeriod
//             and GestationalAge.result >= 37 weeks
//             and GestationalAge.result < 39 weeks
//         return QualifyingEncounter
define "Delivery Encounter Near Term":
      from
      "Delivery Encounter with Age Range" QualifyingEncounter,
      "Last Gestational Age Prior To Or At the Same Time of Delivery" GestationalAge,
      "Delivery Time" Delivery
          where Delivery.authorDatetime during QualifyingEncounter.relevantPeriod
              and GestationalAge.result >= 37 weeks
              and GestationalAge.result < 39 weeks
          return QualifyingEncounter

//define "Last Gestational Age Prior To Or At the Same Time of Delivery":
//   Last(["Assessment, Performed": "Estimated Gestational Age at Delivery"] LastGestational
//       with "Delivery Time" Delivery
//             such that LastGestational.authorDatetime 1 day or less before or on Delivery.authorDatetime
//             sort by authorDatetime
//            )
define "Last Gestational Age Prior To Or At the Same Time of Delivery":
      Last(["Observation": "Estimated Gestational Age at Delivery"] LastGestational
          with "Delivery Time" Delivery
                  such that LastGestational.status = 'final'
                  and LastGestational.effective 1 day or less before or on Delivery.effective
          sort by effective
            )

//define "Delivery Time":
//              ["Assessment, Performed": "Time of Delivery"]
define "Delivery Time":
              ["Observation": "Time of Delivery"] DeliveryTime
              where DeliveryTime.status = 'final'
              and DeliveryTime.category C where FHIRHelpers.ToConcept(C) ~ "Exam"


//define "Delivery Encounter With Cesarean Birth Without Labor or History of Uterine Surgery":
//            "Delivery Encounter Near Term" DeliveryEncounter
//                  with "Cesarean Birth While Not in Labor" CSectionNoLabor
//                    such that CSectionNoLabor.relevantPeriod starts during DeliveryEncounter.relevantPeriod
//                  without "History of Uterine Surgery Procedure" PriorUterineProcedure
//                    such that PriorUterineProcedure.relevantPeriod starts before start of DeliveryEncounter.relevantPeriod
//                  without "History of Uterine Surgery Diagnosis" PriorUterineDiagnosis
//                    such that PriorUterineDiagnosis.prevalencePeriod starts before start of DeliveryEncounter.relevantPeriod
  define "Delivery Encounter With Cesarean Birth Without Labor or History of Uterine Surgery":
              "Delivery Encounter Near Term" DeliveryEncounter
                  with "Cesarean Birth While Not in Labor" CSectionNoLabor
                    such that CSectionNoLabor.performed as period starts during DeliveryEncounter.period
                  without "History of Uterine Surgery Procedure" PriorUterineProcedure
                    such that PriorUterineProcedure.performed as period starts before start of DeliveryEncounter.period
                  without "History of Uterine Surgery Diagnosis" PriorUterineDiagnosis
                    such that PriorUterineDiagnosis.onset as period starts before start of DeliveryEncounter.period

//define "Cesarean Birth While Not in Labor":
//    ["Procedure, Performed": "Cesarean Birth"] CSection
//       without "Is In Labor" Labor
//       such that Labor.authorDatetime 24 hours or less before start of CSection.relevantPeriod
define "Cesarean Birth While Not in Labor":
  ["Procedure": "Cesarean Birth"] Csection
  without "Is In Labor" Labor
  //not sure about "issued"
  such that Csection.status = 'completed' and
  FHIRHelpers.ToDateTime(Labor.issued) 24 hours or less before FHIRHelpers.ToDateTime(Csection.performed as dateTime)

//define "Is In Labor":
//  ["Assessment, Performed": "Labor"]
define "Is In Labor":
  ["Observation": "Labor"] Labor
  where Labor.status = 'final'
  and Labor.category C where FHIRHelpers.ToConcept(C) ~ "Exam"

//define "History of Uterine Surgery Procedure":
//  ["Procedure, Performed": "Classical Cesarean Birth"]
//    union ["Procedure, Performed": "Myomectomy"]
//    union ["Procedure, Performed": "Transabdominal Cerclage"]
//    union ["Procedure, Performed": "Metroplasty"]
//    union ["Procedure, Performed": "Uterine Horn"]
define "History of Uterine Surgery Procedure":
  ["Procedure": "Classical Cesarean Birth"]
    union ["Procedure": "Myomectomy"]
    union ["Procedure": "Transabdominal Cerclage"]
    union ["Procedure": "Metroplasty"]
    union ["Procedure": "Uterine Horn"]

//do these conditions need to be constrained to clinical status, verificationstatus, category?
//define "History of Uterine Surgery Diagnosis":
//  ["Diagnosis": "Perforation of Uterus"]
//    union ["Diagnosis": "Uterine Window"]
//    union ["Diagnosis": "Uterine Rupture"]
//    union ["Diagnosis": "Cornual Ectopic Pregnancy"]
define "History of Uterine Surgery Diagnosis":
      ["Condition": "Perforation of Uterus"]
        union ["Condition": "Uterine Window"]
        union ["Condition": "Uterine Rupture"]
        union ["Condition": "Cornual Ectopic Pregnancy"]


//define "Delivery Encounter With Medical Induction While Not In Labor":
//          "Medical Induction Medication Administered While Not In Labor"
//            union "Medical Induction Procedure Performed While Not In Labor"
define "Delivery Encounter With Medical Induction While Not In Labor":
          "Medical Induction Medication Administered While Not In Labor"
            union "Medical Induction Procedure Performed While Not In Labor"

//define "Medical Induction Medication Administered While Not In Labor":
//          from
//            "Delivery Encounter Near Term" DeliveryEncounter,
//            "Medical Induction Medication" InductionMedication,
//            "Is In Labor" Labor
//            where Labor.authorDatetime during DeliveryEncounter.relevantPeriod
//              and InductionMedication.relevantPeriod 24 hours or less before Labor.authorDatetime
//            return DeliveryEncounter
define "Medical Induction Medication Administered While Not In Labor":
            from
            "Delivery Encounter Near Term" DeliveryEncounter,
            "Medical Induction Medication" InductionMedication,
            "Is In Labor" Labor
            where Labor.issued during DeliveryEncounter.period
              and InductionMedication.effective Period 24 hours or less before Labor.issued
            return DeliveryEncounter

//Need additional constraints?
//define "Medical Induction Medication":
//  ["Medication, Administered": "Oxytocin"]
//    union ["Medication, Administered": "Dinoprostone"]
define "Medical Induction Medication":
              ["MedicationAdministration": "Oxytocin"]
                union ["MedicationAdministration": "Dinoprostone"]

//define "Medical Induction Procedure Performed While Not In Labor":
//                from
//                  "Delivery Encounter Near Term" DeliveryEncounter,
//                    "Medical Induction Procedure" InductionProcedure,
//                    "Is In Labor" Labor
//                    where Labor.authorDatetime during DeliveryEncounter.relevantPeriod
//                      and InductionProcedure.relevantPeriod 24 hours or less before Labor.authorDatetime
//                    return DeliveryEncounter
define "Medical Induction Procedure Performed While Not In Labor":
                  from
                    "Delivery Encounter Near Term" DeliveryEncounter,
                    "Medical Induction Procedure" InductionProcedure,
                    "Is In Labor" Labor
                    where Labor.issued during DeliveryEncounter.period
                      and InductionProcedure.performed dateTime 24 hours or less before Labor.issued
                    return DeliveryEncounter

//define "Medical Induction Procedure":
//   ["Procedure, Performed": "Artificial Rupture of Membranes"]
//      union ["Procedure, Performed": "Medical Induction of Labor"]
define "Medical Induction Procedure":
        ["Procedure": "Artificial Rupture of Membranes"]
            union ["Procedure": "Medical Induction of Labor"]

//define "Delivery Encounter with Justifying Conditions":
//         ( "Delivery Encounter Near Term" DeliveryEncounter
//            with ["Diagnosis": "Conditions Possibly Justifying Elective Delivery Prior to 39 Weeks Gestation"] DiagnosisElectiveDelivery
//            such that DiagnosisElectiveDelivery.prevalencePeriod overlaps DeliveryEncounter.relevantPeriod
//             )
//            union ( "Delivery Encounter Near Term" DeliveryEncounter
//            where exists ( DeliveryEncounter.diagnoses EncounterDiagnoses
//            where EncounterDiagnoses in "Conditions Possibly Justifying Elective Delivery Prior to 39 Weeks Gestation"
//                                    )
//                                )
define "Delivery Encounter with Justifying Conditions":
        ( "Delivery Encounter Near Term" DeliveryEncounter
          with ["Condition": "Conditions Possibly Justifying Elective Delivery Prior to 39 Weeks Gestation"] DiagnosisElectiveDelivery
                    such that DiagnosisElectiveDelivery.onset PeriodRange overlaps DeliveryEncounter.period
              )
                union ( "Delivery Encounter Near Term" DeliveryEncounter
                    where exists ( DeliveryEncounter.diagnoses.condition EncounterDiagnoses
                        where EncounterDiagnoses in "Conditions Possibly Justifying Elective Delivery Prior to 39 Weeks Gestation"
                    )
                )
