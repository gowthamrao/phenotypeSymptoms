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





# phenotypes
pneumonia <- dplyr::tibble(
  label = 'pneumonia',
  targetCohortIds = 329,
  featureCohortIds = c(5, 3, 278, 6, 11, 12, 9, 368, 327, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

strepThoat <- dplyr::tibble(
  label = 'strep throat',
  targetCohortIds = 366,
  featureCohortIds = c(6,278,12,392,3,368,11, 14, 5, 11, 191,3, 6, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

otitisMedia <- dplyr::tibble(
  label = 'otitis media',
  targetCohortIds = 372,
  featureCohortIds = c(12, 9, 327, 368, 354, 278, 3, 20, 367, 391, 6, 353, 355, 352, 14, 5, 11, 191,3, 6),
  notes = "removed 369 because not a symptom, removed 64"
)

cardiacFailure <- dplyr::tibble(
  label = 'Cardiac Failure',
  targetCohortIds = 68,
  featureCohortIds = c( 5, 278, 282, 359, 11, 332, 191, 280, 364, 358, 194, 57, 339, 3, 341, 244, 6, 10, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

hepaticFailure <- dplyr::tibble(
  label = 'Hepatic Failure',
  targetCohortIds = 292,
  featureCohortIds = c(278, 289, 5, 280, 341, 11, 191, 332, 57, 339, 10, 335, 61, 274, 240, 364, 219, 193, 380, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

epistaxis <- dplyr::tibble(
  label = 'Epistaxis',
  targetCohortIds = 356,
  featureCohortIds = c(12, 354, 278, 368, 5, 7, 332, 9, 280, 11, 391, 3, 191, 392, 10, 14, 5, 11, 191,3, 6),
  notes = 'removed 369 because allergic condition is not a symptom, removed 64'
)

acuteKidneyInjury <- dplyr::tibble(
  label = 'Acute Kidney Injury',
  targetCohortIds = 362,
  featureCohortIds = c(278, 5, 282, 280, 11, 191, 359, 332, 194, 358, 339, 10, 364, 57, 341, 331, 299, 3, 6, 4, 244, 7, 348, 398, 95, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

angioedema <- dplyr::tibble(
  label = 'Angioedema',
  targetCohortIds = 220,
  featureCohortIds = c(12,354, 278, 5, 280, 3, 7, 9, 11, 193, 353, 368, 381, 191, 
                       392, 415, 416, 14, 5, 11, 191,3, 6),
  notes = "removed 241 urticaria because angioedema and urticaria has a pre-cordinated code called Angioedema and/or urticaria,
  removed 340 added 415 erythema, 416, 
  removed 369 as part of the entry event for Angioedema
  removed 64"
)

allergicRhinitis <- dplyr::tibble(
  label = 'Allergic Rhinitis',
  targetCohortIds = 367,
  featureCohortIds = c(278, 368, 3, 9, 327, 392, 7, 353, 5, 11, 191, 340, 351, 14, 5, 11, 191,3, 6, 415, 414, 416),
  notes = "removed 64"
)

dysmenorrhea <- dplyr::tibble(
  label = 'Dysmenorrhea',
  targetCohortIds = 395,
  featureCohortIds = c(278, 280, 300, 11, 279, 7, 191, 10, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

acuteUti <- dplyr::tibble(
  label = 'Acute Urinary Tract Infection',
  targetCohortIds = 410,
  featureCohortIds = c(6, 365, 278, 280, 281, 241, 348, 191, 339, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

# sepsisOrSepticShock <- dplyr::tibble(
#   label = 'Sepsis or Septic Shock',
#   targetCohortIds = 411,
#   featureCohortIds = c(278, 324, )
# )

hemorrhoids <- dplyr::tibble(
  label = 'Hemorrhoids',
  targetCohortIds = 407,
  featureCohortIds = c(57, 278, 349, 280, 4, 332, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

atypicalPneumonia <- dplyr::tibble(
  label = 'atypical pneumonia',
  targetCohortIds = 407,
  featureCohortIds = c(5, 3, 278, 20, 359, 358, 6, 11, 191, 403, 332, 12, 10, 57, 9, 331, 339, 368, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

asthmaOrCopd <- dplyr::tibble(
  label = 'asthma or copd',
  targetCohortIds = 26,
  featureCohortIds = c(278,  12, 5, 3, 354, 332, 368, 11, 191, 9, 14, 5, 11, 191,3, 6),
  notes = "removed 20 because bronchitis is parent of emphysematous bronchitis an entry event criteria for bronchitis
  removed 369 because not a symptom, removed 64"
)

asthma <- dplyr::tibble(
  label = 'asthma',
  targetCohortIds = 27,
  featureCohortIds = c(12, 354, 278, 20, 3, 5, 368, 9, 392, 11, 7,191, 327, 328, 6),
  notes = "removed 369 because part of asthma definition entry event criteria, removed 64"
)

tuberculosis <- dplyr::tibble(
  label = 'tuberculosis',
  targetCohortIds = 30,
  featureCohortIds = c(5, 278, 3, 20,280, 6, 11, 57, 191, 350, 359, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

dementia <- dplyr::tibble(
  label = 'dementia',
  targetCohortIds = 33,
  featureCohortIds = c(194, 191, 5, 341, 364, 7, 62) 
)

febrileSeizure <- dplyr::tibble(
  label = 'Febrile Seizure',
  targetCohortIds = 33,
  featureCohortIds = c(6, 392, 278, 9, 3, 5, 327, 341, 7, 10, 11, 12, 20, 191, 194, 368, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

transverseMyelitis <- dplyr::tibble(
  label = 'transverse myelitis',
  targetCohortIds = 412,
  featureCohortIds = c(232, 11,191, 280, 7, 364, 5, 12, 244, 342, 14, 5, 11, 191,3, 6) ,
  notes = "removed 64"
)

acutePancreatitis <- dplyr::tibble(
  label = 'acute pancreatitis',
  targetCohortIds = 251,
  featureCohortIds = c(280, 278, 10, 281, 5, 189, 11, 191, 4, 57, 194, 299, 359, 380, 14, 5, 11, 191,3, 6) ,
  notes = "removed 64"
)

acuteIschemicHemorrhagicStroke <- dplyr::tibble(
  label = 'acute ischemic  or hemorrhagic stroke',
  targetCohortIds = 70,
  featureCohortIds = c(11, 194, 191, 5, 341, 7, 244, 359, 150, 331, 364, 10, 232, 339) ,
  notes = "removed 64, removed 57 because overlaps with hemorrhages"
)

acuteMyocardialInfarction <- dplyr::tibble(
  label = 'acute myocardial infarction',
  targetCohortIds = 71,
  featureCohortIds = c(405, 404, 402, 359, 339, 335, 278, 275, 274, 273, 244, 219, 95, 57, 5, 359, 11, 191, 339, 10, 341, 244, 62) ,
  notes = ""
)

influenzaDiagnosis <- dplyr::tibble(
  label = 'influenza diagnosis',
  targetCohortIds = 72,
  featureCohortIds = c(6,3,9,327, 278, 12, 20, 5, 11, 354, 368, 392, 7, 10, 191, 14, 5, 11, 191,3, 6) ,
  notes = "removed 64"
)

hemorrhagicStroke <- dplyr::tibble(
  label = 'hemorrhagic stroke',
  targetCohortIds = 74,
  featureCohortIds = c(278, 194, 341, 11, 7, 359, 191, 358, 5, 62, 332, 10, 244, 331, 339, 14, 5, 11, 191,3, 6) ,
  notes = "removed 64"
)

appendicitis <- dplyr::tibble(
  label = 'appendicitis',
  targetCohortIds = 234,
  featureCohortIds = c(280, 10, 4, 6, 189, 1911, 281, 417, 14, 5, 11, 191,3, 6),
  notes = "replaced with 417 because had appendix perforation, removed 64"
)

opticNeuritis <- dplyr::tibble(
  label = 'optic Neuritis',
  targetCohortIds = 238,
  featureCohortIds = c(7, 11, 191, 232, 244, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

dic <- dplyr::tibble(
  label = 'disseminated intra vascular coagulation',
  targetCohortIds = 248,
  featureCohortIds = c(359, 5, 57, 280, 194, 339, 191, 341, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

ischemicStroke <- dplyr::tibble(
  label = 'ischemic stroke',
  targetCohortIds = 249,
  featureCohortIds = c(194, 11, 191, 5, 7, 341, 57, 244, 359, 62, 331, 232, 10, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

anaphylaxis <- dplyr::tibble(
  label = 'anaphylaxis',
  targetCohortIds = 258,
  featureCohortIds = c(12, 354, 340, 5, 241, 278, 381, 3, 10, 7, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

myocardititsPeridcarditis <- dplyr::tibble(
  label = 'myocarditis or pericarditis',
  targetCohortIds = 284,
  featureCohortIds = c(278, 5, 11, 191, 14, 5, 11, 191,3, 6),
  notes = "removed 64"
)

osteoarthritis <- dplyr::tibble(
  label = 'osteoarthritis',
  targetCohortIds = 396,
  featureCohortIds = c(278)
)


cohortsToStudy <- dplyr::bind_rows(
  pneumonia,
  strepThoat,
  otitisMedia,
  cardiacFailure,
  hepaticFailure,
  epistaxis,
  acuteKidneyInjury,
  angioedema,
  allergicRhinitis,
  dysmenorrhea,
  acuteUti,
  # sepsisOrSepticShock,
  hemorrhoids,
  atypicalPneumonia,
  asthmaOrCopd,
  asthma,
  tuberculosis,
  dementia,
  febrileSeizure,
  transverseMyelitis,
  acutePancreatitis,
  acuteIschemicHemorrhagicStroke,
  acuteMyocardialInfarction,
  influenzaDiagnosis,
  hemorrhagicStroke,
  appendicitis,
  opticNeuritis,
  dic,
  ischemicStroke,
  anaphylaxis,
  myocardititsPeridcarditis,
  osteoarthritis
) |> 
  dplyr::distinct()


cohortsToStudy <- dplyr::bind_rows(
  cohortsToStudy,
  cohortsToStudy |>
    dplyr::select(label, targetCohortIds) |>
    dplyr::distinct() |>
    dplyr::mutate(featureCohortIds = 278)
) |> 
  dplyr::distinct() |> 
  dplyr::arrange(targetCohortIds,
                 featureCohortIds)


saveRDS(object = cohortsToStudy,
        file = file.path(filePath,
                         "cohortsToStudy.RDS"))