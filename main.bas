Attribute VB_Name = "main"
Option Explicit
Public Declare Function URLDownloadToFile Lib "urlmon" Alias "URLDownloadToFileA" (ByVal pCaller As Integer, ByVal szURL As String, ByVal szFileName As String, ByVal dwReserved As Integer, ByVal lpfnCB As Integer) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Public domain As String
Private Type userinfoType
    userRealName As String
    userGroupName As String
    internetDownFlow As String
    internetUpFlow As String
    Time As String
    flow As String
End Type
Private Type bindType
    csrf As String
    data1 As String
    data2 As String
    data3 As String
    data4 As String
    data5 As String
    data6 As String
End Type
Public userinfo As userinfoType
Public bindinfo As bindType
Public Error As String
Public version As String
Dim cookie As String
Dim checkcode As String
Dim csrf As String
Public local_zh As String
Public local_mm As String
Public objScrCtl As Object
Public connect_n As Long
Function errProxy(s As String)
Dim text As String
text = "|SESSION�ѹ���,�����µ�¼|no errcode|AC��֤ʧ��|Authentication Fail ErrCode=04|����ʱ��/�����ѵ�����|Authentication Fail ErrCode=05|�����˺���ͣ�������ͣ���Ŀ���ԭ�� 1���û�Ƿ��ͣ�� 2���û���ͣ ��Ҫ�˽����ԭ���������������ϵͳ��|Authentication Fail ErrCode=09|���˺ŷ��ó�֧����ֹʹ��|Authentication Fail ErrCode=11|������Radius��¼|Authentication Fail ErrCode=80|���������������|Authentication Fail ErrCode=81|LDAP��֤ʧ��|Authentication Fail ErrCode=85|�˺�����ʹ��|Authentication Fail ErrCode=86|��IP��MACʧ��|Authentication Fail ErrCode=88|IP��ַ��ͻ|Authentication Fail ErrCode=94|�����������������|err(2)|����ָ���ĵ�¼Դ��ַ��Χ�ڵ�¼|err(3)|����ָ����IP��¼|err(7)|����ָ���ĵ�¼ԴVLAN��Χ��¼|err(10)|����ָ����Vlan��¼|err(11)|����ָ����MAC��¼|err(17)|����ָ�����豸�˿ڵ�¼|userid error1|�˺Ų�����|userid error2|�������|userid error3|�������|auth error4|�û�ʹ������������|auth error5|�˺���ͣ��|auth error9|ʱ��������֧|auth error80|��ʱ�ν�ֹ����|auth error99|�û������������|" & _
"auth err198|�û������������|auth error199|�û������������|auth error258|�˺�ֻ����ָ������ʹ��|auth error|�û���֤ʧ��|set_onlinet error|�û�����������|In use|��¼������������|port err|�Ͽ�ʱ�䲻��������|can not use static ip|������ʹ�þ�̬IP|[01], ���ʺ�ֻ����ָ��VLANIDʹ��(0.4095)|���ʺ�ֻ����ָ��VLANIDʹ��|Mac, IP, NASip, PORT err(6)!|���ʺ�ֻ����ָ��VLANIDʹ��|wuxian OLno|VLAN��Χ�����˺ŵĽ���������������|Oppp error: 1|��Ӫ���˺�������󣬴�����Ϊ��1|Oppp error: 5|��Ӫ���˺����ߣ�������Ϊ��5|Oppp error: 18|��Ӫ���˺�������󣬴�����Ϊ��18|Oppp error: 21|��Ӫ���˺����ߣ�������Ϊ��21|Oppp error: 26|��Ӫ���˺ű��󶨣�������Ϊ��26|Oppp error: 29|��Ӫ���˺��������û��˿�NAS-Port-Id���󣬴�����Ϊ��29|Oppp error: userid inuse|��Ӫ���˺��ѱ�ʹ��|Oppp error: can't find user|��Ӫ���˺��޷���ȡ�򲻴���|bind userid error|����Ӫ���˺�ʧ��|Oppp error: TOO MANY CONNECTIONS|��Ӫ���˺�����|Oppp error: Timeout|��Ӫ���˺�״̬�쳣(Ƿ�ѵ�)|Oppp error: User dial-in so soon|��Ӫ���˺Ÿ�����|Oppp error: " & _
"SERVICE SUSPENDED|Ƿ����ͣ����|Oppp error: open vpn session fail!|��Ӫ���˺���Ƿ��,���ֵ|Oppp error: INVALID LOCATION.|��Ӫ���������û��˿ڴ���|Oppp error: 99|�ʺŰ�������������ϵ��Ӫ�̼�����|error5 waitsec <3|��¼����Ƶ������Ⱥ����µ�¼��"
Dim arr
arr = Split(text, "|")
Dim l As Long, i As Long
l = (UBound(arr) + 1) / 2
For i = 0 To l - 1
    If s = arr(i * 2) Then
        errProxy = arr(i * 2 + 1)
        Exit Function
    End If
