
reveal_one <- function(x, name){
  bits  <- substr( as.character( rev( intToBits( parts(x) ) ) ), 2, 2 )

  exponent <- paste( bits[2:12], collapse = "" )
  exponent_value <- strtoi( exponent, base = "2") - 1023

  structure(
    list(
      sign = bits[1],
      exponent = exponent,
      exponent_value = exponent_value,
      fraction = paste( bits[13:64], collapse = "" ),
      name = if( is.na(name) ) "NA" else name
    ),
    class = c("seven31_double")
  )

}

#' reveal the bits of a double
#'
#' @param \dots several expression that should each evaluate to a single double
#'
#' @examples
#' reveal( 1.0, 0.0, -0.0 )
#' reveal( NA, NaN )
#'
#' @export
#' @importFrom purrr map2 map_chr
#' @importFrom rlang quos UQS
reveal <- function( ... ){
  qnames <- map_chr(quos(...), quo_name)
  values <- list(...)
  structure(
    map2( values, qnames, reveal_one ),
    class = "seven31_double_list"
  )
}

#' @importFrom purrr walk
#' @export
print.seven31_double_list <- function(x, ...){
  walk( x, print )
  invisible(x)
}

#' @importFrom crayon bgBlack make_style
style_exponent_value <- function(exponent){
  exponent
}
# style_exponent_value <- function(exponent){
#   if(exponent == 1024){
#     bgBlack$white( " NaN ")
#   } else if( exponent == -1023){
#     bgBlack$white(" zero")
#   } else if( exponent == 0) {
#     make_style( "green3", bg = TRUE)(sprintf( "% 5d", exponent))
#   } else if( exponent > 0) {
#     make_style( "orange", bg = TRUE)(sprintf( "% 5d", exponent))
#   } else {
#     make_style( "tomato", bg = TRUE)(sprintf( "% 5d", exponent))
#   }
# }

#' @importFrom glue glue
#' @importFrom crayon red blue make_style underline style
#' @export
print.seven31_double <- function(x, ...){
  discreet <- make_style( "#E6E6E6", grey = TRUE)

  s <- glue( "{sign} {exponent} ({value}) {fraction} : {name}",
    sign = red(x$sign),
    exponent = blue(x$exponent),
    value = style_exponent_value(x$exponent_value) ,
    fraction = paste( ifelse( strsplit(x$fraction, "")[[1]] == "1", "1", discreet( "0" ) ), collapse = "" ),
    name = x$name
  )
  writeLines(s)
  invisible(x)
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
  nx <- quo_name(enquo(x))
  x <- reveal_one(x, nx)

  ny <- quo_name(enquo(y))
  y <- reveal_one(y, ny)

  structure( list(
    lhs = x,
    rhs = y
  ), class = "seven31_compare" )
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
  lhs <- x$lhs
  rhs <- x$rhs
  exponents <- highlight_differences( lhs$exponent, rhs$exponent)
  fractions <- highlight_differences( lhs$fraction, rhs$fraction)

  format_one <- function(name, sign, exponent, value, fraction){
    sprintf( "%s %s (%s) %s : %s", sign, exponent, style_exponent_value(value), fraction, name)
  }
  cat( format_one(lhs$name, lhs$sign, exponents$lhs, lhs$exponent_value, fractions$lhs ), "\n" )
  cat( format_one(rhs$name, rhs$sign, exponents$rhs, rhs$exponent_value, fractions$rhs ), "\n" )

  invisible(x)
}
