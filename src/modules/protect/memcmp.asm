;memcmp(src0,src1,size)
memcmp:
        push    ebp                                     ; スタックフレームの構築
        mov     ebp, esp                                ;

        push    ebx                                     ; 各レジスタの退避
        push    ecx                                     ;
        push    edx                                     ;
        push    esi                                     ;
        push    edi                                     ;
        pushf                                           ;

        mov     esi, [ebp+4]                            ; 第一引数にアクセス
        mov     edi, [ebp+6]                            ; 第二引数にアクセス
        mov     ecx, [ebp+8]                            ; 第三引数にアクセス

        cld                                             ; DF==0
        repe cmpsb                                      ; 比較
        jnz     .10F                                    ; if(ZF==0)だったら.10Fへ分岐
        mov     eax, 0                                  ;
        jmp     .end                                    ;
.10F:
        mov     eax, -1                                 ;
.end:
        popf                                            ;
        pop     edi                                     ; 各レジスタの復帰
        pop     esi                                     ;
        pop     edx                                     ;
        pop     ecx                                     ;
        pop     ebx                                     ;

        mov     esp, ebp                                ; スタックフレームの破棄
        pop     ebp                                     ;

        ret                                             ; 関数の終了

; (関数の概要(メモリの中を比較する関数です))
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
