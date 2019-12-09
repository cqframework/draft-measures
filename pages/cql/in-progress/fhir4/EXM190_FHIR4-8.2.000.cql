//for 2020 reporting year. QDM to QI-4
//Intensive Care Unit Venous Thromboembolism Prophylaxis
//Author: TJC
library EXM190_FHIR4 version '8.2.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include SupplementalDataElements_FHIR4 version '1.0.0' called SDE
include VTEICU_FHIR4 version '3.1.000' called VTEICU
include TJC_Overall_FHIR4 version '4.0.000' called TJC

codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "LOINC": 'http://loinc.org'
// NOTE: R4 code system URLs changed to be based on terminology.hl7.org...
codesystem "RequestIntent": 'http://terminology.hl7.org/CodeSystem/request-intent'
//NOTE: Created for condition.clinicalStatus which is codeableConcept
codesystem "ConditionClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'

//NOTE: Created for ActPriority for Encounter.category which is codeableConcept
codesystem "ActPriority": 'http://terminology.hl7.org/ValueSet/v3-ActPriority'

valueset "Device Application": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.48'
valueset "Atrial Fibrillation/Flutter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.202'
valueset "Comfort Measures": 'http://cts.nlm.nih.gov/fhir/ValueSet/1.3.6.1.4.1.33895.1.3.0.45'
valueset "Direct Thrombin Inhibitor": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.205'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "General or Neuraxial Anesthesia": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.1743'
valueset "General Surgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.255'
valueset "Glycoprotein IIb/IIIa Inhibitors": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.41'
valueset "Graduated compression stockings (GCS)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.256'
valueset "Gynecological Surgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.257'
valueset "Hemorrhagic Stroke": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.212'
valueset "Hip Fracture Surgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.258'
valueset "Hip Replacement Surgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.259'
valueset "Injectable Factor Xa Inhibitor for VTE Prophylaxis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.211'
valueset "INR": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intermittent pneumatic compression devices (IPC)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.214'
valueset "Intracranial Neurosurgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.260'
valueset "Intravenous route": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.222'
valueset "Ischemic Stroke": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.247'
valueset "Knee Replacement Surgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.261'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.39'
valueset "Low Molecular Weight Heparin for VTE Prophylaxis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.219'
valueset "Low Risk": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.400'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "Mental Health Diagnoses": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1004'
valueset "Obstetrics": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.263'
valueset "Obstetrics VTE": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.264'
valueset "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.134'
valueset "Patient Refusal": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Subcutaneous route": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.223'
valueset "Unfractionated Heparin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.218'
valueset "Urological Surgery": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.272'
valueset "Venous foot pumps (VFP)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.230'
valueset "Venous Thromboembolism": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.279'
valueset "Warfarin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.232'
valueset "Intensive Care Unit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.23'

code "Risk for venous thromboembolism": '72136-5' from "LOINC" display 'Risk for venous thromboembolism'

//NOTE: Created for condition.clinicalStatus which is codeableConcept
code "active": 'active' from "ConditionClinicalStatusCodes"
code "recurrence": 'recurrence' from "ConditionClinicalStatusCodes"
code "relapse": 'relapse' from "ConditionClinicalStatusCodes"
code "inactive": 'inactive' from "ConditionClinicalStatusCodes"
code "remission": 'remission' from "ConditionClinicalStatusCodes"
code "resolved": 'resolved' from "ConditionClinicalStatusCodes"

//NOTE: Created for ActPriority for Encounter.category which is codeableConcept
code "elective": 'elective' from "ActPriority"


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
  	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions"


// Note: added FHIRHelpers.ToDate() in R4
define "Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions":
  ( Global."Inpatient Encounter" InpatientEncounter
  		with ["Patient"] BirthDate
  			such that Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(BirthDate.birthDate), start of InpatientEncounter.period) >= 18
  )
  intersect "Admission Without VTE or Obstetrical Conditions"

  define "Admission Without VTE or Obstetrical Conditions":
  		Global."Inpatient Encounter" InpatientEncounter
  		where not (Global.EncounterDiagnosis(InpatientEncounter).code in "Obstetrics"
  								or Global.EncounterDiagnosis(InpatientEncounter).code in "Venous Thromboembolism"
  								or Global.EncounterDiagnosis(InpatientEncounter).code in "Obstetrics VTE"
  							)


define "Denominator":
    "Encounter With ICU Location"

