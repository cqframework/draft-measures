library DocumentationofCurrentMedicationsintheMedicalRecord version '9.1.000'
//This example is based on CMS 68 V9.1.000 Documentation of Current Medications in the Medical Record
//Updated on 12/3 Collaboration call: changed file name, added SDE elements, corrected reference libaries

using FHIR version '3.0.0'
include FHIRHelpers version '3.0.0' called FHIRHelpers

include MATGlobalCommonFunctions_FHIR3 version '4.0.000' called Global
include SupplementalDataElements_FHIR3 version '1.0.0' called SDE

codesystem "LOINC": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.6.96'

valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Medical or Other reason not done": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1.1502'
valueset "Medications Encounter Code Set": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.1.1834'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Documentation of current medications (procedure)": '428191000124101' from "SNOMEDCT" display 'Documentation of current medications (procedure)'

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

define "Medications Not Documented for Medical Reason":
	["Procedure": "Documentation of current medications (procedure)"] DocumentationNotPerformed
		where DocumentationNotPerformed.status = 'completed'
  		//not sure if 'aborted' is appropriate, given that we are looking for a procedure //
  		//to not be performed, therefore not even started. looking for recommendations//
      //will need to use extension for not performed. Not available yet
      //ESAC team, would you mind showing us where to add the extension  (http://hl7.org/fhir/us/qicore/StructureDefinition/notDone').value in the logic?
      and DocumentationNotPerformed.notDone is true
  		and DocumentationNotPerformed.notDoneReason in "Medical or Other reason not done"

define "Medications Not Documented for Medical Reason - R4":
	["Procedure": "Documentation of current medications (procedure)"] DocumentationNotPerformed
		where DocumentationNotPerformed.status = 'not-done'
      and DocumentationNotPerformed.statusReason in "Medical or Other reason not done"
  		//not sure if 'aborted' is appropriate, given that we are looking for a procedure //
  		//to not be performed, therefore not even started. looking for recommendations//
      //will need to use extension for not performed. Not available yet
      //ESAC team, would you mind showing us where to add the extension  (http://hl7.org/fhir/us/qicore/StructureDefinition/notDone').value in the logic?
      //and DocumentationNotPerformed.notDone is true
  		//and DocumentationNotPerformed.notDoneReason in "Medical or Other reason not done"

/*
In STU3, the Procedure resource has a notDone element, this should be used in STU3.
In R4, the Procedure resource has a status of not-done, and you would use the statusReason as the "not done reason"
*/

define "Denominator Exceptions":
	"Qualifying Encounters During Measurement Period" EncounterDuringMeasurementPeriod
		with "Medications Not Documented for Medical Reason" MedicationsNotDocumented
      such that Global.GetExtension(MedicationsNotDocumented, 'qicore-recorded').value during EncounterDuringMeasurementPeriod.period
			//such that MedicationsNotDocumented.FHIR.provenance.recorded during EncounterDuringMeasurementPeriod.period
  			//unsure what attribute should be used to incorporate timing of negation to reflect it occurred during the Encoutner.
  			//FHIR.provenance.recorded is what's listed in the table on http://hl7.org/fhir/us/qicore/Procedure.html//

/*
In STU3, there is no base element to establish when the procedure not done was documented.
In R4, the extension qicore-recorded is introduced and used on the QICoreProcedureNotDone profile.
This extension would need to be added for STU3 if we need to support this.
The alternative is to use the FHIR Provenance, but that would look like:
Global.GetProvenance(MedicationsNotDocumented).recorded
*/

define "Medications Documented During Qualifying Encounter":
	"Qualifying Encounters During Measurement Period" QualifyingEncounterDuringMeasurementPeriod
		with ["Procedure": "Documentation of current medications (procedure)"] MedicationsDocumented
			such that MedicationsDocumented.performed during QualifyingEncounterDuringMeasurementPeriod.period
			and MedicationsDocumented.status = 'completed'

define "Numerator":
	"Medications Documented During Qualifying Encounter"

define "Initial Population":
	"Qualifying Encounters During Measurement Period" QualifyingEncounter
		where Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 18

define "Qualifying Encounters During Measurement Period":
	["Encounter": "Medications Encounter Code Set"] QualifyingEncounter
		where QualifyingEncounter.period during "Measurement Period"
		and QualifyingEncounter.status = 'finished'
