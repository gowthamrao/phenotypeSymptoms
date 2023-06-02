filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
source(file.path(filePath, "01_selected_phenotypes.R"))
source(file.path(filePath, "02_generate_cohorts.R"))

fileNames <- dplyr::tibble(
  folders = list.files(
    path = "D:\\studyResults\\symptomStudy\\CohortCovariates",
    full.names = TRUE,
    include.dirs = TRUE,
    pattern = "cdm_optum_extended_dod_v2434",
    recursive = TRUE
  )
) |>
  dplyr::mutate(
    primaryCohortId = stringr::str_replace(
      string = folders,
      pattern = stringr::fixed("D:\\studyResults\\symptomStudy\\CohortCovariates/"),
      replacement = ""
    )
  ) |>
  dplyr::mutate(
    primaryCohortId = stringr::str_replace(
      string = primaryCohortId
      ,
      pattern = stringr::fixed("/cdm_optum_extended_dod_v2434"),
      replacement = ""
    )
  )


i = 29
analysisRef <- readRDS(file = file.path(fileNames[i,]$folders,
                                        "analysisRef.RDS"))
covariateRef <- readRDS(file = file.path(fileNames[i,]$folders,
                                        "covariateRef.RDS"))
covariates <- readRDS(file = file.path(fileNames[i,]$folders,
                                        "covariates.RDS"))
timeRef <- readRDS(file = file.path(fileNames[i,]$folders,
                                    "timeRef.RDS"))


covariates |>
  dplyr::inner_join(timeRef) |>
  dplyr::inner_join(covariateRef) |>
  dplyr::inner_join(analysisRef) |>
  dplyr::mutate(covariateCohortCohortId = (covariateId - analysisId) / 1000) |>
  # dplyr::filter(cohortId == cohortId) |>
  dplyr::select(
    cohortId,
    startDay,
    endDay,
    covariateCohortCohortId,
    conceptId,
    analysisId,
    covariateId,
    cohortId,
    covariateName,
    analysisName,
    domainId,
    mean,
    sumValue
  ) |>
  dplyr::filter(mean > 0.01) |>
  dplyr::mutate(mean = round(x = mean, digits = 2)) |>
  # dplyr::filter(analysisName == 'ConditionEraGroupOverlap') |>
  dplyr::filter(startDay == 0) |>
  dplyr::filter(endDay == 0) |>
  dplyr::collect() |>
  dplyr::filter(stringr::str_ends(string = as.character(cohortId),
                                  pattern = "001")) |>
  dplyr::inner_join(cohortDefinitionSet |>
                      dplyr::select(cohortId,
                                    cohortName)) |>
  dplyr::arrange(dplyr::desc(mean)) |>
  dplyr::relocate(cohortName) |>
  dplyr::select(cohortName, 
                cohortId,
                covariateCohortCohortId,
                covariateName,
                mean,
                sumValue) |> 
  View()