define "Encounter With ICU Location":
  "Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
  	where exists (QualifyingEncounter.location Location
				where Global.GetLocation(Location.location).type in "Intensive Care Unit"
  			and Location.period during QualifyingEncounter.period
  	)


define "Denominator Exclusions":
  "Encounter With ICU Location And Encounter Less Than 2 Days"
  union "Encounter With First ICU Stay With Principal Procedure of SCIP VTE Selected Surgery"
	union "Encounter With Intervention Comfort Measures From Day Of Start of Hospitalization To Day After First ICU Stay"
	union "Encounter With Intervention Comfort Measures on Day of or Day After Procedure"


define "Encounter With ICU Location And Encounter Less Than 2 Days":
  "Encounter With ICU Location"QualifyingEncounterICU
  	where Global."LengthInDays"(QualifyingEncounterICU.period)< 2



define function GetExtension(Resource FHIR.DomainResource, Url String):
  First(
		Resource.extension E
	  	where E.url = Url
	)

define function GetExtension(Element FHIR.Element, Url String):
  First(
		Element.extension E
	  	where E.url = Url
	)

/* NOTE: 2 options to express Principal Procedure to retrive "encounter Procedure as an url" and proedure "rank as extension" in R4
          VTE-1 uses Option 1 - generic extension funtion
          VTE-2 uses Option 2 - Specific extension functions
  TODO:  Mapping Table needs revision on using "Encounter.procedure.code", "Encounter.procedure.sequence"
*/

define function GetEncounterProcedure(encounter Encounter):
	 GetExtension(encounter, 'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-encounter-procedure')

define function GetRank(encounterProcedure Extension):
  GetExtension(encounterProcedure, 'rank').value as FHIR.positiveInt

define function GetProcedureId(encounterProcedure Extension):
    Global.GetId((GetExtension(encounterProcedure, 'procedure').value as FHIR.Reference).reference)

define "Encounter With First ICU Stay With Principal Procedure of SCIP VTE Selected Surgery":
from
  "Encounter With ICU Location" QualifyingEncounterICU,
  "SCIP VTE Selected Surgery" SelectedProcedure
  let EncounterProcedure: GetEncounterProcedure(QualifyingEncounterICU)
where GetRank(EncounterProcedure) = 1
  and GetProcedureId(EncounterProcedure) = SelectedProcedure.id
  and SelectedProcedure.performed as Period ends during TJC."CalendarDayOfOrDayAfter"(VTEICU."StartOfFirstICU"(QualifyingEncounterICU))

  define "SCIP VTE Selected Surgery":
  	(	["Procedure": "General Surgery"]
  		union ["Procedure": "Gynecological Surgery"]
  		union ["Procedure": "Hip Fracture Surgery"]
  		union ["Procedure": "Hip Replacement Surgery"]
  		union ["Procedure": "Intracranial Neurosurgery"]
  		union ["Procedure": "Knee Replacement Surgery"]
  		union ["Procedure": "Urological Surgery"] ) P
  		where P.status = 'completed'


//TODO - need FHIRHelpers.ToInterval()  when using start of or end of xxxx .
define "Encounter With Intervention Comfort Measures From Day Of Start of Hospitalization To Day After First ICU Stay":
    "Encounter With ICU Location" QualifyingEncounterICU
      with "Intervention Comfort Measures" ComfortMeasure
    	such that Coalesce(start of FHIRHelpers.ToInterval(ComfortMeasure.performed as Period), ComfortMeasure.authoredOn) during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)

    define "Intervention Comfort Measures":
      	(["ServiceRequest": "Comfort Measures"] P
      		where P.intent in {'order', 'plan'} //NOTE: Mapping table states "Constrain to "order" (include children)"". Should be all listed (original, reflex....)?
        )
      	union
          	(["Procedure": "Comfort Measures"] IntervetionPerformed
            	where IntervetionPerformed.status in {'completed', 'in-progress'})

define "Encounter With Intervention Comfort Measures on Day of or Day After Procedure":
  from
    "Encounter With ICU Location" QualifyingEncounterICU,
    ["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    "Intervention Comfort Measures" ComfortMeasure
    where  AnesthesiaProcedure.status = 'completed'
      	and AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
        //Note - "start of ComfortMeasure.performed as Period" does not work
        and Coalesce(start of FHIRHelpers.ToInterval(ComfortMeasure.performed as Period), ComfortMeasure.authoredOn) during TJC."CalendarDayOfOrDayAfter"(
    			end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed as Period))
    	return QualifyingEncounterICU


