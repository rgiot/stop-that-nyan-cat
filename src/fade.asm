; Fade coding
;
; X = current point
; . = do nothing
; o = use it
;
; ...x...  <- de
; ..oo...  <- hl
; .o.....  <- bc


 macro FADE_OUTPUT_ONE_WORD

    ; Compute the sum 1
    ld a, (bc)
    add ixl
    add (hl)
    dec l
    add (hl)
    ex de, hl
    add (hl)

    exx
    ; Get the division by 4 and reduction by one or two
    ld l, a
    ld d, (hl)
    exx

    ; move to next byte
    dec c
    dec l ;(previous e)
    ; no need to inc e ;(previous l)

    ; compute sum 2
    ld a, (bc)
    add ixl
    add (hl)
    ex de, hl
    add (hl)
    dec l
    add (hl)

    exx
    ld l, a
    ld e, (hl)
    push de
    exx

    dec c
    dec e
    ; no need to inc l


 endm


 macro FADE_OUTPUT_ONE_LINE
    dup CHUNKY_DISPLAY_WIDTH/2
        FADE_OUTPUT_ONE_WORD
    edup
 endm



/**
 * Fill fading in the bufferw
 */
fade_fill_buffer
    ld (.backup_sp+1), sp

    ld hl, table_div_and_check ;fade_div_table
    exx

    ld de, CHUNKY_ARRAY_1 +  CHUNKY_DISPLAY_WIDTH
    dec d       ; everithing is incremented after
    ld hl, de
    inc h
    ld bc, hl
    inc b


    ld (.de_val+1), de
    ld (.hl_val+1), hl
    ld (.bc_val+1), bc


    ; Filling loop
    ld a, CHUNKY_DISPLAY_HEIGHT 
.loop
    ex af, af'

    di


.de_val ld de, 0
.hl_val ld hl, 0
.bc_val ld bc, 0
    inc d
    inc h
    inc b
    ld (.de_val+1), de
    ld (.hl_val+1), hl
    ld (.bc_val+1), bc
    ex de, hl : ld sp, hl : ex de, hl


    ld a, r
    and %11
    ld ixl, a
    FADE_OUTPUT_ONE_LINE
    ld SP, FALSE_STACK
    ei

    ex af, af'
    dec a
    jp nz, .loop

    di
    ld sp, (.de_val +1)
    ld de, 0
    dup CHUNKY_DISPLAY_WIDTH/2 + 1
        push de
    edup

    ld hl, (.de_val +1)
    inc h
    ld sp, hl
    ld de, 0
    dup CHUNKY_DISPLAY_WIDTH/2 + 1
        push de
    edup

    ld hl, (.de_val +1)
    inc h
    inc h
    ld sp, hl
    ld de, 0
    dup CHUNKY_DISPLAY_WIDTH/2 + 1
        push de
    edup

.backup_sp
    ld sp, 0
    ret

