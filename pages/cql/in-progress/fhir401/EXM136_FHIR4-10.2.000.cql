library EXM136_FHIR4 version '10.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include Hospice_FHIR4 version '2.0.000' called Hospice
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'
codesystem "CPT": 'http://www.ama-assn.org/go/cpt'

valueset "ADHD Medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1171'
valueset "Ambulatory": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.122.12.1003'
valueset "Behavioral Health Follow-up Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1054'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hospital Observation Care - Initial": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Mental Health Diagnoses": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1004'
valueset "Narcolepsy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.114.12.1011'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Group Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Psych Visit - Diagnostic Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1496'
valueset "Psychotherapy and Pharmacologic Management": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1055'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Substance Abuse": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.106.12.1004'
valueset "Telehealth Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1031'
valueset "Telephone Management": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1053'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])": '99217' from "CPT" display 'Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital "observation status" if the discharge is on other than the initial date of "observation status." To report services to a patient designated as "observation status" or "inpatient status" and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])'

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

define "Initial Population 1":
Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") in Interval[6,12]
        and exists ( "Qualifying Encounter" )
        and "First ADHD Medication Dispensed" is not null

define "Qualifying Encounter":
(["Encounter": "Office Visit"]
    union ["Encounter": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter": "Home Healthcare Services"]) ValidEncounter
    		where ValidEncounter.period during "Measurement Period"
            		and ValidEncounter.status  = 'finished'

define "First ADHD Medication Dispensed":
First(["MedicationDispense": "ADHD Medications"] FirstADHDMedication
  where FirstADHDMedication.status in {'active','completed'}
        and FirstADHDMedication.whenHandedOver 60 days or less after start "Measurement Period"
                  or FirstADHDMedication.whenHandedOver 90 days or less on or before start of "Measurement Period"
                  return FirstADHDMedication.whenHandedOver
            sort asc
)

define "Denominator 1":
  "Initial Population 1"

define "Denominator Exclusions 1":
Hospice."Has Hospice"
      or exists ( "Narcolepsy Exclusion" )
      or exists ( "Inpatient Stay with Qualifying Diagnosis within 30 Days of Initial ADHD Dispense" )
      or exists ( "Previously on ADHD Medication Exclusion" )

define "Narcolepsy Exclusion":
["Condition": "Narcolepsy"] Narcolepsy
    where Narcolepsy.clinicalStatus ~ ToConcept(Global."active")
    and Global."Prevalence Period"(Narcolepsy) starts before end "Measurement Period"
//category??

define "Inpatient Stay with Qualifying Diagnosis within 30 Days of Initial ADHD Dispense":
"Inpatient Stay with Qualifying Diagnosis" InpatientStay
    with "First ADHD Medication Dispensed" InitialADHDMedication
      such that InpatientStay.period starts 30 days or less on or after InitialADHDMedication

define "Inpatient Stay with Qualifying Diagnosis":
["Encounter": "Encounter Inpatient"] InpatientStay
    where InpatientStay.status = 'finished'
and Global."EncounterDiagnosis"(InpatientStay).code in "Substance Abuse"
or Global."EncounterDiagnosis"(InpatientStay).code in "Mental Health Diagnoses"
    //and ((Global."PrincipalDiagnosis"(InpatientStay).code in "Mental Health Diagnoses")
    //  or (Global."PrincipalDiagnosis"(InpatientStay).code in "Substance Abuse"))

define "Previously on ADHD Medication Exclusion":
["MedicationRequest": "ADHD Medications"] ActiveADHDMedication
    with "First ADHD Medication Dispensed" InitialADHDMedication
      such that ActiveADHDMedication.authoredOn 120 days or less before InitialADHDMedication
        and ActiveADHDMedication.status = 'active'
        and ActiveADHDMedication.intent = 'order'

define "Numerator 1":
exists ( "Encounter 30 Days after Initial ADHD Medication" )

define "Encounter 30 Days after Initial ADHD Medication":
  ( "Qualifying Numerator Encounter" ValidNumeratorEncounter
      with "First ADHD Medication Dispensed" InitialADHDMedication
        such that ValidNumeratorEncounter.period starts 30 days or less on or after InitialADHDMedication
  )

define "Qualifying Numerator Encounter":
((["Encounter": "Office Visit"]
        union ["Encounter": "Hospital Observation Care - Initial"]
        union ["Encounter": "Preventive Care Services - Group Counseling"]
        union ["Encounter": "Behavioral Health Follow-up Visit"]
        union ["Encounter": "Preventive Care Services-Individual Counseling"]
        union ( ["Encounter": "Psychotherapy and Pharmacologic Management"] PsychPharmMgmt
            where exists (PsychPharmMgmt.location Location
              where Global.GetLocation(Location.location).type in "Ambulatory"
            )
        )
        union ["Encounter": "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])"]
        union ["Encounter": "Outpatient Consultation"]
        union ["Encounter": "Home Healthcare Services"]
        union ["Encounter": "Preventive Care Services, Initial Office Visit, 0 to 17"]
        union ["Encounter": "Preventive Care, Established Office Visit, 0 to 17"]
        union ["Encounter": "Psych Visit - Diagnostic Evaluation"]
        union ["Encounter": "Psych Visit - Psychotherapy"]) NumEncounters
        where NumEncounters.status = 'finished'
    )

define "Initial Population 2":
Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") in Interval[6,12]
          and exists ( "Qualifying Encounter" )
          and "First ADHD Medication Dispensed" is not null
          and "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days"

define "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days":
"CumulativeMedicationDuration"("ADHD Medications Taken within 300 Days after First ADHD Medication Dispensed")>= 210

define "ADHD Medications Taken within 300 Days after First ADHD Medication Dispensed":
exists ["MedicationRequest": "ADHD Medications"] ActiveADHDMedications
    with "First ADHD Medication Dispensed" InitialADHDMedication
      such that ActiveADHDMedications.authoredOn 300 days or less on or after day of InitialADHDMedication
    and ActiveADHDMedications.status ='completed'


define "Denominator 2":
"Initial Population 2"

define "Denominator Exclusions 2":
Hospice."Has Hospice"
    or exists ( "Narcolepsy Exclusion" )
    or exists ( "Inpatient Stay with Qualifying Diagnosis within 300 Days of Initial ADHD Dispense" )
    or exists ( "Previously on ADHD Medication Exclusion" )

define "Inpatient Stay with Qualifying Diagnosis within 300 Days of Initial ADHD Dispense":
"Inpatient Stay with Qualifying Diagnosis" InpatientStay
    with "First ADHD Medication Dispensed" InitialADHDMedication
      such that InpatientStay.period starts 300 days or less on or after day of InitialADHDMedication

define "Numerator 2":
exists ( "Encounter 30 Days after Initial ADHD Medication" )
        and ( ( "Two or More Followup Encounters" )
            or ( exists ( "Encounters 300 Days after Initial ADHD Medication" )
                and exists ( "Telehealth Services or Telephone Management Encounter" ))
    )

define "Two or More Followup Encounters":
Count("Encounters 300 Days after Initial ADHD Medication")>= 2

define "Encounters 300 Days after Initial ADHD Medication":
"Qualifying Numerator Encounter" ValidNumeratorEncounter
  with "First ADHD Medication Dispensed" InitialADHDMedication
    such that start of ValidNumeratorEncounter.period in day of Interval[InitialADHDMedication + 31 days, InitialADHDMedication + 300 days]

define "Telehealth Services or Telephone Management Encounter":
( ["Encounter": "Telehealth Services"]
      union ["Encounter": "Telephone Management"] ) TelehealthEncounter
        with "First ADHD Medication Dispensed" InitialADHDMedication
          such that TelehealthEncounter.period starts 31 days or more after day of InitialADHDMedication
            and TelehealthEncounter.period starts 300 days or less after day of InitialADHDMedication
            and TelehealthEncounter.status = 'finished'


define function "CumulativeMedicationDuration"(Medication Choice<FHIR.MedicationRequest, FHIR.MedicationDispense>):
  if Medication is FHIR.MedicationRequest then
  CumulativeDuration(((Medication as FHIR.MedicationRequest).dosageInstruction.timing) T return T.repeat.bounds as Period)
  else if Medication is FHIR.MedicationDispense then
  CumulativeDuration(((Medication as FHIR.MedicationDispense).dosageInstruction.timing) T return T.repeat.bounds as Period)
	else null as Integer

define function "CumulativeDuration"(Intervals List<Interval<DateTime>>):
Sum((collapse Intervals) X return all duration in days of X)
