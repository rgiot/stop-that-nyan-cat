/**
 * Displaying of chunky graphics
 * Krusty/Benediction 01/01/2012
 */


; Width and height of the displaying window
CHUNKY_DISPLAY_WIDTH equ 52
CHUNKY_DISPLAY_HEIGHT equ 38

; Verify if a windows takes no more than 16kb
; (we can put several windows per bank)
 assert CHUNKY_DISPLAY_HEIGHT*256 <= 16*1024
 assert CHUNKY_DISPLAY_WIDTH%2 == 0
 assert CHUNKY_DISPLAY_HEIGHT%2 == 0
 assert CHUNKY_DISPLAY_HEIGHT*2*2 <= 256

/**
 * Macro for displaying two bytes of chunky gfx.
 * We display blocks of two lines at the same time.
 * 
 * Registers signification:
 *
 *  - SP is in one line.
 *  - DE is in another line
 *  - BC is in the color array
 *  - HL is in the chunky array bytes to read
 *
 * parameters:
 * 
 *  - double_value : do we need to double the value (or is it already done)
 */
 macro DISPLAY_TWO_BYTES_FROM_CHUNKY_ARRAY double_value

    
    ; {{{ Byte 1
    ; Obtain the color value
    if double_value
        ld a, (hl) : inc l
        add a
        ld c, a
    else
        ld c, (hl) : inc l
    endif


    ; Read the bytes of this color
    ; and store them in the right registers
    ld a, (bc) : inc c      ; Get color 1 byte 2
    exx                     ; Store it for futur display
    ld d, a
    exx

    ld a, (bc)              ; Get color 1 byte 2
    ld (de), a              ; Display it
    dec e                  ; Move to next pointer 
    ;}}}

    ;{{{Byte 2
    ; Obtain the color value
    if double_value
        ld a, (hl) : inc l
        add a
        ld c, a
    else
        ld c, (hl) : inc l
    endif


    ; Read the bytes of this color
    ; and store them in the right registers
    ld a, (bc) : inc c      ; Get color 1 byte 2
    exx                     ; Store it for futur display
    ld e, a
    push de                 ; Display it
    exx

    ld a, (bc)              ; Get color 1 byte 2
    ld (de), a              ; Display it 
    dec e                  ; Move to next pointer
    ;}}}

    
 endm


/**
 * Macro for displaying one row of chunky gfx.
 * 
 * Registers signification:
 *
 *  - SP is in one line.
 *  - DE is in another line
 *  - BC is in the color array
 *  - HL is in the chunky array bytes to read
 *
 * parameters:
 * 
 *  - double_value : do we need to double the value (or is it already done)
 */
 macro DISPLAY_ONE_ROW_FROM_CHUNKY_ARRAY double_value
    dup CHUNKY_DISPLAY_WIDTH/2
        DISPLAY_TWO_BYTES_FROM_CHUNKY_ARRAY double_value
    edup
 endm

/**
 * Get the right screen address table in IX
 * -two table alternate together)
 */
display_get_screen
    ld a, 0
    inc a
    ld (display_get_screen+1), a

    and 1
    jr z, .second
.first
    ld ix, SCREEN1_ADDRESSES
    ret
.second
    ld ix, SCREEN2_ADDRESSES
    ret

/**
 * Display the whomle chunky array to screen
 */
display_chunk_array_to_screen
    ; backup the stack
    ld (.backup_stack+1), sp    

    ; Buffer to display on screen
.chosen_buffer equ $ +1
    ld hl, CHUNKY_ARRAY_1
    dec h
    ld (.chunky_array_address), hl

    call display_get_screen

; Address of the color palette to use
.color_palette_array equ $+1
    ld bc, CHUNKY_PALETTE_1

 ; Display of all the blocs
; dup CHUNKY_DISPLAY_HEIGHT
    ex af, af'
    ld a, CHUNKY_DISPLAY_HEIGHT
.loop
    ex af, af'
    ; TODO set the buffer address
    di
    ; Get displaying address 1
    ld l, (ix+0)
    ld h, (ix+1)
    inc ixl : inc ixl
    ld sp, hl

    ; Get displaying address 2
    ld e, (ix+0)
    ld d, (ix+1)
    dec de
    inc ixl : inc ixl

    ; Address of the buffer to read
    ; updated each time
.chunky_array_address equ $+1
    ld hl, 00
    inc h
    ld (.chunky_array_address), hl

    DISPLAY_ONE_ROW_FROM_CHUNKY_ARRAY 1
    ld sp, FALSE_STACK  ; retreive stack
    ei                  ; allow interuption if necessary

    ex af,af'
    dec a
    jp nz, .loop
; edup

.backup_stack
    ld sp, 0x0000
    ret



