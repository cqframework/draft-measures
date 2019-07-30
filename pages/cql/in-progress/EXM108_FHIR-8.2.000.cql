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

