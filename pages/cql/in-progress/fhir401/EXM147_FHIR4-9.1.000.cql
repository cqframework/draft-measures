library PreventiveCareandScreeningInfluenzaImmunization version '9.1.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

valueset "Allergy to Eggs": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1253'
valueset "Allergy to Influenza Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1256'
valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Care Services in Long-Term Residential Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services - Nursing Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Egg Substance": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1537'
valueset "Encounter-Influenza": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1252'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Hemodialysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1083'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Influenza Vaccination": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.402'
valueset "Influenza Vaccination Declined": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1255'
valueset "Influenza Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1254'
valueset "Intolerance to Influenza Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1257'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1007'
valueset "Nursing Facility Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Peritoneal Dialysis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1084'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services - Group Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services - Other": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1030'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Previous Receipt of Influenza Vaccine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1185'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "System Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1009'

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

define "Initial Population":
exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period" ) >= 6
			)
		and ( exists "Initial Qualifying Encounter During Measurement Period"
				or exists "Dialysis During Measurement Period")

define "Initial Qualifying Encounter During Measurement Period":
	( ["Encounter": "Office Visit"]
		union ["Encounter": "Outpatient Consultation"]
		union ["Encounter": "Care Services in Long-Term Residential Facility"]
		union ["Encounter": "Home Healthcare Services"]
		union ["Encounter": "Patient Provider Interaction"]
		union ["Encounter": "Preventive Care Services, Initial Office Visit, 0 to 17"]
		union ["Encounter": "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union ["Encounter": "Preventive Care Services-Individual Counseling"]
		union ["Encounter": "Preventive Care Services - Group Counseling"]
		union ["Encounter": "Preventive Care Services - Other"]
		union ["Encounter": "Discharge Services - Nursing Facility"]
		union ["Encounter": "Nursing Facility Visit"]
		union ["Encounter": "Annual Wellness Visit"]
		union ["Encounter": "Preventive Care, Established Office Visit, 0 to 17"]
		union ["Encounter": "Preventive Care Services - Established Office Visit, 18 and Up"] ) QualifyingEncounter
		where QualifyingEncounter.period during "Measurement Period"
		and QualifyingEncounter.status ='finished'

define "Dialysis During Measurement Period":
(["Procedure": "Hemodialysis"]
					union ["Procedure": "Peritoneal Dialysis"])	Dialysis
							where Dialysis.performed during "Measurement Period"
							and Dialysis.status = 'completed'

define "Denominator":
	"Initial Population"
		and ( exists "Encounter During Influenza Season"
				or exists "Dialysis During Influenza Season"
						)

define "Encounter During Influenza Season":
	["Encounter": "Encounter-Influenza"] FluEncounter
		where FluEncounter.period starts during "Influenza Season"
		and FluEncounter.status = 'finished'

define "Dialysis During Influenza Season":
	(["Procedure": "Hemodialysis"]
	union ["Procedure": "Peritoneal Dialysis"]) FluSeasondialysis
		where Global."Normalize Interval"(FluSeasondialysis.performed) starts during "Influenza Season"
		and FluSeasondialysis.status = 'completed'

define "Denominator Exceptions":
	exists "Medical Patient or System Reason for Not Performing Influenza Vaccination"
		or exists "Medical Patient or System Reason for Not Administering Influenza Vaccine"
		or exists "Diagnosis of Allergy to Egg"
		or exists "Egg Substance Allergy"
		or exists "Diagnosis of Allergy to Influenza Vaccine"
		or exists "Diagnosis of Intolerance to Influenza Vaccine"
		or exists "Intolerance of Influenza Vaccination Procedure"
		or exists "Allergy or Intolerance to Influenza Vaccine"

define "Medical Patient or System Reason for Not Performing Influenza Vaccination":
	["Procedure": "Influenza Vaccination"] NoFluVaccination
		where Global.GetExtension(NoFluVaccination, 'qicore-recorded').value during "Influenza Season Including August and September of the Prior Year"
		and NoFluVaccination.status = 'not-done'
			and ( NoFluVaccination.statusReason in "Medical Reason"
					or NoFluVaccination.statusReason in "Patient Reason"
					or NoFluVaccination.statusReason in "System Reason"
					or NoFluVaccination.statusReason in "Influenza Vaccination Declined"
			)

define "Medical Patient or System Reason for Not Administering Influenza Vaccine":
	["MedicationRequest": "Influenza Vaccine"] NoFluVaccine
		where NoFluVaccine.authoredOn during "Influenza Season Including August and September of the Prior Year"
		and NoFluVaccine.doNotPerform is true
		and NoFluVaccine.status = 'completed'
			and ( NoFluVaccine.reasonCode in "Medical Reason"
					or NoFluVaccine.reasonCode in "Patient Reason"
					or NoFluVaccine.reasonCode in "System Reason"
					or NoFluVaccine.reasonCode in "Influenza Vaccination Declined"
			)

define "Diagnosis of Allergy to Egg":
	["Condition": "Allergy to Eggs"] EggAllergy
		where Global."Prevalence Period"(EggAllergy) overlaps after "Influenza Season"
    and EggAllergy.verificationStatus ~ Global."confirmed"

define "Egg Substance Allergy":
	["AllergyIntolerance": "Egg Substance"] AllergyEggSubstance
		where Global."Normalize Interval"(AllergyEggSubstance.onset) starts before end of "Influenza Season"
    and AllergyEggSubstance.verificationStatus ~ Global."confirmed"
    //and AllergyEggSubstance.clinicalStatus ~ Global."active"

define "Diagnosis of Allergy to Influenza Vaccine":
	["Condition": "Allergy to Influenza Vaccine"] FluVaccineAllergyDiagnosis
		where Global."Prevalence Period"(FluVaccineAllergyDiagnosis) overlaps after "Influenza Season"
    and FluVaccineAllergyDiagnosis.verificationStatus ~ Global."confirmed"

define "Diagnosis of Intolerance to Influenza Vaccine":
	["Condition": "Intolerance to Influenza Vaccine"] FluVaccineIntoleranceDiagnosis
		where Global."Prevalence Period"(FluVaccineIntoleranceDiagnosis) overlaps after "Influenza Season"
    and FluVaccineIntoleranceDiagnosis.verificationStatus ~ Global."confirmed"

define "Intolerance of Influenza Vaccination Procedure":
	["AllergyIntolerance": "Influenza Vaccination"] FluVaccinationIntolerance
		where Global."Normalize Interval"(FluVaccinationIntolerance.onset) starts before end of "Influenza Season"
    and FluVaccinationIntolerance.verificationStatus ~ Global."confirmed"
    //and FluVaccinationIntolerance.clinicalStatus ~ Global."active"

define "Allergy or Intolerance to Influenza Vaccine":
	["AllergyIntolerance": "Influenza Vaccine"] FluVaccineAllergyIntolerance
		where Global."Normalize Interval"(FluVaccineAllergyIntolerance.onset) starts before end of "Influenza Season"
    and FluVaccineAllergyIntolerance.verificationStatus ~ Global."confirmed"
    //and FluVaccineAllergyIntolerance.clinicalStatus ~ Global."active"

define "Numerator":
	exists "Influenza Vaccination Procedure"
		or exists "Influenza Immunization Administered"
		or exists "Influenza Vaccine Previously Received"

define "Influenza Vaccination Procedure":
	["Procedure": "Influenza Vaccination"] FluVaccination
		where Global."Normalize Interval"(FluVaccination.performed) starts during "Influenza Season Including August and September of the Prior Year"
    and FluVaccination.status = 'completed'

define "Influenza Immunization Administered":
	["Immunization": "Influenza Vaccine"] AdministeredFluVaccine
		where AdministeredFluVaccine.recorded during "Influenza Season Including August and September of the Prior Year"
    and AdministeredFluVaccine.status = 'completed'
//considering removing this definition. If keeping, maybe use condition
define "Influenza Vaccine Previously Received":
	["Observation": "Previous Receipt of Influenza Vaccine"] PreviousReceiptFluVaccine
		where Global."Normalize Interval"(PreviousReceiptFluVaccine.effective) during "Influenza Season Including August and September of the Prior Year"
    and PreviousReceiptFluVaccine.status in {'final', 'amended'}

define "Influenza Season":
	Interval[start of "Measurement Period" - 3 months, start of "Measurement Period" + 3 months )

define "Influenza Season Including August and September of the Prior Year":
	Interval[start of "Measurement Period" - 5 months, start of "Measurement Period" + 3 months )
