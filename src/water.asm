; Water effect for the RST
; 29 january 2012
; Krusty/Benediction
; Come from CC4


; NOT USED => DO NOT WORK PROPERLY

;;; 
;;; Effectue le calcul de la prochaine etape du eau


 ; HL = source buffer
 ; DE = current buffer
 ; BC = temporary things
 macro WATER_COMPUTE_ONE_BYTE
    ;; Somme des valeurs
    DEC H
    LD  A, (HL)     ; pixel(x,y-1)

    inc h
    DEC L
    ADD A, (HL)     ; pixel(x-1,y)

    INC L
    INC L
    ADD A, (HL)     ; pixel(x+1,y)
    DEC L

    INC H
    ADD A, (HL)     ; pixel(x,y+1)
    dec H

    inc l ; move for next one
    
    ;; /2
    SRL A       ; 

    ex de, hl
    sbc (hl); - Buffer2(x,y)
    inc l ; move for next one
    ex de, hl



        ;; Verification
    BIT 7, A
    JR  Z, 1f
    XOR A
    JR  3f
    ;; suppression 1 etape
1
    LD  B,A
    SRL A
    SRL A
    SRL A
    AND 00011111b
    LD  C,A
    LD  A,B
    SUB C
    JR  NC,2f
    XOR A
2
3   


 endm

 ;; Output one word of water (read in one and write in the other)
 macro WATER_OUTPUT_ONE_WORD

    WATER_COMPUTE_ONE_BYTE

    exx
    ; Get the division by 4 and reduction by one or two
    ld h, a
    exx

    WATER_COMPUTE_ONE_BYTE

    exx
    ld l, a
    push hl
    exx

 endm

 macro WATER_OUTPUT_ONE_LINE
    dup (CHUNKY_DISPLAY_WIDTH-1)/2
        WATER_OUTPUT_ONE_WORD
    edup
 endm



; Fill the buffer of the water effect
; Buffers must be swaped
water_fill_buffer
    call eau_insere_goutte
    ld (.backup_sp+1), sp


    ; Select the working buffers
    ; and exchange them for later
.de_val_exchange
    ld de, CHUNKY_ARRAY_1 +  CHUNKY_DISPLAY_WIDTH ; + 256 later
.hl_val_exchange
    ld hl, CHUNKY_ARRAY_2 +  CHUNKY_DISPLAY_WIDTH ; + 256 later
    ld (.hl_val_exchange+1), de
    ld (.de_val_exchange+1), hl
    ld (display_chunk_array_to_screen.chosen_buffer), de

    ; Store them for later
    ld (.de_val+1), de
    ld (.hl_val+1), hl


    ; Filling loop
    ld a, CHUNKY_DISPLAY_HEIGHT - 2
.loop
    ex af, af'

    di


    ; Get previous line address and move to next one
.de_val ld de, 0
.hl_val ld hl, 0
    inc d
    inc h
    ld (.de_val+1), de
    ld (.hl_val+1), hl
    ex hl, de
    ld sp, hl
    ex hl, de


    ; Compute on line of water
    WATER_OUTPUT_ONE_LINE

    ld SP, FALSE_STACK
    ei

    ex af, af'
    dec a
    jp nz, .loop

.backup_sp
    ld sp, 0
    ret


eau_insere_goutte
    LD  A,1
    DEC A
    LD  (eau_insere_goutte+1), A
    RET NZ

    LD  A,3
    LD  (eau_insere_goutte+1), A
    
    LD  B, 4
    
    ld hl, CHUNKY_ARRAY_1
    CALL    RandomNumber
    AND 00011111b
    ADD A, H
    ADD A, B
    LD  H, A

    CALL    RandomNumber
    AND 00011111b
    ADD A, L
    ADD A, B
    LD  L, A

    CALL    RandomNumber
    AND 00111111b

    
    LD  (HL),A
    INC L
    LD  (HL), A
    DEC L
    DEC L
    LD  (HL), A
    INC L
    DEC H
    LD  (HL), A
    INC H
    INC H
    LD  (HL), A
    
    
    RET
    ;;
    
    
RandomNumber
    ld a, r
    ret
