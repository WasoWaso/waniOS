;define()
        BOOT_LOAD       equ     (0x7C00)                 ; ブートプログラムロード位置

        BOOT_SIZE       equ     (1024 * 8)               ; ブートコードサイズ
        SECT_SIZE       equ     (512)                    ; セクタサイズ 512B
        BOOT_SECT       equ     (BOOT_SIZE / SECT_SIZE)  ; ブートプログラムのセクタ数
        E820_RECORD_SIZE    equ 20                       ; メモリ情報の格納サイズ20B
        KERNEL_LOAD     equ     0x0010_1000              ; カーネルのロード位置
        KERNEL_SIZE     equ     (1024 * 8)               ; カーネルのサイズ
        BOOT_END        equ     (BOOT_LOAD + BOOT_SIZE)  ; ブートコードの最終アドレス
        KERNEL_SECT     equ     (KERNEL_SIZE / SECT_SIZE); カーネルのセクタ数

; (定義の概要)
; 0. それぞれdefineしています、ソースコードにうまく取り込もう
