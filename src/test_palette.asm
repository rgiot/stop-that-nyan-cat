/**
 * Test file to see if everything is ok
 */

test_manage_effect
.actual_color
    ld a, 0

    ld hl,CHUNKY_ARRAY_1 
    call test_fill

    inc a
    ld (.actual_color+1), a
    ret


fill_line
    ld de, hl
    inc de
    ld bc, CHUNKY_DISPLAY_WIDTH-1
    ld (hl), a
    ldir
    ret

test_fill
    ld b, CHUNKY_DISPLAY_HEIGHT
fill_loop
    push bc
    push hl
    call fill_line
    pop hl
    inc h
    pop bc
    djnz fill_loop
    ret

