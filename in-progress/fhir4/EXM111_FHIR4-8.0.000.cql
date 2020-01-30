library EXM111_FHIR4 version '8.0.000'

using FHIR version '4.0.0'

include MATGlobalCommonFunctions_FHIR4 version '4.0.000'called Global
include FHIRHelpers version '4.0.0' called FHIRHelpers
include SupplementalDataElements_FHIR4 version '1.0.0' called SDE

codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "LOINC": 'http://loinc.org'
codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'  /*do we need something like this for ReferralRequest or Communication? please explain when we should add such and how do we locate?*/
codesystem "Diagnosis Role": 'http://hl7.org/fhir/diagnosis-role'

valueset "Decision to Admit to Hospital Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.295'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Hospital Settings": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1111.126'
valueset "Psychiatric/Mental Health Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.299'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
  SDE."Ethnicity"

define "SDE Payer":
	SDE."Payer"

define "SDE Race":
  SDE."Race"

define "SDE Sex":
	SDE."ONC Administrative Sex"

  define "Initial Population":
  		Global."Inpatient Encounter" EncounterInpatient
  		with "ED Visit with Admit Order" EDAdmitOrder
  		such that EDAdmitOrder.period ends 1 hour or less before or on start of EncounterInpatient.period

   define "ED Visit":         /*unable to get the Global.EDVisit logic to work here*/
    	["Encounter": type in "Emergency Department Visit"] EDVisit
        where EDVisit.status='finished'

define "ED Visit with Admit Order": /*7 issues revolve around this statement. Currently Admit Order is an Encounter Order which maps to ReferralRequest, which does not seem appropriate, please advise*/
	"ED Visit" EDVisit
	  with [ServiceRequest: "Decision to Admit to Hospital Inpatient"] AdmitOrder
		  such that FHIRHelpers.ToDateTime(AdmitOrder.authoredOn) during FHIRHelpers.ToInterval(EDVisit.period)
      		    and AdmitOrder.intent in {'plan', 'order'}


define "Measure Population":
"Initial Population"

define "Measure Population Exclusions":
Global."Inpatient Encounter" EncounterInpatient
	with "ED Visit" EDVisit
		such that EDVisit.period ends 1 hour or less before or on start of EncounterInpatient.period
		and EDVisit.status='finished'
		and EDVisit.hospitalization.admitSource in "Hospital Settings"

define "Stratification 1":
/*Encounters of patients without a principal diagnosis in the "Psychiatric/Mental Health Diagnosis" value set*/
Global."Inpatient Encounter" EncounterInpatient
where not exists ( Global."Inpatient Encounter" EncounterInpatient
	where Global."PrincipalDiagnosis"(EncounterInpatient).code in "Psychiatric/Mental Health Diagnosis") EncounterPrincipalDx
or ( Global."Inpatient Encounter" EncounterInpatient
	where Global."PrincipalDiagnosis"(EncounterInpatient).code in "Psychiatric/Mental Health Diagnosis") is null

define "Stratification 2":
/*Encounters of patients with a principal diagnosis that is in the "Psychiatric/Mental Health Diagnosis" value set*/
Global."Inpatient Encounter" EncounterInpatient
	where Global."PrincipalDiagnosis"(EncounterInpatient).code in "Psychiatric/Mental Health Diagnosis"

define function "AdmitDecision"(Encounter "Encounter"):
Last(
	[ServiceRequest: "Decision to Admit to Hospital Inpatient"] AdmitOrder
	  where FHIRHelpers.ToDateTime(AdmitOrder.authoredOn) during FHIRHelpers.ToInterval("RelatedEDVisit"(Encounter).period)
		  and AdmitOrder.intent in {'plan', 'order'}
)

define function "DepartureTime"(Encounter "Encounter"):
        Last(Encounter.location FacilityLocation
        		return
        		end of FacilityLocation.period
        		sort ascending)

define function "MeasureObservation"(Encounter "Encounter"):
    duration in minutes of Interval[FHIRHelpers.ToDateTime("AdmitDecision"(Encounter).authoredOn), ("DepartureTime"("RelatedEDVisit"(Encounter)))]



define function "RelatedEDVisit"(Encounter "Encounter"):
    Last ("ED Visit with Admit Order" EDVisit
    	where (EDVisit.period) ends 1 hour or less before or on start of (Encounter.period)
              sort by start of period)
