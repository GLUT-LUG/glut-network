VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "��������ѧ-У԰�������ͻ���3.0"
   ClientHeight    =   5070
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   6555
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5070
   ScaleWidth      =   6555
   StartUpPosition =   3  '����ȱʡ
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   6000
      Top             =   4200
   End
   Begin VB.Frame Frame1 
      BorderStyle     =   0  'None
      Height          =   495
      Left            =   1680
      TabIndex        =   15
      Top             =   2640
      Width           =   3135
      Begin VB.OptionButton Option2 
         Caption         =   "����У��"
         Height          =   495
         Index           =   1
         Left            =   2040
         TabIndex        =   17
         Top             =   0
         Width           =   1335
      End
      Begin VB.OptionButton Option2 
         Caption         =   "��ɽУ��"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   16
         Top             =   120
         Width           =   1215
      End
   End
   Begin VB.OptionButton Option1 
      Caption         =   "��ͨ"
      Height          =   255
      Index           =   3
      Left            =   4680
      TabIndex        =   7
      Top             =   2400
      Width           =   975
   End
   Begin VB.OptionButton Option1 
      Caption         =   "�ƶ�"
      Height          =   255
      Index           =   2
      Left            =   3480
      TabIndex        =   6
      Top             =   2400
      Width           =   975
   End
   Begin VB.OptionButton Option1 
      Caption         =   "����"
      Height          =   255
      Index           =   1
      Left            =   2280
      TabIndex        =   5
      Top             =   2400
      Width           =   975
   End
   Begin VB.OptionButton Option1 
      Caption         =   "У԰��"
      Height          =   255
      Index           =   0
      Left            =   1080
      TabIndex        =   4
      Top             =   2400
      Value           =   -1  'True
      Width           =   975
   End
   Begin VB.CheckBox Check2 
      Caption         =   "��ʱ�Զ���¼"
      Height          =   375
      Left            =   3600
      TabIndex        =   9
      Top             =   3120
      Width           =   1695
   End
   Begin VB.CommandButton Command2 
      Caption         =   "����"
      Height          =   615
      Left            =   3360
      TabIndex        =   3
      Top             =   3960
      Width           =   1575
   End
   Begin VB.CheckBox Check1 
      Caption         =   "��ס�˺�����"
      Height          =   375
      Left            =   1440
      TabIndex        =   8
      Top             =   3120
      Width           =   1695
   End
   Begin VB.TextBox Text2 
      Height          =   495
      IMEMode         =   3  'DISABLE
      Left            =   1560
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   1800
      Width           =   4215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "��¼"
      Height          =   615
      Left            =   1680
      TabIndex        =   2
      Top             =   3960
      Width           =   1575
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   1560
      TabIndex        =   0
      Top             =   1200
      Width           =   4215
   End
   Begin VB.Label Label5 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "���δ����Ӫ�̣���ѡ��У԰��"
      ForeColor       =   &H00808000&
      Height          =   180
      Left            =   1920
      TabIndex        =   14
      Top             =   3600
      Width           =   3180
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "��������ѧ-У԰����¼"
      BeginProperty Font 
         Name            =   "����"
         Size            =   18
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1080
      TabIndex        =   12
      Top             =   480
      Width           =   4695
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "У԰�����룺"
      Height          =   375
      Left            =   480
      TabIndex        =   11
      Top             =   1920
      Width           =   1095
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "У԰���˺ţ�"
      Height          =   375
      Left            =   480
      TabIndex        =   10
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "��������������ѧ-CH"
      Height          =   180
      Left            =   2400
      TabIndex        =   13
      Top             =   4680
      Width           =   1890
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Dim needUnload As Boolean

Private Sub Check2_Click()
    If Check2.Value = 1 Then
        Check1.Value = 1
    End If
End Sub

Private Sub Command1_Click()
Randomize
If main.login(Text1.text, Text2.text, Val(ReadReg("", "type"))) Then '��¼�ɹ��Ļ�
    If Check1.Value = 1 Then
        WriteReg "", "zh", Text1.text
        WriteReg "", "mm", Text2.text
    End If
    If Check2.Value = 1 Then
        WriteReg "", "auto", "1"
    Else
        WriteReg "", "auto", "0"
    End If
    tray.show
    tray.Visible = False
    needUnload = True
    Unload Me
Else
    If ReadReg("", "auto") = "1" Then
        Label5.Caption = "�Զ���¼��" & errProxy(main.Error) & "|" & Int(Rnd * 10000)
        Timer1.Interval = 2000
        Timer1.Enabled = True
    End If
    If main.Error = "error5 waitsec <3" Then
        Label5.Caption = "��3��֮�����ԣ�" & Int(Rnd * 100)
    ElseIf main.Error = "bind userid error" Then
        MsgBox "����δ�󶨴���Ӫ�̵��˺����룡����ѡ��У԰����¼�������������Ӫ���˺����뼴�ɣ�", vbInformation, "У԰����¼ʱ����"
    ElseIf main.Error = "userid error1" Then
        MsgBox "��У԰���˺Ų����ڣ�", vbInformation, "У԰����¼ʱ����"
    ElseIf main.Error = "userid error2" Then
        MsgBox "��������������������룡", vbInformation, "У԰����¼ʱ����"
    ElseIf main.Error = "Oppp error: can't find user." Then
        MsgBox "��ѡ�����Ӫ�̻�δ���˺ţ�����ѡ��У԰����¼���ٰ���Ӫ���˺ţ�", vbInformation, "У԰����¼ʱ����"
    Else
        If Val(ReadReg("", "type")) = 0 Then
            MsgBox main.Error, vbInformation, errProxy(main.Error) 'errProxy(main.Error) & Int(Rnd * 100)
        Else
            MsgBox main.Error, vbInformation, errProxy(main.Error)
        End If
    End If
