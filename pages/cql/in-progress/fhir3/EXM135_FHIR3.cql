library EXM135_FHIR3 version '8.0.000'

using FHIR version '3.0.0'
//This measure is based on CMS135 v8.0.000 Heart Failure (HF): Angiotensin-Converting Enzyme (ACE) Inhibitor or Angiotensin Receptor Blocker (ARB) or Angiotensin Receptor-Neprilysin Inhibitor (ARNI) Therapy for Left Ventricular Systolic Dysfunction (LVSD)

include MATGlobalCommonFunctions_FHIR3 version '4.0.000' called Global
include FHIRHelpers version '3.0.0' called FHIRHelpers
include SupplementalDataElements_FHIR3 version '1.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

valueset "ACE Inhibitor or ARB": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1139'
valueset "ACE Inhibitor or ARB Ingredient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1489'
valueset "Allergy to ACE Inhibitor or ARB": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1211'
valueset "Care Services in Long-Term Residential Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services - Hospital Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1007'
valueset "Ejection Fraction": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1134'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Heart Failure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.376'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Intolerance to ACE Inhibitor or ARB": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1212'
valueset "Left Ventricular Systolic Dysfunction": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1091'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1007'
valueset "Moderate or Severe": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1092'
valueset "Moderate or Severe LVSD": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1090'
valueset "Nursing Facility Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1008'
valueset "Patient Reason for ACE Inhibitor or ARB Decline": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1140'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Renal Failure Due to ACE Inhibitor": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1151'
valueset "System Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1009'

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

define "Face to Face Encounter During Measurement Period":
	( ["Encounter": "Care Services in Long-Term Residential Facility"]
		union ["Encounter": "Home Healthcare Services"]
		union ["Encounter": "Nursing Facility Visit"]
		union ["Encounter": "Office Visit"]
		union ["Encounter": "Outpatient Consultation"] ) FaceToFaceEncounter
		where FaceToFaceEncounter.period during "Measurement Period"
		and FaceToFaceEncounter.status = 'finished'

define "Inpatient Discharge During Measurement Period":
	["Encounter": "Discharge Services - Hospital Inpatient"] InpatientEncounter
	where InpatientEncounter.period during "Measurement Period"
	and InpatientEncounter.status = 'finished'

// PCPI to ESAC: For "Condition" that uses "overlaps" "overlaps after" and "overlaps before", should we use both onset and abatement?
define "Heart Failure Inpatient Encounter":
	"Inpatient Discharge During Measurement Period" InpatientEncounter
		with ["Condition": "Heart Failure"] HeartFailure
		  such that Global.GetPrevalencePeriod(HeartFailure) overlaps InpatientEncounter.period
			//such that HeartFailure.onset overlaps InpatientEncounter.period
			and HeartFailure.clinicalStatus = 'active'
			and HeartFailure.verificationStatus = 'confirmed'

/*
OnSet for QICoreCondition (STU3) is specified as a choice of:
* dateTime
* Age
* Period
* Range
Abatement is specified as a choice of:
* date
* Age
* boolean
* Period
* Range

See Normalize Onset, Normalize Abatement, and GetPrevalencePeriod in the GlobalCommonFunctions library for more
*/

define "Heart Failure Outpatient Encounter with Moderate or Severe LVSD":
	"Heart Failure Outpatient Encounter" HFOutpatientEncounter
		with "Moderate or Severe LVSD Findings" OutpatientLVSDFindings
		  such that Global.GetPrevalencePeriod(OutpatientLVSDFindings) starts before end of HFOutpatientEncounter.period
			//such that OutpatientLVSDFindings.onset before
			//end of HFOutpatientEncounter.period
				or OutpatientLVSDFindings.effective starts before
				end of HFOutpatientEncounter.period

define "Diagnosis of Pregnancy Outpatient":
	["Condition": "Pregnancy"] Pregnancy
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
		  such that Global.GetPrevalencePeriod(Pregnancy) overlaps ModerateOrSevereLVSDHFOutpatientEncounter.period
			//such that Pregnancy.onset overlaps ModerateOrSevereLVSDHFOutpatientEncounter.period
			and Pregnancy.clinicalStatus = 'active'
			and Pregnancy.verificationStatus = 'confirmed'

