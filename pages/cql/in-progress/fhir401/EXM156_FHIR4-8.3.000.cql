library UseofHighRiskMedicationsintheElderly version '8.3.000'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include Hospice_FHIR4 version '2.0.000' called Hospice
include MATGlobalCommonFunctions_FHIR4 version '5.0.000' called Global
include SupplementalDataElements_FHIR4 version '2.0.0' called SDE

codesystem "LOINC": 'http://loinc.org'

valueset "Acetaminophen / Butalbital": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1317'
valueset "Acetaminophen / Butalbital / Caffeine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1363'
valueset "Acetaminophen / Butalbital / Caffeine / Codeine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1326'
valueset "Acetaminophen / Chlorpheniramine / Dextromethorphan": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1421'
valueset "Acetaminophen / Chlorpheniramine / Dextromethorphan / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1310'
valueset "Acetaminophen / Chlorpheniramine / Dextromethorphan / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1321'
valueset "Acetaminophen / Chlorpheniramine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1328'
valueset "Acetaminophen / Chlorpheniramine / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1316'
valueset "Acetaminophen / Dexbrompheniramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1405'
valueset "Acetaminophen / Dextromethorphan / Diphenhydramine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1399'
valueset "Acetaminophen / Dextromethorphan / Doxylamine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1338'
valueset "Acetaminophen / Dextromethorphan / Doxylamine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1287'
valueset "Acetaminophen / Diphenhydramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1350'
valueset "Acetaminophen / Diphenhydramine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1318'
valueset "Amitriptyline  /  Chlordiazepoxide": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1286'
valueset "Amitriptyline / Perphenazine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1428'
valueset "Amitriptyline Hydrochloride": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1373'
valueset "Amoxapine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1273'
valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Anti Infectives, other": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1481'
valueset "Aspirin / Butalbital / Caffeine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1347'
valueset "Aspirin / Caffeine / Orphenadrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1302'
valueset "Atropine / Diphenoxylate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1274'
valueset "Atropine / Hyoscyamine / Phenobarbital / Scopolamine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1355'
valueset "Benztropine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1361'
valueset "Brompheniramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1427'
valueset "Brompheniramine / Codeine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1409'
valueset "Brompheniramine / Codeine / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1450'
valueset "Brompheniramine / Dextromethorphan / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1325'
valueset "Brompheniramine / Dextromethorphan / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1339'
valueset "Brompheniramine / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1332'
valueset "Butabarbital": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1402'
valueset "Carbinoxamine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1306'
valueset "Care Services in Long-Term Residential Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Carisoprodol": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1369'
valueset "Chlophedianol / Chlorpheniramine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1412'
valueset "Chlophedianol / Dexchlorpheniramine / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1447'
valueset "Chlorpheniramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1352'
valueset "Chlorpheniramine / Dextromethorphan / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1312'
valueset "Chlorpheniramine / Dextromethorphan / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1337'
valueset "Chlorpheniramine / Hydrocodone": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1330'
valueset "Chlorpheniramine / Hydrocodone / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1299'
valueset "Chlorpheniramine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1343'
valueset "Chlorpheniramine / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1315'
valueset "Chlorpropamide": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1303'
valueset "Chlorzoxazone": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1362'
valueset "Clemastine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1308'
valueset "Clomipramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1336'
valueset "Conjugated Estrogens": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1357'
valueset "Conjugated Estrogens / Medroxyprogesterone": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1324'
valueset "Cyclobenzaprine Hydrochloride": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1372'
valueset "Cyproheptadine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1277'
valueset "Desiccated Thyroid": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1354'
valueset "Desipramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1278'
valueset "Dexbrompheniramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1375'
valueset "Dexbrompheniramine / Dextromethorphan / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1426'
valueset "Dexbrompheniramine / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1430'
valueset "Dexbrompheniramine Maleate / Pseudoephedrine Hydrochloride": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1429'
valueset "Dexchlorpheniramine / Dextromethorphan / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1300'
valueset "Dexchlorpheniramine / Pseudoephedrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1425'
valueset "Dextromethorphan / Diphenhydramine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1397'
valueset "Dextromethorphan / Doxylamine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1452'
valueset "Dicyclomine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1279'
valueset "Dienogest / Estradiol Multiphasic": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1398'
valueset "Dimenhydrinate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1500'
valueset "Diphenhydramine / Ibuprofen": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1293'
valueset "Diphenhydramine / Phenylephrine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1307'
valueset "Diphenhydramine Hydrochloride": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1371'
valueset "Dipyridamole": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1349'
valueset "Discharge Services - Nursing Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Disopyramide": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1311'
valueset "Drospirenone / Estradiol": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1410'
valueset "Esterified Estrogens": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1419'
valueset "Esterified Estrogens / Methyltestosterone": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1320'
valueset "Estradiol": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1365'
valueset "Estradiol / Norethindrone": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1323'
valueset "Estropipate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1319'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Glyburide": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1368'
valueset "Glyburide / Metformin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1360'
valueset "Guanfacine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1341'
valueset "High Risk Medications for the Elderly": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1253'
valueset "High-Risk Medications With Days Supply Criteria": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1254'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hydrochlorothiazide / Methyldopa": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1414'
valueset "Hydroxyzine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1374'
valueset "Hyoscyamine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1501'
valueset "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1503'
valueset "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl / Sodium Biphosphate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1504'
valueset "Hyoscyamine / Methenamine / Mblue / Sodium Biphosphate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1505'
valueset "Imipramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1359'
valueset "Indomethacin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1366'
valueset "Isoxsuprine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1422'
valueset "Ketorolac Tromethamine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1364'
valueset "List of Single RxNorm Code Concepts for High Risk Drugs for the Elderly": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1272'
valueset "Meclizine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1506'
valueset "Megestrol": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1342'
valueset "Meperidine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1351'
valueset "Meprobamate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1284'
valueset "Metaxalone": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1358'
valueset "Methocarbamol": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1370'
valueset "Methyldopa": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1331'
valueset "Nifedipine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1353'
valueset "Nonbenzodiazepine hypnotics": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1480'
valueset "Nortriptyline": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1507'
valueset "Nursing Facility Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Ophthalmologic Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.11.1206'
valueset "Paroxetine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1508'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Phenobarbital": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1348'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Promethazine Hydrochloride": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1367'
valueset "Protriptyline": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1509'
valueset "Pseudoephedrine / Triprolidine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1345'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Trihexyphenidyl": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1334'
valueset "Trimipramine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1285'
valueset "Triprolidine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1408'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

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

