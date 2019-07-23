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

EXM72_FHIR

```cql
define "Encounter With Thrombolytic Therapy Documented As Already Given":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with [Condition: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
			such that PriorTPA.onset during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
			  and PriorTPA.clinicalStatus in { 'active', 'recurrence', 'relapse' }
```

Note that verificationStatus is not being checked due to feedback received that it may be difficult for implementers to retrieve the element.

## Medications

### Medications at discharge

```cql
define "Antithrombotic Therapy at Discharge":
	["MedicationRequest": "Antithrombotic Therapy"] Antithrombotic
	  where exists (Antithrombotic.category C where FHIRHelpers.ToConcept(C) ~ "Discharge")
	    and Antithrombotic.intent = 'order'
```

Note that the FHIRHelpers.ToConcept usage is intended to be implicit and will be unnecessary once QUICK is fully supported.

### Medication not administered

### Medication not ordered

### Medication use

### Non-Medication Substances

### Non-Medication Substance Use

## Procedures/Interventions

## Care Plan - Care Goals

## Communication

## Devices

### Device Use

### Device Not Used

### Device Order

### Device Not Ordered

## Care Plan - Care Goals

## Adverse Event

## Allergy/Intolerance

## Observations

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
