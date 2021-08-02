;puts(str)
puts:
        push    bp                                      ;
        mov     bp , sp                                 ;

        push    ax                                      ;
        push    bx                                      ;

        mov     si , [bp + 4]                           ;
        mov     ah , 0x0E                               ;
        mov     bx , 0x0000                             ;
        cld                                             ;
.10E:
        lodsb                                           ;

        cmp     al , 0                                  ;

        int     0x10                                    ;

        jnz     .10E                                    ;

        pop     bx                                      ;
        pop     ax                                      ;

        mov     sp , bp                                 ;
        pop     bp                                      ;

        ret                                             ;
