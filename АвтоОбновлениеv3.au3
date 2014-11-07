#include <GUIConstants.au3>
#include <Date.au3>
#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#NoTrayIcon
$NumParams = $CmdLine[0]


Global $InputLogin
Global $InputPassword
Global $Auth = False
Global $MultiUse = False
Global $UseAuth
Global $User
Global $Password
Global $UseBackup
Global $PathBackup
Global $FormatPathBackup
Global $IgnoreResult
Global $UseLogs = True
Global $PathLogs
Global $FormatPathLogs
Global $OneLog
Global $ShowLogs
Global $UseRIB
Global $UseFileUp
Global $FileUpPath
Global $UseBlockUsers
Global $UseBreak
Global $PathBaseFiles
Global $Path1CEXE
Global $TimeWait
Global $DefaultTimeWait
Global $FileCfg
Global $UseLoadCf
Global $A_Clear[1]
;~ ��������� ����������� ��������� ����� INI ����
If $NumParams = 1 Then

	$Param = $CmdLine[1]
	If StringInStr($Param,'File=') > 0 OR StringInStr($Param,'Srvr=') > 0 Then
		$ConnectStr = $Param
	Else
		$MultiFile = $CmdLine[1]
		$MultiUse = True
	EndIf
	$IniFileName = "UpdateScript.ini"
ElseIf $NumParams = 2 Then
	$MultiFile = $CmdLine[1]
	$MultiUse = True
	$IniFileName = $CmdLine[2]
	$UpdateScript = FileExists($IniFileName)
If Not $UpdateScript Then
	MsgBox(0,'������','�� ������ ���� ��������!')
	Exit
EndIf
Else
	$IniFileName = "UpdateScript.ini"
EndIf


$UpdateScript = FileExists($IniFileName)
Opt("GUIOnEventMode", 1)
If Not $UpdateScript Then
;~ 		��������� 1�
		$UseAuth = True
		WriteLog ($IniFileName, "[1C]")
		WriteLog ($IniFileName,';������������� ������������� ��� ��������� "��������" �������')
		WriteLog ($IniFileName,';���� �� ������������ �� ����� ����������� ��������� ���� ���������')
		WriteLog ($IniFileName, "������������ �������������=��")
		$User = "�������������"
		WriteLog ($IniFileName,';������������ ��� ����������� �� ���������')
		WriteLog ($IniFileName, "������������="&$User)
		$Password = ''
		WriteLog ($IniFileName,';������ ��� ����������� �� ���������')
		WriteLog ($IniFileName, "������=")
;~ 		��������� ������
		WriteLog ($IniFileName, "[Backup]")
		$UseBackup = True
		WriteLog ($IniFileName,';������������� ������� �������� Backup')
		WriteLog ($IniFileName,';���� �� ������� ������������� Backup, ����� �� ��������� ������������')
		WriteLog ($IniFileName, "������ Backup=��")
		$PathBackup = ''
		WriteLog ($IniFileName,';���� � ����� � ��������')
		WriteLog ($IniFileName, "���� � �������=")
		$FormatPathBackup = '@BASENAME@\@DATE@\@FILENAME@.DT'
		WriteLog ($IniFileName,";�������� ������� ����� Backup'a")
		WriteLog ($IniFileName,";����� ������������ ������� ��������� ���������:")
		WriteLog ($IniFileName,";@DATE@ - ���� ������ ���������� � ������� ��������_��_��")
		WriteLog ($IniFileName,";@BASENAME@ - ��� ���� ��� ������� ���������� �����, �������� �� ����������� ��������� ��� �� ������")
		WriteLog ($IniFileName,";@FILENAME@ - ������������ ���(��� ����������)")
		WriteLog ($IniFileName, "������ ����� Backup'a="& $FormatPathBackup)
		$IgnoreResult =  False
		WriteLog ($IniFileName,";������������� ���������� Backup'a")
		WriteLog ($IniFileName,"������������ ��������� Backup'a =���")
;~ 		��������� ������� ������� ���������
		WriteLog ($IniFileName, "[ExecuteEpf]")
		$UseRunEpf = False
		WriteLog ($IniFileName,';������������� ������� ������� ������� ���������')
		WriteLog ($IniFileName,';���� �� ������� ������������� ������� ���������, ����� �� ��������� �� ������������')
		WriteLog ($IniFileName, "��������� ��������� = ���")
		$PathForEpf = ''
		WriteLog ($IniFileName,';���� � ��������� ����� � ������� ����������')
		WriteLog ($IniFileName, "���� � ������� ���������=")

		$UseRunEpfAfterUpdate = False
		WriteLog ($IniFileName,';������������� ������� ������� ������� ���������')
		WriteLog ($IniFileName,';���� �� ������� ������������� ������� ���������, ����� �� ��������� �� ������������')
		WriteLog ($IniFileName, "��������� ��������� ����� ���������� = ���")
		$PathForEpfAfterUpdate = ''
		WriteLog ($IniFileName,';���� � ��������� ����� � ������� ����������')
		WriteLog ($IniFileName, "���� � ������� ��������� ����� ����������=")

;~ 		��������� ��������� ������� �������������
		WriteLog ($IniFileName, "[ExecuteConfig]")
		$UseRunConfig = False
		WriteLog ($IniFileName,';������������� ������� ��������� ������� �������������')
		WriteLog ($IniFileName,';���� �� ������� ������������� ������� ������������� ����� �� ��������� �� ������������')
		WriteLog ($IniFileName, "��������� ������������ �� ���������� = ���")
		$ParamForConfig = ''
		WriteLog ($IniFileName,';����� ���������� ������� �������������')
		WriteLog ($IniFileName, "��������� ������� ��=")

		$UseRunConfigAfterUpdate = False
	    WriteLog ($IniFileName,';������������� ������� ��������� ������� �������������')
		WriteLog ($IniFileName,';���� �� ������� ������������� ������� ������������� ����� �� ��������� �� ������������')
		WriteLog ($IniFileName, "��������� ������������ ����� ���������� = ���")
		$ParamForConfigAfterUpdate = ''
		WriteLog ($IniFileName,';����� ���������� ������� �������������')
		WriteLog ($IniFileName, "��������� ������� �����=")

