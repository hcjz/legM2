object frmUpdateClient: TfrmUpdateClient
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmUpdateClient'
  ClientHeight = 129
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GSocket: TServerSocket
    Active = False
    Port = 0
    Host = '0.0.0.0'
    NoDelay = True
    OnClientConnect = GSocketClientConnect
    OnClientDisconnect = GSocketClientDisconnect
    OnClientRead = GSocketClientRead
    OnClientError = GSocketClientError
    Left = 56
    Top = 24
  end
end
