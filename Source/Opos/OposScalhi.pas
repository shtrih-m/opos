unit OposScalhi;

//////////////////////////////////////////////////////////////////////
//
// OposScal.hi
//
//   Scale header file for OPOS Controls and Service Objects.
//
// Modification history
// -------------------------------------------------------------------
// 1995-12-08 OPOS Release 1.0                                   CRM
// 1996-03-18 OPOS Release 1.01                                  CRM
//   Correct WeightUnits value from 1 to 2.
// 1997-06-04 OPOS Release 1.2                                   CRM
//   Add the following properties: CapDisplay, WeightUnit
// 1998-03-06 OPOS Release 1.3                                   CRM
//   Add the following properties:
//     CapDisplayText, CapPriceCalculating, CapTareWeight,
//     CapZeroScale, AsyncMode, MaxDisplayTextChars, SalesPrice,
//     TareWeight, UnitPrice
// 2005-04-29 OPOS Release 1.9                                   CRM
//   Add the following properties:
//     CapStatusUpdate, ScaleLiveWeight, StatusNotify
//   Remove validation functions.
// 2009-10-02 OPOS Release 1.13                                  CRM
//   Add the following property: ZeroValid
//
//////////////////////////////////////////////////////////////////////

interface

uses
  Oposhi;

const


//////////////////////////////////////////////////////////////////////
// Numeric Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

  PIDXScal_MaximumWeight       =   1 + PIDX_SCAL+PIDX_NUMBER;
  PIDXScal_WeightUnits         =   2 + PIDX_SCAL+PIDX_NUMBER;

//      Added for Release 1.2:
  PIDXScal_WeightUnit          =   2 + PIDX_SCAL+PIDX_NUMBER;
//        WeightUnit = WeightUnits: Support both, due to
//        editing error in the pre-1.2 APG.

//      Added for Release 1.3:
  PIDXScal_AsyncMode           =   3 + PIDX_SCAL+PIDX_NUMBER;
  PIDXScal_MaxDisplayTextChars =   4 + PIDX_SCAL+PIDX_NUMBER;
  PIDXScal_TareWeight          =   5 + PIDX_SCAL+PIDX_NUMBER;

//      Added for Release 1.9:
  PIDXScal_ScaleLiveWeight     =   6 + PIDX_SCAL+PIDX_NUMBER;
  PIDXScal_StatusNotify        =   7 + PIDX_SCAL+PIDX_NUMBER;

//      Added for Release 1.13:
  PIDXScal_ZeroValid           =   8 + PIDX_SCAL+PIDX_NUMBER;



// * Capabilities *

//      Added for Release 1.1:
  PIDXScal_CapDisplay          = 501 + PIDX_SCAL+PIDX_NUMBER;

//      Added for Release 1.3:
  PIDXScal_CapDisplayText      = 502 + PIDX_SCAL+PIDX_NUMBER;
  PIDXScal_CapPriceCalculating = 503 + PIDX_SCAL+PIDX_NUMBER;
  PIDXScal_CapTareWeight       = 504 + PIDX_SCAL+PIDX_NUMBER;
  PIDXScal_CapZeroScale        = 505 + PIDX_SCAL+PIDX_NUMBER;

//      Added for Release 1.9:
  PIDXScal_CapStatusUpdate     = 506 + PIDX_SCAL+PIDX_NUMBER;


//////////////////////////////////////////////////////////////////////
// String Property Index Values.
//////////////////////////////////////////////////////////////////////

implementation

end.