define "Diagnosis of Pregnancy Inpatient":
	["Condition": "Pregnancy"] Pregnancy
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that Global.GetPrevalencePeriod(Pregnancy) overlaps ModerateOrSevereLVSDHFInpatientEncounter.period
			//such that Pregnancy.onset overlaps ModerateOrSevereLVSDHFInpatientEncounter.period
			and Pregnancy.clinicalStatus = 'active'
			and Pregnancy.verificationStatus = 'confirmed'

define "Heart Failure Inpatient Encounter with Moderate or Severe LVSD":
	"Heart Failure Inpatient Encounter" HFInpatientEncounter
		with "Moderate or Severe LVSD Findings" InpatientLVSDFindings
		  such that Global.GetPrevalencePeriod(InpatientLVSDFindings) starts before end of HFInpatientEncounter.period
			//such that InpatientLVSDFindings.onset before
			//end of HFInpatientEncounter.period
				or InpatientLVSDFindings.effective starts before
				end of HFInpatientEncounter.period

define "Denominator 1":
	"Initial Population 1"
		and exists "Heart Failure Outpatient Encounter with Moderate or Severe LVSD"

define "Denominator 2":
	"Initial Population 2"
		and exists "Heart Failure Inpatient Encounter with Moderate or Severe LVSD"

define "Qualifying Encounter":
	( ["Encounter": "Office Visit"]
		union ["Encounter": "Outpatient Consultation"]
		union ["Encounter": "Nursing Facility Visit"]
		union ["Encounter": "Care Services in Long-Term Residential Facility"]
		union ["Encounter": "Home Healthcare Services"]
		union ["Encounter": "Patient Provider Interaction"] ) ValidEncounter
		where ValidEncounter.period during "Measurement Period"
		and ValidEncounter.status = 'finished'

define "Moderate or Severe LVSD Findings":
	( ["Observation": "Ejection Fraction"] EjectionFraction
			where EjectionFraction.status = 'final'
			and EjectionFraction.value < 40 '%')
		union (["Condition": "Moderate or Severe LVSD"] ModerateOrSevereLVSD
			where ModerateOrSevereLVSD.clinicalStatus = 'active'
			and  ModerateOrSevereLVSD.verificationStatus = 'confirmed' )
		union ( ["Condition": "Left Ventricular Systolic Dysfunction"] LVSD
				where LVSD.severity in "Moderate or Severe"
				and LVSD.clinicalStatus = 'active'
				and LVSD.verificationStatus = 'confirmed' )

define "ACEI or ARB or ARNI at Inpatient Discharge":
	["MedicationRequest": "ACE Inhibitor or ARB"] ACEIOrARBOrARNIAtDischarge
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that ACEIOrARBOrARNIAtDischarge.authoredOn during ModerateOrSevereLVSDHFInpatientEncounter.period
			// NOTE: Why not just put this in as a value set filter in the retrieve?
			//and (ACEIOrARBOrARNIAtDischarge.medication as CodeableConcept) in "ACE Inhibitor or ARB"
			and ACEIOrARBOrARNIAtDischarge.status = 'active'
			and ACEIOrARBOrARNIAtDischarge.intent = 'plan'

define "Allergy or Intolerance to ACEI or ARB or ARNI Ingredient Inpatient":
	["AllergyIntolerance": code in "ACE Inhibitor or ARB Ingredient"] ACEIOrARBOrARNIAllergyIntolerance
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that ACEIOrARBOrARNIAllergyIntolerance.onset overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period
			// NOTE: Why not just put this in as a value set filter in the retrieve?
			// NOTE: Category is a required binding to { food | medication | environment | biologic }
			// so this should really be "code", not "category", and category should be restricted here
			// based on intent, unless it's implied by the code restriction already, which appears to be the case
			//and ACEIOrARBOrARNIAllergyIntolerance.category in "ACE Inhibitor or ARB Ingredient"
			and ACEIOrARBOrARNIAllergyIntolerance.clinicalStatus = 'active'
			and ACEIOrARBOrARNIAllergyIntolerance.verificationStatus in {'confirmed', 'unconfirmed'}
			and ACEIOrARBOrARNIAllergyIntolerance.type in {'allergy', 'intolerance'}
			and ACEIOrARBOrARNIAllergyIntolerance.criticality in {'low', 'high', 'unable-to-assess'}

