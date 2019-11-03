.MODEL FLAT,C
.DATA
 GA_SPACE EQU 22
 N=5
.CODE
Rank_Recom_Score PROC
    PUSH EBP
	MOV EBP,ESP
	MOV ECX, N-1					;外层循环执行N-1次
L1:
	MOV EBX, [EBP+8]		;第一个商品偏移地址    
	XOR EDI, EDI        
	XOR EDX, EDX					;DX记录该次扫描是否有元素交换
L2:
	MOV AX, [EBX+20]				;将两商品推荐度分别放入AX和DX
	MOV DX, [EBX+42]
	CMP AX, DX
	;比较AX和DX大小，若AX≥BX则跳转L4,否则交换两商品信息
	JAE  L4
	MOV DX, 1					;该次扫描有元素交换
	XOR ESI, ESI
L3:
	;交换前11个字节
	MOV AL, [EBX+ESI]
	XCHG AL, BYTE PTR[EBX+ESI+ GA_SPACE]
	MOV [EBX+ESI], AL
	INC ESI
	CMP ESI, 22
	JB	L3
L4:
	ADD EBX, GA_SPACE					;移动到下一个商品的位置
	INC EDI					
	CMP EDI,ECX           
	JB  L2
	OR DX, DX
	JZ RETURN					;该次扫描无元素交换，排序完成
	LOOP L1         
RETURN:
	POP EBP
	RET
Rank_Recom_Score ENDP

END