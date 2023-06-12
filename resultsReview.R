# set up----
filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
resultsFolder <- file.path("D:\\studyResults\\symptomStudy",
                           "Report")

dir.create(path = resultsFolder,
           showWarnings = FALSE,
           recursive = TRUE)

source(file.path(filePath, "00_common.R"))

#Information on datasources-----
databaseInformation <- cdmSources |>
  dplyr::filter(
    database %in% PrivateScripts::getListOfDatabaseIds(filterToUsData = TRUE, filterToClaims = TRUE)
  ) |>
  dplyr::select(sourceKey,
                databaseId,
                database,
                databaseDescription) |>
  dplyr::distinct() |>
  dplyr::rename(
    databaseName = databaseId,
    databaseId = sourceKey,
    databaseNameUnformatted = database
  )

# target cohorts----
targetCohortIds <- c(
  27,
  33,
  68,
  70,
  71,
  72,
  74,
  220,
  234,
  238,
  248,
  249,
  251,
  258,
  284,
  292,
  329,
  356,
  362,
  366,
  367,
  372,
  395,
  396,
  407,
  410
)
removeNotAcute <- c(33, 238, 396)
otherRemove <- c(395, 407, 72, 220, 356, 366, 367, 372, 410)
targetCohortIds <- setdiff(x = targetCohortIds,
                           y = c(removeNotAcute,
                                 otherRemove))



# cohorts ----
targetFeatureCohortReference <- readRDS(file = file.path(filePath,
                                                         "cohortsToStudy.RDS")) |>
  dplyr::filter(targetCohortIds %in% targetCohortIds)

featureCohorts <-
  PhenotypeLibrary::getPhenotypeLog() |>
  dplyr::select(cohortId,
                cohortName) |>
  dplyr::mutate(targetCohortFormattedName = PrivateScripts::createGoodCohortNames(text = cohortName)) |>
  dplyr::select(-cohortName) |>
  dplyr::rename(cohortName = targetCohortFormattedName)

targetFeatureCohortReference <- targetFeatureCohortReference |>
  dplyr::select(targetCohortIds,
                featureCohortIds) |>
  dplyr::distinct() |>
  dplyr::arrange(targetCohortIds,
                 featureCohortIds) |>
  dplyr::rename(cohortId = featureCohortIds) |>
  dplyr::inner_join(featureCohorts) |>
  dplyr::mutate(name = paste0(cohortName,
                              " (",
                              cohortId,
                              ")")) |>
  dplyr::select(targetCohortIds,
                name) |>
  dplyr::group_by(targetCohortIds) |>
  dplyr::mutate(comma = paste0(name, collapse = ", ")) |>
  dplyr::select(targetCohortIds,
                comma) |>
  dplyr::rename(cohortId = targetCohortIds,
                symptoms = comma) |>
  dplyr::distinct()


targetCohortsUsedInStudy <- readRDS(file = file.path(filePath,
                                                     "cohortDefinitionSet.RDS")) |>
  dplyr::filter(subsetParent %in% targetCohortIds)

targetCohortFormattedName <- targetCohortsUsedInStudy |>
  dplyr::filter(subsetParent == cohortId) |>
  dplyr::select(cohortId, cohortName) |>
  dplyr::distinct() |>
  dplyr::mutate(targetCohortFormattedName = PrivateScripts::createGoodCohortNames(text = cohortName)) |>
  dplyr::select(-cohortName) |>
  dplyr::rename(subsetParent = cohortId)

targetCohortsUsedInStudy <- targetCohortsUsedInStudy |>
  dplyr::inner_join(targetCohortFormattedName)

databaseIds <- PrivateScripts::getListOfDatabaseIds()


#cohorts
cohortGenerator <- file.path(rootFolder, "CohortGenerator")
cohortGenerator <- PrivateScripts::consolidateCohortGeneratorOutput(
  inputFolder = cohortGenerator,
  outputFolder = file.path(cohortGenerator,
                           'combined'),
  overwrite = TRUE
)


