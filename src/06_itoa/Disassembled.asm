00000000  EB58              jmp short 0x5a
00000002  90                nop
00000003  90                nop
00000004  90                nop
00000005  90                nop
00000006  90                nop
00000007  90                nop
00000008  90                nop
00000009  90                nop
0000000A  90                nop
0000000B  90                nop
0000000C  90                nop
0000000D  90                nop
0000000E  90                nop
0000000F  90                nop
00000010  90                nop
00000011  90                nop
00000012  90                nop
00000013  90                nop
00000014  90                nop
00000015  90                nop
00000016  90                nop
00000017  90                nop
00000018  90                nop
00000019  90                nop
0000001A  90                nop
0000001B  90                nop
0000001C  90                nop
0000001D  90                nop
0000001E  90                nop
0000001F  90                nop
00000020  90                nop
00000021  90                nop
00000022  90                nop
00000023  90                nop
00000024  90                nop
00000025  90                nop
00000026  90                nop
00000027  90                nop
00000028  90                nop
00000029  90                nop
0000002A  90                nop
0000002B  90                nop
0000002C  90                nop
0000002D  90                nop
0000002E  90                nop
0000002F  90                nop
00000030  90                nop
00000031  90                nop
00000032  90                nop
00000033  90                nop
00000034  90                nop
00000035  90                nop
00000036  90                nop
00000037  90                nop
00000038  90                nop
00000039  90                nop
0000003A  90                nop
0000003B  90                nop
0000003C  90                nop
0000003D  90                nop
0000003E  90                nop
0000003F  90                nop
00000040  90                nop
00000041  90                nop
00000042  90                nop
00000043  90                nop
00000044  90                nop
00000045  90                nop
00000046  90                nop
00000047  90                nop
00000048  90                nop
00000049  90                nop
0000004A  90                nop
0000004B  90                nop
0000004C  90                nop
0000004D  90                nop
0000004E  90                nop
0000004F  90                nop
00000050  90                nop
00000051  90                nop
00000052  90                nop
00000053  90                nop
00000054  90                nop
00000055  90                nop
00000056  90                nop
00000057  90                nop
00000058  90                nop
00000059  90                nop
0000005A  FA                cli
0000005B  B80000            mov ax,0x0
0000005E  8ED8              mov ds,ax
00000060  8EC0              mov es,ax
00000062  8ED0              mov ss,ax
00000064  BC007C            mov sp,0x7c00
00000067  FB                sti
00000068  8816487D          mov [0x7d48],dl
0000006C  68307D            push word 0x7d30
0000006F  E8D800            call 0x14a
00000072  83C402            add sp,byte +0x2
00000075  6A01              push byte +0x1
00000077  6A0A              push byte +0xa
00000079  6A08              push byte +0x8
0000007B  683D7D            push word 0x7d3d
0000007E  68961F            push word 0x1f96
00000081  E8E700            call 0x16b
00000084  83C40A            add sp,byte +0xa
00000087  683D7D            push word 0x7d3d
0000008A  E8BD00            call 0x14a
0000008D  83C402            add sp,byte +0x2
00000090  6A03              push byte +0x3
00000092  6A0A              push byte +0xa
00000094  6A08              push byte +0x8
00000096  683D7D            push word 0x7d3d
00000099  68961F            push word 0x1f96
0000009C  E8CC00            call 0x16b
0000009F  83C40A            add sp,byte +0xa
000000A2  683D7D            push word 0x7d3d
000000A5  E8A200            call 0x14a
000000A8  83C402            add sp,byte +0x2
000000AB  6A01              push byte +0x1
000000AD  6A0A              push byte +0xa
000000AF  6A08              push byte +0x8
000000B1  683D7D            push word 0x7d3d
000000B4  686AE0            push word 0xe06a
000000B7  E8B100            call 0x16b
000000BA  83C40A            add sp,byte +0xa
000000BD  683D7D            push word 0x7d3d
000000C0  E88700            call 0x14a
000000C3  83C402            add sp,byte +0x2
000000C6  6A03              push byte +0x3
000000C8  6A0A              push byte +0xa
000000CA  6A08              push byte +0x8
000000CC  683D7D            push word 0x7d3d
000000CF  6AFF              push byte -0x1
000000D1  E89700            call 0x16b
000000D4  83C40A            add sp,byte +0xa
000000D7  683D7D            push word 0x7d3d
000000DA  E86D00            call 0x14a
000000DD  83C402            add sp,byte +0x2
000000E0  6A00              push byte +0x0
000000E2  6A0A              push byte +0xa
000000E4  6A08              push byte +0x8
000000E6  683D7D            push word 0x7d3d
000000E9  6AFF              push byte -0x1
000000EB  E87D00            call 0x16b
000000EE  83C40A            add sp,byte +0xa
000000F1  683D7D            push word 0x7d3d
000000F4  E85300            call 0x14a
000000F7  83C402            add sp,byte +0x2
000000FA  6A00              push byte +0x0
000000FC  6A10              push byte +0x10
000000FE  6A08              push byte +0x8
00000100  683D7D            push word 0x7d3d
00000103  6AFF              push byte -0x1
00000105  E86300            call 0x16b
00000108  83C40A            add sp,byte +0xa
0000010B  683D7D            push word 0x7d3d
0000010E  E83900            call 0x14a
00000111  83C402            add sp,byte +0x2
00000114  6A04              push byte +0x4
00000116  6A02              push byte +0x2
00000118  6A08              push byte +0x8
0000011A  683D7D            push word 0x7d3d
0000011D  6A0C              push byte +0xc
0000011F  E84900            call 0x16b
00000122  83C40A            add sp,byte +0xa
00000125  683D7D            push word 0x7d3d
00000128  E81F00            call 0x14a
0000012B  83C402            add sp,byte +0x2
0000012E  EBFE              jmp short 0x12e
00000130  42                inc dx
00000131  6F                outsw
00000132  6F                outsw
00000133  7469              jz 0x19e
00000135  6E                outsb
00000136  672E2E2E0A0D002D  or cl,[dword cs:0x2d2d2d00]
         -2D2D