Next
errProxy = "��¼�쳣"
End Function
Function getUserInfo() As Boolean
On Error Resume Next:
If cookie = "" Then
    Exit Function
End If
Dim WinHttp
Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
'���ò���
WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
WinHttp.Option(4) = 13056 '���Դ����־
WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
WinHttp.Open "GET", "http://uss.glut.edu.cn/Self/dashboard", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
WinHttp.SetRequestHeader "Host", "uss.glut.edu.cn"
WinHttp.SetRequestHeader "Connection", "keep-alive"
WinHttp.SetRequestHeader "Cookie", "JSESSIONID=" & cookie
WinHttp.SetRequestHeader "DNT", "1"
WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
WinHttp.SetRequestHeader "Origin", "http://uss.glut.edu.cn" '������������
WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
WinHttp.send
WinHttp.WaitForResponse
Dim result As String, userRealName As String
result = WinHttp.ResponseText
If InStr(1, result, "userRealName"":""") Then
    userinfo.userRealName = Split(Split(result, "userRealName"":""")(1), """")(0)
Else
    Exit Function
End If
If InStr(1, result, "userGroupName"":""") Then
    userinfo.userGroupName = Split(Split(result, "userGroupName"":""")(1), """")(0)
Else
    Exit Function
End If
If InStr(1, result, "internetDownFlow"":") Then
    userinfo.internetDownFlow = Trim(Split(Split(result, "internetDownFlow"":")(1), ",")(0))
Else
    Exit Function
End If

If InStr(1, result, "internetUpFlow"":") Then
    userinfo.internetUpFlow = Trim(Split(Split(result, "internetUpFlow"":")(1), ",")(0))
Else
    Exit Function
End If

getUserInfo = True
End Function

Function login(zh As String, mm As String, Optional loginType = 0) As Boolean
On Error Resume Next:
If zh = "" Or mm = "" Then
    Exit Function
End If
If Val(ReadReg("", "xiaoqu")) = 0 Then
    main.domain = "172.16.2.2"
Else
    main.domain = "202.193.80.124"
End If
DoEvents
Dim WinHttp
Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
'���ò���
WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
WinHttp.Option(4) = 13056 '���Դ����־
WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
WinHttp.Open "GET", "http://" & main.domain & "/drcom/login?callback=dr1004&DDDDD=" & zh & "&upass=" & mm & "&0MKKey=123456&R1=0&R3=" & loginType & "&R6=0&para=00&v6ip=&v=8239", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
WinHttp.SetRequestHeader "Host", main.domain
WinHttp.SetRequestHeader "Connection", "keep-alive"
WinHttp.SetRequestHeader "DNT", "1"
WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
WinHttp.SetRequestHeader "Origin", "http://" & main.domain '������������
WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
WinHttp.send
WinHttp.WaitForResponse
Dim result As String
result = BytesToBstr(WinHttp.ResponseBody, "GB2312")
If result = "" Then
Exit Function
End If
If InStr(1, result, "dr1004({") Then
    Dim js As String
    js = "{" & Split(Split(result, "dr1004({")(1), "})")(0) & "}"
    'MsgBox js
    If objScrCtl.Eval("(" & js & ").result") = "1" Then '��¼�ɹ���
        local_zh = zh
        local_mm = mm
        login = True
    Else
        Error = objScrCtl.Eval("(" & js & ").msga")
    End If
End If

End Function
Function check_login()
On Error Resume Next:
Dim WinHttp
Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
'���ò���
WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
WinHttp.Option(4) = 13056 '���Դ����־
WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
WinHttp.Open "GET", "http://" & main.domain, True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
WinHttp.SetRequestHeader "Host", main.domain
WinHttp.SetRequestHeader "Connection", "keep-alive"
WinHttp.SetRequestHeader "DNT", "1"
WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
WinHttp.SetRequestHeader "Origin", "http://" & main.domain '������������
WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
WinHttp.send
WinHttp.WaitForResponse

Dim result As String
result = BytesToBstr(WinHttp.ResponseBody, "GB2312")
'result = WinHttp.ResponseText
If InStr(1, result, "NID='") Then
    
    userinfo.userRealName = Trim(Split(Split(result, "NID='")(1), "'")(0))
    userinfo.Time = Trim(Split(Split(result, "time='")(1), "'")(0))
    userinfo.flow = Round(Trim(Split(Split(result, "flow='")(1), "'")(0)) / 1024, 3)
    check_login = True
    
End If

End Function
Function get_yys() As String
    get_yys = ReadReg("", "type")
    If get_yys = "" Then
        get_yys = "0"
    End If
End Function
Function getYYS(yysType As String) As String
If yysType = "" Or yysType = "0" Then
    getYYS = "У԰��"
    Exit Function
ElseIf yysType = "1" Then
    getYYS = "����"
    Exit Function
ElseIf yysType = "2" Then
    getYYS = "�ƶ�"
    Exit Function
ElseIf yysType = "3" Then
    getYYS = "��ͨ"
    Exit Function
End If
End Function
Function refresh_info()
Form2.info(0).Caption = "��Ӫ�̣�" & getYYS(ReadReg("", "type"))
Form2.info(1).Caption = "�û���" & userinfo.userRealName
Form2.info(2).Caption = "��ʱ����" & userinfo.Time & " ��"
Form2.info(3).Caption = "��������" & userinfo.flow & " MB"
'Form2.info(4).Caption = "�豸��" & 0 & " ̨"
End Function
Function login_uss() As Boolean '��uss��¼У԰��
On Error Resume Next:
    Dim zh As String, mm As String
    zh = local_zh
    mm = local_mm
    If Not getcookie() Then
        Error = "У԰����ʱ���ȶ���ʧЧ�����Ժ����ԣ�"
        Exit Function
    End If
    Dim DAT As String
    DAT = "foo=&bar=&checkcode=" & checkcode & "&account=" & zh & "&password=" & md5.md5(mm, 32) & "&code="
    'MsgBox DAT
    
    Dim WinHttp
    
    Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    '���ò���
    WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
    WinHttp.Option(4) = 13056 '���Դ����־
    WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
    WinHttp.Open "GET", "http://uss.glut.edu.cn/Self/login/randomCode", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
    WinHttp.SetRequestHeader "Host", "uss.glut.edu.cn"
    WinHttp.SetRequestHeader "Connection", "keep-alive"
    WinHttp.SetRequestHeader "Cookie", "JSESSIONID=" & cookie
    WinHttp.SetRequestHeader "DNT", "1"
    WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
    WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
    WinHttp.SetRequestHeader "Origin", "http://uss.glut.edu.cn" '������������
    WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
    WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
    WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
    WinHttp.send
    WinHttp.WaitForResponse
    
    Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1") '���ò���
    WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
    WinHttp.Option(4) = 13056 '���Դ����־
    WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
    WinHttp.Open "POST", "http://uss.glut.edu.cn/Self/login/verify", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
    
    WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
    WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.9"
    WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
    WinHttp.SetRequestHeader "Connection", "keep-alive"
    WinHttp.SetRequestHeader "Content-Length", Len(DAT)
    WinHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    WinHttp.SetRequestHeader "Cookie", "JSESSIONID=" & cookie
    WinHttp.SetRequestHeader "Host", "uss.glut.edu.cn"
    WinHttp.SetRequestHeader "Origin", "http://uss.glut.edu.cn"
    WinHttp.SetRequestHeader "Referer", "http://uss.glut.edu.cn/Self/login/"
    WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
    WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ

    WinHttp.send (DAT)
    WinHttp.WaitForResponse
    Dim result
    result = WinHttp.ResponseText

    If InStr(1, result, "csrftoken") Then
        csrf = Trim(Split(Split(result, "csrftoken: '")(1), "'")(0))
        'MsgBox csrf
        login_uss = True
    End If
    If InStr(1, result, "})('") Then
        Error = Split(Split(result, "})('")(1), "'")(0) '��¼ʧ��ʱ����ʾ��
    End If
    getUserInfo
End Function

Function getcookie() As Boolean '�õ�һ���µ�cookie
On Error Resume Next:
Dim url As String
url = "http://uss.glut.edu.cn/Self/login/"

Dim WinHttp
Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
'���ò���
WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
WinHttp.Option(4) = 13056 '���Դ����־
WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
WinHttp.Open "GET", url, True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
WinHttp.SetRequestHeader "Host", "uss.glut.edu.cn"
WinHttp.SetRequestHeader "Connection", "keep-alive"
WinHttp.SetRequestHeader "DNT", "1"
WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
WinHttp.SetRequestHeader "Origin", "http://uss.glut.edu.cn" '������������
WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
WinHttp.send
WinHttp.WaitForResponse
Dim result
result = WinHttp.ResponseText

cookie = WinHttp.getResponseHeader("set-cookie")

If InStr(1, cookie, "JSESSIONID=") Then
    cookie = Trim(Split(Split(cookie, "JSESSIONID=")(1), ";")(0))
Else
    getcookie = False
    Exit Function
End If
If InStr(1, result, "name=""checkcode"" value=""") Then
    checkcode = Split(Split(result, "name=""checkcode"" value=""")(1), """")(0)
Else
    getcookie = False
    Exit Function
End If
getcookie = True
End Function

Function getbind() '�õ��󶨵���Ӫ��
On Error Resume Next:
Dim WinHttp
    
Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
'���ò���
WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
WinHttp.Option(4) = 13056 '���Դ����־
WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
WinHttp.Open "GET", "http://uss.glut.edu.cn/Self/service/operatorId", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
WinHttp.SetRequestHeader "Host", "uss.glut.edu.cn"
WinHttp.SetRequestHeader "Connection", "keep-alive"
WinHttp.SetRequestHeader "Cookie", "JSESSIONID=" & cookie
WinHttp.SetRequestHeader "DNT", "1"
WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
WinHttp.SetRequestHeader "Origin", "http://uss.glut.edu.cn" '������������
WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
WinHttp.SetRequestHeader "Referer", "http://uss.glut.edu.cn/Self/service"
WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"

WinHttp.send
WinHttp.WaitForResponse
Dim result
result = WinHttp.ResponseText
'Clipboard.Clear
'Clipboard.SetText result
If InStr(1, result, "value=""") Then
Dim valuearr
valuearr = Split(result, "value=""")

