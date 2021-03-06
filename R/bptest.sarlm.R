# Copyright 2004-2011 by Roger Bivand (original taken from bptest() in the lmtest
# package, Copyright (C) 2001 Torsten Hothorn and Achim Zeileis and released
# under GNU General Public License, Version 2 or 3.
#

bptest.sarlm <- function (object, varformula=NULL, studentize = TRUE, data=list()) 
{
    .Deprecated("spatialreg::bptest.sarlm", msg="Method bptest.sarlm moved to the spatialreg package")
#    if (!requireNamespace("spatialreg", quietly=TRUE))
#      stop("install the spatialreg package")
    if (requireNamespace("spatialreg", quietly=TRUE)) {
      return(spatialreg::bptest.sarlm(object=object, varformula=varformula, studentize = studentize, data=data))
    }
    warning("install the spatialreg package")
#  if (FALSE) {
    if(!inherits(object, "sarlm")) stop("not sarlm object")
    Z <- object$tarX
    if (!is.null(varformula)) Z <- model.matrix(varformula, data = data)
    k <- ncol(Z)
    n <- nrow(Z)
    resi <- object$residuals
    if (length(resi) != nrow(Z))
        stop("number of residuals differs from varformula matrix rows")
    sigma2 <- sum(resi^2)/n
    if (studentize) {
        w <- resi^2 - sigma2
        fv <- lm.fit(Z, w)$fitted
        bp <- n * sum(fv^2)/sum(w^2)
        method <- "studentized Breusch-Pagan test"
    }
    else {
        f <- resi^2/sigma2 - 1
        fv <- lm.fit(Z, f)$fitted
        bp <- 0.5 * sum(fv^2)
        method <- "Breusch-Pagan test"
    }
    names(bp) <- "BP"
    df <- k - 1
    names(df) <- "df"
    RVAL <- list(statistic = bp, parameter = df, method = method, 
        p.value = 1 - pchisq(bp, df))
    class(RVAL) <- "htest"
    return(RVAL)
}
#}