define "Numerator":
"Encounter With VTE Prophylaxis Received on Day of or Day After First ICU Stay or Procedure"
	union ( "Encounter With Medication Oral Factor Xa Inhibitor Administered on Day of or Day After First ICU Stay or Procedure"
			intersect ( "Encounter With Prior or Present Diagnosis of Atrial Fibrillation or VTE"
					union "Encounter With Prior or Present Procedure of Hip or Knee Replacement Surgery"
			)
	)
	union "Encounter With Low Risk for VTE or Anticoagulant Administered"
	union "Encounter With No VTE Prophylaxis Due to Medical Reason"
	union "Encounter With No VTE Prophylaxis Due to Patient Refusal"


define "Encounter With VTE Prophylaxis Received on Day of or Day After First ICU Stay or Procedure":
	( from
			"Encounter With ICU Location" QualifyingEncounterICU,
			"VTE Prophylaxis by Medication Administered or Device Applied" VTEProphylaxis
			where Coalesce(VTEProphylaxis.effective as Period,  VTEProphylaxis.timing as Period) starts during TJC."CalendarDayOfOrDayAfter"(VTEICU."StartOfFirstICU"(QualifyingEncounterICU))
			return QualifyingEncounterICU
	)
	union ( from
				"Encounter With ICU Location" QualifyingEncounterICU,
				["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
				"VTE Prophylaxis by Medication Administered or Device Applied" VTEProphylaxis
				where AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
					and Coalesce(VTEProphylaxis.effective as Period,  VTEProphylaxis.timing as Period) starts during TJC."CalendarDayOfOrDayAfter"(
  				end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed as Period))
            return QualifyingEncounterICU
        )

  define "VTE Prophylaxis by Medication Administered or Device Applied":
    ( ["MedicationAdministration": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
  		where VTEMedication.status ='completed'
  					and VTEMedication.dosage.route in "Subcutaneous route"
   )
   	union (["MedicationAdministration": medication in "Low Molecular Weight Heparin for VTE Prophylaxis"] LMWH where LMWH.status = 'completed')
   	union (["MedicationAdministration": medication in "Injectable Factor Xa Inhibitor for VTE Prophylaxis"] FactorXa where FactorXa.status = 'completed')
   	union (["MedicationAdministration": medication in "Warfarin"] Warfarin where Warfarin.status = 'completed')
  	union ((
  			["DeviceUseStatement": code in "Intermittent pneumatic compression devices (IPC)"]
  			union ["DeviceUseStatement": code in "Venous foot pumps (VFP)"]
  			union ["DeviceUseStatement": code in "Graduated compression stockings (GCS)"]
      ) DeviceApplied
  			where DeviceApplied.status = 'active'
    )


define "Encounter With Medication Oral Factor Xa Inhibitor Administered on Day of or Day After First ICU Stay or Procedure":
( from
    "Encounter With ICU Location" QualifyingEncounterICU,
     ["MedicationAdministration": medication in "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
      where FactorXaMedication.status = 'complete'
          and FactorXaMedication.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(VTEICU."StartOfFirstICU"(QualifyingEncounterICU))
      return QualifyingEncounterICU
   )
  union ( from
    			 "Encounter With ICU Location" QualifyingEncounterICU,
    			["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
    			["MedicationAdministration": medication in "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
    			where FactorXaMedication.status = 'complete'
            and AnesthesiaProcedure.status = 'completed'
    				and AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
    					and FactorXaMedication.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(
      				end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed as Period))
    			return QualifyingEncounterICU
        	)

/*NOTE: Feedback at Digitial Quality Summit 2019 indicates verificationStatus may be difficult for implementers to retrieve
          and AtrialFibrillation.verificationStatus = 'confirmed'
*/
define "Encounter With Prior or Present Diagnosis of Atrial Fibrillation or VTE":
	( "Encounter With ICU Location" QualifyingEncounterICU
		with ["Condition": code in "Atrial Fibrillation/Flutter"] AtrialFibrillation
		such that FHIRHelpers.ToConcept(AtrialFibrillation.clinicalStatus) in {"active", "recurrence", "relapse"}
			and AtrialFibrillation.onset as dateTime on or before end of QualifyingEncounterICU.period
	)
union ( "Encounter With ICU Location" QualifyingEncounterICU
				where Global.EncounterDiagnosis(QualifyingEncounterICU).code in "Atrial Fibrillation/Flutter"
			)
union ( "Encounter With ICU Location" QualifyingEncounterICU
				with ["Condition": code in "Venous Thromboembolism"] VTEDiagnosis
				such that  FHIRHelpers.ToConcept(VTEDiagnosis.clinicalStatus) in { "inactive", "remission", "resolved" }
			//and VTEDiagnosis.verificationStatus = 'confirmed'
					and VTEDiagnosis.onset as dateTime before start of QualifyingEncounterICU.period
  		)


define "Encounter With Prior or Present Procedure of Hip or Knee Replacement Surgery":
	"Encounter With ICU Location" QualifyingEncounterICU
	with ( ["Procedure": "Hip Replacement Surgery"]
  			union ["Procedure": "Knee Replacement Surgery"] ) HipKneeProcedure
	such that HipKneeProcedure.status = 'completed'
			and HipKneeProcedure.performed as Period starts on or before end of QualifyingEncounterICU.period



define "Encounter With Low Risk for VTE or Anticoagulant Administered":
  "Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After First ICU Stay"
  union "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure"


define "Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After First ICU Stay":
  "Encounter With ICU Location" QualifyingEncounterICU
  with "Is In Low Risk for VTE or On Anticoagulant" VTERiskAssessment
  such that VTERiskAssessment.effective as dateTime during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)

  // TODO: Issue on return "Observation" { id: AnticoagulantMedication.id, effective: start of FHIRHelpers.ToInterval(AnticoagulantMedication.effective as Period)}
  define "Is In Low Risk for VTE or On Anticoagulant":
  	( ["Observation": "Risk for venous thromboembolism"] VTERiskAssessment
  		where VTERiskAssessment.value in "Low Risk"
          and VTERiskAssessment.status in {'final','amended', 'corrected'}
    	)
    union ( ["Observation": "INR"] INRLabTest
            where INRLabTest.value as Quantity > 3.0
                and INRLabTest.status in {'final','amended', 'corrected'}
                return "Observation" { id: INRLabTest.id, effective: INRLabTest.issued }
          )
    union ((( ["MedicationAdministration": "Unfractionated Heparin"] UnfractionatedHeparin
            where UnfractionatedHeparin.dosage.route in "Intravenous route"
            )
          union ["MedicationAdministration": "Direct Thrombin Inhibitor"]
          union ["MedicationAdministration": "Glycoprotein IIb/IIIa Inhibitors"] ) AnticoagulantMedication
          where AnticoagulantMedication.status = 'complete'
          return "Observation" { id: AnticoagulantMedication.id, effective: (AnticoagulantMedication.effective as Period).start}
          )

define "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure":
  from
  	"Encounter With ICU Location" QualifyingEncounterICU,
  	["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
  	"Is In Low Risk for VTE or On Anticoagulant" LowRiskForVTE
  where AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
  	and LowRiskForVTE.effective as dateTime during TJC."CalendarDayOfOrDayAfter"(end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed as Period))
  return QualifyingEncounterICU


define "Encounter With No VTE Prophylaxis Due to Medical Reason":
  ( "No VTE Prophylaxis Medication Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay"
    intersect "No VTE Prophylaxis Device Due to Medical Reason From Day of Start of Hospitalization To Day After First ICU Stay"
  )
  union ( "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure"
      intersect "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Procedure"
  )


define "No VTE Prophylaxis Medication Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		"No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
		where Coalesce(NoVTEMedication.statusReason,NoVTEMedication.reasonCode) in "Medical Reason"
			and Coalesce(NoVTEMedication.authoredOn, start of FHIRHelpers.ToInterval(NoVTEMedication.effective as Period)) during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)
    return QualifyingEncounterICU

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
  	where	MedicationOrder.doNotPerform is true
      and MedicationOrder.status in {'completed', 'cancelled'}
      //11/5 discussion: all expressions for QI-Core must include a status.
      //Therefore, we need ServiceRequest.status = completed; and MedicationRequest.status = cancelled (or completed, since cancelled indicates it was once ordered but intentionally never filled).
      //So the not done issue is handled by ServiceRequest.doNotPerform = True  Or MedicationRequest.doNotPerform = True
    )


