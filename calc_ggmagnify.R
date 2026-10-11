calc_ggmagnify <- function(x0,
                           y0,
                           largura,
                           origem,
                           id = NULL){

  if(require("purrr")){

    installed.packages("purrr")

  }

  final <- purrr::pmap(
    list(x0,
         y0,
         largura,
         origem),
    \(x0,
      y0,
      largura,
      origem){

      altura <- largura * (origem[["ymax"]] - origem[["ymin"]]) / (origem[["xmax"]] - origem[["xmin"]])

      c(xmin = x0,
        xmax = x0 + largura,
        ymin = y0 - altura,
        ymax = y0)

    },
    .progress = TRUE) |>
    setNames(id)

  return(final)

}
