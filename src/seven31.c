#include <R.h>
#include <Rinternals.h>

SEXP parts(SEXP x) {
  double dx = REAL_ELT(x, 0);
  int* p = (int*)(&x) ;

  SEXP out = PROTECT(Rf_allocVector(INTSXP, 2));
  int* p_out = INTEGER(out);
  p_out[0] = p[0];
  p_out[1] = p[1];
  UNPROTECT(1);

  return out;
}

static const R_CallMethodDef CallEntries[] = {
  {"seven31_parts", (DL_FUNC)& parts, 1},

  {NULL, NULL, 0}
};

void R_init_seven31(DllInfo* dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
