;memcpy(dst,src,size)
memcpy:
        push bp                                         ; meke stack flame
        mov bp, sp                                      ;

        push cx                                         ;
        push si                                         ;
        push di                                         ;

        mov   cx, [bp+4]                                ; access first arg
        mov   si, [bp+6]                                ; access secound arg
        mov   di, [bp+8]                                ; access thourd arg
        cld                                             ; DF=0
        rep movsb                                       ; while(*EDI++ = *ESI++);

        pop   di                                        ;
        pop   si                                        ;
        pop   cx                                        ;

        ;mov   sp, bp                                   ; dicard stack frame
        ;pop   bp                                       ;

        mov   sp,bp                                     ;discard stack frame
        pop   bp                                        ;

        ret                                             ; finish fundtion

        ;　(関数の概要())
        ;　1.まずはスタックフレームを構築して引数のアクセスに備えます
        ;　2.お邪魔することになるレジスタたちを退避させて
        ;　3.movsb命令に備えて引数としてもらった設定値を各レジスタに書き込む
        ;　4.cld命令でDFフラグを0として書き込む (1にしたい場合はstd命令を)
        ;　5.movsb命令は SIに転送元 DIに転送先 として転送元アドレスから転送先アドレスへ1バイトずつ値
        ;　　を書き込む ただしこの場合一回しか転送が行われない、そこでrepプレフィックスを付け足してやって
        ;　　指定された回数分転送を行う このときCXレジスタにその回数を指定する またDFフラグが0の時はアドレスを
        ;　　加算、反対にDFフラグが0の時はアドレスを減算していきながら値を書き込むことになる
        ;　6.お邪魔したレジスタたちを復帰させて
        ;　7.そしてスタックフレームを破棄します
        ;　8.もとの処理に戻してあげる
