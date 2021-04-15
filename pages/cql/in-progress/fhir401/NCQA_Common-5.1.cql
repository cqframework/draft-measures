library NCQA_Common version '5.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0'


// ADP - the HEDIS IG does not apply to this library at this time

// The hedis-ig has defined the ncqa-payer value set:
// http://ncqa.org/fhir/hedis/ValueSet/ncqa-payer (2.16.840.1.113762.1.4.1165.42)
// I cannot see the contents of this value set, it doesn't show up in VSAC
// But looking at the contents of the HL7 SOP value set (2.16.840.1.114222.4.11.3591):
// It seems like we ought to be specifying value sets rather than direct reference codes for
// "MEDICAID", "MEDICARE", and "PRIVATE HEALTH INSURANCE"
// Do those value sets exist already?

codesystem "SOP": 'urn:oid:2.16.840.1.113883.3.221.5'
//codesystem "SOP": 'http://www.nlm.nih.gov/research/umls/sop'

codesystem "SNOMEDCT:2017-09": 'http://snomed.info/sct/731000124108' version 'http://snomed.info/sct/731000124108/version/201709'

valueset "Hospice Encounter":'https://www.ncqa.org/fhir/valueset/2.16.840.1.113883.3.464.1004.1761'
valueset "Hospice Intervention": 'https://www.ncqa.org/fhir/valueset/2.16.840.1.113883.3.464.1004.1762'

// ADP - value sets above are referenced by Apelon.

/* valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1108.15' */

//SOP codes

code "MEDICAID": '2' from "SOP" display 'MEDICAID'
code "MEDICARE": '1' from "SOP" display 'MEDICARE'
code "PRIVATE HEALTH INSURANCE": '5' from "SOP" display 'PRIVATE HEALTH INSURANCE'

// ADP - using codes

/* // Valuesets for "MEDICAID", "MEDICARE", and "PRIVATE HEALTH INSURANCE":
valueset "MEDICAID": 'TBD'
valueset "MEDICARE": 'TBD'
valueset "PRIVATE HEALTH INSURANCE": 'TBD' */

// Is it these value sets?
//valueset "Medicare": 'http://ncqa.org/hedis/ValueSet/2.16.840.1.113762.1.4.1165.44'
//valueset "Medicaid": 'http://ncqa.org/hedis/ValueSet/2.16.840.1.113762.1.4.1165.45'
//valueset "Commercial": 'http://ncqa.org/hedis/ValueSet/2.16.840.1.113762.1.4.1165.46'

//code "MEDICAID": '2' from "SOP" display 'MEDICAID'
//code "MEDICARE": '1' from "SOP" display 'MEDICARE'
//code "PRIVATE HEALTH INSURANCE": '5' from "SOP" display 'PRIVATE HEALTH INSURANCE'

//ADP - not sure where these codes are from

/* code "Discharge to healthcare facility for hospice care (procedure)": '428371000124100' from "SNOMEDCT:2017-09" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)": '428361000124107' from "SNOMEDCT:2017-09" display 'Discharge to home for hospice care (procedure)' */

parameter "Measurement Period" Interval<DateTime>
parameter "ProductLine" String

context Patient

define "Medicaid Product":
  'medicaid'

define "Medicare Product":
  'medicare'

define "Commercial Product":
  'commercial'

define "First Predecessor Year":
  Interval[start of "Measurement Period" - 1 year, start of "Measurement Period" )

define "Participation":
  [Coverage: "PRIVATE HEALTH INSURANCE"]
  	union [Coverage: "MEDICARE"]
  	union [Coverage: "MEDICAID"]

