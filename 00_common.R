rootFolder <- "D:/studyResults/symptomStudy"
projectCode <- "symptomStudy"

targetCohortTableName <- projectCode
temporalStartDays <- c(0, -7, -7, 0, -30)
temporalEndDays <- c(0, 7, 0, 7, 30)
unionCovariateCohorts <- TRUE

databaseIds <- c(
  "truven_ccae",
  "truven_mdcd",
  "cprd" ,
  "jmdc",
  "optum_extended_dod",
  "optum_ehr",
  "truven_mdcr",
  "ims_australia_lpd",
  "ims_germany",
  "ims_france" ,
  "iqvia_pharmetrics_plus"
)