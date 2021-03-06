;RatsOS
[bits 16]

;----------- loader const ------------------
LOADER_BASE_ADDR 		equ 0x9000  ;内存地址0x9000
;---------------------------------------	

section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址

;程序核心内容
Entry:
	

	;---------------------------
    ;输出字符串
    mov si,HelloMsg			;将HelloMsg的地址放入si
    mov dh,0				;设置显示行
	mov dl,0				;设置显示列
    call PrintString		;调用函数


;程序挂起
Fin:
    hlt 					;让CPU挂起，等待指令。
    jmp Fin
	
; ------------------------------------------------------------------------
; 显示字符串函数:PrintString
; 参数:
; si = 字符串开始地址,
; dh = 第N行，0开始
; dl = 第N列，0开始
; ------------------------------------------------------------------------
PrintString:
            mov cx,0     ; BIOS中断参数：显示字符串长度
            mov bx,si
    .s1:                 ; 获取字符串长度
            mov al,[bx]  ; 读取1个字节到al
            add bx,1     ; 读取下个字节
            cmp al,0     ; 是否以0结束
            je .s2
            inc	cx       ; 计数器
            jmp .s1
    .s2:                 ; 显示字符串
            mov bx,si
            mov bp,bx
            mov ax,ds
            mov es,ax    ; BIOS中断参数：计算[ES:BP]为显示字符串开始地址

            mov ah,0x13  ; BIOS中断参数：中断模式
            mov al,0x01  ; BIOS中断参数：输出方式
            mov bh,0x0   ; BIOS中断参数：指定分页为0
            mov bl,0x1F  ; BIOS中断参数：显示属性，指定白色文字
            int 0x10     ; 调用BIOS中断操作显卡。输出字符串
            ret

;准备显示字符串
HelloMsg: DB "hello,ratsos!",0

	times	512-($-$$) db  0 ; 处理当前行$至结束(1FE)的填充	