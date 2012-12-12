; TODO use same values than other effects
bump_hauteur    EQU 38
bump_largeur    EQU 52
bump_largeur_source equ 52




;}}}



bump_derive_x
    ld a, bump_hauteur
    ld (.ix+2), ix
    ld (.iy+2), iy


.loop_x
.ix    ld ix, bump_image_fake + bump_largeur_source
.iy    ld iy, bump_image_fake + bump_largeur_source + 2
    push af

    dup bump_largeur_source
        ld a,(iy+0)
        sub (ix+0)
        neg 
        ld (de), a

     .2 inc de
        inc ix
        inc iy
    edup


    if bump_largeur_source != bump_largeur
        dup bump_largeur_source
            .2 inc de
        edup
    endif


    ld hl, (.ix+2) : 
    if bump_largeur_source != bump_largeur
        ld bc, bump_largeur_source + 2 -1
    else
        ld bc, bump_largeur_source + 2
    endif
    add hl, bc : ld (.ix+2), hl
    inc hl : inc hl : ld (.iy+2), hl
    
    pop af
    dec a
    jp nz, .loop_x

    ret


; {{{ Produce one byte for the bump mapping
 macro BUMP_OUTPUT_BYTE first_byte
    LD  A, (de)     ; Recupération valeur X
    INC e         ; octet pair vers impaire, inc hl inutile
    
                ; Gestion par rapport a la lumiere
    ADD B       ; + posX lumiere
    dec B       ; move light
    

    LD  l, A
    LD  a, (hl) : ld ixl, a ; position x light


    LD  A, (de)   ; Recuperation valeur y
    inc de

                ; Gestion par rapport a la lumiere
    ADD C       ;  +posY lumiere
    

    ;; normalisation et multiplication
    DEC h
    LD  l, A
    LD  A, (hl)
    INC h
    
    
    ;; position horizontale
    ADD ixl



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

    
    endm
;}}}


;bump_selected_new_time
;    ld hl, bump_manage_new_step
;    ld (demo_loop.effect+1), hl
 ;   ret

;;;
;;; {{{ Calcul des valeurs du bump
;;; In this version, everything is stored in the buffer
;;; TODO, suppression de l'operation d'ajout de position de la lumiere systematqiue (a mettre dans l'init de DE)
bump_calcul
bump_manage_new_step
    ; {{{ Change color if required
.tempo_color 
    ld a, %111111 - 2
    inc a
    and %111111
    ld (.tempo_color+1), a
    jr nz, .go
.start_patch
    ASK_COLOR_CHANGE
.end_patch
    ;}}}}

.nb_times
    ld a, 5
    dec a
    ld (.nb_times+1), a
    jp nz, .go


.this_is_the_end
    ld a, 1
    ld (.nb_times+1), a
    ld a, 255
    ld (.tempo_color+1), a
    ld hl, .start_patch
    ld de, hl
    inc de
    ld (hl), 0
 dup .end_patch - .start_patch -1
    ldi
 edup
.but_we_wait_a_bit
    ld a, 0
    inc a
    and %1
    ld (.but_we_wait_a_bit+1), a
    jp nz, .go
    ASK_COLOR_CHANGE

.and_leave_after_a_while
    ld a, 14
    dec a
    ld (.and_leave_after_a_while+1), a
    jp nz, .go



    ld hl, manage_tunnel
    ld (demo_loop.effect+1), hl

.go
    ld (bump_backup_sp), sp

; {{{ X movement of the light
bump_calcul_x
    LD  HL, sintab1
    LD  A, (HL)
   .6 dec L
    LD  (bump_calcul_x+1), HL
bump_calcul_x2
    LD  HL, sintab1 + 69
  .5  LD  (bump_calcul_x2+1), HL
    ADD (HL)
    ADD 20
    LD  (bump_calcul_pos_lumx + 1), A
; }}}

; {{{ Y movement of the light
bump_calcul_y
    LD  HL, sintab1+61
    LD  A, (HL)
 .4 dec l
    LD  (bump_calcul_y+1), HL
bump_calcul_y2
    LD  HL, sintab1 + 27
 .5 inc l
    LD  (bump_calcul_y2+1), HL
    ADD (HL)
   ADD 20
    LD  (bump_calcul_pos_lumy + 1), A
;}}}
    
    
; {{{ Initialisation of various registers
; hl = division table
; de = bump mapping table
; BC = light position
; de' = light table
; HL' = word to output
    LD  hl, table_div_and_check   ; table_div_and_check_and_mul16 ; Multiplication par 16
bump_calcul_image_adr
    LD  d, bump_image/256
    ld  e,0
    
bump_calcul_pos_lumx
    LD  B, 10       ; position X de la lumiere
bump_calcul_pos_lumy
    LD  C, 10       ; position Y de la lumiere
    
    EXX
    ld de, CHUNKY_ARRAY_1 + CHUNKY_DISPLAY_WIDTH ; chunky buffer to use
    ;dec d
    ld (bump_chunky_buffer_line_address), de


    LD  h, bump_light/256 
    EXX
;}}}



    ; Loop for each line
    EX  AF, AF' 
    LD  A, bump_hauteur
bump_calcul_by
    EX  AF, AF'


    ; {{{ backup light position
    ld (bump_backup_light), bc
    EXX

    ;}}}
    ; {{{ Get and move of one line in output buffer
    ; TODO use the stack here
bump_chunky_buffer_line_address equ $ +1
    ld de, CHUNKY_ARRAY_1 + CHUNKY_DISPLAY_WIDTH ; move of one line each time
    di
    ld sp, (bump_chunky_buffer_line_address)
    inc d
    ld (bump_chunky_buffer_line_address), de
    ; }}}
    EXX
    
    
bump_calcul_bx

    BUMP_OUTPUT_BYTE 0
    BUMP_OUTPUT_BYTE 1


bump_calcul_bx_end
    DEFS    (bump_calcul_bx_end - bump_calcul_bx)*(bump_largeur/2 - 1)
    ld sp, FALSE_STACK
    ei

    ;; Decalage de Y et x
bump_backup_light equ $+1
    ld bc, 0
    inc c
    
    EX  AF, AF'
    DEC A
    JP  NZ, bump_calcul_by
    EX  AF, AF'


bump_backup_sp equ $+1
    ld sp, 0
    RET
; }}}

; => 102280 nops sans pile
; => 102361 avec la pile ...
; =>  98322 apres optimisation


;;

MAX_VALUE       EQU 32



