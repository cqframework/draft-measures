library EXM125 version '9.1.000'

/*
Based on CMS125v7 - Breast Cancer Screening
*/

/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include Hospice version '2.0.000' called Hospice
include AdultOutpatientEncounters version '2.0.000' called AdultOutpatientEncounters
include MATGlobalCommonFunctions version '5.0.000' called Global
include SupplementalDataElements version '2.0.0' called SDE
include AdvancedIllnessandFrailtyExclusion version '5.0.000' called AdvancedIllness

valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Bilateral Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "Female": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.560.100.2'
valueset "Mammography": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1018'
valueset "Unilateral Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1020'
valueset "History of bilateral mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1068'
valueset "Status Post Left Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1069'
valueset "Status Post Right Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1070'
valueset "Left": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.122.12.1036'
valueset "Right": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.122.12.1035'
valueset "Unilateral Mastectomy, Unspecified Laterality": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1071'
valueset "Unilateral Mastectomy Right": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1134'
valueset "Unilateral Mastectomy Left": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1133'


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
	Patient.gender = 'female'
			and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") in Interval[51, 74)
			and exists AdultOutpatientEncounters."Qualifying Encounters"

define "Denominator":
		"Initial Population"


define "Denominator Exclusion":
		Hospice."Has Hospice"
				or (( exists "Right Mastectomy Diagnosis" or exists "Right Mastectomy Procedure")
            and (exists "Left Mastectomy Diagnosis" or exists "Left Mastectomy Procedure"))
				or exists "Bilateral Mastectomy Diagnosis"
				or exists "Bilateral Mastectomy Procedure"
        or AdvancedIllness."Advanced Illness and Frailty Exclusion Including Under Age 80"
        or (Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 65
            and AdvancedIllness."Has Spent More Than 90 Days in Long Term Care")

define "Right Mastectomy Diagnosis":
		(
				( [Condition: "Status Post Right Mastectomy"]
          //where C.clinicalStatus ~ ToConcept(Global."active") not needed for exclusion
        )
				union (
						[Condition: "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
								where UnilateralMastectomyDiagnosis.bodySite in "Right"
              //    and UnilateralMastectomyDiagnosis.clinicalStatus ~ ToConcept(Global."active") not needed for exclusion
				)
		) RightMastectomy
				where Global."Normalize Interval"(RightMastectomy.onset) starts on or before end of "Measurement Period"

define "Right Mastectomy Procedure":
        [Procedure: "Unilateral Mastectomy Right"] UnilateralMastectomyRightPerformed
         		where Global."Normalize Interval"(UnilateralMastectomyRightPerformed.performed) ends on or before end of "Measurement Period"
                and UnilateralMastectomyRightPerformed.status = 'completed'

define "Left Mastectomy Procedure":
      [Procedure: "Unilateral Mastectomy Left"] UnilateralMastectomyLeftPerformed
            where Global."Normalize Interval"(UnilateralMastectomyLeftPerformed.performed) ends on or before end of "Measurement Period"
               and UnilateralMastectomyLeftPerformed.status = 'completed'

define "Left Mastectomy Diagnosis":
		(
		    ( [Condition: "Status Post Left Mastectomy"]
        //  where C.clinicalStatus ~ ToConcept(Global."active") not needed for exclusion
        )
				union (
						[Condition: "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
								where UnilateralMastectomyDiagnosis.bodySite in "Left"
                //  and UnilateralMastectomyDiagnosis.clinicalStatus ~ ToConcept(Global."active") not needed for exclusion
				)
		) LeftMastectomy
				where Global."Normalize Interval"(LeftMastectomy.onset) starts on or before end of "Measurement Period"

define "Bilateral Mastectomy Diagnosis":
		[Condition: "History of bilateral mastectomy"] BilateralMastectomyHistory
				where Global."Normalize Interval"(BilateralMastectomyHistory.onset) starts on or before end of "Measurement Period"
    //      and BilateralMastectomyHistory.clinicalStatus ~ ToConcept(Global."active") not needed because it is an exclusion

define "Bilateral Mastectomy Procedure":
		[Procedure: "Bilateral Mastectomy"] BilateralMastectomyPerformed
				where Global."Normalize Interval"(BilateralMastectomyPerformed.performed) ends on or before end of "Measurement Period"
						and BilateralMastectomyPerformed.status = 'completed'

define "Numerator":
		exists (
				[Observation: "Mammography"] Mammogram  // QDM - QI Core mapping guidance advises using Observation for Diagnostic Study, Performed.
						where ( Global."Normalize Interval"(Mammogram.effective) ends 27 months or less on or before end of "Measurement Period" )
								and Mammogram.status in { 'final', 'amended', 'corrected', 'appended' }
		)