define "Initial Population 1":
exists ( ["Patient"] BirthDate
      where Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period" ) >= 65
			)
				and exists ( "Qualifying Encounters" )

define "Qualifying Encounters":
( [Encounter: "Office Visit"]
		union [Encounter: "Ophthalmologic Services"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Discharge Services - Nursing Facility"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Home Healthcare Services"] ) ValidEncounter
			where ValidEncounter.period during "Measurement Period"
              and ValidEncounter.status  = 'finished'

define "Denominator 1":
"Initial Population 1"

define "Denominator Exclusions":
Hospice."Has Hospice"

define "Numerator 1":
exists ( "Order for High Risk Medication" )
	or exists ( "High Risk Medications With Prolonged Duration" )

define "Order for High Risk Medication":
[MedicationRequest: "High Risk Medications for the Elderly"] HighRiskMedicationOrder
		where HighRiskMedicationOrder.authoredOn during "Measurement Period"
        and HighRiskMedicationOrder.status = 'active'

define "High Risk Medications With Prolonged Duration":
( [MedicationRequest: "High-Risk Medications With Days Supply Criteria"] HighRiskMedicationOrder
			where  HighRiskMedicationOrder.dispenseRequest.expectedSupplyDuration >= 90 days
				and exists (HighRiskMedicationOrder.dosageInstruction.timing T
          where T.repeat.bounds as Period during "Measurement Period")
          and HighRiskMedicationOrder.status = 'active'
	)

define "Numerator 2":
exists ( "Same High Risk Medications Ordered on Different Days" )
	or ( "Two High Risk Medications With Prolonged Duration" )

