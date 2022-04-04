;;int status = apm_installation_check()
apm_installation_check:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    bx                                      ; 各レジスタの保存
        pushf                                           ;

        mov     ah , 0x53                               ; AH = 0x53;
        mov     al , 0x00                               ; AL = 0x00;
        xor     bx , bx                                 ; BX = 0x00;

        int     0x15                                    ; CF = BIOS(0x15,0x0053)
        jc     .apm_error                               ; if (CF == 0) {

            mov     ax , 0                              ; //ok

        jmp    .end_check                               ; } else
.apm_error:                                             ; {

            mov     ax , 1                              ; //error status

.end_check:                                             ; }

        popf                                            ;
        pop     bx                                      ; 各レジスタの復帰

        mov     sp , bp                                 ; スッタックフレームの破棄
        pop     bp                                      ;


        ret                                             ; いってらっしゃい

; 関数の概要(APMをサポートしているかをBIOSに尋ねる関数です)
; 1. スタックフレームを構築します.
; 2. 各レジスタを保存します. 戻り値を設定するのでAXレジスタは保存しません.
; 3. APMをサーポートしているか尋ねます.
;    AH=53h AL=00H BX=00H で15番でソフトウェア割り込みします.
;    ここで確認結果としてCFを確認します.
;    CF = 0 の場合はサポート○
;    CF = 1 の場合はサポート☓
;    で、それそれ戻り値に0と1を設定します.
; 4. 各レジスタを復帰します.
; 5. スタックフレームを破棄します.
; 6. ご主人様のとこへ

;apm_shutdown()
apm_shutdown:
        push    bp                                      ; スッタックフレームの構築
        mov     bp , sp                                 ;

        push    bx                                      ; 各レジスタの保存
        push    cx                                      ;
        pushf                                           ;

        mov     ah , 0x53                               ; ぞれぞれの引数を書き込む
        mov     al , 0x07                               ;
        mov     bx , 0x01                               ;
        mov     cx , 0x03                               ;
        int     0x15                                    ;
.error:
        mov     ax , 1                                  ; umm...

        popf                                            ; 各レジスタの復帰
        pop     cx                                      ;
        pop     bx                                      ;

        mov     sp , bp                                 ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; おかえりなさいませ

; 関数雨の概要(シャットダウンします)
; 0. ここではAPMによる電断をします.
;    実際にこの関数を呼び出す前に"apm_installation_check()"関数を発行してAPMに対応している
;    かを調べます.
;    APMへBIOSコールを介して対話します. それぞれの引数は
;
;    AH = 53h   ; APMのコマンド
;    AL = 07h   ; 電源のあれこれを決めるように
;    BX = 01h   ; コンピュータに対して
;    CX = 03h   ; シャットダウン
;    --ここでそれぞれ以下となる.
;    -- 03h = シャットダウン 02h = サスペンド 01h = スタンバイ
;    int 0x15   ; 15番でバイオスコール
;
;    と、なります.
;
; 1. スタックフレームを構築します.
; 2. 各レジスタを保存します. 戻り値を設定するのでAXレジスタは保存しません.
; 3. それぞれに引数を設定して電断します.
; 4. もし電断ができなくてもまだ大丈夫です.
; 5. エラーステータスの1を戻り値に設定して.
; 6. 各レジスタを復帰して.
; 7. ご主人様のもとへ.