define "LOG":
  1 + 1 = 2
  /*
  NCQA Common Library Update 9.3.2019 from version 5.0. This library is updated to QDM 5.5 and contains updated logic for plan enrollment/participation, stratification and the hospice exclusion.

  NCQA Common Library Update 5.31.2019 from version 4.7. This library contains updated logic for plan enrollment/participation, stratification and the hospice exclusion.

  Instructions for Use:

  Include the NCQA_Common library in the HEDIS measure you are working on. Give the library the alias name "Common" (without quotes) which will allow the measure author the ability to invoke the library in expressions in the measure and standardize expressions using the NCQA_Common library between measures.

  Instructions for expressing plan enrollment in HEDIS measures:

  Step 1 - Add a Parameter definition to the measure logic called Product Line

  The expression is a single word: String

  Step 2 - choose from an example below to define plan enrollment for your measure

  Example 1 - One Year Continuously Enrolled with a 45 day gap

  Common."Is Enrolled"("Product Line", end of "Measurement Period", Interval[start of "Measurement Period", end of "Measurement Period"], 45)

  If your gap is "0" days or a different number of days, enter "0" or the number of days.You must enter a digit, even if the gap is zero days.

  Example 2 - Two Years Continuously Enrolled with a 0 day gap

  Common."Is Enrolled"("Product Line", end of "Measurement Period", Interval[start of "Measurement Period" - 1 year, end of "Measurement Period"], 0)

  Add the timing for one year (- 1 year) before the comma

  Example 3 - Twenty Seven Months Continuously Enrolled with a 45 day gap

  Common."Is Enrolled"("Product Line", end of "Measurement Period", Interval[start of "Measurement Period" - 2 years - 3 months, end of "Measurement Period"], 45)

  Add "2 years - 3 months" before the comma and after the start of the Measurement Period in this expression.

  Example 4 - Continously enrolled for 28 days prior to an event with no gap

  Common."Is Enrolled"("Product Line", "Event", Interval["Event" - 28 days, "Event"], 0)

  Example 5 - Continuously enrolled with no gaps during the 9 months prior to an Event and allowing a 45 day gap after the Event

  Common."Is Enrolled"("Product Line", "Event", Interval["Event" - 9 months, "Event"], 0)
  and Common."Is Enrolled"("Product Line", "Event", Interval["Event", end of "Measurement Period"], 45)

  In order to express plan enrollment around an event a definition is required for that "Event" in the measure.

  This "Event" definition must return a System.DateTime in order to calculate enrollment around a specific activity.

  To differentiate this from other expressions in the measure name the expression with the word "Event" in the logic.
  Examples of names are: "Index Prescription Event" or "Delivery Event"

  Step 3 - Name the definition that describes plan enrollment, "Enrolled During Participation Period"

  Instructions for expressing stratification in HEDIS measures:

  Create a definition for each plan and population.The definition names for stratification should follow the naming conventions in the narrative header

  Example definitions for Stratification

  define "Stratification 1":

  exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
  where Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")between 12 and 17)

  and Common."Product Line"("Product Line", end of “Measurement Period”, Interval[start of "Measurement Period",end of "Measurement Period"])= Common."Commercial Product"

  Stratification Example 2: - Using “null” in Stratification to report Plan Participation at the end of the Participation Period

  To report which product line a member is enrolled in at the end of the Participation Period, “null” is substituted for the Index Date in the stratification logic. The use of “null” in the stratification logic will take the product in which the member is enrolled on the day closest to the end of the participation period.  Without the use of “null” in an expression for stratification, the logic functions to report the product in which the member is enrolled on the index date.

  Stratification 2
  Common."Product Line"("Product Line", null, "Measurement Period" = Common."Commercial Product"

  Create a stratification definition for each product line the member is enrolled in as well as stratification definitions for age ranges if applicable.

  Instructions for expressing the Hospice exclusion in HEDIS measures:

  Call the Hospice exclusion by invoking the alias you've assigned

  Common."Hospice Intervention or Encounter"
  */

/* define function "Has Hospice"(MeasurementPeriod Interval<DateTime>):
	exists (
	    [Encounter: "Encounter Inpatient"] DischargeHospice
			where DischargeHospice.status = 'finished'
			    and (
		        DischargeHospice.hospitalization.dischargeDisposition ~ "Discharge to home for hospice care (procedure)"
  				    or DischargeHospice.hospitalization.dischargeDisposition ~ "Discharge to healthcare facility for hospice care (procedure)"
			    )
				and DischargeHospice.period ends during day of MeasurementPeriod
	)
    or exists (
        [ServiceRequest: "Hospice care ambulatory"] HospiceOrder
            where HospiceOrder.intent = 'order'
                and HospiceOrder.authoredOn in day of MeasurementPeriod
    )
    or exists (
        [Procedure: "Hospice care ambulatory"] HospicePerformed
            where HospicePerformed.status = 'completed'
                and "Normalize Interval"(HospicePerformed.performed) overlaps MeasurementPeriod
    ) */

define function "Participation In Period"(ParticipationPeriod Interval<DateTime> ):
  collapse ( Participation P
  			let I: P.period
  				intersect ParticipationPeriod
  			where P.period overlaps ParticipationPeriod
  			return all Interval[ToDate(start of I), predecessor of ( ToDate(
  					end of I
  				)+ 1 day
  			)]
  	)

define function "Is Enrolled On Date"(ProductLine String, IndexDate DateTime ):
  exists ( (
  	case ProductLine
  		when "Commercial Product" then [Coverage: "PRIVATE HEALTH INSURANCE"]
  		when "Medicare Product" then [Coverage: "MEDICARE"]
  		when "Medicaid Product" then [Coverage: "MEDICAID"]
  		else null
  	end ) P
  		where IndexDate during P.period
  )

define function "MemberAgeInYearsAt"(date Date ):
  years between Patient.birthDate and date

define function "Enrollment Periods"(ParticipationPeriod Interval<DateTime> ):
  ( { 3 years, 2 years, 1 year } ) Year
  	where
  	end of ParticipationPeriod - ( Year - 1 year ) after start of ParticipationPeriod
  	return Interval[Max({ successor of(
  			end of ParticipationPeriod - Year
  		), start of ParticipationPeriod }
  	),
  	end of ParticipationPeriod - ( Year - 1 year )]

define function "Is Continuously Enrolled In Period"(EnrollmentPeriod Interval<DateTime>, AllowedGapDays Integer ):
  "Gap Days In Period"(EnrollmentPeriod, "Participation In Period"(EnrollmentPeriod))<= AllowedGapDays

