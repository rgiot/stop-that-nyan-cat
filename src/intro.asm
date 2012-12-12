;; Introduction file

;; TODO display border
SPRITE_WIDTH equ 3
SPRITE_HEIGHT equ 5

    ; {{{ Randomly move the text of some bytes
    macro MOVE_TEXT start
.TMP=$+1
        ld a, start
        inc a
        ld (.TMP), a
        cp 7
        jr nz, 1f
        xor a
        ld (.TMP), a

        ld a, r
        ld c, a
        and %11
        add e
        ld e, a

        ld a, c
        rra
        and %11
        add d
        ld d, a
1
    endm
    ;}}}


introduction_manage_the_introduction




   call fade_fill_buffer


.border_rout
    call introduction_display_border

.wait1 ld a, 1
    or a
    jr z, .go1
    jr .wait2
.go1
    ld de, CHUNKY_ARRAY_1  + 2 + 256 + 256
    MOVE_TEXT 0
    ld hl, SPRITE_F
    call introduction_display_font

    ld hl, SPRITE_A
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_C
   .3 dec e
    call introduction_display_font

    ld hl, SPRITE_T
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_O
   .3 dec e
    call introduction_display_font

    ld hl, SPRITE_R
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_6
   .3 dec e
    call introduction_display_font


.wait2 ld a, 1
    or a
    jr z, .go2
    jr .wait3
.go2


  ld de, CHUNKY_ARRAY_1  + 43 + 256*10
    MOVE_TEXT 2
    ld hl, SPRITE_V
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_O
   .3 dec e
    call introduction_display_font

    ld hl, SPRITE_X
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_Y
   .3 dec e
    call introduction_display_font
.wait3 ld a, 1
    or a
    jr z, .go3
    ret
.go3


 ld de, CHUNKY_ARRAY_1  + 23 + 256*4
    MOVE_TEXT 1
    ld hl, SPRITE_K
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_R
   .3 dec e
    call introduction_display_font

    ld hl, SPRITE_U
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_S
   .3 dec e
    call introduction_display_font

    ld hl, SPRITE_T
   .3 inc e
    call introduction_display_font

    ld hl, SPRITE_Y
   .3 dec e
    call introduction_display_font

    ret


BORDER_BYTE_VALUE = 255
introduction_display_border
    call introduction_display_border_up
    ret

introduction_display_border_up
    ld de, 9
    inc e

    ld a, 64
    cp e
    jp z, introduction_display_border_up_end
    
    
    ld (introduction_display_border_up+1), de
    ld (introduction_display_border_down+1), de

    ld hl, 0xc000 + 0x800*4
    add hl, de



    call introduction_display_border_bloc
    ld (introduction_display_border_right+1), hl

 if ENABLE_NYAN_SHIT
    call intro_display_nyan_shit
 endif
    ret

; Select next border routine
introduction_display_border_up_end
    ld hl, introduction_display_border_right
    ld (introduction_manage_the_introduction.border_rout+1), hl
    xor a
    ld (introduction_manage_the_introduction.wait1+1), a
    ld a, 0x44
    ld (TEXT_COLORS+14), a
    ret


introduction_display_border_right
    ld hl, 0xc000 + 9

    call introduction_display_border_bloc
    call bc26

    ld (introduction_display_border_right+1), hl

.loop
    ld a, 39
    dec a
    ld (.loop+1), a
    jp z, introduction_display_border_right_end
    ret

introduction_display_border_right_end
    ld hl, introduction_display_border_down
    ld (introduction_manage_the_introduction.border_rout+1), hl
    ld a, (introduction_display_border_down+1)
    inc a
    ld (introduction_display_border_down+1), a
    xor a
    ld (introduction_manage_the_introduction.wait2+1), a

    ret


introduction_display_border_down
    ld de, 9
    dec e

    ld a, 9
    cp e
    jp z, introduction_display_border_down_end
    
    
    ld (introduction_display_border_down+1), de

    ld hl, 0xc000 + 20*64
    add hl, de



    call introduction_display_border_bloc
    ld (introduction_display_border_right+1), hl
    ret

introduction_display_border_down_end
    ld hl, introduction_display_border_left
    ld (introduction_manage_the_introduction.border_rout+1), hl
    xor a
    ld (introduction_manage_the_introduction.wait3+1), a

    ret

introduction_display_border_left
    ld hl, 0xc000 + 20*64 + 10
    push hl
    call introduction_display_border_bloc
    pop hl

 .4 call bc29
    ld (introduction_display_border_left+1), hl

