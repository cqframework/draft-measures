library ChildhoodImmunizationStatus version '9.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "LOINC": 'http://loinc.org'
codesystem "CVX": 'http://www2a.cdc.gov/'

valueset "Anaphylactic Reaction to Common Baker's Yeast": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.199.12.1032'
valueset "Anaphylactic Reaction to DTaP Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.199.12.1031'
valueset "Anaphylactic Reaction to Hepatitis A Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.199.12.1026'
valueset "Anti Hepatitis A IgG Antigen Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1033'
valueset "Anti Hepatitis B Virus Surface Ab": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1073'
valueset "Disorders of the Immune System": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.120.12.1001'
valueset "DTaP Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1214'
valueset "DTaP Vaccine Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1022'
valueset "Encephalopathy due to Childhood Vaccination": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.114.12.1007'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Hepatitis A": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1024'
valueset "Hepatitis A Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1215'
valueset "Hepatitis A Vaccine Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1041'
valueset "Hepatitis B": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1025'
valueset "Hepatitis B Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1216'
valueset "Hepatitis B Vaccine Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1042'
valueset "Hib Vaccine (3 dose schedule)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1083'
valueset "Hib Vaccine (3 dose schedule) Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1084'
valueset "Hib Vaccine (4 dose schedule)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1085'
valueset "Hib Vaccine (4 dose schedule) Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1086'
valueset "HIV": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Inactivated Polio Vaccine (IPV)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1219'
valueset "Inactivated Polio Vaccine (IPV) Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1045'
valueset "Influenza Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1218'
valueset "Influenza Vaccine Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1044'
valueset "Intussusception": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.199.12.1056'
valueset "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1009'
valueset "Measles": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1053'
valueset "Measles Antibody Test (IgG Antibody presence)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1060'
valueset "Measles Antibody Test (IgG Antibody Titer)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1059'
valueset "Measles, Mumps and Rubella (MMR) Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1224'
valueset "Measles, Mumps and Rubella (MMR) Vaccine Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1031'
valueset "Mumps": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1032'
valueset "Mumps Antibody Test (IgG Antibody presence)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1062'
valueset "Mumps Antibody Test (IgG Antibody Titer)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1061'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Pneumococcal Conjugate Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1221'
valueset "Pneumococcal Conjugate Vaccine Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1046'
valueset "Positive Finding": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.121.12.1016'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Rotavirus Vaccine (2 dose schedule) Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1048'
valueset "Rotavirus Vaccine (3 dose schedule)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1223'
valueset "Rotavirus Vaccine (3 dose schedule) Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1047'
valueset "Rubella": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1037'
valueset "Rubella Antibody Test (IgG Antibody presence)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1064'
valueset "Rubella Antibody Test (IgG Antibody Titer)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1063'
valueset "Severe Combined Immunodeficiency": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.120.12.1007'
valueset "Varicella Zoster": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1039'
valueset "Varicella Zoster Antibody Test (IgG Antibody Presence)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1067'
valueset "Varicella Zoster Antibody Test (IgG Antibody Titer)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1066'
valueset "Varicella Zoster Vaccine (VZV)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1170'
valueset "Varicella Zoster Vaccine (VZV) Administered": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1040'

code "Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)": '433621000124101' from "SNOMEDCT" display 'Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)'
code "Anaphylaxis due to Hepatitis B vaccine (disorder)": '428321000124101' from "SNOMEDCT" display 'Anaphylaxis due to Hepatitis B vaccine (disorder)'
code "Anaphylaxis due to rotavirus vaccine (disorder)": '428331000124103' from "SNOMEDCT" display 'Anaphylaxis due to rotavirus vaccine (disorder)'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Influenza virus vaccine adverse reaction (disorder)": '420113004' from "SNOMEDCT" display 'Influenza virus vaccine adverse reaction (disorder)'
code "Neomycin adverse reaction (disorder)": '292927007' from "SNOMEDCT" display 'Neomycin adverse reaction (disorder)'
code "Pneumococcal vaccine adverse reaction (disorder)": '293116002' from "SNOMEDCT" display 'Pneumococcal vaccine adverse reaction (disorder)'
code "Poliomyelitis vaccine adverse reaction (disorder)": '293117006' from "SNOMEDCT" display 'Poliomyelitis vaccine adverse reaction (disorder)'
code "Polymyxin B adverse reaction (disorder)": '292992006' from "SNOMEDCT" display 'Polymyxin B adverse reaction (disorder)'
code "rotavirus, live, monovalent vaccine": '119' from "CVX" display 'rotavirus, live, monovalent vaccine'
code "Streptomycin adverse reaction (disorder)": '292925004' from "SNOMEDCT" display 'Streptomycin adverse reaction (disorder)'

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
  exists (["Patient"] Patient
      where Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") >= 1
        and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), end of "Measurement Period") = 2)
    and exists ("Qualifying Encounter")