define "Currently Taking ACEI or ARB or ARNI Inpatient":
	["MedicationStatement": "ACE Inhibitor or ARB"] ActiveACEIOrARBOrARNI
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that ActiveACEIOrARBOrARNI.effective overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period
			// NOTE: Moved to retrieve
      //and (ActiveACEIOrARBOrARNI.medication as CodeableConcept) in "ACE Inhibitor or ARB"
			and ActiveACEIOrARBOrARNI.status = 'active'
      and ActiveACEIOrARBOrARNI.taken = 'y'

define "Currently Taking ACEI or ARB or ARNI Outpatient":
	["MedicationStatement": "ACE Inhibitor or ARB"] ActiveACEIOrARBOrARNI
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that ActiveACEIOrARBOrARNI.effective overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period
			// NOTE: Moved to retrieve
			//and (ActiveACEIOrARBOrARNI.medication as CodeableConcept) in "ACE Inhibitor or ARB"
			and ActiveACEIOrARBOrARNI.status = 'active'
			and ActiveACEIOrARBOrARNI.taken = 'y'

define "Diagnosis of Allergy to ACEI or ARB Outpatient":
	["Condition": "Allergy to ACE Inhibitor or ARB"] ACEIOrARBAllergyDiagnosis
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
		  // NOTE: Propose the use of GetPrevalencePeriod...
			such that Global.GetPrevalencePeriod(ACEIOrARBAllergyDiagnosis) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period
			//such that ACEIOrARBAllergyDiagnosis.onset overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period
			and ACEIOrARBAllergyDiagnosis.clinicalStatus = 'active'
			and ACEIOrARBAllergyDiagnosis.verificationStatus = 'confirmed'

define "Diagnosis of Allergy to ACEI or ARB Inpatient":
	["Condition": "Allergy to ACE Inhibitor or ARB"] ACEIOrARBAllergyDiagnosis
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
      such that Global.GetPrevalencePeriod(ACEIOrARBAllergyDiagnosis) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period
			//such that ACEIOrARBAllergyDiagnosis.onset overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period
			and ACEIOrARBAllergyDiagnosis.clinicalStatus = 'active'
			and ACEIOrARBAllergyDiagnosis.verificationStatus = 'confirmed'

define "Diagnosis of Intolerance to ACEI or ARB Inpatient":
	["Condition": "Intolerance to ACE Inhibitor or ARB"] ACEIOrARBIntoleranceDiagnosis
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that Global.GetPrevalencePeriod(ACEIOrARBIntoleranceDiagnosis) overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period
			//such that ACEIOrARBIntoleranceDiagnosis.onset overlaps after ModerateOrSevereLVSDHFInpatientEncounter.period
			and ACEIOrARBIntoleranceDiagnosis.clinicalStatus = 'active'
			and ACEIOrARBIntoleranceDiagnosis.verificationStatus = 'confirmed'

define "Diagnosis of Intolerance to ACEI or ARB Outpatient":
	["Condition": "Intolerance to ACE Inhibitor or ARB"] ACEIOrARBIntoleranceDiagnosis
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Global.GetPrevalencePeriod(ACEIOrARBIntoleranceDiagnosis) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period
			//such that ACEIOrARBIntoleranceDiagnosis.onset overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period
			and ACEIOrARBIntoleranceDiagnosis.clinicalStatus = 'active'
			and ACEIOrARBIntoleranceDiagnosis.verificationStatus = 'confirmed'

define "Diagnosis of Renal Failure Due to ACEI Inpatient":
	["Condition": "Renal Failure Due to ACE Inhibitor"] RenalFailureDueToACEI
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that Global.GetPrevalencePeriod(RenalFailureDueToACEI) overlaps ModerateOrSevereLVSDHFInpatientEncounter.period
			//such that RenalFailureDueToACEI.onset overlaps ModerateOrSevereLVSDHFInpatientEncounter.period
			and RenalFailureDueToACEI.clinicalStatus = 'active'
			and RenalFailureDueToACEI.verificationStatus = 'confirmed'

