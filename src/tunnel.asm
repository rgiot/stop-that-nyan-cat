; File: tunnel.asm
; Author: Romain Giot
; Description: Tunnel effect for revision contest
;
; Two tables are used
; It will be good to produce them from BASIC or ASM in order to compile...
 
 
; Output a byte of the tunnel
; DE = interlevred tinnel table
; HL = second table
; BC = texture
 MACRO TUNNEL_OUTPUT_BYTE first_byte
    LD  A, (de)     ; Recupération valeur X
    INC e         ; octet pair vers impaire, inc hl inutile
    add b
    
;    bit 7, a
;    jr z, 1f
;    neg
;1f
    ;LD  l, A
    ;LD  a, (hl) : 
    ld c, a ; position x light


    LD  A, (de)   ; Recuperation valeur y
    inc de

    ;; normalisation et multiplication
;    DEC h
    ;LD  l, A
    ;LD  A, (hl)
;    INC h
    
    and 15
    rla
    rla
    rla
    rla
    
    ;; position horizontale
    ADD c



    ;; Stockage
    exx
    ;; Recuperation de numero reel de la lumiere
    LD  l, A

    if first_byte
        ld d, (hl)
    else
        ld e, (hl)
        push de
    endif

    exx

 ENDM
;

    

;; Display the tunnel on screen
;; Code is highly similar to the bump code
manage_tunnel
 ld a, 0
 dec a
 ld (manage_tunnel+1), a
; jr nz, .go
;
;
;
;    ld hl, plasma_manage_new_step
;    ld (demo_loop.effect+1), hl
;    ASK_COLOR_CHANGE
;    ret

.go

 and %11111
 jr nz, .go2
 ASK_COLOR_CHANGE
.go2
    ld (tunnel_backup_sp), sp

    
;  Initialisation of various registers
; hl = division table
; de = bump mapping table
; BC = light position
; de' = light table
; HL' = word to output
    LD  hl, table_div_and_check   ; table_div_and_check_and_mul16 ; Multiplication par 16
back
    ld bc,0
    inc b
    ld (back+1), bc

tunnel_calcul_image_adr
    LD  de, TUNNEL_DATA
    
    EXX
    ld de, CHUNKY_ARRAY_1 + CHUNKY_DISPLAY_WIDTH  ; chunky buffer to use
    ;dec d
    ld (tunnel_chunky_buffer_line_address), de


    LD  h, bump_light/256 
    EXX
;



    ; Loop for each line
    EX  AF, AF' 
    LD  A, bump_hauteur/2+1
tunnel_calcul_by
    EX  AF, AF'


    EXX

    ;
    ;  Get and move of one line in output buffer
    ; TODO use the stack here
tunnel_chunky_buffer_line_address equ $ +1
    ld de, CHUNKY_ARRAY_1 + CHUNKY_DISPLAY_WIDTH ; move of one line each time
    di
    ld sp, (tunnel_chunky_buffer_line_address)
    inc d
    ld (tunnel_chunky_buffer_line_address), de
    ; 
    EXX
    
    
 dup (CHUNKY_DISPLAY_WIDTH/2)
    TUNNEL_OUTPUT_BYTE 0
    TUNNEL_OUTPUT_BYTE 1
 edup
    exx
    push de
    exx
    ld sp, FALSE_STACK
    ei

    EX  AF, AF'
    DEC A
    JP  NZ, tunnel_calcul_by
    EX  AF, AF'

tunnel_backup_sp equ $+1
    ld sp, 0

    ; Tunnel mirroring
    ld a, bump_hauteur - (bump_hauteur/2+1) +1 + 1
    ld hl, CHUNKY_ARRAY_1  + (bump_hauteur/2)*256 - 1
    ld de, hl
tunnel_mirror
    push hl
    push de
    ld bc, bump_largeur
    ldir
    pop de
    pop hl
    dec h
    inc d
    dec a
    jp nz, tunnel_mirror

    RET

