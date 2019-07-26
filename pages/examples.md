---
layout: default
title: Examples
---

# Libraries

# Translated Measures

## Screening Measures

These examples illustrate patient-based screening measures

* [**EXM124**](Measure-measure-exm124-FHIR.html) Cervical Cancer Screening - [Library](Library-library-exm124-FHIR.html)
* [**EXM125**](Measure-measure-exm125-FHIR.html) Breast Cancer Screening - [Library](Library-library-exm125-FHIR.html)
* [**EXM130**](Measure-measure-exm130-FHIR.html) Colorectal Cancer Screening - [Library](Library-library-exm130-FHIR.html)

## Hospital Measures

* [**VTE-1**](Measure-measure-vte-1-FHIR.html) Venous Thromboembolism Prophylaxis - [Library](Library-library-vte-1-FHIR.html)

# In-Testing Measures

* [**EXM105**](cql/in-progress/EXM105_FHIR-8.000_TJC.cql) Discharged on Statin Medication
* [**EXM117**](cql/in-progress/EXM117_FHIR-1.0.0.cql) Childhood Immunization Status
* [**EXM165**](cql/in-progress/EXM165_FHIR-1.0.0.cql) Controlling High Blood Pressure (CPC+ 2019)

# In-Progress Measures

These examples are currently in progress

* [**EXM72**](cql/in-progress/EXM72_FHIR-1.0.0.cql) Antithrombotic Therapy By End of Hospital Day 2
* [**EXM111**](cql/in-progress_EXM111_FHIR-1.0.0.cql) Median Admit Decision Time to ED Departure Time for Admitted Patients
* [**EXM122**](cql/in-progress/EXM122_FHIR-1.0.0.cql) Diabetes: Hemoglobin A1c (HbA1c) Poor Control (> 9%) (CPC+ 2019)
* [**EXM161**](cql/in-progress/EXM161-8.0.0.cql) Adult Major Depressive Disorder (MDD): Suicide Risk Assessment
* [**EXM146**](cql/in-progress/EXM146_FHIR-1.0.0.cql) Appropriate Testing for CHildren with Pharyngitis
* [**EXM159**](cql/in-progress/EXM159_DepressionRemissionatTwelveMonths-0.5.002_atom.cql) Depression Remission at Twelve Months
* [**EXM349**](cql/in-progress/EXM349_FHIR-2.9.000.cql) HIV Screening
* [**EXM2**](cql/in-progress/EXM2_FHIR.cql) Preventive Care and Screening: Screening for Depression and Follow-Up Plan
* [**EXM460**](cql/in-progress/PotentialOpioidOveruse_FHIR-0.1.082.cql) Potential Opioid Overuse
* [**EXM506**](cql/in-progress/EXM506_FHIR-1.0.0.cql) Safe use of opioids - concurrent prescribing
* [**EXM113**](cql/in-progress/EXM113_FHIR-1.0.0.cql) Elective Delivery

# Blocked Measures

These examples are currently blocked

* [**EXM9**](cql/in-progress/EXM9_FHIR-1.0.1.cql) Exclusive Breast Milk Feeding - Blocked on data element representation

# Planned

These examples are planned

# Issues

This section will contain links to trackers that have been submitted for issues encountered during the translation.

Walkthrough examples, specifically identifying gaps and how they were addressed within translation.

Capture and document known gaps.

# Common Patterns and Approaches

## Encounter Examples

### Inpatient Encounter Example

Encounter with Age at Start (VTE-1)

### Inpatient Encounter with Principal Diagnosis

EXM105 - All Stroke Encounter

### Inpatient Encounter with Principal Procedure

VTE-1 - "Encounter With Principal Procedure of SCIP VTE Selected Surgery"

## Diagnosis Examples

EXM72_FHIR-8.1.0_TJC.cql

```cql
define "Encounter With Thrombolytic Therapy Documented As Already Given":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with [Condition: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
			such that PriorTPA.onset during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
			  and PriorTPA.clinicalStatus in { 'active', 'recurrence', 'relapse' }
```

Note that verificationStatus is not being checked due to feedback received that it may be difficult for implementers to retrieve the element.

## Medications

EXM108_FHIR
```cql

define "VTE Prophylaxis by Medication Administered":
( ["MedicationAdministration": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
	where VTEMedication.status = 'completed'
				and VTEMedication.dosage.route in "Subcutaneous route"
)
union (
		(["MedicationAdministration": medication in "Low Molecular Weight Heparin for VTE Prophylaxis"]
			union ["MedicationAdministration": medication in "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
				union ["MedicationAdministration": medication in "Warfarin"]
				) M
				where M.status = 'completed')


```
### Medications at discharge

EXM104_FHIR-8.1.000_TJC.cql

```cql
define "Antithrombotic Therapy at Discharge":
	["MedicationRequest": "Antithrombotic Therapy"] Antithrombotic
	  where exists (Antithrombotic.category C where FHIRHelpers.ToConcept(C) ~ "Discharge")
	    and Antithrombotic.intent = 'order'
```

Note that the FHIRHelpers.ToConcept usage is intended to be implicit and will be unnecessary once QUICK is fully supported.