table <- cohortGenerator$cohortCount |>
  dplyr::filter(databaseId != 'combined') |>
  dplyr::tibble() |>
  dplyr::inner_join(
    targetCohortsUsedInStudy |>
      dplyr::select(cohortId,
                    targetCohortFormattedName,
                    subsetParent) |>
      dplyr::distinct() |>
      dplyr::rename(cohortName = targetCohortFormattedName),
    by = "cohortId"
  ) |>
  dplyr::relocate(cohortId,
                  cohortName) |>
  dplyr::arrange(subsetParent,
                 cohortId) |>
  dplyr::filter(cohortId == subsetParent |
                  cohortId == (subsetParent * 1000) + 1) |>
  dplyr::select(-cohortEntries) |>
  dplyr::mutate(source = ifelse(
    test = cohortId == subsetParent,
    yes = "main",
    no = "subset"
  )) |> tidyr::pivot_wider(
    id_cols = c(subsetParent, databaseId),
    names_from = source,
    values_from = cohortSubjects
  ) |>
  dplyr::mutate(proportion = (subset / main) * 100) |>
  dplyr::mutate(report = prettyNum(
    x = subset,
    big.mark = ",",
    scientific = FALSE
  )) |>
  dplyr::select(subsetParent,
                databaseId,
                report) |>
  dplyr::inner_join(databaseInformation |>
                      dplyr::select(databaseId,
                                    databaseName)) |>
  dplyr::mutate(report = paste0(databaseName,
                                " = ",
                                report)) |>
  dplyr::select(subsetParent,
                report) |>
  dplyr::distinct() |>
  dplyr::group_by(subsetParent) |>
  dplyr::mutate(report = paste0(report, collapse = "\n")) |>
  dplyr::distinct() |>
  dplyr::left_join(targetFeatureCohortReference |>
                     dplyr::rename(subsetParent = cohortId)) |>
  dplyr::inner_join(
    targetCohortsUsedInStudy |>
      dplyr::select(subsetParent,
                    targetCohortFormattedName) |>
      dplyr::distinct()
  ) |>
  dplyr::relocate(subsetParent,
                  targetCohortFormattedName) |>
  dplyr::rename(cohortId = subsetParent,
                cohortName = targetCohortFormattedName)


##########

featureExtractionOutput <- c()
for (i in (1:length(targetCohortIds))) {
  cohortId <- targetCohortIds[[i]]
  dataFolder <-
    file.path("D:\\studyResults\\symptomStudy\\CovariateCohorts",
              cohortId)
  featureExtractionOutput[[i]] <-
    PrivateScripts::consolidateFeatureExtractionOutput(inputFolder = dataFolder,
                                                       groupName = "databaseId",
                                                       overwrite = TRUE)
  featureExtractionOutput[[i]]$analysisRef[["primaryCohortId"]] <-
    cohortId
  featureExtractionOutput[[i]]$covariateRef[["primaryCohortId"]] <-
    cohortId
  featureExtractionOutput[[i]]$covariates[["primaryCohortId"]] <-
    cohortId
  featureExtractionOutput[[i]]$timeRef[["primaryCohortId"]] <-
    cohortId
  featureExtractionOutput[[i]]$covariateContinous[["primaryCohortId"]] <-
    cohortId
}

featureExtraction <- c()
for (i in (1:length(featureExtractionOutput))) {
  featureExtraction$analysisRef <-
    dplyr::bind_rows(featureExtractionOutput[[i]]$analysisRef,
                     featureExtraction$analysisRef)
  
  featureExtraction$covariateRef <-
    dplyr::bind_rows(featureExtractionOutput[[i]]$covariateRef,
                     featureExtraction$covariateRef)
  
  featureExtraction$covariates <-
    dplyr::bind_rows(featureExtractionOutput[[i]]$covariates,
                     featureExtraction$covariates)
  
  featureExtraction$timeRef <-
    dplyr::bind_rows(featureExtractionOutput[[i]]$timeRef,
                     featureExtraction$timeRef)
  
  featureExtraction$covariateContinous <-
    dplyr::bind_rows(
      featureExtractionOutput[[i]]$covariateContinous,
      featureExtraction$covariateContinous
    )
}


###########


