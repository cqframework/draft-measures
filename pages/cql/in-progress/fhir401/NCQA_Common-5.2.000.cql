library NCQA_Common version '5.2.000'

using QDM version '5.5'

codesystem "SOP": 'urn:oid:2.16.840.1.113883.3.221.5'

valueset "Hospice Encounter": 'urn:oid:2.16.840.1.113883.3.464.1004.1761'
valueset "Hospice Intervention": 'urn:oid:2.16.840.1.113883.3.464.1004.1762'

code "MEDICAID": '2' from "SOP" display 'MEDICAID'
code "MEDICARE": '1' from "SOP" display 'MEDICARE'
code "PRIVATE HEALTH INSURANCE": '5' from "SOP" display 'PRIVATE HEALTH INSURANCE'

parameter "Measurement Period" Interval<DateTime>
parameter "ProductLine" String

context Patient

define "Commercial Product":
  'commercial'

define "First Predecessor Year":
  Interval[start of "Measurement Period" - 1 year, start of "Measurement Period" )

define "Is Commercial":
  exists ( ["Patient Characteristic Payer": "PRIVATE HEALTH INSURANCE"] )

define "Is Medicaid":
  exists ( ["Patient Characteristic Payer": "MEDICAID"] )

define "Is Medicare":
  exists ( ["Patient Characteristic Payer": "MEDICARE"] )

define "Medicaid Product":
  'medicaid'

define "Medicare Product":
  'medicare'

define "Participation":
  ["Participation": "PRIVATE HEALTH INSURANCE"]
    union ["Participation": "MEDICARE"]
    union ["Participation": "MEDICAID"]

define "Hospice Intervention or Encounter":
  ( ["Intervention, Performed": "Hospice Intervention"] Hospice
      where Hospice.relevantPeriod overlaps "Measurement Period"
  )
    union ( ["Encounter, Performed": "Hospice Encounter"] HospiceEncounter
        where HospiceEncounter.relevantPeriod overlaps "Measurement Period"
    )

define function "Participation In Period"(ParticipationPeriod Interval<DateTime> ):
  collapse ( Participation P
      let I: P.participationPeriod
        intersect ParticipationPeriod
      where P.participationPeriod overlaps ParticipationPeriod
      return all Interval[ToDate(start of I), predecessor of ( ToDate(
          end of I
        )+ 1 day
      )]
  )

define function "Is Enrolled On Date"(ProductLine String, IndexDate DateTime ):
  exists ( ( case ProductLine
      when "Commercial Product" then ["Participation": "PRIVATE HEALTH INSURANCE"]
      when "Medicare Product" then ["Participation": "MEDICARE"]
      when "Medicaid Product" then ["Participation": "MEDICAID"]
      else null
    end ) P
      where IndexDate during P.participationPeriod
  )

define function "MemberAgeInYearsAt"(date Date ):
  years between ToDate(Patient.birthDatetime)and date

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

define function "Product Line"(ProductLine String, IndexDate DateTime, ParticipationPeriod Interval<DateTime> ):
  ToProductLine(Last(("Participation" P
        where P.participationPeriod overlaps Interval[Coalesce(IndexDate, start of ParticipationPeriod), Coalesce(IndexDate,
          end of ParticipationPeriod
        )]
        sort by
        end of participationPeriod)E
        where ProductLine is null
          or E.code ~ ToProductCode(ProductLine)
    ).code
  )

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

define function "ToProductCode"(ProductLine String ):
  case ProductLine
    when "Commercial Product" then "PRIVATE HEALTH INSURANCE"
    when "Medicare Product" then "MEDICARE"
    when "Medicaid Product" then "MEDICAID"
    else null
  end

define function "ToProductLine"(ProductCode Code ):
  case
    when ProductCode ~ "PRIVATE HEALTH INSURANCE" then "Commercial Product"
    when ProductCode ~ "MEDICARE" then "Medicare Product"
    when ProductCode ~ "MEDICAID" then "Medicaid Product"
    else null
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