define "Same High Risk Medications Ordered on Different Days":
	( from
			[MedicationRequest: "List of Single RxNorm Code Concepts for High Risk Drugs for the Elderly"] MedicationOrder1,
			[MedicationRequest: "List of Single RxNorm Code Concepts for High Risk Drugs for the Elderly"] MedicationOrder2
			where MedicationOrder1.authoredOn during "Measurement Period"
				and MedicationOrder2.authoredOn during "Measurement Period"
				and MedicationOrder1.authoredOn 1 day or more after MedicationOrder2.authoredOn
				and MedicationOrder1.medication.coding ~ MedicationOrder2.medication.coding
        			return MedicationOrder1
	)
	//Acetaminophen / Butalbital
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Butalbital"])
	//Acetaminophen / Butalbital / Caffeine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Butalbital / Caffeine"])
	//Acetaminophen / Butalbital / Caffeine / Codeine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Butalbital / Caffeine / Codeine"])
	//Acetaminophen / Chlorpheniramine / Dextromethorphan
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Dextromethorphan"])
	//Acetaminophen / Chlorpheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Dextromethorphan / Phenylephrine"])
	//Acetaminophen / Chlorpheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Dextromethorphan / Pseudoephedrine"])
	//Acetaminophen / Chlorpheniramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Phenylephrine"])
	//Acetaminophen / Chlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Chlorpheniramine / Pseudoephedrine"])
	//Acetaminophen / Dexbrompheniramine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dexbrompheniramine"])
	//Acetaminophen / Dextromethorphan / Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dextromethorphan / Diphenhydramine / Phenylephrine"])
	//Acetaminophen / Dextromethorphan / Doxylamine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dextromethorphan / Doxylamine"])
	//Acetaminophen / Dextromethorphan / Doxylamine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Dextromethorphan / Doxylamine / Phenylephrine"])
	//Acetaminophen / Diphenhydramine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Diphenhydramine"])
	//Acetaminophen / Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Acetaminophen / Diphenhydramine / Phenylephrine"])
	//Amitriptyline / Chlordiazepoxide
		union "More than 1 Of"([MedicationRequest: "Amitriptyline  /  Chlordiazepoxide"])
	//Amitriptyline / Perphenazine
		union "More than 1 Of"([MedicationRequest: "Amitriptyline / Perphenazine"])
	//Amitriptyline Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Amitriptyline Hydrochloride"])
	//Aspirin / Butalbital / Caffeine
		union "More than 1 Of"([MedicationRequest: "Aspirin / Butalbital / Caffeine"])
	//Amoxapine
		union "More than 1 Of"([MedicationRequest: "Amoxapine"])
	//Aspirin / Caffeine / Orphenadrine
		union "More than 1 Of"([MedicationRequest: "Aspirin / Caffeine / Orphenadrine"])
	//Atropine / Hyoscyamine / Phenobarbital / Scopolamine
		union "More than 1 Of"([MedicationRequest: "Atropine / Hyoscyamine / Phenobarbital / Scopolamine"])
	//Atropine / Diphenoxylate
		union "More than 1 Of"([MedicationRequest: "Atropine / Diphenoxylate"])
	//Benztropine
		union "More than 1 Of"([MedicationRequest: "Benztropine"])
	//Brompheniramine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine"])
	//Brompheniramine / Codeine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Codeine / Phenylephrine"])
	//Brompheniramine / Codeine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Codeine / Pseudoephedrine"])
	//Brompheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Dextromethorphan / Phenylephrine"])
	//Brompheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Dextromethorphan / Pseudoephedrine"])
	//Brompheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Brompheniramine / Pseudoephedrine"])
	//Butabarbital
		union "More than 1 Of"([MedicationRequest: "Butabarbital"])
	//Carbinoxamine
		union "More than 1 Of"([MedicationRequest: "Carbinoxamine"])
	//Carisoprodol
		union "More than 1 Of"([MedicationRequest: "Carisoprodol"])
	//Chlophedianol / Chlorpheniramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Chlophedianol / Chlorpheniramine / Phenylephrine"])
	//Chlophedianol / Dexchlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlophedianol / Dexchlorpheniramine / Pseudoephedrine"])
	//Chlorpheniramine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine"])
	//Chlorpheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Dextromethorphan / Phenylephrine"])
	//Chlorpheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Dextromethorphan / Pseudoephedrine"])
	//Chlorpheniramine / Hydrocodone
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Hydrocodone"])
	//Chlorpheniramine / Hydrocodone / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Hydrocodone / Pseudoephedrine"])
	//Chlorpheniramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Phenylephrine"])
	//Chlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Chlorpheniramine / Pseudoephedrine"])
	//Chlorpropamide
		union "More than 1 Of"([MedicationRequest: "Chlorpropamide"])
	//Chlorzoxazone
		union "More than 1 Of"([MedicationRequest: "Chlorzoxazone"])
	//Clemastine
		union "More than 1 Of"([MedicationRequest: "Clemastine"])
	//Clomipramine
		union "More than 1 Of"([MedicationRequest: "Clomipramine"])
	//Conjugated Estrogens
		union "More than 1 Of"([MedicationRequest: "Conjugated Estrogens"])
	//Conjugated Estrogens / Medroxyprogesterone
		union "More than 1 Of"([MedicationRequest: "Conjugated Estrogens / Medroxyprogesterone"])
	//Cyclobenzaprine Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Cyclobenzaprine Hydrochloride"])
	//Cyproheptadine
		union "More than 1 Of"([MedicationRequest: "Cyproheptadine"])
	//Desiccated Thyroid
		union "More than 1 Of"([MedicationRequest: "Desiccated Thyroid"])
	//Desipramine
		union "More than 1 Of"([MedicationRequest: "Desipramine"])
	//Dexbrompheniramine
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine"])
	//Dexbrompheniramine / Dextromethorphan / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine / Dextromethorphan / Phenylephrine"])
	//Dexbrompheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine / Pseudoephedrine"])
	//Dexbrompheniramine Maleate / Pseudoephedrine Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Dexbrompheniramine Maleate / Pseudoephedrine Hydrochloride"])
	//Dexchlorpheniramine / Dextromethorphan / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Dexchlorpheniramine / Dextromethorphan / Pseudoephedrine"])
	//Dexchlorpheniramine / Pseudoephedrine
		union "More than 1 Of"([MedicationRequest: "Dexchlorpheniramine / Pseudoephedrine"])
	//Dextromethorphan / Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Dextromethorphan / Diphenhydramine / Phenylephrine"])
	//Dextromethorphan / Doxylamine
		union "More than 1 Of"([MedicationRequest: "Dextromethorphan / Doxylamine"])
	//Dicyclomine
		union "More than 1 Of"([MedicationRequest: "Dicyclomine"])
	//Dienogest / Estradiol Multiphasic
		union "More than 1 Of"([MedicationRequest: "Dienogest / Estradiol Multiphasic"])
	//Dimenhydrinate
		union "More than 1 Of"([MedicationRequest: "Dimenhydrinate"])
	//Diphenhydramine / Ibuprofen
		union "More than 1 Of"([MedicationRequest: "Diphenhydramine / Ibuprofen"])
	//Diphenhydramine / Phenylephrine
		union "More than 1 Of"([MedicationRequest: "Diphenhydramine / Phenylephrine"])
 //Diphenhydramine Hydrochloride
	union "More than 1 Of"([MedicationRequest: "Diphenhydramine Hydrochloride"])
	//Dipyridamole
		union "More than 1 Of"([MedicationRequest: "Dipyridamole"])
	//Disopyramide
		union "More than 1 Of"([MedicationRequest: "Disopyramide"])
	//Drospirenone / Estradiol
		union "More than 1 Of"([MedicationRequest: "Drospirenone / Estradiol"])
	//Esterified Estrogens
		union "More than 1 Of"([MedicationRequest: "Esterified Estrogens"])
	//Esterified Estrogens / Methyltestosterone
		union "More than 1 Of"([MedicationRequest: "Esterified Estrogens / Methyltestosterone"])
	//Estradiol
		union "More than 1 Of"([MedicationRequest: "Estradiol"])
	//Estradiol / Norethindrone
		union "More than 1 Of"([MedicationRequest: "Estradiol / Norethindrone"])
	//Estropipate
		union "More than 1 Of"([MedicationRequest: "Estropipate"])
	//Glyburide
		union "More than 1 Of"([MedicationRequest: "Glyburide"])
	//Glyburide / Metformin
		union "More than 1 Of"([MedicationRequest: "Glyburide / Metformin"])
	//Guanfacine
		union "More than 1 Of"([MedicationRequest: "Guanfacine"])
	//Hydrochlorothiazide / Methyldopa
		union "More than 1 Of"([MedicationRequest: "Hydrochlorothiazide / Methyldopa"])
	//Hydroxyzine
		union "More than 1 Of"([MedicationRequest: "Hydroxyzine"])
	//Hyoscyamine
		union "More than 1 Of"([MedicationRequest: "Hyoscyamine"])
	//Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl
		union "More than 1 Of"([MedicationRequest: "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl"])
	//Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl / Sodium Biphosphate
		union "More than 1 Of"([MedicationRequest: "Hyoscyamine / Methenamine / Mblue / Phenyl Salicyl / Sodium Biphosphate"])
	//Hyoscyamine / Methenamine / Mblue / Sodium Biphosphate
		union "More than 1 Of"([MedicationRequest: "Hyoscyamine / Methenamine / Mblue / Sodium Biphosphate"])
	//Imipramine
		union "More than 1 Of"([MedicationRequest: "Imipramine"])
	//Indomethacin
		union "More than 1 Of"([MedicationRequest: "Indomethacin"])
	//Isoxsuprine
		union "More than 1 Of"([MedicationRequest: "Isoxsuprine"])
		//Ketorolac Tromethamine
		union "More than 1 Of"([MedicationRequest: "Ketorolac Tromethamine"])
		//Meclizine
		union "More than 1 Of"([MedicationRequest: "Meclizine"])
		//Megestrol
		union "More than 1 Of"([MedicationRequest: "Megestrol"])
	  //Meperidine
		union "More than 1 Of"([MedicationRequest: "Meperidine"])
	//Meprobamate
		union "More than 1 Of"([MedicationRequest: "Meprobamate"])
	//Metaxalone
		union "More than 1 Of"([MedicationRequest: "Metaxalone"])
	//Methocarbamol
		union "More than 1 Of"([MedicationRequest: "Methocarbamol"])
	//Methyldopa
		union "More than 1 Of"([MedicationRequest: "Methyldopa"])
	//Nifedipine
		union "More than 1 Of"([MedicationRequest: "Nifedipine"])
	//Nortriptyline
		union "More than 1 Of"([MedicationRequest: "Nortriptyline"])
	//Paroxetine
		union "More than 1 Of"([MedicationRequest: "Paroxetine"])
	//Phenobarbital
		union "More than 1 Of"([MedicationRequest: "Phenobarbital"])
	//Promethazine Hydrochloride
		union "More than 1 Of"([MedicationRequest: "Promethazine Hydrochloride"])
	//Protriptyline
		union "More than 1 Of"([MedicationRequest: "Protriptyline"])
	//Pseudoephedrine / Triprolidine
		union "More than 1 Of"([MedicationRequest: "Pseudoephedrine / Triprolidine"])
	//Trihexyphenidyl
		union "More than 1 Of"([MedicationRequest: "Trihexyphenidyl"])
	//Trimipramine
		union "More than 1 Of"([MedicationRequest: "Trimipramine"])
	//Triprolidine
		union "More than 1 Of"([MedicationRequest: "Triprolidine"])