define "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure":
	from
  		"Encounter With ICU Location" QualifyingEncounterICU,
  		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
  		"No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
  where  Coalesce(NoVTEMedication.statusReason,NoVTEMedication.reasonCode) in "Medical Reason"
  		and AnesthesiaProcedure.status = 'completed'
  		and AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
  		and Coalesce(NoVTEMedication.authoredOn, start of FHIRHelpers.ToInterval(NoVTEMedication.effective as Period))during TJC."CalendarDayOfOrDayAfter"(
        end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed as Period))
  return QualifyingEncounterICU


define "No VTE Prophylaxis Device Due to Medical Reason From Day of Start of Hospitalization To Day After First ICU Stay":
  	"Encounter With ICU Location" QualifyingEncounterICU
    with "No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
    such that NoVTEDevice.requestStatusReason in "Medical Reason"
        and NoVTEDevice.authoredOn during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)


  //11/5: ServiceRequest not done reason is an extension in QI-Core R4 as ServiceRequest.extension:statusReason
    define function GetStatusReason(requestReason ServiceRequest):
            GetExtension(requestReason, 'http://hl7.org/fhir/StructureDefinition/request-statusReason')

    define "No VTE Prophylaxis Device Applied or Ordered":
        ((
          ["ServiceRequest": "Venous foot pumps (VFP)"]
          union ["ServiceRequest": "Intermittent pneumatic compression devices (IPC)"]
          union ["ServiceRequest": "Graduated compression stockings (GCS)"]
          ) DeviceOrder
          where DeviceOrder.status = 'completed'
          //11/5 discussion: all expressions for QI-Core must include a status
          //ServiceRequest.status -  draft | active | suspended | completed | entered-in-error | cancelled
              and DeviceOrder.doNotPerform is true
          return {id: DeviceOrder.id, requestStatusReason: GetStatusReason(DeviceOrder), authoredOn: DeviceOrder.authoredOn}
          )
    union
        (
          ["Procedure": "Device Application"] DeviceApplied
            let DeviceNotDoneTiming: GetExtension(DeviceApplied, 'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-recorded').value
            where (DeviceApplied.usedCode in "Intermittent pneumatic compression devices (IPC)"
                or DeviceApplied.usedCode in "Venous foot pumps (VFP)"
                or DeviceApplied.usedCode in "Graduated compression stockings (GCS)"
                )
                and  DeviceApplied.status = 'not-done'
                return {id: DeviceApplied.id, requestStatusReason: DeviceApplied.statusReason, authoredOn: DeviceNotDoneTiming}

    )