.count
    ld a, 40
    dec a
    ld (.count+1), a
    jr z, introduction_display_border_left_end
    ret


introduction_display_border_left_end
    if INTRO_ONLY
        ret
    endif

    ld hl, introduction_do_nothing
    ld (introduction_manage_the_introduction.border_rout+1), hl
    ret


introduction_do_nothing
    ; Remove name 1
    ld a, 255
    ld (introduction_manage_the_introduction.wait1+1), a


    ; Remove name 2
.wait1
    ld a, 5
    or a
    jr z, .wait1_end
    dec a
    ld (.wait1+1), a

.wait1_end
    ld a, 255
    ld (introduction_manage_the_introduction.wait2+1), a


    ; Remove name 3
.wait2
    ld a, 5
    or a
    jr z, .wait2_end
    dec a
    ld (.wait2+1), a
.wait2_end
    ld a, 255
    ld (introduction_manage_the_introduction.wait3+1), a



.waiting_loop
    ld a, 35 + 5  + 5
    dec a
    ld (.waiting_loop+1), a

    ret nz

    ;ld hl, plasma_manage_new_step
    ld hl, plasma_manage_new_step
    ld (demo_loop.effect+1), hl
    ASK_COLOR_CHANGE

    ret


introduction_display_border_bloc

    ld (hl), BORDER_BYTE_VALUE
    call bc26
    ld (hl), BORDER_BYTE_VALUE
    call bc26
    ld (hl), BORDER_BYTE_VALUE
    call bc26
    ld (hl), BORDER_BYTE_VALUE

    ret


   macro FONT_DISPLAY_LINE_BYTE
            ld a, (hl)
            or a
            jp z, 1f
            ld (de), a
1
            inc e
            inc hl

         ld a, (hl)
            or a
            jp z, 1f
            ld (de), a
1
            inc e
            inc hl

         ld a, (hl)
            or a
            jp z, 1f
            ld (de), a
1
            inc e
            inc hl

   endm


  macro FONT_DISPLAY_LINE_BIT
    ld a, (de)
    inc de

    rra
    jr nc, 1f
    ld (hl), b
1
    inc l

    rra
    jr nc, 1f
    ld (hl), b
1
    inc l
    
    rra
    jr nc, 1f
    ld (hl), b
1
    dec l
    dec l
    inc h
  endm

