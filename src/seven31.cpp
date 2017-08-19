#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector parts(double x) {
  int* p = reinterpret_cast<int*>(&x) ;
  return IntegerVector::create( p[0], p[1] ) ;
}