csrf = Split(valuearr(1), """")(0)
Dim data1, data2, data3, data4, data5, data6
data1 = Split(valuearr(2), """")(0)
data2 = Split(valuearr(3), """")(0)
data3 = Split(valuearr(4), """")(0)
data4 = Split(valuearr(5), """")(0)
data5 = Split(valuearr(6), """")(0)
data6 = Split(valuearr(7), """")(0)
bindinfo.csrf = csrf
bindinfo.data1 = data1
bindinfo.data2 = data2
bindinfo.data3 = data3
bindinfo.data4 = data4
bindinfo.data5 = data5
bindinfo.data6 = data6
Else
    MsgBox "��Ϣ����ʧ�ܣ�"
End If
End Function
Function bind(data1, data2, data3, data4, data5, data6) As Boolean
On Error Resume Next:
If bindinfo.csrf = "" Then
    getbind
End If

Dim DAT As String
DAT = "csrftoken=" & bindinfo.csrf & "&FLDEXTRA1=" & data1 & "&FLDEXTRA2=" & data2 & "&FLDEXTRA3=" & data3 & "&FLDEXTRA4=" & data4 & "&FLDEXTRA5=" & data5 & "&FLDEXTRA6=" & data6

Dim WinHttp As Object
Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1") '���ò���
WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
WinHttp.Option(4) = 13056 '���Դ����־
WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
WinHttp.Open "POST", "http://uss.glut.edu.cn/Self/service/bind-operator", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ

WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.9"
WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
WinHttp.SetRequestHeader "Connection", "keep-alive"
WinHttp.SetRequestHeader "Content-Length", Len(DAT)
WinHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
WinHttp.SetRequestHeader "Cookie", "JSESSIONID=" & cookie
WinHttp.SetRequestHeader "Host", "uss.glut.edu.cn"
WinHttp.SetRequestHeader "Origin", "http://uss.glut.edu.cn"
WinHttp.SetRequestHeader "Referer", "http://uss.glut.edu.cn/Self/service/operatorId"
WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ

WinHttp.send (DAT)
WinHttp.WaitForResponse

Dim result
result = WinHttp.ResponseText
'Clipboard.Clear
'Clipboard.SetText result
bindinfo.csrf = ""
If InStr(1, result, "})('") Then
    Dim text
    text = Split(Split(result, "})('")(1), "'")(0) '��¼ʧ��ʱ����ʾ��
    
    If InStr(1, text, "�ɹ�") Then
        Error = Trim(Replace(text, "\n", ""))
        bind = True
    Else
        Error = Trim(Replace(text, "\n", "")) 'û�������κζ�����ʱ��
        bind = False
    End If
    If Error = "" Then
        bind = True
        Error = "���豣�棡"
    End If
End If
End Function
Function checkUpdateFromHTTP(DAT As String) As String
    On Error Resume Next
    Dim WinHttp
    Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    '���ò���
    WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
    WinHttp.Option(4) = 13056 '���Դ����־
    WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
    WinHttp.Open "POST", "http://yiban.glut.edu.cn/xyw/update.php", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
    WinHttp.SetRequestHeader "Host", "yiban.glut.edu.cn"
    WinHttp.SetRequestHeader "Connection", "keep-alive"
    WinHttp.SetRequestHeader "Content-Length", Len(DAT)
    WinHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
    WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
    WinHttp.SetRequestHeader "Origin", "http://yiban.glut.edu.cn" '������������
    WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
    WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
    WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
    WinHttp.send (DAT)
    WinHttp.WaitForResponse
    checkUpdateFromHTTP = WinHttp.ResponseText
End Function
Function checkUpdateFromHTTPS(DAT As String) As String
    On Error Resume Next
    Dim WinHttp
    Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    '���ò���
    WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
    WinHttp.Option(4) = 13056 '���Դ����־
    WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
    WinHttp.Open "POST", "https://yiban.glut.edu.cn/xyw/update.php", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
    WinHttp.SetRequestHeader "Host", "yiban.glut.edu.cn"
    WinHttp.SetRequestHeader "Connection", "keep-alive"
    WinHttp.SetRequestHeader "Content-Length", Len(DAT)
    WinHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
    WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
    WinHttp.SetRequestHeader "Origin", "https://yiban.glut.edu.cn" '������������
    WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
    WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
    WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
    WinHttp.send (DAT)
    WinHttp.WaitForResponse
    checkUpdateFromHTTPS = WinHttp.ResponseText
End Function
Function checkUpdate() As Long '�����£�����Ƿ���ã���ʾ��Ƿ���У԰������
On Error Resume Next

Dim DAT As String
DAT = "checkupdate={""version"":""" & App.Major * 10000 + App.Minor * 100 + App.Revision & """}"

Dim result
result = checkUpdateFromHTTPS(DAT) '����HTTPS
If result = "" Then '����http
    result = checkUpdateFromHTTP(DAT)
End If
If result = "" Then '����https
    If ReadReg("", "auto") <> "1" Then
        DelayM 2000
        If checkUpdate() = 0 Then Exit Function
        MsgBox "��ʱ�޷�����У԰����У԰�����ȶ���������У԰�������ԣ�", vbCritical
        End
    Else
        checkUpdate = 1
        Exit Function
    End If
End If
'Clipboard.Clear
'Clipboard.SetText result
If Left(result, 1) <> "{" Then
    Exit Function
End If
If ReadReg("", "auto") <> "1" Then
    If objScrCtl.Eval("(" & result & ").text") <> "" Then
        MsgBox objScrCtl.Eval("(" & result & ").text"), vbInformation, "��Ҫ���ѣ�"
    End If
End If
If objScrCtl.Eval("(" & result & ").res") <> 100 Then
    WriteReg "", "auto", "0"
    End '����100���˳����
End If
If objScrCtl.Eval("(" & result & ").update") = "True" Then
    If ReadReg("", "auto") <> "1" Then
        MsgBox objScrCtl.Eval("(" & result & ").tip"), vbInformation '����������ʾ��
    End If
    Dim paths As String
    paths = App.path & "\up" & Int(Rnd * 100000) & ".exe"
    Call URLDownloadToFile(0, objScrCtl.Eval("(" & result & ").url"), paths, 0, 0)
    If Dir(paths, vbNormal) <> "" Then
        Shell paths & " upin" & App.ExeName
        End
    Else
        MsgBox "�Զ�����ʧ�ܣ����ֶ����£�������" & objScrCtl.Eval("(" & result & ").url") & "��"
        End
    End If
End If
checkUpdate = 0
'MsgBox result

End Function
Function logout()
On Error Resume Next:
Dim WinHttp
Set WinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
'���ò���
WinHttp.SetTimeouts 60000, 60000, 60000, 5000 '���ò�����ʱʱ��
WinHttp.Option(4) = 13056 '���Դ����־
WinHttp.Option(6) = True 'Ϊ True ʱ��������ҳ���ض�����תʱ�Զ���ת��False ���Զ���ת����ȡ����˷��ص�302״̬��
WinHttp.Open "GET", "http://" & main.domain & "/drcom/logout?callback=dr1003&v=5023", True 'GET �� POST, Url, False ͬ����ʽ��True �첽��ʽ
WinHttp.SetRequestHeader "Host", main.domain
WinHttp.SetRequestHeader "Connection", "keep-alive"
WinHttp.SetRequestHeader "DNT", "1"
WinHttp.SetRequestHeader "Cache-Control", "max-age=0"
WinHttp.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
WinHttp.SetRequestHeader "Origin", "http://" & main.domain '������������
WinHttp.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36 LBBROWSER" '�û��������Ϣ
WinHttp.SetRequestHeader "Accept-Language", "zh-CN,zh;q=0.8"
WinHttp.SetRequestHeader "Upgrade-Insecure-Requests", "1"
WinHttp.send
WinHttp.WaitForResponse
Dim result As String
result = BytesToBstr(WinHttp.ResponseBody, "GB2312")
If result = "" Then
Exit Function
End If
If InStr(1, result, "dr1003({") Then
    Dim js As String
    js = "{" & Split(Split(result, "dr1003({")(1), "})")(0) & "}"
    'MsgBox js
    If objScrCtl.Eval("(" & js & ").result") = "1" Then 'ע���ɹ���
        logout = True
    Else
        'MsgBox objScrCtl.Eval("(" & js & ").msga")
    End If
End If

End Function
Function ToUnixTime(strTime, intTimeZone)
On Error Resume Next
    If IsEmpty(strTime) Or Not IsDate(strTime) Then strTime = Now
    If IsEmpty(intTimeZone) Or Not IsNumeric(intTimeZone) Then intTimeZone = 0
     ToUnixTime = DateAdd("h", -intTimeZone, strTime)
     ToUnixTime = DateDiff("s", "1970-1-1 0:0:0", ToUnixTime)
End Function
Function about()
On Error Resume Next:
MsgBox "������ɣ���������ѧ-�������-CH����--------2019-12-09" & vbCrLf & _
"��ǰ�汾�ţ�" & version & vbCrLf & _
"��������ʹ�ã�" & vbCrLf & _
"����У԰����������" & vbCrLf & _
"����У԰��ϵͳ�������ڱ���ִ�У����������ѡ���˱�������󱣴��ڱ�����" & vbCrLf & _
"��������������ռ�������˽��Ϣ�������ϴ��˺��������Ϣ�������ʹ�á�" & vbCrLf & _
"�������е�������¼������ѧУ��У԰��ϵͳ�б��棬����Ƿ�ʹ�ô�����޹ء�" & vbCrLf & _
"������ʹ�ô��������Υ�������ĺ���뿪�����޹أ�" & vbCrLf & _
"�粻���������������������ֹͣʹ�ã�" & vbCrLf & _
"ʹ�÷���������glut_web��wifi������У԰�������ߣ�����������˺����뼴�ɡ�" & vbCrLf & _
"лл����ʹ�ã���ѧϰ����Ⱥ��60913498"
End Function
Public Sub DelayM(Msec As Long)
On Error Resume Next:
On Error Resume Next
    Dim EndTime As Long
    EndTime = Int(ToUnixTime(Now, 8)) + -Int(-Msec / 1000)
    Do
        Sleep 1
        DoEvents
    Loop While Int(ToUnixTime(Now, 8)) < EndTime
End Sub
Public Function apppath()
apppath = App.path
If Right(apppath, 1) = "\" Then apppath = Left(apppath, Len(apppath) - 1)
End Function
Public Function BytesToBstr(strBody, CodeBase)
On Error Resume Next:
Dim ObjStream
Set ObjStream = CreateObject("Adodb.Stream")
With ObjStream
.Type = 1
.Mode = 3
.Open
.Write strBody
.Position = 0
.Type = 2
.Charset = CodeBase
BytesToBstr = .ReadText
.Close
End With
Set ObjStream = Nothing
End Function
