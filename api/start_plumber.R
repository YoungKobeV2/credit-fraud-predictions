require(plumber)
require(rapidoc)
require(yaml)


pr("plumber.R") %>%
  pr_set_api_spec(read_yaml("api_spec.yml")) %>%
  pr_set_docs("rapidoc",
    allow_authentication = TRUE
  ) %>%
  pr_run(host = "0.0.0.0", port = 8000)