tableSymptoms <- featureExtraction$covariates |>
  dplyr::filter(databaseId %in% c(databaseInformation$databaseId |> unique())) |>
  dplyr::filter(primaryCohortId %in% targetCohortIds) |>
  dplyr::filter(cohortId == (primaryCohortId * 1000) + 1) |>
  dplyr::inner_join(targetCohortsUsedInStudy |>
                      dplyr::select(cohortId,
                                    cohortName,
                                    subsetParent),
                    by = "cohortId") |>
  dplyr::inner_join(
    targetCohortsUsedInStudy |>
      dplyr::select(subsetParent,
                    targetCohortFormattedName) |>
      dplyr::distinct()
  ) |>
  dplyr::select(-cohortId,-cohortName) |>
  dplyr::rename(cohortName = targetCohortFormattedName,
                cohortId = subsetParent) |>
  dplyr::relocate(cohortName,
                  primaryCohortId) |>
  dplyr::inner_join(featureExtraction$covariateRef) |>
  dplyr::mutate(featureCohortId = (covariateId - analysisId) / 1000) |>
  dplyr::left_join(
    featureCohorts |>
      dplyr::rename(featureCohortId = cohortId,
                    featureCohortName = cohortName) |>
      dplyr::bind_rows(
        dplyr::tibble(featureCohortId = -1,
                      featureCohortName = "Composite")
      )
  ) |>
  dplyr::inner_join(featureExtraction$timeRef |>
                      dplyr::filter(startDay == 0,
                                    endDay == 0)) |>
  dplyr::inner_join(databaseInformation |>
                      dplyr::select(databaseId,
                                    databaseName)) |>
  dplyr::select(
    -covariateId,-covariateName,-analysisId,-conceptId,-timeId,-startDay,-endDay,
    -databaseId,-sd,-sumValue,-primaryCohortId
  ) |>
  dplyr::mutate(meanPct = PrivateScripts::percentFormat(x = mean, digits = 1)) |>
  dplyr::arrange(cohortId,
                 featureCohortId) |>
  dplyr::relocate(
    cohortId,
    cohortName,
    featureCohortId,
    featureCohortName,
    databaseName,
    mean,
    meanPct
  )


tableSymptomsRange <-
  tableSymptoms |>
  dplyr::filter(mean > 0.05) |>
  dplyr::group_by(cohortId,
                  featureCohortId) |>
  dplyr::summarise(minMean = PrivateScripts::percentFormat(x = min(mean), digits = 1)) |>
  dplyr::inner_join(
    tableSymptoms |>
      dplyr::filter(mean > 0.05) |>
      dplyr::group_by(cohortId,
                      featureCohortId) |>
      dplyr::summarise(maxMean = PrivateScripts::percentFormat(x = max(mean), digits = 1))
  ) |>
  dplyr::mutate(range = paste0(minMean, " - ", maxMean)) |>
  dplyr::select(cohortId,
                featureCohortId,
                range)

tableSymptomsFinal <- tableSymptoms |>
  dplyr::select(cohortId,
                cohortName,
                featureCohortId,
                featureCohortName) |>
  dplyr::distinct() |>
  dplyr::inner_join(tableSymptomsRange) |>
  dplyr::mutate(report = paste0(featureCohortId,
                                ":",
                                featureCohortName,
                                " [",
                                range,
                                "]")) |>
  dplyr::select(cohortId,
                cohortName,
                report) |>
  dplyr::rename(range = report) |>
  dplyr::group_by(cohortId,
                  cohortName) |>
  dplyr::mutate(range = paste0(range, collapse = "\n")) |>
  dplyr::distinct()

table <- table |>
  dplyr::select(-symptoms) |>
  dplyr::inner_join(tableSymptomsFinal) |>
  dplyr::rename(
    'Id' = cohortId,
    'Cohort' = cohortName,
    'Data Source-' = report,
    'Symptom co-occurrence' = range
  )

openxlsx::write.xlsx(
  x = table,
  file = file.path(resultsFolder, "Table 1.xlsx"),
  asTable = TRUE,
  overwrite = TRUE
)
openxlsx::openXL(file = file.path(resultsFolder, "Table 1.xlsx"))
