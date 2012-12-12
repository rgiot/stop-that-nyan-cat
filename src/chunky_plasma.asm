/**
 * Chunky plasma
 */


PLASMA_WIDTH equ CHUNKY_DISPLAY_WIDTH
PLASMA_HEIGHT equ CHUNKY_DISPLAY_HEIGHT

 
  /**
   * Output one word value for the plasma
   * SP = buffer
   * A = plasma value at this moment
   */
  macro PLASMA_OUTPUT_ONE_WORD
    ; Get first value
    ld d, a
    ld e, a ; patch in inc a, nop or dec a

    ; Get second value
    ld e, a
    ld e, a ; patch in inc a, nop or dec a

    ; output value on screen
    push de
  endm

  /**
   * Output one line of plasma in the chunky buffer
   */
  macro PLASMA_OUTPUT_ONE_LINE
    dup PLASMA_WIDTH/2
        PLASMA_OUTPUT_ONE_WORD
    edup
  endm

/**
 * This function is called by the demos system
 * before each refresh on screen
 */
plasma_manage_new_step

    call plasma_patch_code
    call plasma_fill_buffer


    if PLASMA_ONLY
        ret
    endif

patching_count
    ld a, 0
    inc a
    and %1111111
    ld (patching_count+1), a
    ret nz


patching_table_position
    ld hl, plasma_patching_table

    ld de, plasma_patching_table_end
    or a
    sub hl, de
    ld a, h
    or l
    jr nz, .next

.this_is_the_end
    ld a, 255
    ld (patching_count+1), a

.but_we_wait_a_bit
    ld a, 0
    inc a
    and %11
    ld (.but_we_wait_a_bit+1), a
    ret nz
    ASK_COLOR_CHANGE

.and_leave_after_a_while
    ld a, 14
    dec a
    ld (.and_leave_after_a_while+1), a
    ret nz

    ; {{{ Select to display bump mapping
    ld hl, bump_manage_new_step
    ;ld de, BUMP_COLORS_1
    ;ld (inter.screen_color+1), de
    ld (demo_loop.effect+1), hl

    ; BUG
    ; TODO remove that
    ld hl, display_chunk_array_to_screen.chosen_buffer
    dec (hl)
    ASK_COLOR_CHANGE
    ret
    ;}}}
    
.next
    ld hl, (patching_table_position+1)
    ld de, plasma_fill_buffer.plasma_patch_start
    ld bc,  plasma_fill_buffer.plasma_patch_end - plasma_fill_buffer.plasma_patch_start
    ldir
    ld de, plasma_patch_code.movt_start
    ld bc,  plasma_patch_code.movt_end - plasma_patch_code.movt_start
    ldir
;    ld de, inter.screen_color+1
; .2 ldi
    ld (patching_table_position+1), hl


    
    ASK_COLOR_CHANGE
    ret

; Patching table for changing the curves
plasma_patching_table
.first
 .3 inc l  ;vertical
 .1 inc e
 .3  inc l ; horizontal
 .2  dec e
 ;dw PLASMA_COLORS_2
.first_end
    assert .first_end - .first == (plasma_fill_buffer.plasma_patch_end - plasma_fill_buffer.plasma_patch_start) + (plasma_patch_code.movt_end - plasma_patch_code.movt_start); + 2

.second
 .1 inc l  ; vertical
 .3 dec e
 .5  dec l ; horizontal
; .3  inc e
 ; dw PLASMA_COLORS_3
.second_end
    assert .second_end - .second == plasma_fill_buffer.plasma_patch_end - plasma_fill_buffer.plasma_patch_start + (plasma_patch_code.movt_end - plasma_patch_code.movt_start); + 2

.third
 .3 inc l  ; vertical
 .1 inc e
 .3  dec l ; horizontal
 .2  dec e
 ; dw PLASMA_COLORS_4
.third_end
    assert .third_end - .third == plasma_fill_buffer.plasma_patch_end - plasma_fill_buffer.plasma_patch_start + (plasma_patch_code.movt_end - plasma_patch_code.movt_start) ; + 2
plasma_patching_table_end

/**
 * Fill plasma in the buffer
 */
plasma_fill_buffer
    ld (.backup_sp+1), sp
    ld hl, CHUNKY_ARRAY_1 +  CHUNKY_DISPLAY_WIDTH

; Address of curve for vertical movement
    exx
    ld hl, (PLASMA_CURVE1Y_ADDRESS)
    ld de, (PLASMA_CURVE2Y_ADDRESS)
    exx

    ; Filling loop
    ld b, PLASMA_HEIGHT
.loop
;.old_first_value equ $+1
;    ld a, 0    

    ; Modify the value at each line
    exx
    ld a, (de)
    add a, (hl)
;
.plasma_patch_start
 .1 dec l
 .3   inc e
.plasma_patch_end
    exx

    ; Store the value for the next loop
 ;   ld (.old_first_value), a

    di
    ld sp, hl       ; Use stack to store information
    inc h           ; Move to next line for next loop

.code_to_patch
    PLASMA_OUTPUT_ONE_LINE
    ld SP, FALSE_STACK
    ei
    dec b
    jp nz, .loop

.backup_sp
    ld sp, 0
    ret


/**
 * Patch the code according to the curve
 */
plasma_patch_code

    ; Get curves addresses and move them
    ; for next step
    exx
    ld hl, (PLASMA_CURVE1Y_ADDRESS)
    ld de, (PLASMA_CURVE2Y_ADDRESS)
.movt_start
  .3  inc l ; mvt
  .2  dec e
.movt_end
    ld (PLASMA_CURVE1Y_ADDRESS), hl
    ld (PLASMA_CURVE2Y_ADDRESS), de
    exx

    ; Beginning of the address to patch
    ld hl, plasma_fill_buffer.code_to_patch + 1
    ld bc, LOOKUP_DELTA_OPCODE

    ld a, 0
    ld d, a
    ld e, a
    dup PLASMA_WIDTH/2
        ; (Code is almost duplicated for the two bytes)

        dup 2 ; for the two bytes
        ; Get next value
        exx
        ld a, (de)
        add (hl)

        ; think to change the other one too
        ;sra a
     .1   inc e
     .3   dec l
        exx

        ; store it for next time
        ld e, a
        sub d
        ld d, e
        
        ld c, a

        ld a, (bc)
        ld (hl), a
    .2  inc hl
        edup

        inc hl

    edup

    ret


/**
 * Store the addresses of the plasma curves
 */
PLASMA_CURVE1X_ADDRESS dw PLASMA_CURVE1
PLASMA_CURVE2X_ADDRESS dw PLASMA_CURVE2
PLASMA_CURVE1Y_ADDRESS dw PLASMA_CURVE1
PLASMA_CURVE2Y_ADDRESS dw PLASMA_CURVE2