;~ 		��������� �����
		WriteLog ($IniFileName, "[Logs]")
		$UseLogs =  True
		WriteLog($IniFileName, ";������� ������� �����")
		WriteLog($IniFileName, "����� ����=��")
		$PathLogs = ''
		WriteLog($IniFileName, ";���� � ����� � ������")
		WriteLog($IniFileName, "���� � �����")
		$FormatPathLogs = '@BASENAME@\@DATE@\@FILENAME@.txt'
		WriteLog ($IniFileName,";�������� ������� ����� ���� Backup'a")
		WriteLog ($IniFileName,";����� ������������ ������� ��������� ���������:")
		WriteLog ($IniFileName,";@DATE@ - ���� ������ ���������� � ������� ��������_��_��")
		WriteLog ($IniFileName,";@BASENAME@ - ��� ���� ��� ������� ���������� ���, �������� �� ����������� ��������� ��� �� ������")
		WriteLog ($IniFileName,";@FILENAME@ - ������������ ���(��� ����������)")
		WriteLog ($IniFileName,"������ ����� �����="&$FormatPathLogs)
		WriteLog ($IniFileName,";�������� ������ ���� Backup'a")
		WriteLog ($IniFileName,";��� ������������� ���������� ����� ������ ���")
		WriteLog ($IniFileName,";������ �������� ���������� ������� ������ ����")
		WriteLog ($IniFileName,";��� ��������� ����� �������� (1 ����) ")
		WriteLog ($IniFileName,";������ �������� ���������� ���������� ��������������� ����")
		$OneLog = False
		WriteLog($IniFileName,"���� ����� ���=���")
		$ShowLogs = False
		WriteLog ($IniFileName,";����� ���� �� ���������� ������")
		WriteLog($IniFileName,"�������� ���=���")
;~ 		��������� ����������
		WriteLog ($IniFileName, "[Update]")
		$UseRIB = True
		WriteLog($IniFileName, ";������������� ���������� ��� ���'��")
		WriteLog($IniFileName, ";��������: �� ������������� ��������")
		WriteLog($IniFileName, ";� ������ ������ ����� ������� �������� ��� ������� 1�:����������� '�������������������' ����� �������� ������ ")
		WriteLog($IniFileName, ";� ����� ���������� �� ����� ������� �������� ��� ������� 1�:����������� '������������������' ")
		WriteLog($IniFileName, "������������ ���=��")
		$UseParamLoadUpdate = False
		WriteLog($IniFileName, "������������ �������� ������������������� = ���")

		$UseParamLoadUpload = False
		WriteLog($IniFileName, "������������ �������� ������������������ = ���")



		$UseFileUp = False
		WriteLog($IniFileName, ";������������ ���������� �� �����")
		WriteLog($IniFileName, "������������ ���������� �� �����=���")
		$FileUpPath = ''
		WriteLog($IniFileName, ";���� � ����� ���������� ������������, ���� ��� ��������� �� ���������")
		WriteLog($IniFileName, ";���� ���� �� �����, � ����� ������� ��������� �� �����")
		WriteLog($IniFileName, ";����� ������ ������ ������ �����")
		WriteLog($IniFileName, "���� � ����� ����������=")
		WriteLog($IniFileName, "������������ �������� cf= ���")
		WriteLog($IniFileName, "���� � ����� ������������=")

;~ 		��������� ���������� �������������
		$UseBlockUsers = True
		WriteLog($IniFileName, "[BlockUsers]")
		WriteLog($IniFileName, ";��������: �� ������������� ��������")
		WriteLog($IniFileName, ";� ������ ������ ����� ������� �������� ��� ������� 1�:����������� '������������������������' ")
		WriteLog($IniFileName, ";� ����� ������ ������� ����� ������� �������� ��� ������� 1�:����������� '����������������������������' ")
		WriteLog($IniFileName, "������������ ���������� ������������� = ��")
;~ 		��������� Updater'�
		WriteLog ($IniFileName, "[Default]")
		WriteLog ($IniFileName, ";��������� ������� ���������� ��� ������")
		$UseBreak = False
		WriteLog ($IniFileName, ";����������� ��������� ����� ������� ��������")
		WriteLog ($IniFileName, ";���� ���� ����������� ���������� ������� �� ���������")
		WriteLog($IniFileName, "����������� ��������� ����� ������� ��������=���")
		$PathBaseFiles = ''
		WriteLog ($IniFileName, ";���� � ����� �� ������� ��� (��������������)")
		WriteLog($IniFileName, "���� � ����� �� ������� ���="&$PathBaseFiles)
		WriteLog ($IniFileName,";������ ����� ������ ������ ��� ")
		WriteLog ($IniFileName,";� ��� �� ��������� �� ����� �������� ")
		WriteLog ($IniFileName,";��� ���������:")
		WriteLog ($IniFileName,";��� ��������� ��������: ")
		WriteLog ($IniFileName,";@BASENAME@ - ��� ���� ��� ������� ��������� ")
		WriteLog ($IniFileName,";@BASEPATH@ - ������ ���������� � ����� ������ (������� � 1�: ������������������������()) ��� ������� � �������� ������")
		WriteLog ($IniFileName,";������: @BASENAME@|@BASEPATH@ ")
		WriteLog ($IniFileName,";��� ���������� ��������: ")
		WriteLog ($IniFileName,";������: @ConnectString@ - ������ ���������� � ����� ������ (������� � 1�: ������������������������()) ��� ������� � �������� ������")
		$Path1CEXE = 'C:\Program Files\1cv81\bin\1cv8.exe'
		WriteLog ($IniFileName,";���� � ������������ ����� 1� (1cv8.exe)")
		WriteLog ($IniFileName,";���� ���� �� �����, ����� ������ ������ ������ �����")
		WriteLog ($IniFileName,"���� � ����� ��������� ����� 1�="&$Path1CEXE)
 		$TimeWait = 120
		WriteLog ($IniFileName,";����� �������� ���������� �������� 1�")
		WriteLog ($IniFileName,";�� ��������� 2 ���� ����� ����� ������ ��������� � ���������� ��������")
		WriteLog ($IniFileName,";����������� � �������")
		WriteLog ($IniFileName,"�����="&$TimeWait)
	Else
;~ 		��������� 1�
		$UseAuth = IniRead($IniFileName, "1C", "������������ �������������", "������")
		$UseAuth = StringToBool ($UseAuth,True)
		$User = IniRead($IniFileName, "1C", "������������", "�������������")
		$Password = IniRead($IniFileName, "1C", "������", "")

;~ 		��������� ������
		$UseBackup = IniRead($IniFileName, "Backup", "������ Backup", "������")
		$UseBackup = StringToBool ($UseBackup,True)
		$PathBackup = IniRead($IniFileName, "Backup", "���� � �������", "")
		$FormatPathBackup = IniRead($IniFileName, "Backup", "������ ����� Backup'a", '@BASENAME@\@DATE@\@FILENAME@.DT')
		$IgnoreResult = IniRead($IniFileName, "Backup", "������������ ��������� Backup'a", "���")
		$IgnoreResult = StringToBool ($IgnoreResult,False)

;~ 		��������� ������� ������� ���������
		$UseRunEpf = IniRead($IniFileName, "ExecuteEpf", "��������� ���������", "����")
		$UseRunEpf = StringToBool ($UseRunEpf,False)
		$PathForEpf = IniRead($IniFileName, "ExecuteEpf", "���� � ������� ���������", "")

		$UseRunEpfAfterUpdate = IniRead($IniFileName, "ExecuteEpf", "��������� ��������� ����� ����������", "����")
		$UseRunEpfAfterUpdate = StringToBool ($UseRunEpfAfterUpdate,False)
		$PathForEpfAfterUpdate = IniRead($IniFileName, "ExecuteEpf", "���� � ������� ��������� ����� ����������", "")

