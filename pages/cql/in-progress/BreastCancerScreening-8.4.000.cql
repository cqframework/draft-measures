library BreastCancerScreening version '8.4.000'

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0' called FHIRHelpers
include MATGlobalCommonFunctions version '4.0.000' called Global
include Adult_Outpatient_Encounters version '1.2.000' called AdultOutpatientEncounters
include Hospice version '2.0.000' called Hospice
include AdvancedIllnessandFrailtyExclusionECQM version '4.0.000' called FrailtyLTI

codesystem "LOINC": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.6.1'

valueset "Bilateral Mastectomy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "Ethnicity": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Female": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.560.100.2'
valueset "History of bilateral mastectomy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1068'
valueset "Left": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.122.12.1036'
valueset "Mammography": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1018'
valueset "ONC Administrative Sex": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Payer": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Race": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Right": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.122.12.1035'
valueset "Status Post Left Mastectomy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1069'
valueset "Status Post Right Mastectomy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1070'
valueset "Unilateral Mastectomy": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1020'
valueset "Unilateral Mastectomy Left": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1133'
valueset "Unilateral Mastectomy Right": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1134'
valueset "Unilateral Mastectomy, Unspecified Laterality": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1071'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
	Patient.extension extensions
		where extensions.url = 'http://hl7.org/fhir/us/core/StructureDefinition-us-core-ethnicity'
			return extensions.value

define "SDE Payer":
	["Patient Characteristic Payer": "Payer"]

define "SDE Race":
	["Patient Characteristic Race": "Race"]

define "SDE Sex":
	["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator":
	"Initial Population"

// Adding status check to ensure we are dealing with a Procedure, Performed
define "Bilateral Mastectomy Procedure":
	[Procedure: "Bilateral Mastectomy"] BilateralMastectomyPerformed
		where BilateralMastectomyPerformed.performed ends before
		end of "Measurement Period"
			and BilateralMastectomyPerformed.status = 'completed'

define "Numerator":
	exists ( [DiagnosticReport: "Mammography"] Mammogram
			where ( Mammogram.effective ends 27 months or less before day of
				end "Measurement Period"
					and Mammogram.status = 'final'
			)
	)

define "Left Mastectomy Procedure":
	[Procedure: "Unilateral Mastectomy Left"] UnilateralMastectomyLeftPerformed
		where UnilateralMastectomyLeftPerformed.performed ends before
		end of "Measurement Period"
			and UnilateralMastectomyLeftPerformed.status = 'completed'


define "Right Mastectomy Procedure":
	[Procedure: "Unilateral Mastectomy Right"] UnilateralMastectomyRightPerformed
		where UnilateralMastectomyRightPerformed.performed ends before
		end of "Measurement Period"
			and UnilateralMastectomyRightPerformed.status = 'completed'

define "Unilateral Mastectomy Procedure":
	[Procedure: "Unilateral Mastectomy"] UnilateralMastectomy
		where UnilateralMastectomy.performed ends before
		end of "Measurement Period"
			and UnilateralMastectomy.status = 'completed'

define "Bilateral Mastectomy Diagnosis":
	["Diagnosis": "History of bilateral mastectomy"] BilateralMastectomyHistory
		where BilateralMastectomyHistory.prevalencePeriod starts before
		end of "Measurement Period"

define "Left Mastectomy Diagnosis":
	( ["Diagnosis": "Status Post Left Mastectomy"]
		union ( ["Diagnosis": "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
				where UnilateralMastectomyDiagnosis.anatomicalLocationSite in "Left"
		) ) LeftMastectomy
		where LeftMastectomy.prevalencePeriod starts before
		end of "Measurement Period"

define "Right Mastectomy Diagnosis":
	( ["Diagnosis": "Status Post Right Mastectomy"] RightMastectomyProcedure
		union ( ["Diagnosis": "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
				where UnilateralMastectomyDiagnosis.anatomicalLocationSite in "Right"
		) ) RightMastectomy
		where RightMastectomy.prevalencePeriod starts before
		end of "Measurement Period"

define "Initial Population":
	exists ( ["Patient Characteristic Sex": "Female"] )
		and exists ["Patient Characteristic Birthdate": "Birth date"] BirthDate
			where Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")in Interval[51, 74 )
				and exists AdultOutpatientEncounters."Qualifying Encounters"

define "Denominator Exclusions":
	Hospice."Has Hospice"
		or ( Count("Unilateral Mastectomy Procedure")= 2 )
		or ( ( exists ( "Right Mastectomy Diagnosis" )
					or exists ( "Right Mastectomy Procedure" )
			)
				and ( exists ( "Left Mastectomy Diagnosis" )
						or exists ( "Left Mastectomy Procedure" )
				)
		)
		or exists "Bilateral Mastectomy Diagnosis"
		or exists "Bilateral Mastectomy Procedure"
		or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"
		or ( exists ["Patient Characteristic Birthdate": "Birth date"] BirthDate
				where ( Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 65 )
					and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
		)
