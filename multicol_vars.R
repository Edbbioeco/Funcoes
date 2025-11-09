multicol_vars <- function(df_cor, var1, var2, threshold) {
  
  require("tidyverse")
  
  if(nrow(df_cor) == 0){
    
    return(character(0))
    
  }
  
  df_cor <- df_cor |> 
    dplyr::rename("var1" = var1,
                  "var2" = var2)
  
  df_cor <- df_cor |> 
    dplyr::arrange(var1, var2)
  
  todas_variaveis <- unique(c(df_cor$var1, 
                              df_cor$var2))
  
  selecionadas <- character(0)
  
  while(length(todas_variaveis) > 0) {
    
    var_atual <- todas_variaveis[1]
    
    selecionadas <- c(selecionadas, var_atual)
    
    todas_variaveis <- todas_variaveis[todas_variaveis != var_atual]
    
    correlacionadas <- df_cor |>
      dplyr::filter(var1 == var_atual | var2 == var_atual) |>
      dplyr::filter(abs(cor) >= threshold) |>
      dplyr::mutate(outra_var = ifelse(var1 == var_atual, 
                                       var2, 
                                       var1)) |>
      dplyr::pull(outra_var) |>
      unique()
    
    todas_variaveis <- todas_variaveis[!todas_variaveis %in% correlacionadas]
    
  }
  
  return(selecionadas)
  
}