;~ 		��������� ��������� ������� �������������
		$UseRunConfig = IniRead($IniFileName, "ExecuteConfig", "��������� ������������ �� ����������", "����")
		$UseRunConfig = StringToBool ($UseRunConfig,False)
		$ParamForConfig = IniRead($IniFileName, "ExecuteConfig", "��������� ������� ��", "")

		$UseRunConfigAfterUpdate = IniRead($IniFileName, "ExecuteConfig", "��������� ������������ ����� ����������", "����")
		$UseRunConfigAfterUpdate = StringToBool ($UseRunConfigAfterUpdate,False)
	    $ParamForConfigAfterUpdate = IniRead($IniFileName, "ExecuteConfig", "��������� ������� �����", "")

;~ 		��������� �����
		$UseLogs = IniRead($IniFileName, "Logs", "����� ����", "������")
		$UseLogs = StringToBool ($UseLogs,True)
		$PathLogs = IniRead($IniFileName, "Logs", "���� � �����", "")
		$FormatPathLogs = IniRead($IniFileName, "Logs", "������ ����� �����", "@BASENAME@\@DATE@\@FILENAME@.txt")

		$OneLog = IniRead($IniFileName, "Logs", "���� ����� ���", "���")
		$OneLog = StringToBool ($OneLog,False)
		$ShowLogs = IniRead($IniFileName, "Logs", "�������� ���", "����")
		$ShowLogs = StringToBool ($ShowLogs,False)

;~ 		��������� ����������
		$UseRIB = IniRead($IniFileName, "Update", "������������ ���", "��")
		$UseRIB = StringToBool ($UseRIB,True)
		$UseParamLoadUpdate = IniRead($IniFileName, "Update", "������������ �������� �������������������", "���")
		$UseParamLoadUpdate = StringToBool ($UseParamLoadUpdate,False)
		$UseParamLoadUpload = IniRead($IniFileName, "Update", "������������ �������� ������������������", "���")
		$UseParamLoadUpload = StringToBool ($UseParamLoadUpload,False)

		$UseFileUp = IniRead($IniFileName, "Update", "������������ ���������� �� �����", "���")
		$UseFileUp = StringToBool ($UseFileUp,True)
		$FileUpPath = IniRead($IniFileName, "Update", "���� � ����� ����������", "")

;~ 		��������� ���������� �������������
		$UseBlockUsers = IniRead($IniFileName, "BlockUsers", "������������ ���������� �������������", "��")
		$UseBlockUsers = StringToBool ($UseBlockUsers,True)

;~ 		��������� Updater'�
		$UseBreak = IniRead($IniFileName, "Default", "����������� ��������� ����� ������� ��������", "����")
		$UseBreak = StringToBool ($UseBreak,False)
		$Path1CEXE = IniRead($IniFileName, "Default", "���� � ����� ��������� ����� 1�", "C:\Program Files\1cv81\bin\1cv8.exe")
		$PathBaseFiles = IniRead($IniFileName, "Default", "���� � ����� �� ������� ���",'')
		$TimeWait = IniRead($IniFileName, "Default", "�����",120)
		$TimeWait = Number($TimeWait)
		If $TimeWait = 0 Then
			$TimeWait = 120
		EndIf
		$UseLoadCf = IniRead($IniFileName, "Update", "������������ �������� cf",'���')
		$UseLoadCf = StringToBool ($UseLoadCf,False)
		$FileCfg = IniRead($IniFileName, "Update", "���� � ����� ������������", "")
EndIf

If NOT FileExists($Path1CEXE) then
	$msg = MsgBox(20, "�� ��������� ���� ������� 1�", "�� ������ ������� ������ ����? ���� ���, �� ������ �������� ������ ", 50)
		if $msg = 7 Then
			Exit
		EndIf
EndIf

While 1
	If FileExists($Path1CEXE) then ExitLoop
	$Path1CEXE = FileOpenDialog("�������� ���� ������� ��������� 1� ", @ProgramFilesDir & "", "��������� (*.exe)", 1 )
WEnd

If $UseFileUp AND NOT FileExists($FileUpPath) then
	$msg = MsgBox(20, "�� ��������� ���� ��� ���������� ������������ 1�", "�� ������ ������� ������ ���� ����������? ���� ���, �� ������ �������� ������ ", 50)
		if $msg = 7 Then
			Exit
		EndIf
EndIf
if $UseFileUp Then
	While 1
		If FileExists($FileUpPath) then ExitLoop
		$FileUpPath = FileOpenDialog("�������� ���� ���������� ", @WorkingDir & "", "������������� 1� (*.cf)|���������� ������������ 1� (*.cfu)|��� ��������� (*.cfu;*.cf)", 1 )
	WEnd
EndIf
If $PathBaseFiles <>'' AND NOT FileExists($PathBaseFiles) then
	MsgBox(0,'������',"�� ������� ������ �������� � �������")
	Exit
Else
	$multiUse= True
	$MultiFile = $PathBaseFiles
EndIf


If $UseAuth Then

	Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode
	$mainwindow = GUICreate("������������ �������", 242, 120)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OKButton")
	GUICtrlCreateLabel("��� ���������� ������� ���������� ������:", 5, 10)
	$okbutton = GUICtrlCreateButton("��������� ������", 60, 85, 120)
	GUICtrlSetOnEvent($okbutton, "OKButton")
	GUISetState(@SW_SHOW)
	GUICtrlCreateLabel("������������ 1�:", 5, 37)
	GUICtrlCreateLabel("������ 1�:", 5, 62)
	$InputLogin =GUICtrlCreateInput ("�������������", 110,  35, 120, 20)
	$InputPassword =GUICtrlCreateInput ("", 110,  60, 120, 20,0x0020)

	;~ ���� ����� ������ � ������
	While 1
	  Sleep(1000)  ; Idle around
		If $Auth Then
		   GUIDelete()
		 ExitLoop
		EndIf

	WEnd

EndIf

