unit OposScal;

/////////////////////////////////////////////////////////////////////
//
// OposScal.h
//
//   Scale header file for OPOS Applications.
//
// Modification history
// ------------------------------------------------------------------
// 1995-12-08 OPOS Release 1.0                                   CRM
// 2005-04-29 OPOS Release 1.9                                   CRM
//   Add StatusNotify constants.
//   Add StatusUpdateEvent constants.
//   Add more ResultCodeExtended constants.
// 2006-03-15 OPOS Release 1.10                                  CRM
//   Corrected names of StatusUpdateEvent constants from 1.9.
//
/////////////////////////////////////////////////////////////////////

interface

const

/////////////////////////////////////////////////////////////////////
// "WeightUnit" Property Constants
/////////////////////////////////////////////////////////////////////

  SCAL_WU_GRAM         = 1;
  SCAL_WU_KILOGRAM     = 2;
  SCAL_WU_OUNCE        = 3;
  SCAL_WU_POUND        = 4;


/////////////////////////////////////////////////////////////////////
// "StatusNotify" Property Constants (added in 1.9)
/////////////////////////////////////////////////////////////////////

  SCAL_SN_DISABLED = 1;
  SCAL_SN_ENABLED  = 2;


/////////////////////////////////////////////////////////////////////
// "StatusUpdateEvent" Event: "Status" Constants (added in 1.9)
/////////////////////////////////////////////////////////////////////

  SCAL_SUE_STABLE_WEIGHT     = 11;
  SCAL_SUE_WEIGHT_UNSTABLE   = 12;
  SCAL_SUE_WEIGHT_ZERO       = 13;
  SCAL_SUE_WEIGHT_OVERWEIGHT = 14;
  SCAL_SUE_NOT_READY         = 15;
  SCAL_SUE_WEIGHT_UNDER_ZERO = 16;


/////////////////////////////////////////////////////////////////////
// "ResultCodeExtended" Property Constants
/////////////////////////////////////////////////////////////////////

  OPOS_ESCAL_OVERWEIGHT  = 201; // ReadWeight
  OPOS_ESCAL_UNDER_ZERO  = 202; // ReadWeight (added in 1.9)
  OPOS_ESCAL_SAME_WEIGHT = 203; // ReadWeight (added in 1.9)

implementation

end.
