;int KBC_Data_Write(data)
KBC_Data_Write:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    cx                                      ; 各レジスタの保存
        pushf                                           ;

        mov     cx , 3                                  ; CX = 3; //最大カウント数
.10L:                                                   ; do
;                                                       ; {
        in      al , 0x64                               ;   AL = inp(0x64);
        test    al , 0x02                               ;   ZF = AL & 0x2;

        loopnz  .10L                                    ; } while (--CX && !ZF);

        cmp     cx , 0                                  ; if (CX)
.20Q:   jz      .20E                                    ; {

        mov     al , [bp + 4]                           ;   AL = データ;
        out     0x60 , al                               ;   outp(0x60, AL);

        mov     ax , cx                                 ;   return CX;
.20E:                                                   ; }

        popf                                            ; 各レジスタの復帰
        pop     cx                                      ;

        mov     sp , bp                                 ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; もとのとこへ

;int KBC_Data_Read(data)
KBC_Data_Read:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    cx                                      ; 各レジスタの保存
        push    di                                      ;
        pushf                                           ;

        mov     cx , 3                                  ; CX = 3; //最大カウント数
.10L:                                                   ; do
;                                                       ; {
        in      al , 0x64                               ; AL = inp(0x64);
        test    al , 0x01                               ; ZF = AL & 0x1;

        loopz  .10L                                     ; } while (CX-- && !ZF);

        cmp     cx , 0                                  ; if (CX)
.20Q:   jz      .20E                                    ; {

        mov     ah , 0x00                               ; AH = 0;
        in      al , 0x60                               ; AL = inp(0x60);

        mov     di , [bp + 4]                           ;
        mov     [di + 0] , ax                           ;

        mov     ax , cx                                 ; return CX;
.20E:
        popf                                            ; 各レジスタの復帰
        pop     di                                      ;
        pop     cx                                      ;

        mov     sp , bp                                 ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; もとのとこへ

;int KBC_Cmd_Write(cmd)
KBC_Cmd_Write:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    cx                                      ; 各レジスタの保存
        pushf                                           ;

        mov     cx , 3                                  ; CX = 3;//最大カウント数
.10L:                                                   ; do
;                                                       ; {
        in      al , 0x64                               ; AL = inp(0x64);
        test    al , 0x02                               ; ZF = AL & 0x2;

        loopnz  .10L                                    ; } while (--CX && !ZF);

        cmp     cx , 0                                  ; if(CX)
.20Q:   jz      .20E                                    ; {

        mov     al , [bp + 4]                           ; AL = コマンド;
        out     0x64 , al                               ; outp(0x64, AL)

        mov     ax , cx                                 ; return CX;
.20E:
        pop     cx                                      ; 各レジスタの復帰
        pushf                                           ;

        mov     sp , bp                                 ; スタックフレームの構築
        pop     bp                                      ;

        ret                                             ; もとのとこへ

; (関数の概要())
; 0. キーボードドライバの関数を集めました.
; <KBC_Data_Write>
; 0. KBCが接続されている0x60番のポートへデータを書き込む関数です.
; 1. スタックフレームを構築します.
; 2. 各レジスタを保存します.
; 3. '.10L' 実際にKBCへデータを送る前にするべきことがありそれは、KBCにデータを現在書き込める
;    かどうかを検査することです.
;    そしてそれを確認するためにはKBCのステータス・レジスタのビット1を確認して入力バッファが空か
;    どうかを検査します.
;    そのとき(BIT1==0)のときは入力バッファが空つまりKBCへデータを書き込むことができる状態そし
;    て(BIT1==1)のときは入力バッファにデータありつまりKBCへデータを書き込むことができない状態
;    となります.
;    'in al,0x64' KBCのステータス・レジスタを読み込みます.
;    'test al,0x02' 読み込んだ値のB1を検査します.
;    'loopnz .10L' もし入力バッファが空だったら先へ進みます.
;    B1==0 → and 1, 0 → ZF==1 → loopnzをスルー.
;    B1==1 → and 1, 1 → ZF==0 → loopnzに引っかかる.
;    入力バッファにデータありだったのなら、入力バッファが空になるまでウェイトします、このときCX
;    レジスタをカウンターとして3を設定しているので3回検査してバッファが空になるのを確認できなか
;    ったら関数の終了となります.
; 4. '.20Q' 入力バッファを検査する過程でタイムアウトしたか検査します.
;    タイムアウトしたのならCX==0となりKBCへデータを書き込むことができないので関数を終了します.
;    バッファが空だったのならKBCへデータを書き込むことができるので引数に書き込む値をとりKBCへ
;    データを書き込んだ後、戻り値にカウント数を渡して関数の終了となります.
; 5. 各レジスタを復帰します.
; 6. スタックフレームを破棄します.
; 7. スタックに積まれている戻り番地を基にもとのとこへ.

; <KBC_Data_Read>
; 0. KBCが接続されている0x60番のポートからデータを読み込む関数です.
; 1. スタックフレームを構築します.
; 2. 各レジスタを保存します.
; 3. '.10L' 実際にKBCからデータを読み込む前にするべきことがありそれは、KBCからデータを現在読み
;    込めるかどうかを検査することです.
;    そしてそれを確認するためにはKBCのステータス・レジスタのビット0を確認して出力バッファに現在
;    読むこむべきデータがあるかどうかを検査します.
;    そのとき(BIT0==0)のときは出力バッファが空つまりKBCから読み込むべきデータがない状態そして
;    (BIT0==1)のときは出力バッファにデータありつまりKBCから読み込むべきデータがある状態となる
;    に加えてここでの読むこむべきデータとはキーボードからのデータがある状態やKBCからのレスポンス
;    がある状態をさします.
;    'in al,0x64' KBCのステータス・レジスタを読み込みます.
;    'test al,0x02' 読み込んだ値のB0を検査します.
;    'loopz .10L' もし出力バッファがデータありだったら先へ進みます.
;    B0==0 → and 1, 0 → ZF==1 → loopzに引っかかる.
;    B0==1 → and 1, 1 → ZF==0 → loopzをスルー.
;    出力バッファにデータがなかったのなら、出力バッファにデータありになるまでウェイトします、こ
;    のときCXレジスタをカウンターとして3を設定しているので3回検査してバッファにデータありになる
;    のを確認できなかったら関数の終了となります.
; 4. '.20Q' 出力バッファを検査する過程でタイムアウトしたか検査します.
;    タイムアウトしたのならCX==0となりKBCから読むこむべきデータがないので関数を終了します.
;    バッファにデータありだったのならKBCから読み込むべきデータがあるのでKBCからデータを読み込み
;    引数にアドレスをとり読み込んだ値を所定の位置へ書き込んだ後、戻り地にカウント数を渡して関数
;    の終了となります.
; 5. 各レジスタを復帰します.
; 6. スタックフレームを破棄します.
; 7. もとのとこへ.

; <KBC_Cmd_Write>
; 0. コマンドを書き込みたいので'out 0x64 ,al'としました.
