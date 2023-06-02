filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))

# phenotypes
pneumonia <- dplyr::tibble(
  label = 'pneumonia',
  targetCohortIds = 329,
  featureCohortIds = c(64,5, 3, 278, 6, 11, 12, 9, 368, 327)
)

strepThoat <- dplyr::tibble(
  label = 'strep throat',
  targetCohortIds = 366,
  featureCohortIds = c(64,6,278,12,392,3,368,11)
)

otitisMedia <- dplyr::tibble(
  label = 'otitis media',
  targetCohortIds = 372,
  featureCohortIds = c(12, 9, 64, 327, 368, 354, 278, 369, 3, 20, 367, 391, 6, 353, 355, 352)
)

cardiacFailure <- dplyr::tibble(
  label = 'Cardiac Failure',
  targetCohortIds = 68,
  featureCohortIds = c(64, 324, 5, 278, 282, 359, 11, 332, 191, 280, 364, 358, 194, 57, 339, 3, 341, 244, 6, 10)
)

hepaticFailure <- dplyr::tibble(
  label = 'Hepatic Failure',
  targetCohortIds = 292,
  featureCohortIds = c(64, 324, 278, 289, 5, 280, 341, 11, 191, 332, 57, 339, 10, 335, 61, 274, 240, 364, 219, 193, 380)
)

epistaxis <- dplyr::tibble(
  label = 'Epistaxis',
  targetCohortIds = 356,
  featureCohortIds = c(12, 324, 354, 278, 369, 64, 368, 5, 7, 332, 9, 280, 11, 391, 3, 191, 392, 10)
)

acuteKidneyInjury <- dplyr::tibble(
  label = 'Acute Kidney Injury',
  targetCohortIds = 362,
  featureCohortIds = c(324, 64, 278, 5, 282, 280, 11, 191, 359, 332, 194, 358, 339, 10, 364, 57, 341, 331, 299, 3, 6, 4, 244, 7, 348, 398, 95)
)

angioedema <- dplyr::tibble(
  label = 'Angioedema',
  targetCohortIds = 220,
  featureCohortIds = c(369, 340, 241, 12,354, 324, 64, 278, 5, 280, 332, 3, 7, 9, 11, 193, 353, 368, 381, 191, 
                       38, 392)
)

allergicRhinitis <- dplyr::tibble(
  label = 'Allergic Rhinitis',
  targetCohortIds = 367,
  featureCohortIds = c(324, 64, 278, 368, 3, 9, 327, 392, 7, 353, 5, 11, 191, 340, 351)
)

dysmenorrhea <- dplyr::tibble(
  label = 'Dysmenorrhea',
  targetCohortIds = 395,
  featureCohortIds = c(278, 280, 300, 64, 11, 279, 7, 191, 10)
)

# acuteUti <- dplyr::tibble(
#   label = 'Acute Urinary Tract Infection',
#   targetCohortIds = 410,
#   featureCohortIds = c()
# )
# 
# sepsisOrSepticShock <- dplyr::tibble(
#   label = 'Sepsis or Septic Shock',
#   targetCohortIds = 411,
#   featureCohortIds = c()
# )

hemorrhoids <- dplyr::tibble(
  label = 'Hemorrhoids',
  targetCohortIds = 407,
  featureCohortIds = c(324, 57, 278, 349, 280, 4, 332, 64)
)

atypicalPneumonia <- dplyr::tibble(
  label = 'atypical pneumonia',
  targetCohortIds = 407,
  featureCohortIds = c(64, 5, 324,3, 278, 20, 359, 358, 6, 11, 191, 403, 332, 12, 10, 57, 9, 331, 339, 368)
)


asthmaOrCopd <- dplyr::tibble(
  label = 'asthma or copd',
  targetCohortIds = 26,
  featureCohortIds = c(64, 324, 278, 369, 12, 20, 5, 3, 354, 332, 368, 11, 191, 9)
)

asthma <- dplyr::tibble(
  label = 'asthma',
  targetCohortIds = 27,
  featureCohortIds = c(369, 12, 64, 324, 354, 278, 20, 3, 5, 368, 9, 392, 11, 7,191, 327, 328, 6)
)

