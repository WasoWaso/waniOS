;boot()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; マクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        %include "/home/m8ku/prog/src/include/macro.asm"
        %include "/home/m8ku/prog/src/include/define.asm"

        ORG     BOOT_LOAD                               ; プログラムの開始位置を設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; エントリポイント
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
entry:
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; BPB( BIOS Parameter Block )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        jmp     ipl                                     ; IPLラベルへ移動
        times  90 - ( $ - $$ ) db 0x90                  ; BPB領域を確保
ipl:
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; IPL( Initial Program Loader )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        cli                                             ; //割り込み禁止

        mov     ax , 0x0000                             ; AX=0x0000
        mov     ds , ax                                 ; DS=0x0000
        mov     es , ax                                 ; ES=0x0000
        mov     ss , ax                                 ; SS=0x0000
        mov     sp , BOOT_LOAD                          ; SP=0x7c00

        sti                                             ; //割り込み許可

        mov     [BOOT + drive.no] , dl                  ; ドライブ番号
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 文字列を表示
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        cdecl   puts , .s0                              ; puts(.s0);//Booting...

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 次の５１２バイトを読み込む
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov     bx , BOOT_SECT - 1                      ; BX = 残りのブートセクタ数
        mov     cx , BOOT_LOAD + SECT_SIZE              ; CX = 次のロードアドレス

        cdecl   read_chs, BOOT,  bx, cx                 ; セクタ読み出し関数の発行


        cmp     ax , bx                                 ; if(AX!=BX)
.10Q:   jz      .10E                                    ; {
.10T:   cdecl   puts, .e0                               ; puts(.e0); //メッセージ
        call    reboot                                  ; reboot();  //再起動
.10E:                                                   ; }

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 次のステージへ移行
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        jmp     stage_2nd                               ;

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; データ
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.s0:    db  "Booting..." , 0x0A , 0x0D , 0              ;
.e0:    db  "Error:sector read", 0                      ;

        align       2       , db 0                      ;
BOOT:
        istruc  drive
            at drive.no,    dw  0                       ; ドライブ番号
            at drive.cyln,  dw  0                       ; S:シリンダー
            at drive.head,  dw  0                       ; H:ヘッド
            at drive.sect,  dw  2                       ; S:セクタ
        iend

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; モジュール
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    %include "/home/m8ku/prog/src/modules/real/puts.asm"
    %include "/home/m8ku/prog/src/modules/real/reboot.asm"
    %include "/home/m8ku/prog/src/modules/real/read_chs.asm"

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ブートフラグの設定 (先頭512バイトの終了)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;p;;;;;;;;;;;;;;;;;;;;;;;;;;
        times 510 - ($ - $$) db 0x00                    ; IPL領域を浸す
        db      0x55 , 0xAA                             ; 0x55 0xAA

    ;****************************************************
    ; リアルモード時に取得した情報 絶対参照するため0x7E00へ配置
    ;****************************************************
FONT:
.seg:   dw  0                                           ; フォントadrの保存先(seg)
.off:   dw  0                                           ; フォントadrの保存先(off)

ACPI_DATA:                                              ; ACPI data
.adr:   dd  0                                           ; ACPI data address
.len:   dd  0                                           ; ACPI data lenght

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; モジュール (先頭512バイト以降に配置)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    %include "/home/m8ku/prog/src/modules/real/itoa.asm"
    %include "/home/m8ku/prog/src/modules/real/get_drive_param.asm"
    %include "/home/m8ku/prog/src/modules/real/get_font_adr.asm"
    %include "/home/m8ku/prog/src/modules/real/get_mem_info.asm"
    %include "/home/m8ku/prog/src/modules/real/kbc.asm"

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ブートプログラムの第二ステージ ▽
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stage_2nd:
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 文字列を表示
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        cdecl puts, .s0                                 ; puts(.s0);

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; ドライブ情報を取得
        ;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        cdecl   get_drive_param, BOOT                   ; get_drive_param(BOOT);
        cmp     ax , 0                                  ; if (0 == AX)
.10Q:   jnz     .10E                                    ; {
.10T:   cdecl   puts, .e0                               ;   puts(.e0);
        call    reboot                                  ;   reboot(); //再起動
.10E:                                                   ; }

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; ドライブ情報を表示
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov     ax , [BOOT + drive.no]                  ; AX = ブートドライブ
        cdecl   itoa, ax, .p1, 2, 16, 0b0100            ;

        mov     ax , [BOOT + drive.cyln]                ; AX = シリンダ(トラック)数
        cdecl   itoa, ax, .p2, 4, 16, 0b0100            ;

        mov     ax , [BOOT + drive.head]                ; AX = ヘッド数
        cdecl   itoa, ax, .p3, 2, 16, 0b0100            ;

        mov     ax , [BOOT + drive.sect]                ; AX=トラックあたりのセクタ数
        cdecl   itoa, ax, .p4, 2, 16, 0b0100            ;

        cdecl   puts, .s2                               ; puts(.s2); //情報を表示

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; 次のステージへ移行
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        jmp     stage_3rd                               ; 第三ステージへ移行

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; データ
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.s0:    db  "2nd stage...", 0x0A, 0x0D, 0
.s2:    db  " Drive:0x"
.p1:    db  "--, C:0x"
.p2:    db  "----, H:0x"
.p3:    db  "--, S:0x"
.p4:    db  "--", 0x0A, 0x0D, 0
.e0:    db  "Error:Can't get parameter.", 0

    ;****************************************************
    ; ブートプログラムの第三ステージ ▽
    ;****************************************************
