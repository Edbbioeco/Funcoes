# PAcotes ----

install.packages("purrr")

library(purrr)

# Lista de termos ----

termos <- c("Flavio miliciano",
            "Flávio ana Clara",
            "Flávio comando Vermelho",
            "Flávio escandalo",
            "Flávio banco master",
            "Flávio vorcaro") |>
  rep(5)

termos

# Pesquisar termos ----

purrr::walk(
  termos,
  \(termo){

    paste0("https://www.google.com/search?q=",
           utils::URLencode(termo,
                            reserved = TRUE)) |>
      utils::browseURL()

    base::Sys.sleep(1)

    },
  .progress = TRUE)

# Listar navegadores ----

navegadores <- readRegistry(
  "SOFTWARE\\Clients\\StartMenuInternet",
  hive = "HLM",
  maxdepth = 5) |>
  purrr::keep_at(
    \(nome){

      stringr::str_detect(nome,
                          "Google Chrome|Microsoft Edge")

      }) |>
  purrr::map_chr(
    \(x){

      purrr::pluck(x,
                   "shell", "open", "command", "(Default)",
                   .default = NA_character_)

      }) |>
  stringr::str_remove_all('"')

navegadores

# Fazer as pesquisas ----

purrr::walk(
  termos,
  \(termo){

    purrr::walk(
      navegadores,
      \(navs){

        paste0("https://www.google.com/search?q=",
               utils::URLencode(termo,
                                reserved = TRUE)) |>
          utils::browseURL()

        base::Sys.sleep(1)

        })

    },
  .progress = TRUE)

# Fazer as pesquisas em mais de um navegador ----

purrr::walk(
  termos,
  \(termo){

    purrr::walk(
      navegadores,
      \(navs){

        tryCatch(
          {

            url <- paste0("https://www.google.com/search?q=",
                         utils::URLencode(termo,
                                          reserved = TRUE))

            system2(
              command = "cmd",
              args = c("/c", "start", "/min", '""',
                       shQuote(navs, type = "cmd"),
                       shQuote(url, type = "cmd")),
              wait = FALSE,
              invisible = TRUE)

            base::Sys.sleep(1)

            },
          error = \(e){

            message("Browser não encontrado")

            })

        })

    },
  .progress = TRUE)
