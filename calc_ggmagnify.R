calc_ggmagnify <- function(x0,
                           y0,
                           largura,
                           origem,
                           id = NULL,
                           corrigir_lat = FALSE){

  if(require("purrr")){

    installed.packages("purrr")

  }

  final <- purrr::pmap(
    list(x0,
         y0,
         largura,
         list(origem)),
    \(x0,
      y0,
      largura,
      origem){

      altura <- largura * (origem[["ymax"]] - origem[["ymin"]]) / (origem[["xmax"]] - origem[["xmin"]])

      if(corrigir_lat){

        altura <- altura / cos(mean(origem[c("ymin", "ymax")]) * pi / 180)^2

      }

      c(xmin = x0,
        xmax = x0 + largura,
        ymin = y0 - altura,
        ymax = y0)

    },
    .progress = TRUE) |>
    setNames(id)

  return(final)

}
