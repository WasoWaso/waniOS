;kernel()
%include    "/home/m8ku/prog/src/include/define.asm"
%include    "/home/m8ku/prog/src/include/macro.asm"

    ORG         KERNEL_LOAD                             ; 0010_1000番地始まりだぞ
[BITS 32]
;--------------------------------------------------------
; エントリポイント
;--------------------------------------------------------
kernel:
        jmp     $                                       ; ∞

    times   (KERNEL_SIZE - ($ - $$))    db  0x00        ; 8kバイトでアセンブル