;;;
; Display a sprite in the chunky buffer
; DE= buffer
; HL= sprite
;
introduction_display_font

  if USE_BIT_CODED_FONT
      push bc
      ld b, C1
      ex de, hl
        FONT_DISPLAY_LINE_BIT
        FONT_DISPLAY_LINE_BIT
        FONT_DISPLAY_LINE_BIT
        FONT_DISPLAY_LINE_BIT
        FONT_DISPLAY_LINE_BIT
        pop bc
    ex de, hl
  else
        push de
        FONT_DISPLAY_LINE_BYTE
        pop de
        inc d
    push de
        FONT_DISPLAY_LINE_BYTE
        pop de
        inc d
    push de
        FONT_DISPLAY_LINE_BYTE
        pop de
        inc d
    push de
        FONT_DISPLAY_LINE_BYTE
        pop de
        inc d
    push de
        FONT_DISPLAY_LINE_BYTE
        pop de
        inc d

  endif
    ret


    ; Build a char {
    macro CHAR p11, p12, p13, p21, p22, p23, p31, p32, p33, p41, p42, p43, p51, p52, p53

        ; Store in bit (one byte per line, maybe better to crunch ?)
    if USE_BIT_CODED_FONT
        db (p13 )*1 + (p12 *2) + (p11  *4  )
        db (p23 )*1 + (p22 *2) + (p21  *4  )
        db (p33 )*1 + (p32 *2) + (p31  *4  )
        db (p43 )*1 + (p42 *2) + (p41  *4 ) 
        db (p53 )*1 + (p52 *2) + (p51  *4)  
    else
        ; Store in bytes
        db p13*C1, p12*C1, p11*C1
        db p23*C1, p22*C1, p21*C1
        db p33*C1, p32*C1, p31*C1
        db p43*C1, p42*C1, p41*C1
        db p53*C1, p52*C1, p51*C1
    endif
    endm
    ;}



    ; Specific code and macros for the nyan cat {{{
    if ENABLE_NYAN_SHIT

    ; display a line of nyancat
    macro DISPLAY_NYAN_CAT_LINE
        ; Two bytes
        dup 2
            ld a, (de)
            inc de

            ; 8 blocks per byte
            dup 8
                rra
                jr nc, 1f
                ld (hl), b
1
                inc l
            edup
        edup

        ; go in the start
  .16    dec l
        inc h  
    endm

    ; Store a byte of nyan cat
    macro OUTPUT_HEIGHT_PIXS p1, p2, p3, p4, p5, p6, p7, p8
      db p1+p2*2+p3*4+p4*8+p5*16+p6*32+p7*64+p8*128
    endm

;;
; Displaying code for the nyan shit
intro_display_nyan_shit
    ;ld a, r
    ;and %11
    ;ret z

    ld de, NYAN_SHIT
    ld hl, CHUNKY_ARRAY_1 + 256*12 + 16
    ld b, C1
    push hl
    dup 10
        DISPLAY_NYAN_CAT_LINE
    edup

    ; joue 1
    ld c, 18
    ld de, 6*256+15
    pop hl
    push hl
    add hl, de
    ld (hl), c
    dec l
    ld (hl), c
    inc h
    ld (hl), c
    inc l
    ld (hl), c


    ; joue 2
    ld c, 10
    ld de, 6*256+2
    pop hl
    push hl
    add hl, de
    ld (hl), c
    dec l
    ld (hl), c
    inc h
    ld (hl), c
    inc l
    ld (hl), c

    ; eye 1
    ld b, 0
    ld c, 20
    ld de, 4*256+4
    pop hl
    push hl
    add hl, de
    ld (hl), b
    dec l
    ld (hl), c
    inc h
    ld (hl), b
    inc l
    ld (hl), b
 
    ; eye 2
    ld de, 4*256+12
    pop hl
    push hl
    add hl, de
    ld (hl), b
    dec l
    ld (hl), c
    inc h
    ld (hl), b
    inc l
    ld (hl), b

    pop hl
    ret

NYAN_SHIT
    OUTPUT_HEIGHT_PIXS 0,1,1,1,0,0,0,0
    OUTPUT_HEIGHT_PIXS 0,0,0,0,1,1,1,0
    OUTPUT_HEIGHT_PIXS 0,1,1,1,1,0,0,0
    OUTPUT_HEIGHT_PIXS 0,0,0,1,1,1,1,0
    OUTPUT_HEIGHT_PIXS 0,1,1,1,1,1,0,0
    OUTPUT_HEIGHT_PIXS 0,0,1,1,1,1,1,0
    OUTPUT_HEIGHT_PIXS 0,1,1,1,1,1,1,1
    OUTPUT_HEIGHT_PIXS 1,1,1,1,1,1,1,0
    OUTPUT_HEIGHT_PIXS 1,1,1,1,0,1,1,1
    OUTPUT_HEIGHT_PIXS 1,1,1,0,1,1,1,1
    OUTPUT_HEIGHT_PIXS 1,1,1,1,1,1,1,1
    OUTPUT_HEIGHT_PIXS 1,0,1,1,1,1,1,1
    OUTPUT_HEIGHT_PIXS 1,1,1,1,1,1,1,1
    OUTPUT_HEIGHT_PIXS 1,1,1,1,1,1,1,1
    OUTPUT_HEIGHT_PIXS 1,1,1,1,1,0,1,1
    OUTPUT_HEIGHT_PIXS 1,0,1,0,1,1,1,1
    OUTPUT_HEIGHT_PIXS 0,1,1,1,1,0,0,0
    OUTPUT_HEIGHT_PIXS 0,0,0,0,1,1,1,0
    OUTPUT_HEIGHT_PIXS 0,0,0,1,1,1,1,1
    OUTPUT_HEIGHT_PIXS 1,1,1,1,1,0,0,0


 endif
    ; }}}

;        1111111111112222222222223333333333334444444444455555555555
SPRITE_F
    CHAR 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0
SPRITE_A
    CHAR 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1
SPRITE_C
    CHAR 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1
SPRITE_T
    CHAR 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1
SPRITE_O
    CHAR 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1
SPRITE_R
    CHAR 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1
SPRITE_6
    CHAR 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1
SPRITE_K
    CHAR 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1
SPRITE_X
    CHAR 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1
SPRITE_S
    CHAR 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0
SPRITE_U
    CHAR 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1
SPRITE_Y
    CHAR 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0
SPRITE_V
    CHAR 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1


