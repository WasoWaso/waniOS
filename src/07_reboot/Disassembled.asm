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
00000068  8816AE7C          mov [0x7cae],dl
0000006C  68967C            push word 0x7c96
0000006F  E83E00            call 0xb0
00000072  83C402            add sp,byte +0x2
00000075  BE630F            mov si,0xf63
00000078  6A01              push byte +0x1
0000007A  6A0A              push byte +0xa
0000007C  6A08              push byte +0x8
0000007E  68A37C            push word 0x7ca3
00000081  56                push si
00000082  E84C00            call 0xd1
00000085  83C40A            add sp,byte +0xa
00000088  68A37C            push word 0x7ca3
0000008B  E82200            call 0xb0
0000008E  83C402            add sp,byte +0x2
00000091  E8BF00            call 0x153
00000094  EBFE              jmp short 0x94
00000096  42                inc dx
00000097  6F                outsw
00000098  6F                outsw
00000099  7469              jz 0x104
0000009B  6E                outsb
0000009C  672E2E2E0A0D002D  or cl,[dword cs:0x2d2d2d00]
         -2D2D
000000A6  2D2D2D            sub ax,0x2d2d
000000A9  2D2D0A            sub ax,0xa2d
000000AC  0D0000            or ax,0x0
000000AF  005589            add [di-0x77],dl
000000B2  E550              in ax,0x50
000000B4  53                push bx
000000B5  56                push si
000000B6  9C                pushf
000000B7  8B7604            mov si,[bp+0x4]
000000BA  B40E              mov ah,0xe
000000BC  BB0000            mov bx,0x0
000000BF  FC                cld
000000C0  AC                lodsb
000000C1  3C00              cmp al,0x0
000000C3  7404              jz 0xc9
000000C5  CD10              int 0x10
000000C7  EBF7              jmp short 0xc0
000000C9  9D                popf
000000CA  5E                pop si
000000CB  5B                pop bx
000000CC  58                pop ax
000000CD  89EC              mov sp,bp
000000CF  5D                pop bp
000000D0  C3                ret
000000D1  55                push bp
000000D2  89E5              mov bp,sp
000000D4  50                push ax
000000D5  53                push bx
000000D6  51                push cx
000000D7  52                push dx
000000D8  56                push si
000000D9  57                push di
000000DA  9C                pushf
000000DB  8B4604            mov ax,[bp+0x4]
000000DE  8B7606            mov si,[bp+0x6]
000000E1  8B4E08            mov cx,[bp+0x8]
000000E4  89F7              mov di,si
000000E6  01CF              add di,cx
000000E8  4F                dec di
000000E9  8B5E0C            mov bx,[bp+0xc]
000000EC  F7C30100          test bx,0x1
000000F0  7408              jz 0xfa
000000F2  83F800            cmp ax,byte +0x0
000000F5  7D03              jnl 0xfa
000000F7  83CB02            or bx,byte +0x2
000000FA  F7C30200          test bx,0x2
000000FE  7410              jz 0x110
00000100  83F800            cmp ax,byte +0x0
00000103  7D07              jnl 0x10c
00000105  F7D8              neg ax
00000107  C6042D            mov byte [si],0x2d
0000010A  EB03              jmp short 0x10f
0000010C  C6042B            mov byte [si],0x2b
0000010F  49                dec cx
00000110  8B5E0A            mov bx,[bp+0xa]
00000113  BA0000            mov dx,0x0
00000116  F7F3              div bx
00000118  89D6              mov si,dx
0000011A  8A94437D          mov dl,[si+0x7d43]
0000011E  8815              mov [di],dl
00000120  4F                dec di
00000121  83F800            cmp ax,byte +0x0
00000124  E0ED              loopne 0x113
00000126  83F900            cmp cx,byte +0x0
00000129  740D              jz 0x138
0000012B  B020              mov al,0x20
0000012D  837E0C04          cmp word [bp+0xc],byte +0x4
00000131  7502              jnz 0x135
00000133  B030              mov al,0x30
00000135  FD                std
00000136  F3AA              rep stosb
00000138  9D                popf
00000139  5F                pop di
0000013A  5E                pop si
0000013B  5A                pop dx
0000013C  59                pop cx
0000013D  5B                pop bx
0000013E  58                pop ax
0000013F  89EC              mov sp,bp
00000141  5D                pop bp
00000142  C3                ret
00000143  3031              xor [bx+di],dh
00000145  3233              xor dh,[bp+di]
00000147  3435              xor al,0x35
00000149  3637              ss aaa
0000014B  3839              cmp [bx+di],bh
0000014D  41                inc cx
0000014E  42                inc dx
0000014F  43                inc bx
00000150  44                inc sp
00000151  45                inc bp
00000152  46                inc si
00000153  686F7D            push word 0x7d6f
00000156  E857FF            call 0xb0
00000159  83C402            add sp,byte +0x2
0000015C  B410              mov ah,0x10
0000015E  CD16              int 0x16
00000160  3C20              cmp al,0x20
00000162  75F8              jnz 0x15c
00000164  688D7D            push word 0x7d8d
00000167  E846FF            call 0xb0
0000016A  83C402            add sp,byte +0x2
0000016D  CD19              int 0x19
0000016F  0A0D              or cl,[di]
00000171  50                push ax
00000172  7573              jnz 0x1e7
00000174  682053            push word 0x5320
00000177  50                push ax
00000178  41                inc cx
00000179  43                inc bx
0000017A  45                inc bp
0000017B  204B65            and [bp+di+0x65],cl
0000017E  7920              jns 0x1a0
00000180  746F              jz 0x1f1
00000182  205265            and [bp+si+0x65],dl
00000185  626F6F            bound bp,[bx+0x6f]
00000188  742E              jz 0x1b8
0000018A  2E2E000A          add [cs:bp+si],cl
0000018E  0D0A0D            or ax,0xd0a
00000191  0000              add [bx+si],al
00000193  0000              add [bx+si],al
00000195  0000              add [bx+si],al
00000197  0000              add [bx+si],al
00000199  0000              add [bx+si],al
0000019B  0000              add [bx+si],al
0000019D  0000              add [bx+si],al
0000019F  0000              add [bx+si],al
000001A1  0000              add [bx+si],al
000001A3  0000              add [bx+si],al
000001A5  0000              add [bx+si],al
000001A7  0000              add [bx+si],al
000001A9  0000              add [bx+si],al
000001AB  0000              add [bx+si],al
000001AD  0000              add [bx+si],al
000001AF  0000              add [bx+si],al
000001B1  0000              add [bx+si],al
000001B3  0000              add [bx+si],al
000001B5  0000              add [bx+si],al
000001B7  0000              add [bx+si],al
000001B9  0000              add [bx+si],al
000001BB  0000              add [bx+si],al
000001BD  0000              add [bx+si],al
000001BF  0000              add [bx+si],al
000001C1  0000              add [bx+si],al
000001C3  0000              add [bx+si],al
000001C5  0000              add [bx+si],al
000001C7  0000              add [bx+si],al
000001C9  0000              add [bx+si],al
000001CB  0000              add [bx+si],al
000001CD  0000              add [bx+si],al
000001CF  0000              add [bx+si],al
000001D1  0000              add [bx+si],al
000001D3  0000              add [bx+si],al
000001D5  0000              add [bx+si],al
000001D7  0000              add [bx+si],al
000001D9  0000              add [bx+si],al
000001DB  0000              add [bx+si],al
000001DD  0000              add [bx+si],al
000001DF  0000              add [bx+si],al
000001E1  0000              add [bx+si],al
000001E3  0000              add [bx+si],al
000001E5  0000              add [bx+si],al
000001E7  0000              add [bx+si],al
000001E9  0000              add [bx+si],al
000001EB  0000              add [bx+si],al
000001ED  0000              add [bx+si],al
000001EF  0000              add [bx+si],al
000001F1  0000              add [bx+si],al
000001F3  0000              add [bx+si],al
000001F5  0000              add [bx+si],al
000001F7  0000              add [bx+si],al
000001F9  0000              add [bx+si],al
000001FB  0000              add [bx+si],al
000001FD  0055AA            add [di-0x56],dl
