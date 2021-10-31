unit NCRScale;

interface

uses
  OPOS;

const
  /////////////////////////////////////////////////////////////////////
  // "ResultCodeExtended" Property Constants for Scale
  /////////////////////////////////////////////////////////////////////

  NCR_ESCAL_UNSTABLE           = 2 + OPOSERREXT; // ReadWeight NO stable weight available
  NCR_ESCAL_UNDERZERO          = 3 + OPOSERREXT; // ReadWeight Weight under zero
  NCR_ESCAL_ZEROWEIGHT         = 4 + OPOSERREXT; // ReadWeight Stable Weight of zero
  NCR_ESCAL_WEIGHTUNCHANGED    = 5 + OPOSERREXT; // ReadWeight status Weight unchanged
  NCR_ESCAL_NOTREADY           = 6 + OPOSERREXT; // ReadWeight status Not Ready TAR 72258


  /////////////////////////////////////////////////////////////////////
  // "DirectIO" Method Constants for Scale (NCR 7870 and 7880)
  /////////////////////////////////////////////////////////////////////

  NCRDIO_SCAL_STATUS            = 601;
  NCRDIO_SCAL_READROM           = 602;
  NCRDIO_SCAL_ROM_VERSION       = 603;
  NCRDIO_SCAL_LIVE_WEIGHT       = 604;
  NCRDIO_SCAL_DIRECT            = 605;
  NCRDIO_SCAL_WEIGHT_DELAY      = 606;
  NCRDIO_SCAL_ZERO              = 607;

implementation

end.
