unit OposCashhi;

//////////////////////////////////////////////////////////////////////
//
// OposCash.hi
//
//   Cash Drawer header file for OPOS Controls and Service Objects.
//
// Modification history
// -------------------------------------------------------------------
// 1995-12-08 OPOS Release 1.0                                   CRM
// 2000-09-24 OPOS Release 1.5                                   BKS
//   Add the following property: CapStatusMultiDrawerDetect
// 2005-04-29 OPOS Release 1.9                                   CRM
//   Remove validation functions.
//
//////////////////////////////////////////////////////////////////////

interface

uses
  OposCash, Oposhi;

//////////////////////////////////////////////////////////////////////
// Numeric Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

const
  PIDXCash_DrawerOpened        =   1 + PIDX_CASH+PIDX_NUMBER;

// * Capabilities *

  PIDXCash_CapStatus           = 501 + PIDX_CASH+PIDX_NUMBER;

//  Added in Release 1.5
  PIDXCash_CapStatusMultiDrawerDetect
                                        = 502 + PIDX_CASH+PIDX_NUMBER;


//////////////////////////////////////////////////////////////////////
// String Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *


implementation

end.