#Region ### START Koda GUI section ### Form=
$MainForm = GUICreate("���������� ������������ 1�", 781, 350, 211, 145)
GUISetOnEvent($GUI_EVENT_CLOSE, "MainFormClose")
$Run = GUICtrlCreateTabItem("���������� �������")
GUICtrlSetState(-1, $GUI_HIDE)
$ProgressWait = GUICtrlCreateProgress(8, 30, 25, 313, $PBS_VERTICAL)
;~ $ProgressWait = GUICtrlCreateProgress(8, 30, 25, 313, BitOR($PBS_SMOOTH,$PBS_VERTICAL))
$lblProtocol = GUICtrlCreateLabel("��������:", 42, 84, 97, 28)
GUICtrlSetFont(-1, 16, 400, 0, "Garamond")
$lstLogList = GUICtrlCreateListView("����|����|��������|���������", 41, 117, 735, 227, BitOR($LVS_REPORT,$LVS_SINGLESEL,$LVS_SHOWSELALWAYS,$LVS_SORTDESCENDING,$LVS_AUTOARRANGE,$WS_HSCROLL))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 130)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 150)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 250)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 200)
$txtCommentRun = GUICtrlCreateInput("�������� �������", 40, 30, 737, 21, BitOR($ES_CENTER,$ES_AUTOHSCROLL,$ES_READONLY))
$ProgressStatus = GUICtrlCreateProgress(40, 60, 737, 17)
$txtBaseNameLog = GUICtrlCreateInput("�������� �������", 8, 4, 769, 21, BitOR($ES_CENTER,$ES_AUTOHSCROLL,$ES_READONLY))
#EndRegion ### END Koda GUI section ###

GUISetState(@SW_SHOW)


Func MainFormClose ()
	Exit
EndFunc

GUICtrlSetData ($ProgressWait,0)
_ArrayAdd($A_Clear,'')
FOR $element IN $A_Clear
	GUICtrlDelete($element)
NEXT

if $multiUse Then



	$MultiLogFileName = String (@YEAR)& String (@MON)&String (@MDAY) &'_'&String (@HOUR)&'_'& String (@MIN)&'\MultiLog.txt'


	$MultiLogFile = GetLogFile ($MultiLogFileName)
	$file = FileOpen($MultiFile, 0)

	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(0, "Error", "�� ���� ������� ��������� ���� ��� ������ � ������-�����������.")
		Exit
	EndIf

	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then
			ExitLoop
		EndIf
			$tline =''
;~ 			MsgBox(0, "Line read:", $line)
			$tline =''&$line
;~ 			MsgBox(0, "$tline read:", $tline)
;~ 			$array = StringSplit($tline, @TAB)
;~ 			If not @error Then
			$ConnectStr = $line
;~ 				MsgBox(0, "$PrgExe:", $PrgExe)
;~  			MsgBox(0, "$ConnectStr:", $ConnectStr)

				$BaseName = GetBaseName($ConnectStr)
				$Connect =GetConnectStr($ConnectStr)
				$prefics = GetPrefics($ConnectStr)
;~ 				MsgBox(0, "$Connect:", $Connect)
;~  				MsgBox(0, "$BaseName:", $BaseName)
;~ 				Exit
				If $UseBackUp Then
					$BackupName = GetBackupName ($BaseName,$FormatPathBackup,$Connect)
				Else
					$BackupName = ""
				EndIf

				if $UseLogs Then
					$LogFileName = GetLogFileName($FormatPathLogs,$BaseName,$Connect)
					$LogFile = GetLogFile($LogFileName)
				Else
					$LogFileName = ""
					$LogFile = ''
				EndIf
 				DoUp ($Path1CEXE,$BaseName,$Connect,$prefics,$BackupName,$LogFile)
				AddLogToMultiLog($MultiLogFile,$LogFileName,$BaseName,$Connect,$prefics,$BackupName)
;~ 		   EndIf
	Wend

	FileClose($MultiLogFile)

	MsgBox(0, "���������� �����������", "���������� ������ �������")
	Sleep(60)
	If $ShowLogs Then ShellExecute($MultiLogFileName)
	Exit
Else
	$BaseName = GetBaseName($ConnectStr)
	$Connect =GetConnectStr($ConnectStr)
	$prefics = GetPrefics($ConnectStr)
	If $UseBackUp Then
		$BackupName = GetBackupName ($BaseName,$FormatPathBackup,$Connect)
	Else
		$BackupName = ""
	EndIf
	if $UseLogs Then
		$LogFileName = GetLogFileName($FormatPathLogs,$BaseName,$Connect)
		$LogFile = GetLogFile($LogFileName)
	Else
		$LogFileName = ""
		$LogFile = ''
	EndIf
	$Result = DoUp ($Path1CEXE,$BaseName,$Connect,$prefics,$BackupName,$LogFile)
	If $Result Then
	$TextR = "���������� ������ �������"
	Else
	$TextR = "���������� ������ c ��������"
	EndIf
	MsgBox(0, "���������� �����������",$TextR )
	If $ShowLogs Then ShellExecute($LogFileName)
	Exit
EndIf

Func UpdateForm ($Base,$Action,$Percent)

	GUICtrlSetData($txtBaseNameLog,$Base)
	GUICtrlSetData($txtCommentRun,$Action)
	GUICtrlSetData($ProgressStatus,$Percent)
;~ 	GUICtrlSetData($ProgressWait,100-$Percent)
	$ListItem = GUICtrlCreateListViewItem(_Now()&'|'&$Base&'|'&$Action,$lstLogList)
	_ArrayAdd($A_Clear,$ListItem)
	Return $ListItem
EndFunc

Func ReplaceStringFormat ($Rtext,$BaseName,$Connect)


	$RDATE = '@DATE@'
	$ZNDATE = String (@YEAR)& String (@MON)&String (@MDAY) &'_'&String (@HOUR)&'_'& String (@MIN)
	$RBASENAME = '@BASENAME@'
	$ZNBASENAME  = $BaseName
	$RBASEPATH = '@BASEPATH@'
	$ZNBASEPATH = $Connect
	$RFILENAME = '@FILENAME@'
	$ZNFILENAME = $BaseName &'_'&$ZNDATE
	$Rtext = StringReplace ($Rtext,$RDATE,$ZNDATE)
	$Rtext = StringReplace ($Rtext,$RBASENAME,$ZNBASENAME)
	$Rtext = StringReplace ($Rtext,$RBASEPATH,$ZNBASEPATH)

	$Rtext = StringReplace ($Rtext,$RFILENAME,$ZNFILENAME)
;~ 	MsgBox(0, "������", $Rtext)

	return $Rtext


EndFunc


Func StringToBool ($Text,$DefaultName)
    $bool = $DefaultName
	if StringUpper ($Text) = "����" Then
		$bool = False
	ElseIf StringUpper ($Text) = "������" Then
		$bool = True
	ElseIf StringUpper ($Text) = "��" Then
		$bool = True
	ElseIf StringUpper ($Text) = "���" Then
		$bool = False
	ElseIf StringUpper ($Text) = "1" Then
		$bool = True
	ElseIf StringUpper ($Text) = "0" Then
		$bool = False
	ElseIf StringUpper ($Text) = "TRUE" Then
		$bool = True
	ElseIf StringUpper ($Text) = "FALSE" Then
		$bool = False
	EndIf
	Return $bool
EndFunc

Func GetLogFileName($Rtext,$BaseName,$Connect)
    $logname = ReplaceStringFormat ($Rtext,$BaseName,$Connect)

	Return $logname