00000140  2D2D2D            sub ax,0x2d2d
00000143  2D2D0A            sub ax,0xa2d
00000146  0D0000            or ax,0x0
00000149  005589            add [di-0x77],dl
0000014C  E550              in ax,0x50
0000014E  53                push bx
0000014F  56                push si
00000150  9C                pushf
00000151  8B7604            mov si,[bp+0x4]
00000154  B40E              mov ah,0xe
00000156  BB0000            mov bx,0x0
00000159  FC                cld
0000015A  AC                lodsb
0000015B  3C00              cmp al,0x0
0000015D  7404              jz 0x163
0000015F  CD10              int 0x10
00000161  EBF7              jmp short 0x15a
00000163  9D                popf
00000164  5E                pop si
00000165  5B                pop bx
00000166  58                pop ax
00000167  89EC              mov sp,bp
00000169  5D                pop bp
0000016A  C3                ret
0000016B  55                push bp
0000016C  89E5              mov bp,sp
0000016E  50                push ax
0000016F  53                push bx
00000170  51                push cx
00000171  52                push dx
00000172  56                push si
00000173  57                push di
00000174  9C                pushf
00000175  8B4604            mov ax,[bp+0x4]
00000178  8B7606            mov si,[bp+0x6]
0000017B  8B4E08            mov cx,[bp+0x8]
0000017E  89F7              mov di,si
00000180  01CF              add di,cx
00000182  4F                dec di
00000183  8B5E0C            mov bx,[bp+0xc]
00000186  F7C30100          test bx,0x1
0000018A  7408              jz 0x194
0000018C  83F800            cmp ax,byte +0x0
0000018F  7D03              jnl 0x194
00000191  83CB02            or bx,byte +0x2
00000194  F7C30200          test bx,0x2
00000198  7410              jz 0x1aa
0000019A  83F800            cmp ax,byte +0x0
0000019D  7D07              jnl 0x1a6
0000019F  F7D8              neg ax
000001A1  C6042D            mov byte [si],0x2d
000001A4  EB03              jmp short 0x1a9
000001A6  C6042B            mov byte [si],0x2b
000001A9  49                dec cx
000001AA  8B5E0A            mov bx,[bp+0xa]
000001AD  BA0000            mov dx,0x0
000001B0  F7F3              div bx
000001B2  89D6              mov si,dx
000001B4  8A94DD7D          mov dl,[si+0x7ddd]
000001B8  8815              mov [di],dl
000001BA  4F                dec di
000001BB  83F800            cmp ax,byte +0x0
000001BE  E0ED              loopne 0x1ad
000001C0  83F900            cmp cx,byte +0x0
000001C3  740D              jz 0x1d2
000001C5  B020              mov al,0x20
000001C7  837E0C04          cmp word [bp+0xc],byte +0x4
000001CB  7502              jnz 0x1cf
000001CD  B030              mov al,0x30
000001CF  FD                std
000001D0  F3AA              rep stosb
000001D2  9D                popf
000001D3  5F                pop di
000001D4  5E                pop si
000001D5  5A                pop dx
000001D6  59                pop cx
000001D7  5B                pop bx
000001D8  58                pop ax
000001D9  89EC              mov sp,bp
000001DB  5D                pop bp
000001DC  C3                ret
000001DD  3031              xor [bx+di],dh
000001DF  3233              xor dh,[bp+di]
000001E1  3435              xor al,0x35
000001E3  3637              ss aaa
000001E5  3839              cmp [bx+di],bh
000001E7  41                inc cx
000001E8  42                inc dx
000001E9  43                inc bx
000001EA  44                inc sp
000001EB  45                inc bp
000001EC  46                inc si
000001ED  0000              add [bx+si],al
000001EF  0000              add [bx+si],al
000001F1  0000              add [bx+si],al
000001F3  0000              add [bx+si],al
000001F5  0000              add [bx+si],al
000001F7  0000              add [bx+si],al
000001F9  0000              add [bx+si],al
000001FB  0000              add [bx+si],al
000001FD  0055AA            add [di-0x56],dl