define function "Is Enrolled"(ProductLine String, IndexDate DateTime, ParticipationPeriod Interval<DateTime>, AllowedGapDays Integer ):
  ( ProductLine is null
      or "Is Enrolled On Date"(ProductLine, IndexDate)
  )
    and AllTrue(("Enrollment Periods"(ParticipationPeriod))EnrollmentPeriod
        return "Is Continuously Enrolled In Period"(EnrollmentPeriod, if duration in months of EnrollmentPeriod >= 6 then AllowedGapDays
            else 0
        )
    )

define function "Product Line Participation"(ProductLine String, IndexDate DateTime, ParticipationPeriod Interval<DateTime>):
  Last(
    (
      "Participation" P
        where P.period
          overlaps Interval[Coalesce(IndexDate, start of ParticipationPeriod),
            Coalesce(IndexDate, end of ParticipationPeriod)]
        sort by end of period
    ) E
      where ProductLine is null
        or case ProductLine
          when "Commercial Product" then E.type ~ "PRIVATE HEALTH INSURANCE"
          when "Medicare Product" then E.type ~ "MEDICARE"
          when "Medicaid Product" then E.type ~ "MEDICAID"
          else null
        end
  )

// Use to define Commercial Stratification Criteria
define function "Is Enrolled Commercial"(ProductLine String, IndexDate DateTime, ParticipationPeriod Interval<DateTime>):
  "Product Line Participation"(ProductLine, IndexDate, ParticipationPeriod).type ~ "PRIVATE HEALTH INSURANCE"

// Use to define Medicare Stratification Criteria
define function "Is Enrolled Medicare"(ProductLine String, IndexDate DateTime, ParticipationPeriod Interval<DateTime>):
  "Product Line Participation"(ProductLine, IndexDate, ParticipationPeriod).type ~ "MEDICARE"

// Use to define Medicaid Stratification Criteria
define function "Is Enrolled Medicaid"(ProductLine String, IndexDate DateTime, ParticipationPeriod Interval<DateTime>):
  "Product Line Participation"(ProductLine, IndexDate, ParticipationPeriod).type ~ "MEDICAID"

define function "Gap Days In Period"(ParticipationPeriod Interval<DateTime>, Periods List<Interval<DateTime>> ):
  case Count(Periods)
    when 1 then if Periods[0]starts day of ParticipationPeriod then difference in days between
    end of Periods[0]and
    end of ParticipationPeriod
      else if Periods[0]ends day of ParticipationPeriod then difference in days between start of ParticipationPeriod and start of Periods[0]
      else maximum Integer
    when 2 then if Periods[0]starts day of ParticipationPeriod
      and Periods[1]ends day of ParticipationPeriod then difference in days between
    end of Periods[0]and start of Periods[1]
      else maximum Integer
    else maximum Integer
  end

define function "CalendarAgeInDaysAt"(BirthDateTime DateTime, AsOf DateTime ):
  days between ToDate(BirthDateTime)and ToDate(AsOf)

define function "CalendarAgeInDays"(BirthDateTime DateTime ):
  CalendarAgeInDaysAt(BirthDateTime, Today())

define function "CalendarAgeInMonthsAt"(BirthDateTime DateTime, AsOf DateTime ):
  months between ToDate(BirthDateTime)and ToDate(AsOf)

define function "CalendarAgeInMonths"(BirthDateTime DateTime ):
  CalendarAgeInMonthsAt(BirthDateTime, Today())

define function "LengthInDays"(Value Interval<DateTime> ):
  difference in days between start of Value and
  end of Value

define function "CalendarAgeInYearsAt"(BirthDateTime DateTime, AsOf DateTime ):
  years between ToDate(BirthDateTime)and ToDate(AsOf)

define function "CalendarAgeInYears"(BirthDateTime DateTime ):
  CalendarAgeInYearsAt(BirthDateTime, Today())

define function "ToDate"(Value DateTime ):
  DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezoneoffset from Value)

define function "Normalize Interval"(choice Choice<FHIR.dateTime, FHIR.Period, FHIR.Timing, FHIR.instant, FHIR.string, FHIR.Age, FHIR.Range>):
  case
	  when choice is FHIR.dateTime then
    	Interval[FHIRHelpers.ToDateTime(choice as FHIR.dateTime), FHIRHelpers.ToDateTime(choice as FHIR.dateTime)]
		when choice is FHIR.Period then
  		FHIRHelpers.ToInterval(choice as FHIR.Period)
		when choice is FHIR.instant then
			Interval[FHIRHelpers.ToDateTime(choice as FHIR.instant), FHIRHelpers.ToDateTime(choice as FHIR.instant)]
		when choice is FHIR.Age then
		  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age),
			  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age) + 1 year)
		when choice is FHIR.Range then
		  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).low),
			  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).high) + 1 year)
		when choice is FHIR.Timing then
		  Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute a single interval from a Timing type')
    when choice is FHIR.string then
      Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute an interval from a String value')
		else
			null as Interval<DateTime>
	end
