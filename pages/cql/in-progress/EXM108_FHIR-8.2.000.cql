//for 2020 reporting year. QDM v5.4
//Venous Thromboembolism Prophylaxis

library  EXM108_FHIR version '8.2.000'

using FHIR version '4.0.0'

include FHIRHelpers version '3.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR version '4.0.000' called Global
include VTEICU_FHIR version '3.1.000' called VTEICU
include SupplementalDataElements_FHIR version '1.0.0' called SDE

codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "LOINC": 'http://loinc.org'
//codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'

valueset "Atrial Fibrillation/Flutter": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.202'
valueset "Comfort Measures": 'https://cts.nlm.nih.gov/fhir/ValueSet/1.3.6.1.4.1.33895.1.3.0.45'
valueset "Direct Thrombin Inhibitor": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.205'
valueset "Emergency Department Visit": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "General or Neuraxial Anesthesia": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.1743'
valueset "General Surgery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.255'
valueset "Glycoprotein IIb/IIIa Inhibitors": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.41'
valueset "Graduated compression stockings (GCS)": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.256'
valueset "Gynecological Surgery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.257'
valueset "Hemorrhagic Stroke": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.212'
valueset "Hip Fracture Surgery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.258'
valueset "Hip Replacement Surgery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.259'
valueset "Injectable Factor Xa Inhibitor for VTE Prophylaxis": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.211'
valueset "INR": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intermittent pneumatic compression devices (IPC)": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.214'
valueset "Intracranial Neurosurgery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.260'
valueset "Intravenous route": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.222'
valueset "Ischemic Stroke": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.247'
valueset "Knee Replacement Surgery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.261'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.39'
valueset "Low Molecular Weight Heparin for VTE Prophylaxis": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.219'
valueset "Low Risk": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.400'
valueset "Medical Reason": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "Mental Health Diagnoses": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1004'
valueset "Obstetrics": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.263'
valueset "Obstetrics VTE": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.264'
valueset "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.134'
valueset "Patient Refusal": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Subcutaneous route": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.223'
valueset "Unfractionated Heparin": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.218'
valueset "Urological Surgery": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.272'
valueset "Venous foot pumps (VFP)": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.230'
valueset "Venous Thromboembolism": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.279'
valueset "Warfarin": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.232'
valueset "Intensive Care Unit": 'https://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.23'

code "Risk for venous thromboembolism": '72136-5' from "LOINC" display 'Risk for venous thromboembolism'

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
	SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
	SDE."SDE Sex"

define "Admission Without VTE or Obstetrical Conditions":
		Global."Inpatient Encounter" InpatientEncounter
		where not (Global.EncounterDiagnosis(InpatientEncounter).code in "Obstetrics"
								or Global.EncounterDiagnosis(InpatientEncounter).code in "Venous Thromboembolism"
								or Global.EncounterDiagnosis(InpatientEncounter).code in "Obstetrics VTE"
							)

// Note: added FHIRHelpers.ToDate() in R4
define "Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions":
  ( Global."Inpatient Encounter" InpatientEncounter
  		with ["Patient"] BirthDate
  			such that Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(BirthDate.birthDate), start of InpatientEncounter.period) >= 18
  )
  intersect "Admission Without VTE or Obstetrical Conditions"


// Note 1: confirm url is a right reference
//Note2: Code will not work without ToBoolean() in R4, while it works in STU3
define "No VTE Prophylaxis Device Applied or Ordered":
  // NOTE: Should be using device.code, but that requires CQL 1.4
  ((["DeviceUseStatement": code in "Venous foot pumps (VFP)"]
    union ["DeviceUseStatement": code in "Intermittent pneumatic compression devices (IPC)"]
    union ["DeviceUseStatement": code in "Graduated compression stockings (GCS)"]
  ) DeviceApplied
    where exists (DeviceApplied.extension E where E.url = 'http://hl7.org/fhir/R4/extension-request-doNotPerform.html' and FHIRHelpers.ToBoolean(E.value) is true)
    )
  union ((
    ["DeviceRequest": code in "Venous foot pumps (VFP)"]
      union ["DeviceRequest": code in "Intermittent pneumatic compression devices (IPC)"]
      union ["DeviceRequest": code in "Graduated compression stockings (GCS)"]
  ) DeviceOrder
    where DeviceOrder.intent = 'order' //Note: Need add all types of order as "in {" original-order",  "reflex-order",  "filler-order"}"" etc?
      and exists (DeviceOrder.extension E where E.url = 'http://hl7.org/fhir/R4/extension-request-doNotPerform.html' and FHIRHelpers.ToBoolean(E.value) is true)
      )