define "Two High Risk Medications With Prolonged Duration":
	( "Cumulative Medication Duration"("AntiInfectives During Measurement Period")>= 90
			and "More than One AntiInfective Order"
	)
		or ( "Cumulative Medication Duration"("Hypnotics During Measurement Period")>= 90
				and "More than One Nonbenzodiazepine Hypnotics Order"
		)

define "AntiInfectives During Measurement Period":
	[MedicationRequest: "Anti Infectives, other"] AntiInfectives
		where exists (AntiInfectives.dosageInstruction.timing T
      where T.repeat.bounds as Period during "Measurement Period"
      and AntiInfectives.status = 'active')
      return Interval[AntiInfectives.dosageInstruction.timing.repeat.bounds.start, AntiInfectives.dosageInstruction.timing.repeat.bounds.end]

define function "More than 1 Of"(Medication List<"MedicationRequest">):
	"Medication" OrderMedication1
		with "Medication" OrderMedication2
			such that OrderMedication1.authoredOn 1 day or more after OrderMedication2.authoredOn
				and OrderMedication1.authoredOn during "Measurement Period"
				and OrderMedication2.authoredOn during "Measurement Period"
		return OrderMedication1
define "More than One AntiInfective Order":
	//Anti Infectives, other
	exists ( "More than 1 Of"([MedicationRequest: "Anti Infectives, other"]))

define "Hypnotics During Measurement Period":
	[MedicationRequest: "Nonbenzodiazepine hypnotics"] Hypnotics
		where exists (Hypnotics.dosageInstruction.timing T
      where T.repeat.bounds as Period during "Measurement Period")
      and Hypnotics.status = 'active'

define "More than One Nonbenzodiazepine Hypnotics Order":
	//Nonbenzodiazepine hypnotics
	exists ( "More than 1 Of"([MedicationRequest: "Nonbenzodiazepine hypnotics"]))

define function "Cumulative Medication Duration"(Medication List<Interval<DateTime>>):
  Sum((collapse(Medication))CumulativeMedication
      return all duration in days of CumulativeMedication
  )
