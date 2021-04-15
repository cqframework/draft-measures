library PalliativeCareHEDIS version '0.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include NCQA_Common version '5.1.000' called Common

valueset "Palliative Care Assessment": 'https://www.ncqa.org/fhir/valueset/2.16.840.1.113883.3.464.1004.2225'
valueset "Palliative Care Encounter": 'https://www.ncqa.org/fhir/valueset/2.16.840.1.113883.3.464.1004.1450'
valueset "Palliative Care Intervention": 'https://www.ncqa.org/fhir/valueset/2.16.840.1.113883.3.464.1004.2224'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Palliative Care in the Measurement Period":
  exists ( ["Observation": "Palliative Care Assessment"] PalliativeAssessment
      where PalliativeAssessment.status in {'final','amended','corrected'}
      and Common."Normalize Interval"(PalliativeAssessment.effective) during "Measurement Period"
  )
    or exists ( ["Encounter": "Palliative Care Encounter"] PalliativeEncounter
        where PalliativeEncounter.status = 'finished'
        and PalliativeEncounter.period overlaps "Measurement Period"
    )
    or exists ( ["Procedure": "Palliative Care Intervention"] PalliativeIntervention
        where PalliativeIntervention.status in {'completed','in-progress'}
        and Common."Normalize Interval"(PalliativeIntervention.performed) overlaps "Measurement Period"
            )