stage_3rd:
        ;************************************************
        ; 文字列を表示
        ;************************************************
        cdecl   puts, .s1                               ; puts(.s1);

        ;************************************************
        ; プロテクトモードで使用するフォントは、BIOSに内蔵された
        ; ものを流用する
        ;************************************************
        cdecl   get_font_adr, FONT                      ; BIOSフォントアドレスを取得

        ;************************************************
        ; フォントアドレスの表示
        ;************************************************
        cdecl   itoa, word [FONT.seg], .p1, 4, 16, 0b0100
        cdecl   itoa, word [FONT.off], .p2, 4, 16, 0b0100
        cdecl   puts, .s2

        ;************************************************
        ; メモリ情報の取得と表示
        ;************************************************
        cdecl   get_mem_info                            ; get_mem_info();

        mov     eax , [ACPI_DATA.adr]                   ; EAX = ACPI_DATA.adr;
        cmp     eax , 0                                 ; if (EAX)
.10Q:   je      .10E                                    ;{
        cdecl itoa, ax, .p4, 4, 16, 0b0100              ; itoa(AX); //下位Adr変換
        shr     eax , 16                                ; EAX >>= 16;
        cdecl itoa, ax, .p3, 4, 16, 0b0100              ; itoa(AX); //上位Adr変換

        cdecl puts, .s3                                 ; puts(.s3);
.10E:                                                   ; }

        ;************************************************
        ; 次のステージへ移行
        ;************************************************
        jmp     stage_4th                               ; 第四ステージへ移行

.s0:    db  "--------", 0x0A, 0x0D, 0
.s1:    db  "3rd stage...", 0x0A, 0x0D, 0

.s2:    db  " Font Address="
.p1:    db  "ZZZZ:"
.p2:    db  "ZZZZ", 0x0A, 0x0D, 0
        db  0x0A, 0x0D, 0

.s3:    db  " ACPI DATA="
.p3:    db  "ZZZZ"                                      ; 上位32ビット
.p4:    db  "ZZZZ", 0x0A, 0x0D, 0                       ; 下位32ビット

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ブートプログラムの第四ステージ ▽
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stage_4th:
        ;------------------------------------------------
        ; 文字列を表示
        ;------------------------------------------------
        cdecl   puts, .s0                               ; puts(.s0);

        ;------------------------------------------------
        ; A20ゲートの有効化
        ;------------------------------------------------
        cli                                             ; //割り込み禁止

        cdecl   KBC_Cmd_Write, 0xAD                     ; //キーボード無効化

        cdecl   KBC_Cmd_Write, 0xD0                     ; //出力信号読み出しコマンド
        cdecl   KBC_Data_Read, .key                     ; //出力信号のデータ読み込み

        mov     bl , [.key]                             ; BL = key;
        or      bl , 0x02                               ; BL |= 0x02; //A20Gate

        cdecl   KBC_Cmd_Write, 0xD1                     ; //出力信号書き込みコマンド
        cdecl   KBC_Data_Write, bx                      ; //出力信号へ反映

        cmp     ax , 0                                  ; if (0 == AX)
.10Q:   jnz     .10E                                    ; {
        cdecl   puts, .s2                               ;   puts(.s2);
.10E:                                                   ; }
        cdecl   KBC_Cmd_Write, 0xAE                     ; //キーボード有効化
<<<<<<< HEAD

=======
        
>>>>>>> 291f6dd653f0f362ec36a1687f95878b5ebff402
        sti                                             ; //割り込み許可

        cdecl   puts, .s1                               ; puts(.s1);

        ;************************************************
        ; 数値を表示
        ;************************************************
        mov     ax , 3939                               ;
        cdecl itoa, ax, .39, 8, 10, 0b0001              ; itoa(AX)
        cdecl puts, .39                                 ; puts(.s1);

        jmp     $                                       ; while (1); //　∞

.key:   dw  0
.s0:    db  "4th stage...", 0x0A, 0x0D, 0
.s1:    db  " A20 Gate Enabled.", 0x0A, 0x0D, 0
.s2:    db  " A20 Gate could't Enable", 0x0A, 0x0D, 0
.39:    db  "--------", 0x0A, 0x0D, 0
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; パディング (このファイルは8Kバイトとする)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        times (BOOT_SIZE - ($ - $$)) db 0x00            ; 8KByte
;(関数の概要())
; 0. 第四ステージの作成とA20ゲートを有効化して1MB以上のメモリ空間へアクセスできるようにし
;    ました.
