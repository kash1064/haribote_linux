;my-os
;TAB = 4

CYLS	EQU		10

	;読み込み先
	ORG		0x7c00

	JMP		entry
	DB		0x90
	DB		"BOOTSEC0" ;ブートセクタ名8bytes
	DW		512 ;1セクタの大きさ
	DB		1 ;
	DW		1
	DB		2
	DW		224 ;rootdirの大きさ
	DW		2880
	DB		0xf0
	DW		9
	DW		18
	DW		2
	DD		0
	DD		2880
	DB		0,0,0x29
	DD		0xffffffff
	DB		"MY-OS      " ;ディスクの名前(11Byte
	DB		"FAT12   " ;フォーマットの名前
	RESB	18

entry:
	;レジスタを初期化する
	MOV		AX,0
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX

	;ディスクの読み込み
	MOV		AX,0x0820
	MOV 	ES,AX
	MOV 	CH,0
	MOV 	DH,0
	MOV 	CL,2

readloop:
	MOV 	SI,0

retry:
	MOV 	AH,0x02
	MOV 	AL,1
	MOV 	BX,0
	MOV 	DL,0x00
	INT		0x13 ;ディスクの呼び出し
	JNC		next ;jump if not carry CF>0ならジャンプ！
	ADD 	SI,1
	CMP 	SI,5
	JAE		error ;SI >= 5ならエラー
	MOV		AH,0x00
	MOV 	DL,0x00
	INT 	0x13 ;ドライブのリセット
	JMP 	retry

next:
	MOV		AX,ES
	ADD 	AX,0x0020
	MOV 	ES,AX ;ESを512/16加算して次の番地に進む
	ADD 	CL,1
	CMP 	CL,18
	JBE		readloop ;CL<=10ならreadloopへ
	MOV 	CL,1
	ADD 	DH,1
	CMP 	DH,2
	JB 		readloop
	MOV 	DH,0
	ADD 	CH,1
	CMP 	CH,CYLS
	JB		readloop

	MOV 	[0x0ff0],CH
	JMP		0xc200 ;sysファイルの読み込み
	
error:
	MOV 	SI,msg

putloop:
	MOV 	AL,[SI] ;メモリ位置を代入している（AL,BYTE [SI])
	ADD		SI,1
	CMP		AL,0 
	JE 		fin ;JEは比較結果がイコールの時に実行される
	MOV 	AH, 0x0e
	MOV 	BX,15
	INT		0x10
	JMP 	putloop

fin:
		HLT
		JMP		fin

msg:
	DB		0x0a,0x0a
	DB		"load error"
	DB		0x0a
	DB		0
	
	RESB 	0x1fe-($-$$)
	DB		0x55,0xaa