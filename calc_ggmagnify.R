calc_ggmagnify <- function(x0,
                           y0,
                           origem,
                           fator,
                           id = NULL,
                           corrigir_lat = FALSE){

  if(require("purrr")){

    installed.packages("purrr")

  }

  final <- purrr::pmap(
    list(x0,
         y0,
         list(origem)),
    \(x0,
      y0,
      largura,
      origem){

      largura <- (origem[["xmax"]] - origem[["xmin"]]) * fator

      altura <- (origem[["ymax"]] - origem[["ymin"]]) * fator

      c(xmin = x0,
        xmax = x0 + largura,
        ymin = y0 - altura,
        ymax = y0)

    },
    .progress = TRUE) |>
    purrr::pluck(1) |>
    setNames(id)

  return(final)

}
