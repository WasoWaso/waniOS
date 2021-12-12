;read_lba(drive, lba, sect, dst)
read_lba:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    si                                      ; 各レジスタの保存
        pushf                                           ;

        mov     si , [bp + 4]                           ; 第一引数へアクセス

        mov     ax , [bp + 6]                           ; 第二引数へアクセス

        cdecl   lba_chs, si, .chs, ax                   ; lba_chs(drive,.chs,lba)

        mov     al , [si + drive.no]                    ; ドライブ番号をもってきて
        mov     [.chs + drive.no] , al                  ; .chsへ書く

        cdecl   read_chs, .chs, word [bp + 8], word [bp + 10]

        popf                                            ; 各レジスタの復帰
        pop     si                                      ;

        ;                                          AX = read_chs(drive,sect,dst)
        mov     sp , bp                                 ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; もとのとこへ

.chs:   times drive_size    db  0                       ; 読み込みセクタに関する情報
;(関数の概要(lba方式でディスクアクセスをする関数です))
; 0. lba方式でディスクアクセスをしたいときに利用する関数です.
;    lba方式でディスクアクセスするように見えますが実はchs方式でアクセスしています.
; 1. スタックフレームを立てます.
; 2. それぞれの引数へアクセスします.
;    第一引数はドライブ情報が書き込んである構造体のアドレスです.
;    第二引数はlba方式でのセクタ番号です.
; 3. lba方式によるセクタ指定をchs方式よるセクタ指定に変換する関数を発行します.
; 4. ドライブ番号がまだ構造体に入っていないのでブートストラップの中で得た値を代用します.
; 5. lba方式をchs方式へ変換できたのでchs方式によるセクタ読み関数を発行します.
;    戻り値は読み込んだセクタ数です.
; 6. 各レジスタを復帰します.
; 7. スタックフレームを解体して.
; 8. もとのとこへ.

;lba_chs(drive, drv_chs, lba)
lba_chs:
        push    bp                                      ; スタックフレームの構築
        mov     bp , sp                                 ;

        push    ax                                      ; 各レジスタの保存
        push    bx                                      ;
        push    dx                                      ;
        push    si                                      ;
        push    di                                      ;
        pushf                                           ;

        mov     si , [bp + 4]                           ; 第一引数を取得
        mov     di , [bp + 6]                           ; 第二引数を取得

        mov     al , [si + drive.head]                  ; AL = 最大ヘッド数
        mul     byte [si + drive.sect]                  ; AX = AL * 最大セクタ数
        mov     bx , ax                                 ; BX = cylnあたりのセクタ数

        mov     ax , [bp + 8]                           ; 第三引数を取得
        mov     dx , 0                                  ; DX = LBA (上位二バイト)
        div     bx                                      ; AX=DX:AX/BX//シリンダ番号
        ;                                               ; DX = DX:AX % BX //残り
        mov     [di + drive.cyln] , ax                  ; drv_chs.cyln=シリンダ番号

        mov     ax , dx                                 ; AX = 残り
        div     byte [si + drive.sect]                  ; AL=AX / sect//ヘッド番号
        ;                                               ; AH=AX % sect//セクタ番号
        movzx   dx , ah                                 ; DX = セクタ番号
        inc     dx                                      ; (セクタは1始まりだから+1)

        mov     ah , 0                                  ; AX = ヘッド位置

        mov     [di + drive.head] , ax                  ; drv_chs.head = ヘッド番号
        mov     [di + drive.sect] , dx                  ; drv_chs.sect = セクタ番号

        popf                                            ; 各レジスタの復帰
        pop     di                                      ;
        pop     si                                      ;
        pop     dx                                      ;
        pop     bx                                      ;
        pop     ax                                      ;

        mov     sp , bp                                 ; スタックフレームの破棄
        pop     bp                                      ;

        ret                                             ; もとのとこへ

;(関数の概要(lba方式をchs方式へ変換する関数です))
; 0. ディスクを最大限に活用するためにlba方式を利用したいところですが、互換性を考えてLBA方式によ
;    るセクタ指定をCHS方式へ変換する関数を作りました. driveはドライブ情報のアドレスをdrv_chs
;    は変換後の値をlbaはLBA方式によるセクタ番号を、３つを引数にとります.
;    変換前に必要となる構造体のアドレスはSIレジスタに書き込んでおきます.
;    変換後に書き込む構造体のアドレスはDIレジスタに書き込んでおきます.
;    [si + drive.no] [di + drive.no] このように変換前と変換後の区別をつけます.
; 1. スタックフレームを構築します.
; 2. 各レジスタを保存します.
; 3. シリンダあたりのセクタ数を導くためにすでに取得している最大ヘッド数と最大セクタ数を掛けます.
; 4. 次にシリンダ番号を導きます、シリンダ番号=LBA / シリンダあたりのセクタ数 によって導きます.
; 5. 次にヘッド番号とセクタ番号を導きます. シリンダ番号の演算をした時に出る余剰を基に導きます.
;    ヘッド番号 = シリンダ番号の余り / 最大セクタ数
;    セクタ番号 = ヘッド番号の余り + 1
; 6. こちらは、ヘッド番号=シリンダ番号 / 最大セクタ数  セクタ番号=シリンダ番号 % 最大セクタ数
;    ともいえます.
; 7. それぞれを変換後の構造体へ書き込みます.
;    movzxはゼロ拡張と呼ばれる動作をします. 1Bレジスタを2Bレジスタに転送する時に転送先の2B目を
;    ゼロで埋めます.
; 8. 各レジスタを復帰します.
; 9. スタックフレームを取ります.
;10. もとのとこへ戻ってもらいます.