define "Initial Population":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions"

define "Is In Low Risk for VTE or On Anticoagulant":
	( ["Observation": "Risk for venous thromboembolism"] VTERiskAssessment
			where VTERiskAssessment.value in "Low Risk"
  	)

// Note: Code will not work without ToBoolean() in R4, while it works in STU3
define "No VTE Prophylaxis Medication Administered or Ordered":
	((	["MedicationAdministration": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"]
	union
	["MedicationAdministration": medication in "Low Molecular Weight Heparin for VTE Prophylaxis"]
	union
	["MedicationAdministration": medication in "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
	union
	["MedicationAdministration": medication in "Warfarin"]
	) MedicationAdm
		where MedicationAdm.status = 'not-done'
	)
	union
	((	["MedicationRequest": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"]
	union
	["MedicationRequest": medication in "Low Molecular Weight Heparin for VTE Prophylaxis"]
	union
	["MedicationRequest": medication in "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
	union
	["MedicationRequest": medication in "Warfarin"]
	) MedicationOrder
	where	FHIRHelpers.ToBoolean(MedicationOrder.doNotPerform) is true
	)


define "Intervention Comfort Measures":
	(["ServiceRequest": "Comfort Measures"] P
		where P.intent = 'order')
		union
  	(["Procedure": "Comfort Measures"] IntervetionPerformed
  	where IntervetionPerformed.status = 'completed')

// Note: In order to make coding work, using FHIRHelpers.ToDateTime() with dateTime datatype. Need test out "start of performed as Period"
define "Intervention Comfort Measures on Day of or Day After Start of Hospitalization":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		with "Intervention Comfort Measures" ComfortMeasure
			such that FHIRHelpers.ToDateTime(Coalesce(ComfortMeasure.performed as dateTime,ComfortMeasure.authoredOn)) 1 day or less on or after day of start of Global."Hospitalization"(QualifyingEncounter)

/*************************************/

define "ED Visit":
	["Encounter": type in "Emergency Department Visit"] EDVisit
    where EDVisit.status = 'finished'

//Done
define "No VTE Prophylaxis Device Due to Medical Reason During ED Visit":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		"ED Visit" EDVisit,
		"No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
		where FHIRHelpers.ToInterval(EDVisit.period) ends 1 hour or less on or before start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
			and (singleton from NoVTEDevice.reasonCode in "Medical Reason")
			and Coalesce(NoVTEDevice.authoredOn, NoVTEDevice.recordedOn) during FHIRHelpers.ToInterval(EDVisit.period)

//Done
define "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Admission":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		"No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
		where (singleton from NoVTEDevice.reasonCode in "Medical Reason")
			and Coalesce(NoVTEDevice.authoredOn, NoVTEDevice.recordedOn) during VTEICU."CalendarDayOfOrDayAfter"(start of FHIRHelpers.ToInterval(QualifyingEncounter.period))



//Done
define "No VTE Prophylaxis Medication Due to Medical Reason During ED Visit":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		"ED Visit" EDVisit,
		"No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
		where FHIRHelpers.ToInterval(EDVisit.period) ends 1 hour or less on or before start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
			and (singleton from NoVTEMedication.reasonCode in "Medical Reason")
		// TODO: Profile of MedicationAdministration to ensure effective is a Period
			and Coalesce(NoVTEMedication.authoredOn, start of NoVTEMedication.effective) during FHIRHelpers.ToInterval(EDVisit.period)
		return QualifyingEncounter

//Done
define "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Admission":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		"No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
		where (singleton from NoVTEMedication.reasonCode in "Medical Reason")
			and Coalesce(NoVTEMedication.authoredOn, start of NoVTEMedication.effective) during VTEICU."CalendarDayOfOrDayAfter"(start of FHIRHelpers.ToInterval(QualifyingEncounter.period))
		return QualifyingEncounter

//Done
define "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Procedure":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
		where NoVTEDevice.reasonCode in "Medical Reason"
			and AnesthesiaProcedure.status = 'completed'
			// TODO: Profile of procedure to ensure performed is a Period
			and AnesthesiaProcedure.performed ends 1 day after day of start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
			and  Coalesce(NoVTEDevice.authoredOn, NoVTEDevice.recordedOn) during VTEICU."CalendarDayOfOrDayAfter"(end of AnesthesiaProcedure.performed)
		return QualifyingEncounter



//Done
define "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
		where NoVTEMedication.reasonCode in "Medical Reason"
			and AnesthesiaProcedure.status = 'completed'
			and AnesthesiaProcedure.performed ends 1 day after day of start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
			// TODO: Profile of MedicationAdministration to ensure effective is a Period
			and Coalesce(NoVTEMedication.authoredOn, start of NoVTEMedication.effective) during VTEICU."CalendarDayOfOrDayAfter"(end of AnesthesiaProcedure.performed)
		return QualifyingEncounter


//Done
define "Encounter Less Than 2 Days":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		where Global."LengthInDays"(FHIRHelpers.ToInterval(QualifyingEncounter.period))< 2


//Done
define "SCIP VTE Selected Surgery":
	(	["Procedure": "General Surgery"]
		union ["Procedure": "Gynecological Surgery"]
		union ["Procedure": "Hip Fracture Surgery"]
		union ["Procedure": "Hip Replacement Surgery"]
		union ["Procedure": "Intracranial Neurosurgery"]
		union ["Procedure": "Knee Replacement Surgery"]
		union ["Procedure": "Urological Surgery"] ) P
		where P.status = 'completed'


//Done

//Done
define "Intervention Comfort Measures on Day of or Day After Procedure":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"Intervention Comfort Measures" ComfortMeasure
		where  AnesthesiaProcedure.status = 'completed'
				and AnesthesiaProcedure.performed ends 1 day after day of start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
				and Coalesce(ComfortMeasure.authoredOn, start of ComfortMeasure.performed) 1 day or less on or after day of end of AnesthesiaProcedure.performed

//Done
define "VTE Prophylaxis by Medication Administered or Device Applied":
	( ["MedicationAdministration": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
			where VTEMedication.status = 'completed'
						and VTEMedication.dosage.route in "Subcutaneous route"
	)
		union ["MedicationAdministration": medication in "Low Molecular Weight Heparin for VTE Prophylaxis"]
		union ["MedicationAdministration": medication in "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
		union ["MedicationAdministration": medication in "Warfarin"]
		union ((
				["DeviceUseStatement": code in "Intermittent pneumatic compression devices (IPC)"]
				union ["DeviceUseStatement": code in "Venous foot pumps (VFP)"]
				union ["DeviceUseStatement": code in "Graduated compression stockings (GCS)"]
      ) DeviceApplied
				where DeviceApplied.status = 'completed'
    )

//Done
define "VTE Prophylaxis Received on Day of or Day After Admission or Procedure":
	( from
			"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
			"VTE Prophylaxis by Medication Administered or Device Applied" HasVTEProphylaxis
			// TODO: Profile of MedicationAdministration to ensure effective is a Period
			where Coalesce(HasVTEProphylaxis.recordedOn, start of HasVTEProphylaxis.effective) during VTEICU."CalendarDayOfOrDayAfter"(start of FHIRHelpers.ToInterval(QualifyingEncounter.period))
			return QualifyingEncounter
	)
		union ( from
				"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
				["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
				"VTE Prophylaxis by Medication Administered or Device Applied" HasVTEProphylaxis
				where AnesthesiaProcedure.performed ends 1 day after day of start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
					and Coalesce(HasVTEProphylaxis.recordedOn, start of HasVTEProphylaxis.effective) during VTEICU."CalendarDayOfOrDayAfter"(end of AnesthesiaProcedure.performed)
				return QualifyingEncounter
		)


//Done
define "Medication Oral Factor Xa Inhibitor Administered on Day of or Day After Admission or Procedure":
	( from
			"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
			["MedicationAdministration": medication in "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
			where FactorXaMedication.effective starts during VTEICU."CalendarDayOfOrDayAfter"(start of FHIRHelpers.ToInterval(QualifyingEncounter.period))
			return QualifyingEncounter
	)
		union ( from
				"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
				["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
				["MedicationAdministration": medication in "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
				where AnesthesiaProcedure.status = 'completed'
				and AnesthesiaProcedure.performed ends 1 day after day of start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
					and FactorXaMedication.effective starts during VTEICU."CalendarDayOfOrDayAfter"(end of AnesthesiaProcedure.performed)
				return QualifyingEncounter
		)

//Done
define "Encounter With Prior or Present Diagnosis of Atrial Fibrillation or VTE":
	( "Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
			with ["Condition": code in "Atrial Fibrillation/Flutter"] AtrialFibrillation
				such that AtrialFibrillation.clinicalStatus = 'active'
				and AtrialFibrillation.verificationStatus = 'confirmed'
				and Global."Normalize Onset"(AtrialFibrillation.onset) on or before end of FHIRHelpers.ToInterval(QualifyingEncounter.period)
	)
		union ( "Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
				where Global.EncounterDiagnosis(QualifyingEncounter).code in "Atrial Fibrillation/Flutter"
			)
		union ( "Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
				with ["Condition": code in "Venous Thromboembolism"] VTEDiagnosis
					such that  VTEDiagnosis.clinicalStatus in { 'inactive', 'remission', 'resolved' }
					and VTEDiagnosis.verificationStatus = 'confirmed'
					and Global."Normalize Onset"(VTEDiagnosis.onset) before start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
		)

//Done
define "Encounter With ICU Location Stay 1 Day or More":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		where exists ( QualifyingEncounter.location Location
				where Global.GetLocation(Location.location).type in "Intensive Care Unit"
					and Global."LengthInDays"(Location.period)>= 1
					and Location.period starts during VTEICU."CalendarDayOfOrDayAfter"(start of FHIRHelpers.ToInterval(QualifyingEncounter.period))
		)


//Done
define "Encounter With Principal Diagnosis of Mental Disorder or Stroke":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		where Global."PrincipalDiagnosis"(QualifyingEncounter).code in "Mental Health Diagnoses"
			or Global."PrincipalDiagnosis"(QualifyingEncounter).code in "Hemorrhagic Stroke"
			or Global."PrincipalDiagnosis"(QualifyingEncounter).code in "Ischemic Stroke"

//Done
// TODO: Define an ordinality extension to a Procedure profile and ask Patient Administration and/or Patient Care to review
define "Encounter With Principal Procedure of SCIP VTE Selected Surgery":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		with ( "SCIP VTE Selected Surgery" Procedure
			where GetExtension(Procedure.extension, 'http://example.org/StructureDefinition/ordinality').value ~ "Principal" ) SelectedProcedure
			such that SelectedProcedure.performed during FHIRHelpers.ToInterval( QualifyingEncounter.period)

//Done
define "Denominator Exclusions":
	"Encounter Less Than 2 Days"
		union "Encounter With ICU Location Stay 1 Day or More"
		union "Encounter With Principal Diagnosis of Mental Disorder or Stroke"
		union "Encounter With Principal Procedure of SCIP VTE Selected Surgery"
		union "Intervention Comfort Measures on Day of or Day After Start of Hospitalization"
		union "Intervention Comfort Measures on Day of or Day After Procedure"


//Done
define "Encounter With Prior or Present Procedure of Hip or Knee Replacement Surgery":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		with ( ["Procedure": "Hip Replacement Surgery"]
			union ["Procedure": "Knee Replacement Surgery"] ) HipKneeProcedure
			such that HipKneeProcedure.status = 'completed'
				and HipKneeProcedure.performed starts on or before end of FHIRHelpers.ToInterval(QualifyingEncounter.period)

//Done
define "Low Risk for VTE or Anticoagulant Administered":
	"Low Risk for VTE or Anticoagulant Administered During ED Visit"
		union "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Admission"
		union "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure"

//Done
define "No VTE Prophylaxis Due to Medical Reason":
	( "No VTE Prophylaxis Medication Due to Medical Reason During ED Visit"
			intersect "No VTE Prophylaxis Device Due to Medical Reason During ED Visit"
	)
		union ( "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Admission"
				intersect "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Admission"
		)
		union ( "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure"
				intersect "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Procedure"
		)

//Done
define "No VTE Prophylaxis Due to Patient Refusal During ED Visit":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		"ED Visit" EDVisit,
		"No VTE Prophylaxis Medication or Device Due to Patient Refusal" PatientRefusal
		where EDVisit.period ends 1 hour or less on or before start of QualifyingEncounter.period
			and Coalesce(PatientRefusal.effective, PatientRefusal.authoredOn, PatientRefusal.recordedOn) during EDVisit.period
		return QualifyingEncounter

//Done
define "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Admission":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		"No VTE Prophylaxis Medication or Device Due to Patient Refusal" PatientRefusal
		where Coalesce(start of PatientRefusal.effective, PatientRefusal.authoredOn, PatientRefusal.recordedOn)
      during VTEICU."CalendarDayOfOrDayAfter"(start of QualifyingEncounter.period)
		return QualifyingEncounter

//Done
define "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Medication or Device Due to Patient Refusal" PatientRefusal
		where AnesthesiaProcedure.performed ends 1 day after day of start of QualifyingEncounter.period
			and Coalesce(start of PatientRefusal.effective, PatientRefusal.authoredOn, PatientRefusal.recordedOn)
        during VTEICU."CalendarDayOfOrDayAfter"(end of AnesthesiaProcedure.performed)
		return QualifyingEncounter

//Done
define "No VTE Prophylaxis Medication or Device Due to Patient Refusal":
	( "No VTE Prophylaxis Medication Administered or Ordered"
		union "No VTE Prophylaxis Device Applied or Ordered" ) NoVTEProphylaxis
		where GetExtension(NoVTEProphylaxis.extension, 'http://example.org/StructureDefinition/notDoneReason').value in "Patient Refusal"

//Done
define "No VTE Prophylaxis Due to Patient Refusal":
	"No VTE Prophylaxis Due to Patient Refusal During ED Visit"
		union "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Admission"
		union "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure"

//Done
define "Numerator":
	"VTE Prophylaxis Received on Day of or Day After Admission or Procedure"
		union ( "Medication Oral Factor Xa Inhibitor Administered on Day of or Day After Admission or Procedure"
				intersect ( "Encounter With Prior or Present Diagnosis of Atrial Fibrillation or VTE"
						union "Encounter With Prior or Present Procedure of Hip or Knee Replacement Surgery"
				)
		)
		union "Low Risk for VTE or Anticoagulant Administered"
		union "No VTE Prophylaxis Due to Medical Reason"
		union "No VTE Prophylaxis Due to Patient Refusal"

//Done
define "Is In Low Risk for VTE or On Anticoagulant":
	( ["Observation": code in "Risk for venous thromboembolism"] VTERiskAssessment
			where VTERiskAssessment.value in "Low Risk"
	)

/*
// TODO: Issues with constructing the FHIR types here...
		union ( ["Observation": "INR"] INRLabTest
				where INRLabTest.value as Quantity > 3.0
				return "Observation" { id: INRLabTest.id, effective: INRLabTest.issued }
		)
		union ((( ["MedicationAdministration": "Unfractionated Heparin"] UnfractionatedHeparin
					where UnfractionatedHeparin.dosage.route in "Intravenous route"
						)
				union ["MedicationAdministration": "Direct Thrombin Inhibitor"]
				union ["MedicationAdministration": "Glycoprotein IIb/IIIa Inhibitors"] ) AnticoagulantMedication
					return "Observation" { id: AnticoagulantMedication.id, effective: start of effective}
		)
*/

//Done
define "Low Risk for VTE or Anticoagulant Administered During ED Visit":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		"ED Visit" EDVisit,
		"Is In Low Risk for VTE or On Anticoagulant" VTERiskAssessment
		where FHIRHelpers.ToInterval(EDVisit.period) ends 1 hour or less on or before start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
			and VTERiskAssessment.issued during FHIRHelpers.ToInterval(EDVisit.period)
		return QualifyingEncounter

//Done
define "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Admission":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		with "Is In Low Risk for VTE or On Anticoagulant" VTERiskAssessment
			such that VTERiskAssessment.issued during VTEICU."CalendarDayOfOrDayAfter"(start of FHIRHelpers.ToInterval(QualifyingEncounter.period))

//Done
define "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure":
	from
		"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter,
		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"Is In Low Risk for VTE or On Anticoagulant" VTERiskAssessment
		where AnesthesiaProcedure.performed ends 1 day after day of start of FHIRHelpers.ToInterval(QualifyingEncounter.period)
			and VTERiskAssessment.issued during VTEICU."CalendarDayOfOrDayAfter"(end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed))
		return QualifyingEncounter