EndFunc
Func AddLogToMultiLog($MultiLogFile,$LogFileName,$BaseName,$Connect,$prefics,$BackupName)
	If $OneLog then

		if $prefics = 'F' Then
		 $preficsr = '�������� ����'
		Else
		 $preficsr = '������-��������� ����'
		EndIf
		WriteMultiLog ($MultiLogFile,'---------------------------------------------')
		WriteMultiLog ($MultiLogFile,'���� ����������:           '&@TAB&_Now())
		WriteMultiLog ($MultiLogFile,'���������� ����:           '&@TAB&$BaseName)
		WriteMultiLog ($MultiLogFile,'������ ����������:         '&@TAB&$Connect)
		WriteMultiLog ($MultiLogFile,'����� ����:                '&@TAB&$preficsr)
		WriteMultiLog ($MultiLogFile,'��� ����� �������� �����:  '&@TAB&$BackupName)
		WriteMultiLog ($MultiLogFile,'��� ����� �����:           '&@TAB&$LogFileName)
		WriteMultiLog ($MultiLogFile,'���:')
		$logfileadd = FileOpen($LogFileName, 0)
		While 1
			$logline = FileReadLine($logfileadd)
			If @error = -1 Then ExitLoop
			WriteLog ($MultiLogFile,$logline)

		Wend
		WriteLog ($MultiLogFile,'---------------------------------------------')
		FileClose($logfileadd)
	EndIf
EndFunc
Func UpdateResult($item,$txtResult)
	GUICtrlSetData ($item,'|||'&$txtResult)
EndFunc
Func DoUp ($PrgExe,$BaseName,$Connect,$prefics,$BackupName,$LogFile)
	$Con = True

	DeleteLogS ($BaseName)
	WriteLog ($LogFile,"������ ���������� "& _Now())
	$Item = UpdateForm ($BaseName,"������ ����������",0)
	UpdateResult ($Item,'���������')

;~ 	ProgressOn("���������� ���������� ��: "&$BaseName, "", "0 ���������",200,200,16)
;~ 	ProgressSet(5, "5 ���������","��������� ���������� �������������")


	$Con = BlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
		WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

		FileClose($LogFile)
;~ 		ProgressOff()
		Return $Con
	EndIf
	UpdateResult ($Item,'���������')
	AksForStop($LogFile)

;~ 	ProgressSet(10, "10 ���������","���� �������� ������")

	$Con = BkCopy($PrgExe,$BaseName,$Connect,$prefics,$BackupName,$LogFile)
	If Not $Con then
		WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

		FileClose($LogFile)
;~ 		ProgressOff()
		Return $Con
	EndIf
	AksForStop($LogFile)


;~ ProgressSet(20, "20 ���������","�������� ����� ������������")
	$Con = RunEpf ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
		WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

		FileClose($LogFile)
		Return $Con
	EndIf
	AksForStop($LogFile)

    $Con = RunConfig ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
		WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

		FileClose($LogFile)
		Return $Con
	EndIf
	AksForStop($LogFile)


;~ 	ProgressSet(20, "20 ���������","�������� ����� ������������")
	$Con =ReadMessager ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
		WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

		FileClose($LogFile)
		Return $Con
	EndIf


	AksForStop($LogFile)

;~ 	ProgressSet(50, "50 ���������","���� ���������� ��")
	$Con = Update ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
			WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

			FileClose($LogFile)
;~ 			ProgressOff()
		Return $Con
	EndIf
	AksForStop($LogFile)

;~ 	ProgressSet(80 , "80 ���������", "������������ � �������")
	$Con =ReadWriteMessager ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
			WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

			FileClose($LogFile)
;~ 			ProgressOff()
			Return $Con
	EndIf
	;~ ProgressSet(20, "20 ���������","�������� ����� ������������")
	$Con = RunEpfAfterUpdate ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
		WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

		FileClose($LogFile)
		Return $Con
	EndIf

   AksForStop($LogFile)

  		

    $Con = RunConfigAfterUpdate ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
	If Not $Con then
		WriteLog ($LogFile,"�������� ---- ����������� ������ ("& _Now()&')')

		FileClose($LogFile)
		Return $Con
  	EndIf

	AksForStop($LogFile)
   
;~ 	ProgressSet(100 , "���������", "���������� ���������")
	sleep(1000)
;~ 	ProgressOff()


	FileClose($LogFile)


EndFunc

Func SpecialEvents()

EndFunc

Func ReadMessager ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
	$result = True
	If $UseRIB Then
		 If $UseParamLoadUpdate then
		   $Item = UpdateForm ($BaseName,"������ ����� ������������",50)
		   $PID = Run ($PrgExe &' ENTERPRISE /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /C ������������������� /DisableStartupMessages /UC�������������',"", @SW_HIDE)
		   $result =WaitSleep($PID)
		   If $Result Then
			   WriteLog ($LogFile,"������ ����� ������������ ---- ������� ("& _Now()&')')
			   UpdateResult($item,'�������')
		   Else
			   WriteLog ($LogFile,"������ ����� ������������ ---- �� ��������� ���������� ("& _Now()&')')
			   UpdateResult($item,'�� ��������� ����������')
		   EndIf
		 Else
			   WriteLog ($LogFile,"������ ����� ������������ ---- �� ������������ ("& _Now()&')')
			   UpdateResult($item,'�� ������������')
		 EndIf
	ElseIf $UseFileUp Then
		$Item = UpdateForm ($BaseName,"������ ����� ������������",50)
		$PID = Run ($PrgExe &' DESIGNER /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /UC������������� /UpdateCfg "'&$FileUpPath&'" /DumpResult "'&$BaseName&'update.rst"',"", @SW_HIDE)
		$result =WaitSleep($PID)
		If $Result Then
;~ 			WriteLog ($LogFile,"������ ����� ������������ ---- ������� ("& _Now()&')')
			If NOT $IgnoreResult Then
				$UpdateResult = CheckResult($BaseName&"update.rst")
				If $UpdateResult Then
					WriteLog ($LogFile,"������ ����� ������������---- ������� ("& _Now()&')')
					UpdateResult($item,'�������')
				Else
					WriteLog ($LogFile,"������ ����� ������������ ---- ������ ("& _Now()&')')
					UpdateResult($item,'������')
					AksForStop($LogFile)
					$Con = UnBlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)

					Return False
				EndIf
			EndIf
			If $IgnoreResult Then
				UpdateResult($item,'�������')
				If $UpdateResult Then
				$tx = "�������"
				Else
				$tx = "������"
				EndIf
				WriteLog ($LogFile,"������ ����� ������������ ---- ������������� ("&$tx&") ("& _Now()&')')
			EndIf
		Else
			WriteLog ($LogFile,"������ ����� ������������ ---- �� ��������� ���������� ("& _Now()&')')
			UpdateResult($item,'�� ��������� ����������')
		EndIf
	ElseIf $UseLoadCf Then
		$Item = UpdateForm ($BaseName,"������ ����� ������������",50)
		$PID = Run ($PrgExe &' DESIGNER /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /UC������������� /LoadCfg "'&$FileCfg&'" /DumpResult "'&$BaseName&'update.rst"',"", @SW_HIDE)
		$result =WaitSleep($PID)
		If $Result Then
