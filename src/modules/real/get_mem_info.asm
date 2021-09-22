;get_mem_info()
get_mem_info:
        push    eax                                     ; 各レジスタの保存
        push    ebx                                     ;
        push    ecx                                     ;
        push    edx                                     ;
        push    si                                      ;
        push    di                                      ;
        push    bp                                      ;
        pushf                                           ;

        mov     bp , 0                                  ; lines = 0; //行数
        mov     ebx , 0                                 ; index = 0; //インデックス

        cdecl   puts, .s0                               ;
.10L:                                                   ; do
;                                                       ; {
        mov     eax , 0x0000E820                        ; EAX = 0x0000E820;
;                                                       ; EBX = インデックス
        mov     ecx , E820_RECORD_SIZE                  ; ECX = 要求バイト数;
        mov     edx , 0x534D4150                        ; EDX = 'SMAP';
        mov     di , .b0                                ; ES：DI ＝ バッファ;
        int     0x15                                    ; BIOS(0x15,0xE820);

        cmp     eax , 'PAMS'                            ;
        je      .12E                                    ;
        jmp     .10E                                    ;
.12E:
        jnc     .14E                                    ; if (CF){
        jmp     .10E                                    ;   break;
.14E:                                                   ; } //エラーなし?
        cdecl   put_mem_info , di                       ; 1レコードのメモリ情報を表示


        mov     eax , [di + 16]                         ; EAX = レコードタイプ;
        cmp     eax , 3                                 ; if (3 == EAX)//ACPIData
        jne     .15E                                    ; {

        mov     eax , [di + 0]                          ; EAX = BASEアドレス
        mov     [ACPI_DATA.adr] , eax                   ; ACPI_DATA.adr = EAX;

        mov     eax , [di + 8]                          ; EAX = Lenght;
        mov     [ACPI_DATA.len] , eax                   ; ACPI_DATA.len = EAX;
.15E:                                                   ; }
        cmp     ebx , 0                                 ; if (0 != EBX)
.16Q:   jz      .16E                                    ; {

        inc     bp                                      ;   lines++;
        and     bp , 0x07                               ;   lines &= 0x07;
        jnz     .16E                                    ;   if (0 == lines)
;                                                       ;   {
        cdecl   puts, .s2                               ;       puts(.s2);
        mov     ah , 0x10                               ;       //キー入力待ち
        int     0x16                                    ;       AL=BIOS(0x16,0x10)

        cdecl   puts, .s3                               ;       puts(.s3);
;                                                       ;   }
.16E:                                                   ; }
        cmp     ebx , 0                                 ;
.10Q:   jne     .10L                                    ;
.10E:                                                   ; while (0 != EBX)
        cdecl   puts, .s1                               ;

        popf                                            ; 各レジスタの復帰
        pop     bp                                      ;
        pop     di                                      ;
        pop     si                                      ;
        pop     edx                                     ;
        pop     ecx                                     ;
        pop     ebx                                     ;
        pop     eax                                     ;

        ret                                             ; もとのとこへ

.s0:    db  " E820_RECORD_SIZE:", 0x0A, 0x0D
        db  " Base_____________ Length___________ Type____", 0x0A, 0x0D, 0
.s1:    db  " --------------------------------------------", 0x0A, 0x0D, 0
.s2:    db  " <more...>", 0
.s3:    db  0x0D, "          ", 0x0D, 0
.t1:    db  "ACPInow", 0x0A, 0x0D, 0

        align   4, db   0
.b0:    times E820_RECORD_SIZE db 0

;put_mem_info(adr)
put_mem_info:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    bx                                      ; 各レジスタの保存
        push    si                                      ;

        mov     si , [bp + 4]                           ; SI = バッファアドレス;

        ;Base(64bit)                                    ; //ここから変換していく
        cdecl itoa, word [si + 6], .p2 + 0, 4, 16, 0b0100
        cdecl itoa, word [si + 4], .p2 + 4, 4, 16, 0b0100
        cdecl itoa, word [si + 2], .p3 + 0, 4, 16, 0b0100
        cdecl itoa, word [si + 0], .p3 + 4, 4, 16, 0b0100

        ;Length(64bit)
        cdecl itoa, word [si + 14], .p4 + 0, 4, 16, 0b0100
        cdecl itoa, word [si + 12], .p4 + 4, 4, 16, 0b0100
        cdecl itoa, word [si + 10], .p5 + 0, 4, 16, 0b0100
        cdecl itoa, word [si + 08], .p5 + 4, 4, 16, 0b0100

        ;Type(32bit)
        cdecl itoa, word [si + 18], .p6 + 0, 4, 16, 0b0100
        cdecl itoa, word [si + 16], .p6 + 4, 4, 16, 0b0100

        cdecl puts, .s1                                 ; レコード情報を表示
;                                                       ;
        mov     bx , [si + 16]                          ; 2バイトアドレス変換↓
        and     bx , 0x07                               ; BX = Type(1 ~ 5)
        shl     bx , 1                                  ; BX *= 2;
        add     bx , .t0                                ; BX += .t0;
        cdecl puts, word [bx]                           ; puts(*BX);

        pop     si                                      ; 各レジスタの復帰
        pop     bx                                      ;

        mov     sp , bp                                 ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; おりゃー

.s1:    db  " "                                         ; 一レコード分のメモリ情報
.p2:    db  "ZZZZZZZZ_"                                 ; ベース上位32ビット
.p3:    db  "ZZZZZZZZ "                                 ; ベース下位32ビット
.p4:    db  "ZZZZZZZZ_"                                 ; バイト長上位32ビット
.p5:    db  "ZZZZZZZZ "                                 ; バイト長下位32ビット
.p6:    db  "ZZZZZZZZ ", 0                              ;　データタイプ32ビット

.s4:    db  " (Unknown)", 0x0A, 0x0D, 0
.s5:    db  " (usable)", 0x0A, 0x0D, 0
.s6:    db  " (reserved)", 0x0A, 0x0D, 0
.s7:    db  " (ACPI data)", 0x0A, 0x0D, 0
.s8:    db  " (ACPI NVS)", 0x0A, 0x0D, 0
.s9:    db  " (bad memory)", 0x0A, 0x0D, 0

.t0:    dw  .s4, .s5, .s6, .s7, .s8, .s9

;(関数の概要(メモリ情報の取得と表示をします))
; 0. 一つのソースファイルの中に２つの関数をつくっています.

; <get_mem_info>
; 0. レコード情報の取得を行います、専用の表示関数のソースはこちらの関数の下につくっています.
; 1. 引数は貰わないのでレジスタの保存だけしちゃいます.
; 2. 'mov bp,0''mov ebx,0' 変数の初期化をします.
; 3. 'cdecl puts,.s0' ヘッダを表示します.
; 4. 'int 0x15' メモリ情報を取得するためにBIOSコールを呼びます、EAXにE820h、ECXに書き込み先
;     バイト数、EDXに"SMAP"が引数です.
; 5. コマンドが対応しているか検査してEBXが3だったらACPIのテーブルなので値を所定の位置へ書き込
;    みます.
; 6. 'cdecl put_mem_info,di' テーブル情報のアドレスを引数に専用の表示関数を呼び出します.
; 7. '.16Q' メモリ情報を8行分表示するたび注意を促します、ページ数をマスクして非零分岐をします
;    lineが8になる度にand命令によって4ビット目が0になり、0からまたlineが加算されていくことに
;    なるので8ページずつ文字列を表示することができます.
;     line(BP)       0x07
;     ________     ________
;    |00000001| X |00000111| → ZF = 0                           (ページが1)
;     ^^^^^^^^     ^^^^^^^^
;     ________     ________
;    |00001000| X |00000111| → ZF = 1   → "<more...>"を表示.     (ページが8)
;     ^^^^^^^^     ^^^^^^^^
;     ________     ________
;    |00000001| X |00000111| → ZF = 0                           (ページが9)
;     ^^^^^^^^     ^^^^^^^^
;     ________     ________
;    |00001000| X |00000111| → ZF = 1   → "<more...>"を表示.     (ページが16)
;     ^^^^^^^^     ^^^^^^^^
; 8. '.10Q' EBXに0が入ると最終レコードなので、それまでレコードの取得を繰り返しをします.
; 9. 'cdecl puts,.s1' フッダを表示します
;10. 保存しておいたレジスタの復帰をします
;11. 'ret' 関数の終了です.

; <put_mem_info>
; 0. メモリ情報の表示をします、引数にレコードを取ります.
;    レコードの構造 > 0 ~ 8(BASEAdr) 8 ~ 16(Len) 16 ~ 20(Type)
; 1. スタックフレームの構築をします.
; 2. レジスタの保存をします.
; 3. 'mov si,[bp+4]' 第一引数をとります.
; 4. 'cdecl itoa,xxx' レコード情報を文字列に変換します、レコード長が64bitの値が書き込まれて
;    いてx86はリトルエディアンなので後ろから徐々に変換していき変換した文字列は前から配置していき
;    ます.
; 5. 'cdecl  puts,.s1' 変換した文字列を表示します.
; 6. 'mov bx,[si+16]' タイプ情報をとります、知りたいのは下位2Bなので左です.
; 7. 'and bx,0x07' マスクします.
; 8. 'shl bx,1' タイプ情報を左シフトして2バイトアドレッシングのインデックスにします.
; 9. 'add bx,.t0' 事前に定義している各文字列へのアドレスの始端(.t0)に先程つくった値を加算する
;    ことで対応した文字列のアドレスを得ることができます.
;10. 'cdecl puts,word[bx]' 文字列表示関数に先程つくった値を引数にわたします.
;11. お邪魔したのでレジスタを復帰します.
;12. 前関数に戻るためにスタックフレームを壊します.
;13. 'ret' 前関数へ戻ります.