define "Diagnosis of Renal Failure Due to ACEI Outpatient":
	["Condition": "Renal Failure Due to ACE Inhibitor"] RenalFailureDueToACEI
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that Global.GetPrevalencePeriod(RenalFailureDueToACEI) overlaps ModerateOrSevereLVSDHFOutpatientEncounter.period
			//such that RenalFailureDueToACEI.onset overlaps ModerateOrSevereLVSDHFOutpatientEncounter.period
			and RenalFailureDueToACEI.clinicalStatus = 'active'
			and RenalFailureDueToACEI.verificationStatus = 'confirmed'

define "Heart Failure Outpatient Encounter":
	"Face to Face Encounter During Measurement Period" ValidFaceToFaceEncounter
		with ["Condition": "Heart Failure"] HeartFailure
		such that HeartFailure.clinicalStatus = 'active'
		and HeartFailure.verificationStatus = 'confirmed'
		and Global.GetPrevalencePeriod(HeartFailure) overlaps ValidFaceToFaceEncounter.period
		//and HeartFailure.onset overlaps ValidFaceToFaceEncounter.period

define "ACEI or ARB or ARNI Ordered Outpatient":
	["MedicationRequest": "ACE Inhibitor or ARB"] ACEIOrARBOrARNIOrdered
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that ACEIOrARBOrARNIOrdered.authoredOn during ModerateOrSevereLVSDHFOutpatientEncounter.period
			// NOTE: Moved to retrieve
	    //and (ACEIOrARBOrARNIOrdered.medication as CodeableConcept) in "ACE Inhibitor or ARB"
			and ACEIOrARBOrARNIOrdered.intent = 'order'
			and ACEIOrARBOrARNIOrdered.status in {'active', 'completed'}

define "Numerator 1":
	exists "ACEI or ARB or ARNI Ordered Outpatient"
		or exists "Currently Taking ACEI or ARB or ARNI Outpatient"

define "Allergy or Intolerance to ACEI or ARB or ARNI Ingredient Outpatient":
	["AllergyIntolerance": code in "ACE Inhibitor or ARB Ingredient"] ACEIOrARBOrARNIAllergyIntolerance
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
      such that Global."Normalize Onset"(ACEIOrARBOrARNIAllergyIntolerance.onset) overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period
			//such that ACEIOrARBOrARNIAllergyIntolerance.onset overlaps after ModerateOrSevereLVSDHFOutpatientEncounter.period
			// NOTE: Should be "code" not "category"
			// NOTE: "category" should be specified { food | medication | environment | biologic }
			// NOTE: Moved to retrieve
      //and ACEIOrARBOrARNIAllergyIntolerance.category in "ACE Inhibitor or ARB Ingredient"
			and ACEIOrARBOrARNIAllergyIntolerance.clinicalStatus = 'active'
			and ACEIOrARBOrARNIAllergyIntolerance.verificationStatus in {'confirmed', 'unconfirmed'}
			and ACEIOrARBOrARNIAllergyIntolerance.type in {'allergy', 'intolerance'}
			and ACEIOrARBOrARNIAllergyIntolerance.criticality in {'low', 'high', 'unable-to-assess'}

define "Denominator Exceptions 1":
	exists "Medical Patient or System Reason for Not Ordering ACEI or ARB or ARNI Outpatient"
		or exists "Allergy or Intolerance to ACEI or ARB or ARNI Ingredient Outpatient"
		or exists "Diagnosis of Allergy to ACEI or ARB Outpatient"
		or exists "Diagnosis of Intolerance to ACEI or ARB Outpatient"
		or exists "Diagnosis of Pregnancy Outpatient"
		or exists "Diagnosis of Renal Failure Due to ACEI Outpatient"

define "Denominator Exceptions 2":
	exists "Medical Patient or System Reason for No ACEI or ARB or ARNI at Inpatient Discharge"
		or exists "Allergy or Intolerance to ACEI or ARB or ARNI Ingredient Inpatient"
		or exists "Diagnosis of Allergy to ACEI or ARB Inpatient"
		or exists "Diagnosis of Intolerance to ACEI or ARB Inpatient"
		or exists "Diagnosis of Pregnancy Inpatient"
		or exists "Diagnosis of Renal Failure Due to ACEI Inpatient"

define "Numerator 2":
	exists "ACEI or ARB or ARNI at Inpatient Discharge"
		or exists "Currently Taking ACEI or ARB or ARNI Inpatient"

