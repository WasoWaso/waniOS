;CeasarCodeEncrypt(dst,key)
CCE:
        push    bp                                      ;
        mov     bp , sp                                 ;

        push    bx                                      ;
        push    cx                                      ;
        push    di                                      ;
        pushf                                           ;

        mov     di , [bp + 4]                           ;
        mov     bx , [bp + 6]                           ;

Test:
        cmp     bx , 1                                  ;
        je      .C1                                     ;

        cmp     bx , 2                                  ;
        je      .C2                                     ;

        cmp     bx , 3                                  ;
        je      .C3                                     ;

        cmp     bx , 4                                  ;
        je      .C4

        cmp     bx , 5                                  ;
        je      .C5                                     ;

;        cmp     bx , 6                                  ;
;        je      .C6                                     ;

;        cmp     bx , 7                                  ;
;        je      .C7                                     ;

;        cmp     bx , 8                                  ;
;        je      .C8                                     ;

;        cmp     bx , 9                                  ;
;        je      .C9                                     ;

;        cmp     bx , 10                                 ;
;        je      .C10                                    ;

;        cmp     bx , 11                                 ;
;        je      .C11                                    ;

;        cmp     bx , 12                                 ;
;        je      .C12                                    ;

;        cmp     bx , 13                                 ;
;        je      .C13                                    ;

;        cmp     bx , 14                                 ;
;        je      .C14                                    ;

;        cmp     bx , 15                                 ;
;        je      .C15                                    ;

;        cmp     bx , 16                                 ;
;        je      .C16                                    ;

;        cmp     bx , 17                                 ;
;        je      .C17                                    ;

;        cmp     bx , 18                                 ;
;        je      .C18                                    ;

;        cmp     bx , 19                                 ;
;        je      .C19                                    ;

;        cmp     bx , 20                                 ;
;        je      .C20                                    ;

;        cmp     bx , 21                                 ;
;        je      .C21                                    ;

;        cmp     bx , 22                                 ;
;        je      .C22                                    ;

;        cmp     bx , 23                                 ;
;        je      .C23                                    ;

;        cmp     bx , 24                                 ;
;        je      .C24                                    ;

;        cmp     bx , 25                                 ;
;        je      .C25                                    ;

;一つずらす
.C1:
        mov     al , [di]                               ;

        cmp     al , 0x0A                               ;
        je      .C1E                                    ;

        cmp     al , 0x0D                               ;
        je      .C1E                                    ;

        cmp     al , 0                                  ;
        je      .E                                      ;

        sub     al , 1                                  ;

        cmp     al , 0x41                               ;
        jb      .C1L                                    ;
        jmp     .C1E                                    ;
.C1L:
        add     al , 26                                 ;
.C1E:
        stosb                                           ;

        jmp     .C1                                     ;

;2つずらす
.C2:
        mov     al , [di]                               ;

        cmp     al , 0xA                                ;
        je      .C2E

        cmp     al , 0x0D                               ;
        je      .C2E                                    ;

        cmp     al , 0                                  ;
        je      .E                                      ;

        sub     al , 2                                  ;

        cmp     al , 0x41                               ;
        jb      .C2L                                    ;
        jmp     .C2E                                    ;
.C2L:
        add     al , 26                                 ;
.C2E:
        stosb                                           ;

        jmp     .C2                                     ;

;三つずらす
.C3:
        mov     al , [di]                               ;

        cmp     al , 0xA                                ;
        je      .C3E

        cmp     al , 0x0D                               ;
        je      .C3E                                    ;

        cmp     al , 0                                  ;
        je      .E                                      ;

        sub     al , 3                                  ;

        cmp     al , 0x41                               ;
        jb      .C3L                                    ;
        jmp     .C3E                                    ;
.C3L:
        add     al , 26                                 ;
.C3E:
        stosb                                           ;

        jmp     .C3                                     ;

;四つずらす
.C4:
        mov     al , [di]                               ;

        cmp     al , 0xA                                ;
        je      .C4E

        cmp     al , 0x0D                               ;
        je      .C4E                                    ;

        cmp     al , 0                                  ;
        je      .E                                      ;

        sub     al , 4                                  ;

        cmp     al , 0x41                               ;
        jb      .C4L                                    ;
        jmp     .C4E                                    ;
.C4L:
        add     al , 26                                 ;
.C4E:
        stosb                                           ;

        jmp     .C4                                     ;

;五つずらす
.C5:
        mov     al , [di]                               ;

        cmp     al , 0xA                                ;
        je      .C5E

        cmp     al , 0x0D                               ;
        je      .C5E                                    ;

        cmp     al , 0                                  ;
        je      .E                                      ;

        sub     al , 5                                  ;

        cmp     al , 0x41                               ;
        jb      .C5L                                    ;
        jmp     .C5E                                    ;
.C5L:
        add     al , 26                                 ;
.C5E:
        stosb                                           ;

        jmp     .C5                                     ;


.E:     popf                                            ;
        pop     di                                      ;
        pop     cx                                      ;
        pop     bx                                      ;

        mov     sp , bp                                 ;
        pop     bp                                      ;

        ret                                             ;

;(関数の概要(シーザー式暗号の関数です)作成中です)
; 0. ひとまず保留中
