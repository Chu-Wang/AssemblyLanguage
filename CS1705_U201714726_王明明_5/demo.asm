.386
.model   flat,stdcall
option   casemap:none

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD
Tjd		 proto :DWORD

include      menuID.INC

include      D:\masm32\INCLUDE\windows.inc
include      D:\masm32\INCLUDE\user32.inc
include      D:\masm32\INCLUDE\kernel32.inc
include      D:\masm32\INCLUDE\gdi32.inc
include      D:\masm32\INCLUDE\shell32.inc

includelib   D:\masm32\LIB\user32.lib
includelib   D:\masm32\LIB\kernel32.lib
includelib   D:\masm32\LIB\gdi32.lib
includelib   D:\masm32\LIB\shell32.lib

goods	     struct
	     gname			db	10 dup(0)
	     discount		db	0
	     inprice		db	0
	     outprice		db	0
	     innum			db	0
	     outnum			db	0
	     recommendation	db	0
goods      ends

.data
ClassName    db       'TryWinClass',0
AppName      db       'Our First Window',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       'I Am CS1705 WMM',0
hInstance    dd       0
CommandLine  dd       0
buf	    goods  <> 
		goods  <'Pen',10,35,56,70,25,'0'>
		goods  <'Book',9,12,30,25,5,'0'>
		goods  <'Pencil',9,1,4,50,6,'0'>
		goods  <'Ruler',8,2,5,50,10,'0'>
		goods  <'Bumf',10,3,1,100,1,'0'>
		
msg_gname			db		'GName',0
msg_discount		db		'Discount',0
msg_inprice			db		'In_Price',0
msg_outprice		db		'Out_price',0
msg_innum			db		'In_Num',0
msg_outnum			db		'Out_Num',0
msg_recommendation	db		'Recommendation',0
discount			db		2,1,1,1,2, '10','9','9','8','10'
inprice				db		2,2,1,1,1, '35','12','1','2','3'
outprice			db		2,2,1,1,1, '56','30','4','5','1'
innum				db		2,2,2,2,3, '70','25','50','50','100'
outnum				db		2,1,1,2,1, '25','5','6','10','1'
;;recommendation		db		2,0,0,0, '0'
menuItem     db       0  ;当前菜单状态, 1=处于list, 0=Clear

.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     ;;
WinMain      proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
             invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
	     LOCAL  ps:PAINTSTRUCT
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
             ;;your code
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
	    .ELSEIF wParam == IDM_FILE_LIST
		    mov menuItem, 1
		    invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
	    .ELSEIF wParam == IDM_FILE_CLEAR
		    mov menuItem, 0
		    invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
		.ELSEIF wParam == IDM_FILE_RECOMMENDATION
		    invoke Tjd,5
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
             invoke BeginPaint,hWnd, addr ps
             mov hdc,eax
	     .IF menuItem == 1
		 invoke Display,hdc
	     .ENDIF
	     invoke EndPaint,hWnd,addr ps
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