define "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Procedure":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
		where  NoVTEDevice.requestStatusReason in "Medical Reason"
        and AnesthesiaProcedure.status = 'completed'
        and AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
        and NoVTEDevice.authoredOn during TJC."CalendarDayOfOrDayAfter"(
			         end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed as Period))
		return QualifyingEncounterICU


define "Encounter With No VTE Prophylaxis Due to Patient Refusal":
"No VTE Prophylaxis Due to Patient Refusal From Day of Start of Hospitalization To Day After First ICU Stay"
	union "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure"

define "No VTE Prophylaxis Due to Patient Refusal From Day of Start of Hospitalization To Day After First ICU Stay":
	"Encounter With ICU Location" QualifyingEncounterICU
		with "No VTE Prophylaxis Medication or Device Due to Patient Refusal" PatientRefusal
    such that Coalesce(PatientRefusal.effective as dateTime, PatientRefusal.authoredOn)
        during VTEICU.FromDayOfStartOfHospitalizationToDayAfterFirstICU(QualifyingEncounterICU)

  define "No VTE Prophylaxis Medication or Device Due to Patient Refusal":
      ( "No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
          where  Coalesce(NoVTEMedication.statusReason,NoVTEMedication.reasonCode) in "Patient Refusal"
      )
      union ("No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
              where NoVTEDevice.requestStatusReason in "Patient Refusal"
            )

define "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		["Procedure": "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Medication or Device Due to Patient Refusal" PatientRefusal
		where AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
			and Coalesce(PatientRefusal.effective as dateTime, PatientRefusal.authoredOn)
        during TJC."CalendarDayOfOrDayAfter"(
  			end of FHIRHelpers.ToInterval(AnesthesiaProcedure.performed as Period))
		return QualifyingEncounterICU



define "Denominator Exceptions":
  "Encounter With First ICU Location Stay Less Than 1 day"

define "Encounter With First ICU Location Stay Less Than 1 day":
  "Encounter With ICU Location" QualifyingEncounterICU
	 where Global."LengthInDays"(VTEICU."FirstICULocationPeriod"(QualifyingEncounterICU))< 1