End If

End Sub

Private Sub Command2_Click()
main.about
End Sub


Private Sub Form_Load()
Dim i As Long
WriteReg "", "test", "1"
If ReadReg("", "test") <> "1" Then
    MsgBox "�޷�����ע������Ҽ�ʹ�ù���Ա���У�", vbCritical, "���"
End If

If App.PrevInstance Then
    'tray.m_NotifyIcon.ShowBubble "�࿪����", "Ϊ���ϳ��������ȶ����������еڶ���ʵ����лл��"
    MsgBox "��˫���ˣ����������û��˫��������ʹ�����������������һ�����̣�", vbInformation
    End
End If

version = App.Major & "." & App.Minor & "." & App.Revision
Me.Caption = "��������ѧ-У԰������ " & version & " ����CH"

If Len(Command) >= 4 Then
    Dim path As String
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    If Command = "update" Or Left(Command, 4) = "upin" Then
        On Error Resume Next
        DelayM 100
        Randomize
        If Left(Command, 4) = "upin" Then
            path = App.path & "\" & Mid(Command, 5) & ".exe"
            If Dir(path, vbNormal) <> "" Then 'ɾ���ɰ汾
                Do
                    i = i + 1
                    fso.DeleteFile path, True
                    If Dir(path, vbNormal) = "" Then Exit Do 'ɾ���ɹ��˳�ѭ��
                    DelayM 100
                Loop Until i > 100
            End If
        End If
        Dim file1 As String, file2 As String
        file1 = App.path & "\" & App.ExeName & ".exe" '����ļ���
        file2 = App.path & "\��У԰����¼.exe" '�淶���ļ���
        If Dir(file1, vbNormal) = "" Then
            MsgBox "���³����Ҳ���" & file1 & "���°汾�Ѿ�Ϊ�����غã��������Ҳ����ļ���" & App.path & "\" & App.ExeName & ".exe" & vbCrLf & "��ȷ��û�����̸�Ŀ¼��"
            End
        End If
        
        fso.CopyFile App.path & "\" & App.ExeName & ".exe", file2
        Set fso = Nothing
        Shell file2 & " upok" & App.ExeName, vbNormalFocus
        End
    End If
    If Left(Command, 4) = "upok" Then
        On Error Resume Next
        DelayM 100
        path = App.path & "\" & Mid(Command, 5) & ".exe"
        If Dir(path, vbNormal) <> "" Then
            Do
                i = i + 1
                fso.DeleteFile path, True
                If Dir(path, vbNormal) = "" Then Exit Do
                DelayM 100
            Loop Until i > 100
        End If
        If ReadReg("", "auto") <> "1" Then
            MsgBox "����ѳɹ��Զ����£��˳���·����" & path & "" & vbCrLf & "���ȷ��������"
        End If
    End If
    If Command = "autorun" Then
        WriteReg "", "auto", "1"
        '�Զ������϶���Ҫ�Զ���¼
    End If
End If
Set objScrCtl = CreateObject("MSScriptControl.ScriptControl") '��ʼ��js������
objScrCtl.Language = "JavaScript"

Text1.text = ReadReg("", "zh")
Text2.text = ReadReg("", "mm")
Check1.Value = IIf(Text2.text <> "", 1, 0)
Check2.Value = IIf(ReadReg("", "auto") = "1", 1, 0)

Dim xiaoqu As Long
If ReadReg("", "xiaoqu") = "" Then
    xiaoqu = 0
Else
    xiaoqu = Val(ReadReg("", "xiaoqu"))
End If


Dim types As Long
If ReadReg("", "type") = "" Then
    types = 0
Else
    types = Val(ReadReg("", "type"))
End If

Option1(types).Value = True
Option2(xiaoqu).Value = True

'MsgBox md5.md5("1", 32)
Timer1.Enabled = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If Not needUnload Then End
End Sub

Private Sub Option1_Click(Index As Integer)
    If Option1(Index).Value Then
        WriteReg "", "type", Index
    End If
End Sub
Private Sub Option2_Click(Index As Integer)
    
    If Option2(Index).Value Then
        If Index = 1 Then
            If Option1(2).Value = True Then Option1(0).Value = True
            Option1(2).Enabled = False
        Else
            Option1(2).Enabled = True
        End If
        WriteReg "", "xiaoqu", Index
    End If
End Sub
Private Sub Text2_KeyPress(KeyAscii As Integer)
If KeyAscii = 13 Then
    Command1_Click
End If
End Sub

Private Sub Timer1_Timer()
    Timer1.Enabled = False
    If Timer1.Interval <> 2000 Then
        If ReadReg("", "auto") <> "1" Then 'û���Զ���¼����Ҫ������
            main.checkUpdate
        Else
            Do
                If main.checkUpdate() = 0 Then Exit Do
                DelayM 2000
            Loop Until 0
        End If
    End If
    
    
    
    'MsgBox types
    If ReadReg("", "auto") = "1" Then
        Label5.Caption = "�Զ���¼��..." & Rnd
        Command1_Click
    Else
        'If main.check_login Then
            'MsgBox "У԰���ѵ�¼������������У԰���˺����룬�´δ򿪿ɿ��ٵ�¼��"
        'End If
    End If
End Sub