;~ 			WriteLog ($LogFile,"������ ����� ������������ ---- ������� ("& _Now()&')')
			If NOT $IgnoreResult Then
				$UpdateResult = CheckResult($BaseName&"update.rst")
				If $UpdateResult Then
					WriteLog ($LogFile,"������ ����� ������������---- ������� ("& _Now()&')')
					UpdateResult($item,'�������')
				Else
					WriteLog ($LogFile,"������ ����� ������������ ---- ������ ("& _Now()&')')
					UpdateResult($item,'������')
					AksForStop($LogFile)
					$Con = UnBlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)

					Return False
				EndIf
			EndIf
			If $IgnoreResult Then
				UpdateResult($item,'�������')
				If $UpdateResult Then
				$tx = "�������"
				Else
				$tx = "������"
				EndIf
				WriteLog ($LogFile,"������ ����� ������������ ---- ������������� ("&$tx&") ("& _Now()&')')
			EndIf
		Else
			WriteLog ($LogFile,"������ ����� ������������ ---- �� ��������� ���������� ("& _Now()&')')
			UpdateResult($item,'�� ��������� ����������')
		EndIf
	Else
		WriteLog ($LogFile,"������ ����� ������������ ---- �� ������������ ("& _Now()&')')

	EndIf

	Return $result
EndFunc

Func ReadWriteMessager ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
   $result = True
  if $UseRIB then
	  If $UseParamLoadUpload then

		  $Item = UpdateForm ($BaseName,"����� � �������",80)
		  $PID = Run ($PrgExe &' ENTERPRISE /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /C ������������������ /DisableStartupMessages /UC�������������',"", @SW_HIDE)
		  $result =WaitSleep($PID)
		  If $Result Then
			  WriteLog ($LogFile,"����� � ������� (��������/��������) ---- ������� ("& _Now()&')')
			  UpdateResult($item,'�������')
		  Else
			  WriteLog ($LogFile,"����� � ������� (��������/��������) ---- �� ��������� ���������� ("& _Now()&')')
			  UpdateResult($item,'�� ��������� ����������')
		   EndIf
	  Else
			WriteLog ($LogFile,"����� � ������� (��������/��������)  ---- �� ������������ ("& _Now()&')')
			UpdateResult($item,'�� ������������')
	  EndIf

   Else
	WriteLog ($LogFile,"����� � ������� ---- �� ������������ ("& _Now()&')')

  EndIf
  Return $result
EndFunc

Func BlockUsers ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
$result = True
  If $UseBlockUsers Then
	$Item = UpdateForm ($BaseName,"��������� ���������� �������������",10)
	$PID = Run ($PrgExe &' ENTERPRISE /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /C���������������������������� /DisableStartupMessages /UC�������������',"", @SW_HIDE)
	$result =WaitSleep($PID)
	If $Result Then
		WriteLog ($LogFile,"���������� ������������� ---- ������� ("& _Now()&')')
		UpdateResult($item,'�������')
	Else
		WriteLog ($LogFile,"���������� ������������� ---- �� ��������� ���������� ("& _Now()&')')
		UpdateResult($item,'�� ��������� ����������')
	EndIf
  Else
	WriteLog ($LogFile,"���������� ������������� ---- �� ������������ ("& _Now()&')')
  EndIf
  Return $result

EndFunc

Func RunEpf ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
  $result = True
  If $UseRunEpf Then
	$Item = UpdateForm ($BaseName,"������ ���������",10)
	$PID = Run ($PrgExe &' ENTERPRISE /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /Execute"'&$PathForEpf&'"  /DisableStartupMessages /UC�������������',"", @SW_HIDE)
	$result =WaitSleep($PID)
	If $Result Then
		WriteLog ($LogFile,"������ ��������� �������� ---- ������� ("& _Now()&')')
		UpdateResult($item,'�������')
	Else
		WriteLog ($LogFile,"������ ��������� �������� ---- �� ��������� ���������� ("& _Now()&')')
		UpdateResult($item,'�� ��������� ����������')
	EndIf
  Else
	WriteLog ($LogFile,"������ ��������� �������� ---- �� ������������ ("& _Now()&')')
  EndIf
  Return $result

EndFunc

Func RunEpfAfterUpdate ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
  $result = True
  If $UseRunEpfAfterUpdate Then
	$Item = UpdateForm ($BaseName,"������ ���������",10)
	$PID = Run ($PrgExe &' ENTERPRISE /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /Execute"'&$PathForEpfAfterUpdate&'"  /DisableStartupMessages /UC�������������',"", @SW_HIDE)
	$result =WaitSleep($PID)
	If $Result Then
		WriteLog ($LogFile,"������ ��������� �������� ---- ������� ("& _Now()&')')
		UpdateResult($item,'�������')
	Else
		WriteLog ($LogFile,"������ ��������� �������� ---- �� ��������� ���������� ("& _Now()&')')
		UpdateResult($item,'�� ��������� ����������')
	EndIf
  Else
	WriteLog ($LogFile,"������ ��������� �������� ---- �� ������������ ("& _Now()&')')
  EndIf
  Return $result

EndFunc

Func UnBlockUsers ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
 $result = True
 If $UseBlockUsers Then
	$Item = UpdateForm ($BaseName,"������ ���������� �������������",99)
	$PID = Run ($PrgExe &' ENTERPRISE /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /C���������������������������� /DisableStartupMessages /UC�������������',"", @SW_HIDE)
    $result =WaitSleep($PID)
  If $Result Then
		WriteLog ($LogFile,"������ ���������� ������������� ---- ������� ("& _Now()&')')
		UpdateResult($item,'�������')
	Else
		WriteLog ($LogFile,"������ ���������� ������������� ---- �� ��������� ���������� ("& _Now()&')')
		UpdateResult($item,'�� ��������� ����������')
	EndIf
  Else
	WriteLog ($LogFile,"������ ���������� ������������� ---- �� ������������ ("& _Now()&')')
  EndIf
  Return $result
EndFunc


