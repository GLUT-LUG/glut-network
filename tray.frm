VERSION 5.00
Begin VB.Form tray 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "У԰������"
   ClientHeight    =   555
   ClientLeft      =   150
   ClientTop       =   690
   ClientWidth     =   1635
   Icon            =   "tray.frx":0000
   LinkTopic       =   "Form3"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   555
   ScaleWidth      =   1635
   ShowInTaskbar   =   0   'False
   Visible         =   0   'False
   Begin VB.Menu Menu 
      Caption         =   "�˵�"
      Begin VB.Menu show 
         Caption         =   "��ʾ"
      End
      Begin VB.Menu exit 
         Caption         =   "�˳�"
      End
   End
End
Attribute VB_Name = "tray"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Const WM_MOUSEMOVE = &H200
Private Const WM_LBUTTONDOWN = &H201
Private Const WM_LBUTTONUP = &H202
Private Const WM_LBUTTONDBLCLK = &H203
Private Const WM_RBUTTONDOWN = &H204
Private Const WM_RBUTTONUP = &H205
Private Const WM_RBUTTONDBLCLK = &H206
Public m_NotifyIcon As New CYFNotifyIcon '����ͼ��

Public Sub untray()
    On Error Resume Next
    Set m_NotifyIcon = Nothing
End Sub

Private Sub init()
    On Error Resume Next
    Call m_NotifyIcon.AddNotifyIcon(Me.hWnd, Me.Icon.Handle, "У԰������")
End Sub

Private Sub show_Click()
If Not Form2 Is Nothing Then Form2.show
End Sub
Private Sub Form_Load()
    
    If 1 <> 1 Then
    Me.show
    Me.Visible = True
    End If
    
    Form2.show
    init
    Me.Top = -2000
    Me.Left = -2000
End Sub
Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim lMsg As Single
    lMsg = X / Screen.TwipsPerPixelX
    Select Case lMsg
        Case WM_LBUTTONUP
            Form2.show
        Case WM_RBUTTONUP
            PopupMenu Menu
        ' Case WM_MOUSEMOVE
        ' Case WM_LBUTTONDOWN
        ' Case WM_LBUTTONDBLCLK
        ' Case WM_RBUTTONDOWN
        ' Case WM_RBUTTONDBLCLK
        ' Case Else
    End Select
    'Debug.Print lMsg
End Sub

Private Sub exit_Click()
    Rem If Not Form2 Is Nothing Then
    '    Unload Form2
    '    untray
    '    End
    Rem End If
    Dim Msg
    Msg = MsgBox("��ȷ��Ҫ�˳��𣬲������ܵ��¿��ܻ��޷�����", vbOKCancel, "У԰������")
    If Msg = vbCancel Then
        'Cancel = -1
        'End
        Exit Sub
    End If
    untray
    End
End Sub

Private Sub showform_Click()
    'm_NotifyIcon.ShowBubble "��У԰��", "�������ʾ��"
    Form2.show
End Sub

