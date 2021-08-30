;get_font_adr(adr)
get_font_adr:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    ax                                      ; 各レジスタの保存
        push    bx                                      ;
        push    si                                      ;
        push    es                                      ;
        push    bp                                      ;


        mov     si , [bp + 4]                           ; dst=FONTアドレスの保存先;

        mov     ax , 0x1130                             ; //フォントアドレスの取得
        mov     bh , 0x06                               ; 8x16 font (vga/mcga)
        int     10h                                     ; ES:BP=FONT ADDRESS;

        mov     [si + 0] , es                           ; dst[0]=セグメント;
        mov     [si + 2] , bp                           ; dst[1]=オフセット;

        pop     bp                                      ; 各レジスタの復帰
        pop     es                                      ;
        pop     si                                      ;
        pop     bx                                      ;
        pop     ax                                      ;

        mov     sp , bp                                 ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; //もどっていきなさい

;(関数の概要(フォントアドレスを所得する関数です))
; 0. BIOSサービスを利用してフォントアドレスを貰い指定の場所へ書き込みます.
; 1. スタックフレームの構築とレジスタの保存をし引数のアクセスへ備えます.
; 2. 'mov si,[bp+4]' フォンアドレスはES:BPへ書き込まれるので引数としてもらった[保存先+0]が
;    セグメントアドレス,[保存先+2]がオフセットアドレスとして書き込むこととします.
; 3. 'mov [si+x],XX'でBIOSからもらったフォントアドレスを書き込ます.
; 4. スタックの復帰とスタックフレームを破棄して関数の終了へ備えます.
; 5. もどっていきなさい.
