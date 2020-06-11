library PrimaryCariesPreventionasOfferedbyPCPsincludingDentists version '10.2.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include Hospice_FHIR4 version '2.0.000' called Hospice
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Clinical Oral Evaluation": 'urn:oid:2.16.840.1.113883.3.464.1003.125.12.1003'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fluoride Varnish Application for Children": 'urn:oid:2.16.840.1.113883.3.464.1003.125.12.1002'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care - Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care- Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

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

define "Denominator":
  "Initial Population"

define "Qualifying Encounters":
  ( ["Encounter": "Office Visit"]
    union ["Encounter": "Preventive Care - Established Office Visit, 0 to 17"]
    union ["Encounter": "Preventive Care- Initial Office Visit, 0 to 17"]
    union ["Encounter": "Preventive Care Services - Established Office Visit, 18 and Up"]
    union ["Encounter": "Preventive Care Services-Initial Office Visit, 18 and Up"]
    union ["Encounter": "Clinical Oral Evaluation"] ) ValidEncounter
    where Global."Normalize Interval"(ValidEncounter.period) during "Measurement Period"
      and ValidEncounter.status = 'finished'

define "Denominator Exclusions":
  Hospice."Has Hospice"

define "Stratification 2":
  exists ["Patient"] BirthDate
    where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) in Interval[5, 11]

define "Stratification 3":
  exists ["Patient"] BirthDate
    where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) in Interval[12, 20 )

define "Stratification 1":
  exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 6
        and Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) <= 4
  )

define "Initial Population":
  exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 6
        and Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) < 20
  )
    and exists ( "Qualifying Encounters" )

define "Numerator":
  exists  ["Procedure": "Fluoride Varnish Application for Children"] FluorideApplication
      where FluorideApplication.performed during "Measurement Period"
        and FluorideApplication.status = 'completed'