Func RunConfig ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
  
  $result = True
  If $UseRunConfig then
	$Item = UpdateForm ($BaseName,"������ ������������� � �������� ������ (�� ����������)",20)
	$PID = Run ($PrgExe &' DESIGNER /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /UC������������� "'&$ParamForConfig&'" /DumpResult "'&$BaseName&'backup.rst"',"", @SW_HIDE)

	$result = WaitSleep($PID)
	IF $result Then

		If NOT $IgnoreResult Then
			$RunResult = CheckResult($BaseName&"backup.rst")
			If $RunResult Then
				WriteLog ($LogFile,"������ ������������� � �������� ������ (�� ����������) ---- ������� ("& _Now()&')')
				UpdateResult($item,'�������')
			Else
				WriteLog ($LogFile,"������ ������������� � �������� ������ (�� ����������) ---- ������ ("& _Now()&')')
				UpdateResult($item,'������')
				AksForStop($LogFile)
				$Con = UnBlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
				Return False
			EndIf
		EndIf
		If $IgnoreResult Then
			UpdateResult($item,'�������')
			If $RunResult Then
			$tx = "�������"
			Else
			$tx = "������"
			EndIf
			WriteLog ($LogFile,"������ ������������� � �������� ������ (�� ����������) ---- ������������� ("&$tx&") ("& _Now()&')')
		EndIf
	Else
		UpdateResult($item,'�� ��������� ����������')
		WriteLog ($LogFile,"������ ������������� � �������� ������ (�� ����������)  ---- �� ��������� ���������� ("& _Now()&')')
	EndIf
  Else

	WriteLog ($LogFile,"������ ������������� � �������� ������ (�� ����������) ---- �� ������������ ("& _Now()&')')
  EndIf
  Return $result
EndFunc

Func RunConfigAfterUpdate ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
  
  $result = True
  If $UseRunConfigAfterUpdate then
	$Item = UpdateForm ($BaseName,"������ ������������� � �������� ������ (����� ����������)",95)
	$PID = Run ($PrgExe &' DESIGNER /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /UC������������� "'&$ParamForConfigAfterUpdate&'" /DumpResult "'&$BaseName&'backup.rst"',"", @SW_HIDE)

	$result = WaitSleep($PID)
	IF $result Then

		If NOT $IgnoreResult Then
			$RunResult = CheckResult($BaseName&"backup.rst")
			If $RunResult Then
				WriteLog ($LogFile,"������ ������������� � �������� ������ (����� ����������) ---- ������� ("& _Now()&')')
				$Con = UnBlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
				UpdateResult($item,'�������')
			Else
				WriteLog ($LogFile,"������ ������������� � �������� ������ (����� ����������) ---- ������ ("& _Now()&')')
				UpdateResult($item,'������')
				AksForStop($LogFile)
				$Con = UnBlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
				Return False
			EndIf
		EndIf
		If $IgnoreResult Then
			UpdateResult($item,'�������')
			If $RunResult Then
			$tx = "�������"
			Else
			$tx = "������"
			EndIf
			WriteLog ($LogFile,"������ ������������� � �������� ������ (����� ����������) ---- ������������� ("&$tx&") ("& _Now()&')')
		EndIf
	Else
		UpdateResult($item,'�� ��������� ����������')
		WriteLog ($LogFile,"������ ������������� � �������� ������ (����� ����������)  ---- �� ��������� ���������� ("& _Now()&')')
	EndIf
  Else
	WriteLog ($LogFile,"������ ������������� � �������� ������ (�� ����������) ---- �� ������������ ("& _Now()&')')
  EndIf
  Return $result
EndFunc



Func Update ($PrgExe,$BaseName,$ConnectStr,$prefics,$LogFile)
  $result = True
  if $UseRIB or $UseFileUp Or $UseLoadCf then
		$Item = UpdateForm ($BaseName,"���������� ������������",50)
		$PID = Run ($PrgExe &' DESIGNER /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /UC������������� /UpdateDBCfg /DumpResult "'&$BaseName&'update.rst"',"", @SW_HIDE)
		$result =WaitSleep($PID)
	IF $result Then

		If NOT $IgnoreResult Then
			$UpdateResult = CheckResult($BaseName&"update.rst")
			If $UpdateResult Then
				WriteLog ($LogFile,"���������� ������������ ---- ������� ("& _Now()&')')
				UpdateResult($item,'�������')

				Else
				WriteLog ($LogFile,"���������� ������������ ---- ������ ("& _Now()&')')
				UpdateResult($item,'������')
				AksForStop($LogFile)


				Return False
			EndIf
			$Con = UnBlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
		EndIf
		If $IgnoreResult Then
			UpdateResult($item,'�������')
			If $UpdateResult Then
			$tx = "�������"
			Else
			$tx = "������"
			EndIf
			WriteLog ($LogFile,"���������� ������������ ---- ������������� ("&$tx&") ("& _Now()&')')
		EndIf
	Else
		WriteLog ($LogFile,"���������� ������������  ---- �� ��������� ���������� ("& _Now()&')')
		UpdateResult($item,'�� ��������� ����������')
	EndIf

 Else
	WriteLog ($LogFile,"���������� ������������ ---- �� ������������ ("& _Now()&')')
 EndIf

 Return $result
 EndFunc

Func BkCopy($PrgExe,$BaseName,$ConnectStr,$prefics,$BkName,$LogFile)
  $result = True
  If $UseBackUp then
	$Item = UpdateForm ($BaseName,"�������� �������� �����",20)
	$PID = Run ($PrgExe &' DESIGNER /'&$prefics&'"'&$ConnectStr&'" /N'&$User&' /P'&$Password&' /UC������������� /DumpIB "'&$BkName&'" /DumpResult "'&$BaseName&'backup.rst"',"", @SW_HIDE)

	$result = WaitSleep($PID)
	IF $result Then

		If NOT $IgnoreResult Then
			$BackupResult = CheckResult($BaseName&"backup.rst")
			If $BackupResult Then
				WriteLog ($LogFile,"�������� �������� ����� ---- ������� ("& _Now()&')')
				UpdateResult($item,'�������')
			Else
				WriteLog ($LogFile,"�������� �������� ����� ---- ������ ("& _Now()&')')
				UpdateResult($item,'������')
				AksForStop($LogFile)
				$Con = UnBlockUsers ($PrgExe,$BaseName,$Connect,$prefics,$LogFile)
				Return False
			EndIf
		EndIf
		If $IgnoreResult Then
			UpdateResult($item,'�������')
			If $BackupResult Then
			$tx = "�������"
			Else
			$tx = "������"
			EndIf
			WriteLog ($LogFile,"�������� �������� ����� ---- ������������� ("&$tx&") ("& _Now()&')')
		EndIf
	Else
		UpdateResult($item,'�� ��������� ����������')
		WriteLog ($LogFile,"�������� �������� �����  ---- �� ��������� ���������� ("& _Now()&')')
	EndIf
  Else

	WriteLog ($LogFile,"�������� �������� ����� ---- �� ������������ ("& _Now()&')')
  EndIf
  Return $result
EndFunc

Func WaitSleep($PID)

	;~ Add $TimeWait minutes to current time
	$sEndDate = _DateAdd( 'n',$TimeWait, _NowCalc())
	$result = False
	$Max = _DateDiff('s', _NowCalc(), $sEndDate)
	While 1
