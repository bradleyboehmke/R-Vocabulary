PV <- function(FV, r, n, na.rm = FALSE) {
        if(!is.numeric(FV) | !is.numeric(r) | !is.numeric(n)){
                stop('This function only works for numeric inputs!\n', 
                     'You have provided objects of the following classes:\n', 
                     'FV: ', class(FV), '\n',
                     'r: ', class(r), '\n',
                     'n: ', class(n))
        }
        
        if(na.rm == TRUE) {
                FV <- FV[!is.na(FV)]
        }
        
        PV <- FV/(1+r)^n
        round(PV, 2)
}