### Medication not discharged

```cql
define "Antithrombotic Not Given at Discharge":
	["MedicationRequest": "Antithrombotic Therapy"] NoAntithromboticDischarge
	  // STU3
		where exists (NoAntithromboticDischarge.extension E where E.url = 'http://hl7.org/fhir/us/davinci-deqm/STU3/StructureDefinition/extension-doNotPerform' and E.value is true)
		// R4
		//where NoAntithromboticDischarge.doNotPerform is true
			and (singleton from NoAntithromboticDischarge.reasonCode in "Medical Reason"
				or singleton from NoAntithromboticDischarge.reasonCode in "Patient Refusal")

// NOTE: On the assumption that status of not-taken is the closest to what the measure is looking for, this is the expression:				
// TODO: Request discussion w/ Pharmacy regarding how medications not prescribed at discharged would be documented
//define "Antithrombotic Not Given at Discharge R4":
//  ["MedicationStatement": "Antithrombotic Therapy"] AntithromboticTherapy
//	  where AntithromboticTherapy.status = 'not-taken'
//		  and (AntithromboticTherapy.statusReason in "Medical Reason"
//				or AntithrombtoicTherapy.statusReason in "Patient Refusal")
```

### Medication not administered

EXM108_FHIR
```cql

define "No VTE Prophylaxis Medication Administered":
(	["MedicationAdministration": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"]
	union
	["MedicationAdministration": medication in "Low Molecular Weight Heparin for VTE Prophylaxis"]
	union
	["MedicationAdministration": medication in "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
	union
	["MedicationAdministration": medication in "Warfarin"]
	) MedicationAdm
		where MedicationAdm.status = 'not-done'

```

### Medication not ordered

EXM108_FHIR
```cql

define "No VTE Prophylaxis Medication Ordered":
	(	["MedicationRequest": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"]
	union
	["MedicationRequest": medication in "Low Molecular Weight Heparin for VTE Prophylaxis"]
	union
	["MedicationRequest": medication in "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
	union
	["MedicationRequest": medication in "Warfarin"]
	) MedicationOrder
	where 	MedicationOrder.intent = 'order' //TJC: Need Fix- status is required, do we need to express here?
		 and MedicationOrder.doNotPerform.value is true
```

### Medication use

### Non-Medication Substances

### Non-Medication Substance Use

## Procedures/Interventions

EXM108_FHIR
```cql
define "Intervention Comfort Measures":
	(["ServiceRequest": "Comfort Measures"] P
		where P.intent = 'order')
	union
	(["Procedure": "Comfort Measures"] IntervetionPerformed
		where IntervetionPerformed.status = 'completed')
```

## Care Plan - Care Goals

## Communication

## Devices

### Device Use

EXM108_FHIR
```cql

define "VTE Prophylaxis by Device Applied":
 (
				["DeviceUseStatement": code in "Intermittent pneumatic compression devices (IPC)"]
				union ["DeviceUseStatement": code in "Venous foot pumps (VFP)"]
				union ["DeviceUseStatement": code in "Graduated compression stockings (GCS)"]
      ) DeviceApplied
				where DeviceApplied.status = 'completed'


```

### Device Not Used

EXM108_FHIR
```cql

define "No VTE Prophylaxis Device Applied":

   (["DeviceUseStatement": code in "Venous foot pumps (VFP)"]
    union ["DeviceUseStatement": code in "Intermittent pneumatic compression devices (IPC)"]
    union ["DeviceUseStatement": code in "Graduated compression stockings (GCS)"]
  ) DeviceApplied
    where GetExtension(DeviceApplied.extension, 'http://example.org/fhir/extensions/notDone').value is true
    //TJC: not sure if we can use R4 extension url of doNotPerform http://hl7.org/fhir/StructureDefinition/request-doNotPerform

```

### Device Order

### Device Not Ordered

EXM108_FHIR
```cql
define "No VTE Prophylaxis Device Ordered":
    ["DeviceRequest": code in "Venous foot pumps (VFP)"]
      union ["DeviceRequest": code in "Intermittent pneumatic compression devices (IPC)"]
      union ["DeviceRequest": code in "Graduated compression stockings (GCS)"]
  ) DevideOrder
    where DevideOrder.intent = 'Order'
      and GetExtension(DevideOrder.extension, 'http://hl7.org/fhir/StructureDefinition/request-doNotPerform').value is true

```

## Care Plan - Care Goals

## Adverse Event

## Allergy/Intolerance

## Observations

EXM108_FHIR
```cql
define "Is In Low Risk for VTE or On Anticoagulant":
	( ["Observation": code in "Risk for venous thromboembolism"] VTERiskAssessment
			where exists(FHIRHelpers.ToConcept(VTERiskAssessment.value) ~ FHIRHelpers.ToConcept("Low Risk" )
	)
```

### General Observations

### Laboratory tests

### Diagnostic Imaging Studies

### Symptoms

### Vital Signs

#### Blood Pressure

#### BMI

## Family History

## Immunization

## Cross-context queries (e.g to another individuals record)

## Program Participation (e.g. health plan, disease specific program)

## Requests

### Orders

### Recommendations

### Proposals

# Tools