tuberculosis <- dplyr::tibble(
  label = 'tuberculosis',
  targetCohortIds = 30,
  featureCohortIds = c(64, 5, 324, 278, 3, 20,280, 6, 11, 57, 191, 350, 359) 
)

dementia <- dplyr::tibble(
  label = 'dementia',
  targetCohortIds = 33,
  featureCohortIds = c(194, 191, 5, 341, 364, 7, 62) 
)

febrileSeizure <- dplyr::tibble(
  label = 'Febrile Seizure',
  targetCohortIds = 33,
  featureCohortIds = c(64, 6, 392, 278, 9, 3, 5, 327, 341, 7, 10, 11, 12, 20, 191, 194, 368) 
)

transverseMyelitis <- dplyr::tibble(
  label = 'transverse myelitis',
  targetCohortIds = 63,
  featureCohortIds = c(324, 64, 232, 11,191, 280, 7, 364, 5, 12, 244, 342) 
)

acutePancreatitis <- dplyr::tibble(
  label = 'acute pancreatitis',
  targetCohortIds = 251,
  featureCohortIds = c(324, 280, 278, 10, 64, 281, 5, 189, 11, 191, 4, 57, 194, 299, 359, 380) 
)

acuteIschemicStroke <- dplyr::tibble(
  label = 'acute ischemic stroke',
  targetCohortIds = 70,
  featureCohortIds = c(64, 324, 11, 194, 191, 5, 57, 341, 7, 244, 359, 150, 331, 364, 10, 232, 339) 
)

acuteMyocardialInfarction <- dplyr::tibble(
  label = 'acute myocardial infarction',
  targetCohortIds = 70,
  featureCohortIds = c(324, 64, 5, 359, 11, 191, 339, 10, 341, 57, 244, 62) 
)

influenzaDiagnosis <- dplyr::tibble(
  label = 'influenza diagnosis',
  targetCohortIds = 72,
  featureCohortIds = c(64,6,3,9,327, 324, 278, 12, 20, 5, 11, 354, 368, 392, 7, 10, 191) 
)

hemorrhagicStroke <- dplyr::tibble(
  label = 'hemorrhagic stroke',
  targetCohortIds = 74,
  featureCohortIds = c(324, 278, 64,194, 341, 11, 7, 359, 191, 358, 5, 62, 332, 10, 244, 331, 339) 
)

appendicitis <- dplyr::tibble(
  label = 'appendicitis',
  targetCohortIds = 234,
  featureCohortIds = c(280, 324, 10, 64, 299, 4, 6, 189, 1911, 281)
)

opticNeuritis <- dplyr::tibble(
  label = 'optic Neuritis',
  targetCohortIds = 238,
  featureCohortIds = c(324, 7, 64, 011, 191, 232, 244)
)

dic <- dplyr::tibble(
  label = 'disseminated intra vascular coagulation',
  targetCohortIds = 248,
  featureCohortIds = c(359, 324, 5, 64, 57, 280, 194, 339, 191, 341)
)

ischemicStroke <- dplyr::tibble(
  label = 'ischemic stroke',
  targetCohortIds = 249,
  featureCohortIds = c(64, 324, 194, 11, 191, 5, 7, 341, 57, 244, 359, 62, 331, 232, 10)
)

anaphylaxis <- dplyr::tibble(
  label = 'anaphylaxis',
  targetCohortIds = 258,
  featureCohortIds = c(12, 354, 64, 340, 5, 324, 241, 278, 381, 3, 10, 7)
)

myocardititsPeridcarditis <- dplyr::tibble(
  label = 'myocarditis or pericarditis',
  targetCohortIds = 284,
  featureCohortIds = c(324, 278, 64, 5, 11, 191)
)

osteoarthritis <- dplyr::tibble(
  label = 'osteoarthritis',
  targetCohortIds = 396,
  featureCohortIds = c(324)
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
  # acuteUti,
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
  acuteIschemicStroke,
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
)