define "Medical Patient or System Reason for No ACEI or ARB or ARNI at Inpatient Discharge":
	["MedicationRequest": "ACE Inhibitor or ARB"] NoACEIOrARBOrARNIAtDischarge
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that NoACEIOrARBOrARNIAtDischarge.authoredOn during ModerateOrSevereLVSDHFInpatientEncounter.period
			// NOTE: Moved to retrieve
		  //and (NoACEIOrARBOrARNIAtDischarge.medication as CodeableConcept) in "ACE Inhibitor or ARB"
			// NOTE: Why use singleton from here?
			and ( NoACEIOrARBOrARNIAtDischarge.reasonCode in "Medical Reason"
				or NoACEIOrARBOrARNIAtDischarge.reasonCode in "Patient Reason"
				or NoACEIOrARBOrARNIAtDischarge.reasonCode in "Patient Reason for ACE Inhibitor or ARB Decline"
				or NoACEIOrARBOrARNIAtDischarge.reasonCode in "System Reason"
			)
			//and ( singleton from NoACEIOrARBOrARNIAtDischarge.reasonCode in "Medical Reason"
			//	or singleton from NoACEIOrARBOrARNIAtDischarge.reasonCode in "Patient Reason"
			//	or singleton from NoACEIOrARBOrARNIAtDischarge.reasonCode in "Patient Reason for ACE Inhibitor or ARB Decline"
			//	or singleton from NoACEIOrARBOrARNIAtDischarge.reasonCode in "System Reason"
		  //)
//PCPI to ESAC: We're wondering which approach is correct to express negation logic. Should we use MedicationRequest (see above) or MedicationStatement (see below OPTION 2)?
// NOTE: US Core is moving away from MedicationStatement, so the recommendation is to use MedicationRequest

define "OPTION 2 Medical Patient or System Reason for No ACEI or ARB or ARNI at Inpatient Discharge":
	["MedicationStatement"] NoACEIOrARBOrARNIAtDischarge
		with "Heart Failure Inpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFInpatientEncounter
			such that NoACEIOrARBOrARNIAtDischarge.effective during ModerateOrSevereLVSDHFInpatientEncounter.period
		  and (NoACEIOrARBOrARNIAtDischarge.medication as CodeableConcept) in "ACE Inhibitor or ARB"
			and NoACEIOrARBOrARNIAtDischarge.taken = 'n'
			and ( singleton from NoACEIOrARBOrARNIAtDischarge.reasonNotTaken in "Medical Reason"
				or singleton from NoACEIOrARBOrARNIAtDischarge.reasonNotTaken in "Patient Reason"
				or singleton from NoACEIOrARBOrARNIAtDischarge.reasonNotTaken in "Patient Reason for ACE Inhibitor or ARB Decline"
				or singleton from NoACEIOrARBOrARNIAtDischarge.reasonNotTaken in "System Reason")

define "Medical Patient or System Reason for Not Ordering ACEI or ARB or ARNI Outpatient":
	["MedicationRequest"] NoACEIOrARBOrARNIOrdered
		with "Heart Failure Outpatient Encounter with Moderate or Severe LVSD" ModerateOrSevereLVSDHFOutpatientEncounter
			such that NoACEIOrARBOrARNIOrdered.authoredOn during ModerateOrSevereLVSDHFOutpatientEncounter.period
		 	and (NoACEIOrARBOrARNIOrdered.medication as CodeableConcept) in "ACE Inhibitor or ARB"
      and (singleton from NoACEIOrARBOrARNIOrdered.reasonCode in "Medical Reason"
				or singleton from NoACEIOrARBOrARNIOrdered.reasonCode in "Patient Reason"
				or singleton from NoACEIOrARBOrARNIOrdered.reasonCode in "Patient Reason for ACE Inhibitor or ARB Decline"
				or singleton from NoACEIOrARBOrARNIOrdered.reasonCode in "System Reason"
		)

define "Initial Population 1":
	Global."CalendarAgeInYearsAt" (FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 18
		and Count("Qualifying Encounter")>= 2
		and exists "Heart Failure Outpatient Encounter"

define "Initial Population 2":
	Global."CalendarAgeInYearsAt" (FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 18
		and exists "Heart Failure Inpatient Encounter"
