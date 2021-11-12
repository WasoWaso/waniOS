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

    ;----------------------------------------------------
    ; ブートプログラムの第四ステージ ▽
    ;----------------------------------------------------
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

        sti                                             ; //割り込み許可

        ;------------------------------------------------
        ; 文字列を表示
        ;------------------------------------------------
        cdecl   puts, .s1                               ; puts(.s1);

        ;------------------------------------------------
        ; キーボードLEDのテスト
        ;------------------------------------------------
        cdecl   puts, .s3                               ; //開始の旨を表示

        mov     bx , 0                                  ; BX = LEDの初期値;
        mov     cx , 39                                 ; テストの回数を制限
.20L:                                                   ; {
        push    cx                                      ; 回数カウンタの保存
        mov     ah , 0x00                               ; AH = 0;
        int     0x16                                    ; AL = BIOS(0x16,0x00)

        cmp     al , '1'                                ; if (AL < 1) {
        jb      .20E                                    ;   break; }

        cmp     al, '3'                                 ; if (3 < AL) {
        ja      .20E                                    ;   break; }

        mov     cl , al                                 ; CL = キー入力
        dec     cl                                      ; CL --; //１減算
        and     cl , 0x03                               ; CL &= 0x03; //0~2に制限
        mov     ax , 0x0001                             ; AX = 0x0001;//bit変換用
        shl     ax , cl                                 ; AX <<= CL;//0~2bitシフト
        xor     bx , ax                                 ; BX ^= ax; //ビット反転

        cli                                             ; // 割り込み禁止

        cdecl KBC_Cmd_Write, 0xAD                       ; // キーボード無効化

        cdecl KBC_Cmd_Write, 0xED                       ; // LEDコマンド
        cdecl KBC_Data_Read, .key                       ; // 受信応答の取得

        cmp     [.key] , byte 0xFA                      ; if (0xFA == key)
.21Q:   jne     .21F                                    ; {
        cdecl KBC_Data_Write, bx                        ;   //LEDデータの書き込み
        jmp     .21E                                    ; } else
.21F:                                                   ; {
        cdecl   itoa, word [.key], .e1, 2, 16, 0b0000   ; 受信コードの準備
        cdecl   puts, .e0                               ; 受信コードの表示
.21E:                                                   ; }
        cdecl KBC_Cmd_Write, 0xAE                       ; キーボード有効化

        sti                                             ; 割り込み許可

        pop     cx                                      ; 回数カウンタの復帰
        loop    .20L                                    ; while (--CX);
.20E:
        ;------------------------------------------------
        ; 文字列を表示
        ;------------------------------------------------
        cdecl   puts, .s4                               ; //完了の旨を表示

        ;------------------------------------------------
        ; 数値を表示
        ;------------------------------------------------
        mov     ax , 3939                               ;
        cdecl itoa, ax, .39, 8, 10, 0b0001              ; itoa(AX)
        cdecl puts, .39                                 ; puts(.s1);

        jmp     $                                       ; while (1); //　∞

.key:   dw  0
.f1:    dw  0
.s0:    db  "4th stage...", 0x0A, 0x0D, 0
.s1:    db  " A20 Gate Enabled.", 0x0A, 0x0D, 0
.s2:    db  " A20 Gate could't Enable", 0x0A, 0x0D, 0
.s3:    db  " Keyboard LED Test...", 0
.s4:    db  " (done)", 0x0A, 0x0D, 0
.s5:    db  0x0A, 0x0D, 0
.e0:    db  "["
.e1:    db  "ZZ]", 0x0A, 0x0D, 0
.39:    db  "--------", 0x0A, 0x0D, 0
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; パディング (このファイルは8Kバイトとする)
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        times (BOOT_SIZE - ($ - $$)) db 0x00            ; 8KByte
;(関数の概要())
; 0. キーボードのランプを制御してみます. KBCへキーボードLEDの制御コマンド0xEDを送信し、続けて
;    データを送信します. (bit0:Scroll Lock) (bit1:Num Lock) (bit2:Caps Lock)
; 1. 'mov bx,0' LEDの点灯状態をプログラム中に保持したいのでBXレジスタをLEDのフラグとします.
; 2. 'mov cx,39' テスト回数を設定します.
; 3. 'push cx' ここから繰り返しが始まります.カウンタであるCXレジスタを後に利用するので繰り返し
;    の中で値を保持しておくためにプッシュしておきます.
; 4. 'mov ah,0x00 / int 0x16' キーボードに入力されたキーの文字コードを取得します.
; 5. 'cmp al,'1' ~ ja .10E' ここで道がわかれます.文字コードが'1'から'3'までの範囲なら後に
;    続きます.範囲外なら何もしないとこまで飛んでいきます.
; 6. 'mov cl , al' 文字コードをCLレジスタにうつします.
; 7. 'dec cl' 次の論理演算で0から2の値を得るために一つ減らしておきます.
; 8. 'and cl,0x03' ビットのマスクをします. <'1'の文字コードは0x31><'2'の文字コードは0x32>
;    といった具合に文字コードに対して下位ビットが0 ~ 2に対応していて、それらを取り出したいので
;    ビットをマスクします. 前に値を減算しているため実際の数値は異なっているけど、また次に関係し
;    ています.
;    文字コードを二進数にする目的です.
;    <注意: 7番のデクリメントを考えないでの解説>
;                                     0x31           0x03       0x01
;     　　　　　　　　　　　　　　　　　　________       ________
;    キーボードで1 (文字コードで0x31)　|00110001| and |00000011| → 0000001
;                                   ^^^^^^^^       ^^^^^^^^  (1の位を取り出す)
; 9. 'mov ax,0x0001' 次に必要な値なので事前に用意しておきます.
; 10.'shl ax,cl' また次に必要になる値を練ります. 0b0000001 の1を移動して特定のキーに対応する
;    ビットパターンをつくります. いくつ左シフトするかは8番で得た数値を利用します. '1'なら0x01
;    '2'なら0x02 '3'なら0x04が得られます.
; 11.'xor bx,ax' いよいよLEDのフラグへ変更を加えます. 元々の値と新しいビットパターンをビット
;    反転してスイッチのような役割を果たします.
; 12.'cli' 後にKBCを制御するので割り込みを禁止します.
; 13.KBCへコマンドを送信すると応答がバッファに入ります、それを読み取り正常なら後に続きます.
; 14.KBCへデータを書き込みます.データはBXレジスタに入っているのでこちらを引数に取ります.
;    正常が確認できなかったらコードを表示します.
; 15.キーボードを有効化します.
; 16.割り込みを許可します.
; 17.繰り返しをします.
; 18.テストが終了したら完了の旨を伝えます.
