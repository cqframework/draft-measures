library TerminologyGuidance

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

codesystem "Observation Category Codes": 'http://terminology.hl7.org/CodeSystem/observation-category'

code "Observation Category: Social History": 'social-history' from "Observation Category Codes" display 'Social History'
code "Observation Category: Vital Signs": 'vital-signs' from "Observation Category Codes" display 'Vital Signs'

context Patient

/*
# Terminology Resources
* CodeSystem - A set of codes, has a URL and version
* ValueSet - A subset of a code system (or code systems)
* Can ONLY bind to ValueSets, not CodeSystems

Code systems defined in FHIR
Code systems define externally
ValueSets defined in FHIR
ValueSets defined in VSAC

# Terminology Type Elements in FHIR
* code - Required binding to FHIR-defined value set
* CodeableConcept - Required, Preferred, or Extensible binding to FHIR-defined value set

If the element is defined with a Required binding to a FHIR-defined value set, the element will
be of type "code" meaning that it only has the actual code, and can be referenced directly.
Note that the code system is explicitly defined by the FHIR resource/profile, and that is
the _only_ reason that it is "safe" to reference the code value as a string.

If the element is defined with any other binding (Preferred, Extensible, Example), then
the element will be of type "CodeableConcept" (almost always, especially for eCQM usage),
meaning that comparisons _must_ be to specific concepts defined in code systems, or
membership tests against value sets.

# Examples

## code element
[Observation.status](http://hl7.org/fhir/R4/observation-definitions.html#Observation.status)
*/

define ObservationStatusComparison:
  [Observation] O
    where O.status in { 'final', 'amended' }

/*
## CodeableConcept element bound to FHIR-defined value set
[Observation.category](http://hl7.org/fhir/R4/observation-definitions.html#Observation.category)

Navigate to the Value Set definition
[observation-category](http://hl7.org/fhir/R4/valueset-observation-category.html)

Navigate to the Code System definition
[ObservationCategoryCodes](http://hl7.org/fhir/R4/codesystem-observation-category.html)
Copy the "Defining URL" into a code system declaration:

codesystem "<Title>": '<Defining URL>'
codesystem "Observation Category Codes": 'http://terminology.hl7.org/CodeSystem/observation-category'

Best practice is _not_ to include the version unless necessary. If version is required,
specify it using the version component of the code system declaration:

codesystem "<Title>:<Version>": '<Defining URL>' version '<Version>'
codesystem "Observation Category Codes:4.0.1": 'http://terminology.hl7.org/CodeSystem/observation-category' version '4.0.1'

Declare the codes in the code system for use as direct-reference codes within CQL:

code "[<Code System Title>: ]<Display>": '<Code>' from "<Code System Title>" display '<Display>'

code "Observation Category: Social History": 'social-history' from "Observation Category Codes" display 'Social History'
code "Observation Category: Vital Signs": 'vital-signs' from "Observation Category Codes" display 'Vital Signs'
...
*/

define ObservationCategoryComparison:
  [Observation] O
    where O.category contains ToConcept("Observation Category: Vital Signs")
