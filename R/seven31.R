
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

#' compare the bits of two double
#'
#' @param x a number
#' @param y another number
#'
#' @examples
#' compare( .3 + .6, .9)
#' compare( 2, sqrt(2)^2)
#'
#' @importFrom rlang quo_name enquo
#' @export
compare <- function(x, y){
  x_ <- quo_name(enquo(x))
  y_ <- quo_name(enquo(y))

  structure( list(
      lhs = reveal(x), lhs_name = x_,
      rhs = reveal(y), rhs_name = y_
    ), class = "seven31_compare" )
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

highlight_differences <- function(x, y){
  highlight <- make_style( "red", bg = TRUE)$white
  discreet  <- make_style( "#E6E6E6", grey = TRUE)

  lhs <- strsplit( x, "" )[[1]]
  rhs <- strsplit( y, "" )[[1]]
  eq  <- lhs == rhs

  list(
    lhs = paste( ifelse( eq, discreet(lhs), highlight(lhs) ), collapse = "" ),
    rhs = paste( ifelse( eq, discreet(rhs), highlight(rhs) ), collapse = "" )
  )

}

#' @export
print.seven31_compare <- function(x, ...){
  exponents <- highlight_differences( x$lhs$exponent, x$rhs$exponent)
  fractions <- highlight_differences( x$lhs$fraction, x$rhs$fraction)

  names <- format( c(x$lhs_name, x$rhs_name) )

  format_one <- function(name, sign, exponent, value, fraction){
    sprintf( "%s %s (%s) %s : %s", sign, exponent, sprintf( "% 5d", value ), fraction, name)
  }
  cat( format_one(names[1], x$lhs$sign, exponents$lhs, x$lhs$exponent_value, fractions$lhs ), "\n" )
  cat( format_one(names[2], x$rhs$sign, exponents$rhs, x$rhs$exponent_value, fractions$rhs ), "\n" )

  invisible(x)
}
