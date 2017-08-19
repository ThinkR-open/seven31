
#' reveal the bits of a double
#'
#' @param x a double
#'
#' @examples
#' reveal( 1.0 )
#' reveal( 0.0 )
#' reveal( -0.0 )
#' reveal( NA )
#' reveal( NaN )
#'
#' @export
reveal <- function( x ){
  bits  <- substr( as.character( rev( intToBits( parts(x) ) ) ), 2, 2 )

  exponent <- paste( bits[2:12], collapse = "" )
  exponent_value <- strtoi( exponent, base = "2") - 1023
  structure(
    list(
      sign = bits[1],
      exponent = exponent,
      exponent_value = exponent_value,
      fraction = paste( bits[13:64], collapse = "" )
    ),
    class = c("seven31_double")
  )
}

#' @importFrom glue glue
#' @importFrom crayon red blue make_style underline style
#' @export
print.seven31_double <- function(x, ...){
  discreet <- make_style( "#E6E6E6", grey = TRUE)
  exp_style <- make_style( "purple2", bg = TRUE)

  s <- glue( "{sign} {exponent} ({value}) {fraction}",
    sign = red(x$sign),
    exponent = blue(x$exponent),
    value = exp_style(sprintf( "% 5d", x$exponent_value) ),
    fraction = paste( ifelse( strsplit(x$fraction, "")[[1]] == "1", "1", discreet( "0" ) ), collapse = "" )
  )
  writeLines(s)
  invisible(x)
}