Display      proc   hdc:HDC
             XX     equ  10
             YY     equ  10
	     XX_GAP equ  100
	     YY_GAP equ  30
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_gname,5
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_discount,8
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_inprice,8
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_outprice,9
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_innum,6
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_outnum,7
             invoke TextOut,hdc,XX+6*XX_GAP,YY+0*YY_GAP,offset msg_recommendation,14
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf[1*16].gname,3
             invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset discount+5,	discount
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset inprice+5,	inprice
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset outprice+5,	outprice
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset innum+5,		innum
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset outnum+5,	outnum
             invoke TextOut,hdc,XX+6*XX_GAP,YY+1*YY_GAP,offset buf[1*16].recommendation,1
             ;;
			 invoke TextOut,hdc,XX+0*XX_GAP,YY+2*YY_GAP,offset buf[2*16].gname,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+2*YY_GAP,offset discount+7,	discount+1
             invoke TextOut,hdc,XX+2*XX_GAP,YY+2*YY_GAP,offset inprice+7,	inprice+1
             invoke TextOut,hdc,XX+3*XX_GAP,YY+2*YY_GAP,offset outprice+7,	outprice+1
             invoke TextOut,hdc,XX+4*XX_GAP,YY+2*YY_GAP,offset innum+7,		innum+1
             invoke TextOut,hdc,XX+5*XX_GAP,YY+2*YY_GAP,offset outnum+7,	outnum+1
             invoke TextOut,hdc,XX+6*XX_GAP,YY+2*YY_GAP,offset buf[2*16].recommendation,1
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+3*YY_GAP,offset buf[3*16].gname,6
             invoke TextOut,hdc,XX+1*XX_GAP,YY+3*YY_GAP,offset discount+8,	discount+2
             invoke TextOut,hdc,XX+2*XX_GAP,YY+3*YY_GAP,offset inprice+9,	inprice+2
             invoke TextOut,hdc,XX+3*XX_GAP,YY+3*YY_GAP,offset outprice+9,	outprice+2
             invoke TextOut,hdc,XX+4*XX_GAP,YY+3*YY_GAP,offset innum+9,		innum+2
             invoke TextOut,hdc,XX+5*XX_GAP,YY+3*YY_GAP,offset outnum+8,	outnum+2
             invoke TextOut,hdc,XX+6*XX_GAP,YY+3*YY_GAP,offset buf[3*16].recommendation,1
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+4*YY_GAP,offset buf[4*16].gname,5
             invoke TextOut,hdc,XX+1*XX_GAP,YY+4*YY_GAP,offset discount+9,	discount+3
             invoke TextOut,hdc,XX+2*XX_GAP,YY+4*YY_GAP,offset inprice+10,	inprice+3
             invoke TextOut,hdc,XX+3*XX_GAP,YY+4*YY_GAP,offset outprice+10,	outprice+3
             invoke TextOut,hdc,XX+4*XX_GAP,YY+4*YY_GAP,offset innum+11,		innum+3
             invoke TextOut,hdc,XX+5*XX_GAP,YY+4*YY_GAP,offset outnum+9,	outnum+3
             invoke TextOut,hdc,XX+6*XX_GAP,YY+4*YY_GAP,offset buf[4*16].recommendation,1
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+5*YY_GAP,offset buf[5*16].gname,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+5*YY_GAP,offset discount+10,	discount+4
             invoke TextOut,hdc,XX+2*XX_GAP,YY+5*YY_GAP,offset inprice+11,	inprice+4
             invoke TextOut,hdc,XX+3*XX_GAP,YY+5*YY_GAP,offset outprice+11,	outprice+4
             invoke TextOut,hdc,XX+4*XX_GAP,YY+5*YY_GAP,offset innum+13,		innum+4
             invoke TextOut,hdc,XX+5*XX_GAP,YY+5*YY_GAP,offset outnum+11,	outnum+4
             invoke TextOut,hdc,XX+6*XX_GAP,YY+5*YY_GAP,offset buf[5*16].recommendation,1
             ret
Display      endp

Tjd			proc	goonum:DWORD
		push eax
		push ebx
		push ecx
		push edx
		push edi
		push esi
		push ebp

       MOV  bx,word ptr goonum
       mov  ebp,0
       LEA  EBP,buf
       add  Ebp,16
LOPA1: 
	MOV AL,128
	MOV	AH,0
	CWDE
	MOV	EDI,EAX
	MOV	AL,ds:[ebp+10]
	MOV	AH,0
	CWDE
	MOV	ESI,EAX
	MOV	al,ds:[ebp+12]
	CWDE
	IMUL	EAX,ESI
	CDQ
	MOV	ECX,10
	IDIV	ECX
	push eax
	mov edx,0
	MOV	Al,ds:[ebp+11]
	CWDE
	IMUL	EAX,EDI
	CDQ
	pop ecx
	idiv ecx
	MOV	ESI,EAX
	MOV	Al,ds:[ebp+13]
	CWDE
	IMUL	EAX,2
	MOV	ECX,EAX
	push eax
	mov edx,0
	MOV	Al,ds:[ebp+14]
	CWDE
	IMUL	EAX,EDI
	CDQ
	pop ecx
	IDIV	ECX
	ADD	eax,esi		;计算推荐度
       cmp ax,100
       jg  ranka
       cmp ax,50
       jg  rankb
       cmp ax,10
       jg  rankc
       mov DS:[EBP+15],BYTE PTR 'F'
       jmp LOPA2
ranka: mov DS:[EBP+15],BYTE PTR 'A'
       jmp LOPA2
rankb: mov DS:[EBP+15],byte ptr 'B'
       jmp LOPA2 
rankc: mov DS:[EBP+15],byte ptr 'C' 
LOPA2: ADD  EBP,16
       DEC  bx
       JNZ  LOPA1 
       
        pop ebp
		pop esi
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
       RET
Tjd			endp
             end  Start
