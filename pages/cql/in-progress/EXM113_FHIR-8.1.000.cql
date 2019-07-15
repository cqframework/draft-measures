// for 2020 Reporting Year

library EXM113 version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '3.0.0'
include MATGlobalCommonFunctions version '4.0.000' called Global
include SupplementalDataElements_FHIR version '1.0.0' called SDE


codesystem "LOINC": 'http://loinc.org'

//valueset "Anticoagulant Therapy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.200'


context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
	SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
	SDE."SDE Sex"
