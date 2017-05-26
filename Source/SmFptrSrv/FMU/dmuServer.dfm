object dmServer: TdmServer
  OldCreateOrder = False
  Left = 458
  Top = 291
  Height = 182
  Width = 174
  object TCPServer: TIdCmdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnConnect = TCPServerConnect
    OnDisconnect = TCPServerDisconnect
    CommandHandlers = <
      item
        CmdDelimiter = #0
        Command = 'OPENPORT'
        Disconnect = False
        Name = 'chOpenPort'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = chOpenPortCommand
      end
      item
        CmdDelimiter = #0
        Command = 'CLOSEPORT'
        Disconnect = False
        Name = 'chClosePort'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = chClosePortCommand
      end
      item
        CmdDelimiter = #0
        Command = 'SEND'
        Disconnect = False
        Name = 'chSend'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = chSendCommand
      end
      item
        CmdDelimiter = ' '
        Command = 'CLAIM'
        Disconnect = False
        Name = 'chClaimDevice'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = chClaimDeviceCommand
      end
      item
        CmdDelimiter = ' '
        Command = 'RELEASE'
        Disconnect = False
        Name = 'chReleaseDevice'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = chReleaseDeviceCommand
      end
      item
        CmdDelimiter = ' '
        Command = 'OPENRECEIPT'
        Disconnect = False
        Name = 'chOpenReceipt'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = TCPServerchOpenReceiptCommand
      end
      item
        CmdDelimiter = ' '
        Command = 'CLOSERECEIPT'
        Disconnect = False
        Name = 'chCloseReceipt'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = TCPServerchCloseReceiptCommand
      end
      item
        CmdDelimiter = ' '
        Command = 'CONNECT'
        Disconnect = False
        Name = 'chConnect'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = TCPServerchConnectCommand
      end
      item
        CmdDelimiter = ' '
        Command = 'DISCONNECT'
        Disconnect = False
        Name = 'chbDisconnect'
        NormalReply.Code = '200'
        ParamDelimiter = ' '
        ParseParams = True
        Tag = 0
        OnCommand = TCPServerCommandHandlers8Command
      end>
    ExceptionReply.Code = '500'
    ExceptionReply.Text.Strings = (
      'Unknown Internal Error')
    Greeting.Code = '200'
    Greeting.Text.Strings = (
      'Welcome')
    HelpReply.Code = '100'
    HelpReply.Text.Strings = (
      'Help follows')
    MaxConnectionReply.Code = '300'
    MaxConnectionReply.Text.Strings = (
      'Too many connections. Try again later.')
    ReplyTexts = <>
    ReplyUnknownCommand.Code = '400'
    ReplyUnknownCommand.Text.Strings = (
      'Unknown Command')
    Left = 64
    Top = 32
  end
end