;~  		MsgBox(0,'',(1 - (_DateDiff('s', _NowCalc(), $sEndDate)/$Max))*100)
		GUICtrlSetData($ProgressWait,(_DateDiff('s', _NowCalc(), $sEndDate)/$Max)*100)
		If Not ProcessExists ($PID) Then
			$result = True
			ExitLoop
		EndIf
		Sleep(10)
		$Diff = _DateDiff('s', _NowCalc(), $sEndDate)
		If @Error Then
			$result = True
			ExitLoop
		EndIf
		If $Diff < 0 Then
			ProcessClose($PID)
			$result = False
			ExitLoop
		EndIf

	WEnd

	Return $result

EndFunc

Func CheckResult($FlName)


		$bool = False
			$line = FileReadLine($FlName,1)
				If @error = -1 Then
					$bool = False
				EndIf
				If $line = "1"Then
					$bool = False
				ElseIf $line = "0"Then
					$bool = True
				EndIf
		 Return $bool
EndFunc


Func WriteLog ($LogFile,$Text)

	; Check if file opened for writing OK
	If $UseLogs Then
		FileWriteLine($LogFile, $Text & @CRLF)
	EndIf


EndFunc

Func WriteMultiLog ($LogFile,$Text)

	; Check if file opened for writing OK
	If $OneLog Then
		FileWriteLine($LogFile, $Text & @CRLF)
	EndIf


EndFunc

Func AksForStop ($LogFile)
	If $UseBreak Then
		$msg = MsgBox(20, "��������� ����������", "�� ������ ���������� ����������?", 5)
		if $msg = 6 Then
			WriteLog ($LogFile,"������ ���������� ���������� ������������� ")
			WriteLog ($LogFile,"���������� ����� ���� �� ��������� �� ����� ")
			FileClose($LogFile)
			Exit
		EndIf
	EndIf
EndFunc
Func OKButton()
  ;Note: at this point @GUI_CTRLID would equal $okbutton,
  ;and @GUI_WINHANDLE would equal $mainwindow
  $Password = GUICtrlRead($InputPassword)
  $User =  GUICtrlRead($InputLogin)
;~   MsgBox(0, "GUI Event",'������������: '&$User&' ������: '& $Password)
  $lenpass = StringLen($Password)
  $lenuser = StringLen($User)
  If $lenuser = 0 Then
	  MsgBox(64, "������", "�� �������� ������������")
	  $Auth = False
  ElseIf $lenpass = 0 Then
	  MsgBox(64, "������", "�� �������� ������")
	  $Auth = False
  Else
	$Auth = True
  EndIf

EndFunc

Func GetBaseName ($ConnectStr)
	If StringInStr($ConnectStr, "Srvr=") > 0 Then
		$result = StringInStr($ConnectStr, "Ref=")
		$BaseName = StringRight($ConnectStr, StringLen($ConnectStr)-$result-3)
		$BaseName = StringReplace($BaseName,";",'')
		$BaseName = StringReplace($BaseName,'"','')
		$BaseName = StringStripWS($BaseName,3)
		Return $BaseName
	Else
		$NumRazdelitel = StringInStr($ConnectStr, "|")
		If $NumRazdelitel > 0 Then
			$BaseName = StringLeft ($ConnectStr,$NumRazdelitel-1)
			$BaseName = StringReplace($BaseName,";",'')
			$BaseName = StringReplace($BaseName,'"','')
			$BaseName = StringStripWS($BaseName,3)
			Return $BaseName
		Else
			$BaseName = $ConnectStr
			$BaseName = StringReplace($BaseName,"/",'_')
			$BaseName = StringReplace($BaseName,"\",'_')
			$BaseName = StringReplace($BaseName,";",'')
			$BaseName = StringReplace($BaseName,'"','')
			$BaseName = StringStripWS($BaseName,3)
			Return $BaseName
		EndIf
	EndIf
EndFunc

Func GetConnectStr($ConnectStr)
	If StringInStr($ConnectStr, "Srvr=") > 0 Then
;~ 		Srvr="192.168.17.102";Ref="���_��_������";
		$ConnectStr = StringReplace($ConnectStr,";",'/',1)
		$ConnectStr = StringReplace($ConnectStr,";",'')
		$ConnectStr = StringReplace($ConnectStr,'"','')
		$ConnectStr = StringReplace($ConnectStr,"Srvr=",'')
		$ConnectStr = StringReplace($ConnectStr,"Ref=",'')
		Return $ConnectStr
	ElseIf StringInStr($ConnectStr, "File=") > 0 Then
		$ConnectStr = StringReplace($ConnectStr,'"','')
		$ConnectStr = StringReplace($ConnectStr,"File=",'')
		$ConnectStr = StringReplace($ConnectStr,";",'')
		$NumRazdelitel = StringInStr($ConnectStr, "|")
		If $NumRazdelitel > 0 Then
			$ConnectStr = StringRight ($ConnectStr,StringLen($ConnectStr)-$NumRazdelitel)
		EndIf
		Return $ConnectStr
	EndIf

EndFunc

Func GetPrefics($ConnectStr)
	If StringInStr($ConnectStr, "Srvr=") > 0 Then

		Return 'S'
	Else
		Return 'F'
	EndIf

EndFunc

Func GetBackupName ($BaseName,$Rtext,$Connect)
;~ ����������� ������ ���������� ��� ���� ����� ���������� ����� ��� ����
;~ 	MsgBox(0, "Error", "���������� ������� ���� ��� ��������������."&$BaseName)
	$BN = ReplaceStringFormat ($Rtext,$BaseName,$Connect)
;~  	MsgBox(0, "Error", ""&$BN)
    $PathNum = StringInStr($BN, "\",0,-1)
;~ 	MsgBox(0, "$PathNum", ""&$PathNum)
	$Path = StringLeft( $BN, $PathNum )
;~ 		$NachPath = "\\192.168.17.125\d$\��������� 1C\���������� 1C_8\���_���������\��������\"
    DirCreate($PathBackup & $Path )
;~ 	MsgBox(0, "$Path", $PathBackup &$Path)
	$BkName  = $PathBackup & $BN

;~ 	ElseIf StringInStr($ConnectStr, "File=") > 0 Then
;~
;~ 		DirCreate($BaseName &'\'&String (@YEAR)& String (@MON)&String (@MDAY) &'_'&String (@HOUR)&'_'& String (@MIN)& '\')

;~ 		$BkName = $BaseName & $BN
;~
;~ EndIf

	Return $BkName
EndFunc

Func GetLogFile ($LogFileName)
	;�������� ����� ���� ����������
	$LogFile = FileOpen($LogFileName, 9)
	If $LogFile = -1 Then
		MsgBox(0, "Error", "���������� ������� ���� ��� ��������������."&$LogFileName)
		Exit
	EndIf
	Return $LogFile

EndFunc

Func DeleteLogS($BaseName)
		;~ ������� ��� ����. ��������
	If Not FileExists($BaseName&'backup.rst') Then

		FileDelete ( $BaseName&'backup.rst' )

	EndIf

	If Not FileExists($BaseName&'update.rst') Then

		FileDelete ( $BaseName&'update.rst' )

	EndIf
EndFunc