define "Qualifying Encounter":
  (["Encounter": "Office Visit"]
    union ["Encounter": "Home Healthcare Services"]
    union ["Encounter": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter": "Preventive Care Services, Initial Office Visit, 0 to 17"]) ValidEncounter
    where ValidEncounter.status in { 'arrived', 'triaged', 'in-progress', 'onleave', 'finished' }
      and ValidEncounter.period during "Measurement Period"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice"

define "Numerator":
  (exists ("Four DTaP Vaccinations")
      or exists ("DTaP Numerator Inclusion Conditions")
  )
    and (exists ("Three Polio Vaccinations")
        or exists ("Polio Numerator Inclusion Conditions")
    )
    and (exists ("One MMR Vaccination")
        or exists ("MMR Numerator Inclusion Conditions")
        or (exists ("Measles Indicators")
            and exists ("Mumps Indicators")
            and exists ("Rubella Indicators")
        )
    )
    and ("Has Appropriate Number of Hib Immunizations"
        or exists ("Hib Numerator Inclusion Conditions")
    )
    and (exists ("Three Hepatitis B Vaccinations")
        or exists ("Hepatitis B Numerator Inclusion Conditions")
    )
    and (exists ("One Chicken Pox Vaccination" )
        or exists ("Varicella Zoster Numerator Inclusion Conditions")
    )
    and (exists ("Four Pneumococcal Conjugate Vaccinations")
        or exists ("Pneumococcal Conjugate Numerator Inclusion Conditions")
    )
    and (exists ("One Hepatitis A Vaccinations")
        or exists ("Hepatitis A Numerator Inclusion Conditions")
    )
    and ("Has Appropriate Number of Rotavirus Immunizations"
        or exists ("Rotavirus Numerator Inclusion Conditions")
    )
    and (exists ("Two Influenza Vaccinations")
        or exists ("Influenza Numerator Inclusion Conditions")
    )

define "Four DTaP Vaccinations":
  from
    "DTaP Immunizations or Procedures" DTaPVaccination1,
    "DTaP Immunizations or Procedures" DTaPVaccination2,
    "DTaP Immunizations or Procedures" DTaPVaccination3,
    "DTaP Immunizations or Procedures" DTaPVaccination4
    where DTaPVaccination2 1 day or more after day of DTaPVaccination1
      and DTaPVaccination3 1 day or more after day of DTaPVaccination2
      and DTaPVaccination4 1 day or more after day of DTaPVaccination3
    return DTaPVaccination1

define "DTaP Immunizations or Procedures":
  ((["Immunization": "DTaP Vaccine"] DTaPImmunization
      where DTaPImmunization.status = 'completed'
        return FHIRHelpers.ToDateTime(DTaPImmunization.occurrence as dateTime))
   union (["Procedure": "DTaP Vaccine Administered"] DTaPProcedure
      where DTaPProcedure.status = 'completed'
        return end of Global."Normalize Interval"(DTaPProcedure.performed))
  ) DTaPVaccination
      where DTaPVaccination during Interval[Patient.birthDate + 42 days, Patient.birthDate + 2 years]

define "DTaP Numerator Inclusion Conditions":
  (["Condition": "Anaphylactic Reaction to DTaP Vaccine"]
    union ["Condition": "Encephalopathy due to Childhood Vaccination"] ) DTaPConditions
    where DTaPConditions.clinicalStatus ~ ToConcept(Global."active")
      and start of Global."Prevalence Period"(DTaPConditions) during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "Three Polio Vaccinations":
  from
    "Polio Immunizations or Procedures" PolioVaccination1,
    "Polio Immunizations or Procedures" PolioVaccination2,
    "Polio Immunizations or Procedures" PolioVaccination3
    where PolioVaccination2 1 day or more after day of PolioVaccination1
      and PolioVaccination3 1 day or more after day of PolioVaccination2
    return PolioVaccination1

define "Polio Immunizations or Procedures":
  ((["Immunization": "Inactivated Polio Vaccine (IPV)"] IPVImmunization
      where IPVImmunization.status = 'completed'
        return FHIRHelpers.ToDateTime(IPVImmunization.occurrence as dateTime))
  union (["Procedure": "Inactivated Polio Vaccine (IPV) Administered"] IPVProcedure
      where IPVProcedure.status = 'completed'
        return end of Global."Normalize Interval"(IPVProcedure.performed))
    ) PolioVaccination
        where PolioVaccination during Interval[Patient.birthDate + 42 days, Patient.birthDate + 2 years]

define "Polio Numerator Inclusion Conditions":
  (["Condition": "Poliomyelitis vaccine adverse reaction (disorder)"]
    union ["Condition": "Streptomycin adverse reaction (disorder)"]
    union ["Condition": "Polymyxin B adverse reaction (disorder)"]
    union ["Condition": "Neomycin adverse reaction (disorder)"]) PolioConditions
    where PolioConditions.clinicalStatus ~ ToConcept(Global."active")
      and start of Global."Prevalence Period"(PolioConditions) during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "One MMR Vaccination":
  ((["Immunization": "Measles, Mumps and Rubella (MMR) Vaccine"] MMRImmunization
      where MMRImmunization.status = 'completed'
        return FHIRHelpers.ToDateTime(MMRImmunization.occurrence as dateTime))
    union (["Procedure": "Measles, Mumps and Rubella (MMR) Vaccine Administered"] MMRProcedure
      where MMRProcedure.status = 'completed'
          return end of Global."Normalize Interval"(MMRProcedure.performed))
    ) MMRVaccination
      where MMRVaccination during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "MMR Numerator Inclusion Conditions":
  (["Condition": "Disorders of the Immune System"]
    union ["Condition": "HIV"]
    union ["Condition": "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue"]
    union ["Condition": "Neomycin adverse reaction (disorder)"]) MMRConditions
    where MMRConditions.clinicalStatus ~ ToConcept(Global."active")
      and start of Global."Prevalence Period"(MMRConditions) during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "Measles Indicators":
  (["Observation": "Measles Antibody Test (IgG Antibody Titer)"] MeaslesTiter
      where MeaslesTiter.value >= 1.10
        and MeaslesTiter.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(MeaslesTiter.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Observation": "Measles Antibody Test (IgG Antibody presence)"] MeaslesIgGPresence
      where MeaslesIgGPresence.value in "Positive Finding"
        and MeaslesIgGPresence.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(MeaslesIgGPresence.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Measles"] MeaslesDiagnosis
      where MeaslesDiagnosis.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalence Period"(MeaslesDiagnosis) during Interval[Patient.birthDate, Patient.birthDate + 2 years])

define "Mumps Indicators":
  (["Observation": "Mumps Antibody Test (IgG Antibody Titer)"] MumpsTiter
      where MumpsTiter.value >= 1.10
        and MumpsTiter.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(MumpsTiter.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Observation": "Mumps Antibody Test (IgG Antibody presence)"] MumpsIgGPresence
      where MumpsIgGPresence.value in "Positive Finding"
        and MumpsIgGPresence.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(MumpsIgGPresence.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Mumps"] MumpsDiagnosis
      where MumpsDiagnosis.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalence Period"(MumpsDiagnosis) during Interval[Patient.birthDate, Patient.birthDate + 2 years])

define "Rubella Indicators":
  (["Observation": "Rubella Antibody Test (IgG Antibody Titer)"] RubellaTiter
      where RubellaTiter.value >= 1.10
        and RubellaTiter.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(RubellaTiter.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Observation": "Rubella Antibody Test (IgG Antibody presence)"] RubellaIgGPresence
      where RubellaIgGPresence.value in "Positive Finding"
        and RubellaIgGPresence.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(RubellaIgGPresence.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Rubella"] RubellaDiagnosis
      where RubellaDiagnosis.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalence Period"(RubellaDiagnosis) during Interval[Patient.birthDate, Patient.birthDate + 2 years])

define "Has Appropriate Number of Hib Immunizations":
  exists ("All Hib Vaccinations" HibImmunization //union of 3 and 4 dose immunizations
  //4 dose test
      let has_4_dose: Count("Hib 4 Dose Immunizations or Procedures")> 0
      where (has_4_dose //if pt had at least one 4 dose code
          and Count(distinct("All Hib Vaccinations" HibVaccinations
                return HibVaccinations
            )
          )>= 4 //pt must have 4 regimens (e.g., 3,3,4,4 or 4,3,4,4)
      )
        or (has_4_dose is false //if pt did not have at least one 4 dose code
            and Count(distinct("All Hib Vaccinations" HibVaccinations
                  return HibVaccinations
              )
            )>= 3 //pt must have 3 regimens of 3 dose codes
        )
  )

define "All Hib Vaccinations":
  "Hib 3 or 4 Dose Immunizations" AllHibDoses1
    without "Hib 3 or 4 Dose Immunizations" AllHibDoses2
      such that AllHibDoses1 less than 1 day before AllHibDoses2

define "Hib 3 or 4 Dose Immunizations":
  "Hib 3 Dose Immunizations or Procedures"
    union "Hib 4 Dose Immunizations or Procedures"

define "Hib 3 Dose Immunizations or Procedures":
  ((["Immunization": "Hib Vaccine (3 dose schedule)"] Hib3Immunization
    where Hib3Immunization.status = 'completed'
      return FHIRHelpers.ToDateTime(Hib3Immunization.occurrence as dateTime))
  union (["Procedure": "Hib Vaccine (3 dose schedule) Administered"] Hib3Procedure
    where Hib3Procedure.status = 'completed'
      return end of Global."Normalize Interval"(Hib3Procedure.performed))
  ) ThreeDoseHib
    where ThreeDoseHib during Interval[Patient.birthDate + 42 days, Patient.birthDate + 2 years]

define "Hib 4 Dose Immunizations or Procedures":
  ((["Immunization": "Hib Vaccine (4 dose schedule)"] Hib4Immunization
    where Hib4Immunization.status = 'completed'
      return FHIRHelpers.ToDateTime(Hib4Immunization.occurrence as dateTime))
  union (["Procedure": "Hib Vaccine (4 dose schedule) Administered"] Hib4Procedure
    where Hib4Procedure.status = 'completed'
      return end of Global."Normalize Interval"(Hib4Procedure.performed))
  ) FourDoseHib
    where FourDoseHib during Interval[Patient.birthDate + 42 days, Patient.birthDate + 2 years]

define "Hib Numerator Inclusion Conditions":
  ["Condition": "Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)"] HibReaction
    where HibReaction.clinicalStatus ~ ToConcept(Global."active")
      and start of Global."Prevalence Period"(HibReaction) during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "Three Hepatitis B Vaccinations":
  from
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination1,
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination2,
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination3
    where HepatitisBVaccination2 1 day or more after day of HepatitisBVaccination1
      and HepatitisBVaccination3 1 day or more after day of HepatitisBVaccination2
    return HepatitisBVaccination1

define "Hepatitis B Immunizations or Procedures":
  ((["Immunization": "Hepatitis B Vaccine"] HepatitisBImmunization
    where HepatitisBImmunization.status = 'completed'
      return FHIRHelpers.ToDateTime(HepatitisBImmunization.occurrence as dateTime))
  union (["Procedure": "Hepatitis B Vaccine Administered"] HepatitisBProcedure
    where HepatitisBProcedure.status = 'completed'
      return end of Global."Normalize Interval"(HepatitisBProcedure.performed))
  ) HepatitisBVaccination
      where HepatitisBVaccination during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "Hepatitis B Numerator Inclusion Conditions":
  (["Observation": "Anti Hepatitis B Virus Surface Ab"] HepatitisBAntigenTest
      where HepatitisBAntigenTest.result in "Positive Finding"
        and HepatitisBAntigenTest.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(HepatitisBAntigenTest.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Anaphylaxis due to Hepatitis B vaccine (disorder)"] HepatitisBReaction
      where HepatitisBReaction.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalence Period"(HepatitisBReaction) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Anaphylactic Reaction to Common Baker's Yeast"] YeastReaction
      where YeastReaction.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalence Period"(YeastReaction) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Hepatitis B"] HepatitisBDiagnosis
      where HepatitisBDiagnosis.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalence Period"(HepatitisBDiagnosis) during Interval[Patient.birthDate, Patient.birthDate + 2 years])

define "One Chicken Pox Vaccination":
  ((["Immunization": "Varicella Zoster Vaccine (VZV)"] ChickenPoxImmunization
    where ChickenPoxImmunization.status = 'completed'
      return FHIRHelpers.ToDateTime(ChickenPoxImmunization.occurrence as dateTime))
  union (["Procedure": "Varicella Zoster Vaccine (VZV) Administered"] ChickenPoxProcedure
    where ChickenPoxProcedure.status = 'completed'
      return start of Global."Normalize Interval"(ChickenPoxProcedure.performed))
  ) ChickenPoxVaccination
  where ChickenPoxVaccination during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "Varicella Zoster Numerator Inclusion Conditions":
  (["Observation": "Varicella Zoster Antibody Test (IgG Antibody Titer)"] ChickenPoxTiter
      where ChickenPoxTiter.result >= 1.10
        and ChickenPoxTiter.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(ChickenPoxTiter.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Observation": "Varicella Zoster Antibody Test (IgG Antibody Presence)"] ChickenPoxIgGPresence
      where ChickenPoxIgGPresence.result in "Positive Finding"
        and ChickenPoxIgGPresence.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(ChickenPoxIgGPresence.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Disorders of the Immune System"] ImmuneDisorder
      where ImmuneDisorder.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(ImmuneDisorder) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "HIV"] HIV
      where HIV.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(HIV) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue"] LymphaticMalignantNeoplasm
      where LymphaticMalignantNeoplasm.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(LymphaticMalignantNeoplasm) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Neomycin adverse reaction (disorder)"] NeomycinReaction
      where NeomycinReaction.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(NeomycinReaction) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Varicella Zoster"] VaricellaZoster
      where VaricellaZoster.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(VaricellaZoster) during Interval[Patient.birthDate, Patient.birthDate + 2 years])

define "Four Pneumococcal Conjugate Vaccinations":
  from
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination1,
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination2,
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination3,
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination4
    where PneumococcalVaccination2 1 day or more after day of PneumococcalVaccination1
      and PneumococcalVaccination3 1 day or more after day of PneumococcalVaccination2
      and PneumococcalVaccination4 1 day or more after day of PneumococcalVaccination3
    return PneumococcalVaccination1

define "Pneumococcal Conjugate Immunizations or Procedures":
  ((["Immunization": "Pneumococcal Conjugate Vaccine"] PneumococcalImmunization
    where PneumococcalImmunization.status = 'completed'
      return FHIRHelpers.ToDateTime(PneumococcalImmunization.occurrence as dateTime))
  union (["Procedure": "Pneumococcal Conjugate Vaccine Administered"] PneumococcalProcedure
    where PneumococcalProcedure.status = 'completed'
      return end of Global."Normalize Interval"(PneumococcalProcedure.performed))
  ) PneumococcalVaccination
      where PneumococcalVaccination during Interval[Patient.birthDate + 42 days, Patient.birthDate + 2 years]

define "Pneumococcal Conjugate Numerator Inclusion Conditions":
  ["Condition": "Pneumococcal vaccine adverse reaction (disorder)"] PneumococcalReaction
    where PneumococcalReaction.clinicalStatus ~ ToConcept(Global."active")
      and start of Global."Prevalance Period"(PneumococcalReaction) during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "One Hepatitis A Vaccinations":
  ((["Immunization": "Hepatitis A Vaccine"] HepatitisAImmunization
    where HepatitisAImmunization.status = 'completed'
      return FHIRHelpers.ToDateTime(HepatitisAImmunization.occurrence as dateTime))
  union (["Procedure": "Hepatitis A Vaccine Administered"] HepatitisAProcedure
    where HepatitisAProcedure.status = 'completed'
      return end of Global."Normalize Interval"(HepatitisAProcedure.performed))
  ) HepatitisAVaccination
    where HepatitisAVaccination during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "Hepatitis A Numerator Inclusion Conditions":
 (["Observation": "Anti Hepatitis A IgG Antigen Test"] HepatitisAAntigenTest
      where HepatitisAAntigenTest.result in "Positive Finding"
        and HepatitisAAntigenTest.status in { 'final', 'amended', 'corrected' }
        and end of Global."Normalize Interval"(HepatitisAAntigenTest.effective) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Anaphylactic Reaction to Hepatitis A Vaccine"] HepatitisAReaction
      where HepatitisAReaction.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(HepatitisAReaction) during Interval[Patient.birthDate, Patient.birthDate + 2 years])
    union (["Condition": "Hepatitis A"] HepatitisADiagnosis
      where HepatitisADiagnosis.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(HepatitisADiagnosis) during Interval[Patient.birthDate, Patient.birthDate + 2 years])

define "Has Appropriate Number of Rotavirus Immunizations":
  exists ("All Rotavirus Vaccinations" RotavirusImmunization
      let has_3_dose: Count("Rotavirus 3 Dose Immunizations or Procedures")> 0
      where (has_3_dose
          and Count(distinct("All Rotavirus Vaccinations" RotavirusVaccinations
                return RotavirusVaccinations
            )
          )>= 3
      )
        or (has_3_dose is false
            and Count(distinct("All Rotavirus Vaccinations" RotavirusVaccinations
                  return RotavirusVaccinations
              )
            )>= 2
        )
  )

define "All Rotavirus Vaccinations":
  "Rotavirus 2 or 3 Dose Immunizations" AllRotavirusDoses1
    without "Rotavirus 2 or 3 Dose Immunizations" AllRotavirusDoses2
      such that AllRotavirusDoses1 less than 1 day before AllRotavirusDoses2

define "Rotavirus 2 or 3 Dose Immunizations":
  "Rotavirus 2 Dose Immunizations or Procedures"
    union "Rotavirus 3 Dose Immunizations or Procedures"

define "Rotavirus 2 Dose Immunizations or Procedures":
  ((["Immunization": "rotavirus, live, monovalent vaccine"] RotavirusLiveImmunization
    where RotavirusLiveImmunization.status = 'completed'
      return FHIRHelpers.ToDateTime(RotavirusLiveImmunization.occurrence as dateTime))
  union (["Procedure": "Rotavirus Vaccine (2 dose schedule) Administered"] Rotavirus2Procedure
    where Rotavirus2Procedure.status = 'completed'
      return end of Global."Normalize Interval"(Rotavirus2Procedure.performed))
  ) TwoDoseRotavirus
      where TwoDoseRotavirus during Interval[Patient.birthDate + 42 days, Patient.birthDate + 2 years]

define "Rotavirus 3 Dose Immunizations or Procedures":
  ((["Immunization": "Rotavirus Vaccine (3 dose schedule)"] Rotavirus3Immunization
    where Rotavirus3Immunization.status = 'completed'
      return FHIRHelpers.ToDateTime(Rotavirus3Immunization.occurrence as dateTime))
  union (["Procedure": "Rotavirus Vaccine (3 dose schedule) Administered"] Rotavirus3Procedure
    where Rotavirus3Procedure.status = 'completed'
      return end of Global."Normalize Interval"(Rotavirus3Procedure.performed))
  ) ThreeDoseRotavirus
      where ThreeDoseRotavirus during Interval[Patient.birthDate + 42 days, Patient.birthDate + 2 years]

define "Rotavirus Numerator Inclusion Conditions":
 (["Condition": "Anaphylaxis due to rotavirus vaccine (disorder)"]
      union ["Condition": "Severe Combined Immunodeficiency"]
      union ["Condition": "Intussusception"]) RotavirusConditions
      where RotavirusConditions.clinicalStatus ~ ToConcept(Global."active")
        and start of Global."Prevalance Period"(RotavirusConditions) during Interval[Patient.birthDate, Patient.birthDate + 2 years]

define "Two Influenza Vaccinations":
  from
    "Influenza Immunizations or Procedures" FluVaccination1,
    "Influenza Immunizations or Procedures" FluVaccination2
    where FluVaccination2 1 day or more after day of FluVaccination1
    return FluVaccination1

define "Influenza Immunizations or Procedures":
  ((["Immunization": "Influenza Vaccine"] InfluenzaImmunization
    where InfluenzaImmunization.status = 'completed'
      return FHIRHelpers.ToDateTime(InfluenzaImmunization.occurrence as dateTime))
  union (["Procedure": "Influenza Vaccine Administered"] InfluenzaProcedure
    where InfluenzaProcedure.status = 'completed'
      return end of Global."Normalize Interval"(InfluenzaProcedure.performed))
  ) InfluenzaAdministration
      where InfluenzaAdministration during Interval[Patient.birthDate + 180 days, Patient.birthDate + 2 years]

define "Influenza Numerator Inclusion Conditions":
  (["Condition": "Influenza virus vaccine adverse reaction (disorder)"]
    union ["Condition": "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue"]
    union ["Condition": "Neomycin adverse reaction (disorder)"]
    union ["Condition": "HIV"]
    union ["Condition": "Disorders of the Immune System"]) InfluenzaConditions
    where InfluenzaConditions.clinicalStatus ~ ToConcept(Global."active")
      and start of Global."Prevalance Period"(InfluenzaConditions) during Interval[Patient.birthDate, Patient.birthDate + 2 years]
