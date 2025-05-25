require(tidymodels)
require(tidyr)
require(dplyr)
require(jsonlite)
require(plumber)

source("secrets.R")

model <- readRDS("model.rds")

thres <- read.csv("classification_threshold.csv") %>%
  as_tibble() %>%
  pull(value)

authorize_user <- function(req, res) {
  auth_header <- req$HTTP_AUTHORIZATION
  details <- NA

  if (!is.null(auth_header)) {
    auth_header <- gsub("Basic ", "", auth_header)
    details <- base64_dec(auth_header) %>% rawToChar()
  }

  ADMINS <- vector()
  ADMINS[1] <- Sys.getenv("ADMIN1")
  ADMINS[2] <- Sys.getenv("ADMIN2")
  ADMINS[3] <- Sys.getenv("ADMIN3")

  if (is.null(auth_header) | !any(details %in% ADMINS)) {
    res$status <- 401
  }


  if (!is.null(auth_header) & any(details %in% ADMINS)) {
    res$status <- 200
  }
}

#* redirect to Swagger api UI
#* @get /

function(res) {
  res$status <- 302
  res$setHeader("Location", "/__docs__/")
}


#* get prediction
#* @post /get_prediction

function(req, res) {
  authorize_user(req, res)


  if (res$status == 401) {
    return(list(message = "You are unauthorized to use this endpoint , enter correct username and password"))
  }

  if (res$status == 200) {
    newdata <- fromJSON(req$postBody) %>% as_tibble()
    probs <- predict(model, newdata, type = "prob") %>%
      rename(fraud = .pred_1, legit = .pred_0)

    pred_class <- ifelse(probs$fraud > thres, 1, 0)

    list(classification_threshold = thres, probabilities = probs$fraud, predictions = pred_class)
    return(list(
      classification_threshold = list(legit = 1 - thres, fraud = thres),
      probabilities = as.list(probs),
      fraud_prediction = pred_class
    ))
  }
}
