;memcmp(src0,src1,size)
memcmp:
        push    bp                                      ; スタックフレームの構築
        mov     bp, sp                                  ;

        push    bx                                      ; 各レジスタの退避
        push    cx                                      ;
        push    dx                                      ;
        push    si                                      ;
        push    di                                      ;
        pushf                                           ;

        mov     si, [bp+4]                              ; 第一引数にアクセス
        mov     di, [bp+6]                              ; 第二引数にアクセス
        mov     cx, [bp+8]                              ; 第三引数にアクセス

        cld                                             ; DF==0
        repe cmpsb                                      ; 比較
        jnz     .10F                                    ; if(ZF==0)だったら.10Fへ分岐
        mov     ax, 0                                   ;
        jmp     .end                                    ;
.10F:
        mov     ax, -1                                  ;
.end:
        popf                                            ;
        pop     di                                      ; 各レジスタの復帰
        pop     si                                      ;
        pop     dx                                      ;
        pop     cx                                      ;
        pop     bx                                      ;

        mov     sp, bp                                  ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; 関数の終了

; (関数の概要())
; 1.まずはスタックフレームの構築
; 2.お邪魔するレジスタたちをスタックに積んで
; 3.引数を受け取る
; 4.cld命令でDFフラグを0として書き込む,これで+方向に進む (1にしたい場合はstd命令を)
; 5.cmpsb命令はSIレジスタとDIレジスタに書き込んだメモリアドレスを比較してcmp命令の通り
;   に各フラグを設定する,repeの終了条件はZF==0またはCX==0,(ZFフラグについては命令開始
;   時から検査をするらしい)これでひとつでも異なる値があったらすぐに次の命令に遷移できる
; 6.条件分岐パートで異なる値がなかったらAXに0を異なる値があったらいいな-1を書き込む
; 7.お邪魔したレジスタたちをスタックから下ろして
; 8.スタックフレームの破棄
; 8.もとの処理に戻してあげる
