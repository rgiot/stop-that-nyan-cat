    output test_chunky.o

; Parameters to test crunching ratio {

; If set to 1, do not automatically build the shades
USE_PRECOMPUTED_SHADES  equ 1
; If set to 1, do not build the sines
USE_PRECOMPUTED_SINES   equ 1
; If set to 1, font is store in bit and not bytes
USE_BIT_CODED_FONT      equ 1
ENABLE_NYAN_SHIT        equ 1

; Set to 1 to use Grim player
AZ_MUSIC        equ 1

INTRO_ONLY      equ 0
PLASMA_ONLY     equ 0
;}

; Set to 1 to not display intro
DO_NOT_DISPLAY_INTRO equ 0

TEXT_DURATION equ 50*19 + 30
PLASMA_DURATION_1 equ 50*7 - 30
PLASMA_DURATION_2 equ 50*7
PLASMA_DURATION_3 equ 50*7
PLASMA_DURATION_4 equ 50*7
BUMP_DURATION_1 equ 50*15
BUMP_DURATION_2 equ 50*15
C0 equ 0
C1 equ 52


 macro ASK_COLOR_CHANGE
    xor a
    ld (inter.change_color_wait+1), a
 endm


  if 1 = AZ_MUSIC
    include data/music_az/azp.macros.asm
  endif
;;
; We try to use the same curves each time

    org 0x200

; {{{ Init
/**
 * Initialise the demo system
 */
init_demosystem

   ; Do things with system
    xor a : call 0xbc0e
    di
  
;;{{{ Sinus table
  if USE_PRECOMPUTED_SINES
    ; Copy paste the sins
     ld hl, eau_sin
     ld de, sintab1
     ld bc, 256
     ldir
 else
    ; Compute the sinus curves with the system

                    ; SinGen - Parabolic approximation, bitch
_slut               EQU &c000

_slut_h = _slut/256
_slut_q3= _slut_h+2
_slut_q4= _slut_h+3

                xor a
                ld h, 0
                ld d, 0
                ld bc, _slut_q3*256 + _slut_q4
                ld l,a
                ld e,l
                exx
                ld b,a ; 256
                ld d,b
_slut_loop      
                ld c,b
                dec b
                ld e,b
                ld h,d
                ld l,d
_slut_square    add hl,de
                djnz _slut_square
                ld a,h
                exx
                rra
                ld d,b
                ld h,c
                dec l
                ld (de),a ; 3rd Quad
                ld (hl),a ; 4th Quad
                cpl
                res 1,d
                res 1,h 
                ld (de),a ; 1st Quad
                ld (hl),a ; 2nd Quad    
                inc e
                exx
                ld b,c
                djnz _slut_loop


    ld de, sintab1
    ld hl, 0xc000
    ld b, 0
.loopsin
        ld a, (hl)
        sra a
        add 127
        sra a
        ld (de), a
        inc e
     .4 inc hl
     djnz .loopsin
 endif

; }}}
 

   ; TODO compute curves here

   ; TODO crtc transition
crtc_value
    ld b, 0xbc
    ld hl, 0x0100+32
    out (c), h : inc b : out (c), l

; Build the lookup tables for the displaying routine
build_screen_tables
    ld hl, 0xc000 + 64 + 64  - 1
    ld ix, SCREEN1_ADDRESSES
    ld iy, SCREEN2_ADDRESSES

    ld a, 64
.loop
    push af

    ; 1rst line screen 1
    ld (ix+0), l
    ld (ix+1), h
 .2 inc ix

    ;2nd line screen 1
    call bc26
    ld (iy+0), l
    ld (iy+1), h
 .2 inc iy

    ; 1rst line screen 2
    call bc26
    ld (ix+0), l
    ld (ix+1), h
 .2 inc ix

    ;2nd line screen 2
    call bc26
    ld (iy+0), l
    ld (iy+1), h
 .2 inc iy

    call bc26
    pop af
    dec a
    jr nz, .loop


 if not USE_PRECOMPUTED_SHADES
; Build bayer shades
; need to use better ones
; TODO remove that
init_shades    
    ld iy, CHUNKY_PALETTE_1
    ld ix, MATRICE
    ld d,  1
    ld e,  2
    ld b,  13

    ld a,  %11000000
    ld (iy+0), a
    ld (iy+1), a
    inc iy : inc iy
.loop
    push bc


    ; build shades
    call bayer_mode0


    pop bc
    inc e
    inc d
    djnz .loop

    dec d
    dec e
    ld a, d
    ld d, e
    ld e, a
    ;ld d, e
    ;ld e, 1
    ld b,  13
.loop2
    push bc
    call bayer_mode0
    dec e
    dec d
    pop bc
    djnz .loop2
    push iy : pop de
    ld hl, CHUNKY_PALETTE_1 + 1
    ld bc, 256-13*4 - 1
    ldir
 else
     ld hl, precomputed_shades
     ld de, CHUNKY_PALETTE_1
     ld bc, 256
     ldir
 endif
; }}}

; Tunnel init {{{
tunnel_init
tunnel_init_distances
    ld hl, TUNNEL_DATA_PRECOMPUTED
    ld de, TUNNEL_DATA
    ld bc, (38/2+1)*52

tunnel_init_distances_loop
    
    ; copy
    ld a, (hl)
    ld (de), a

    ; move in buffers
    inc hl
    inc de
    inc de
    
    dec bc
    ld a, b
    or a
    jp nz, tunnel_init_distances_loop
    or c
    jp nz, tunnel_init_distances_loop

tunnel_init_angles
    ld de, TUNNEL_DATA+1
    ld bc, (38/2+1)*52

tunnel_init_angles_loop
    
    ; copy
    ld a, (hl)
    ld (de), a

    ; move in buffers
    inc hl
    inc de
    inc de
    
    dec bc
    ld a, b
    or a
    jp nz, tunnel_init_angles_loop
    or c
    jp nz, tunnel_init_angles_loop
;}}}

; {{{ bump init
bump_init
  
;; REcopie de code
    LD  HL, bump_calcul_bx
    LD  DE, bump_calcul_bx_end
    LD  BC, (bump_calcul_bx_end - bump_calcul_bx)*(bump_largeur/2 - 1)
    LDIR

 ;; Vertical light miror
    exx
    ld hl, bump_light+128-16
    exx
    ld hl, bump_light+128-16
    ld de, bump_light+128
    ld b, 8
copy_light
    push bc

    ; horizontal copy
    exx
    push hl
    ld de, hl
    dup 15
        inc e
    edup
    dup 8
        ld a, (hl)
        ld (de), a
        dec e
        inc l
    edup
    pop hl
    ld bc, 16
    sub hl, bc

    exx

    ; vertical copy
    push hl
    ld bc, 16
    ldir
    pop hl
    ld bc, 16
    sub hl, bc
    
    pop bc
    djnz copy_light

    ;; Creation de la table de multiplication et normalisation
    LD  DE, table_div_and_check_and_mul16
bump_init_lokup_b

    LD  A, E        ; division
    INC D

    ;SRL    A
    SRL A       ; /2
    SRL A
    CP  MAX_VALUE
    JR  C, suite1
    ld a, MAX_VALUE
suite1
    LD  (DE), A ; div and check
    
    DEC D
    ;; multiplication
    ADD A
    ADD A
    ADD A
    ADD A
    LD  (DE), A ; div and check and mul

    
    
    INC E

    LD  A, E
    OR  A
    JR  NZ, bump_init_lokup_b




    ; Compute the derive from the bump
bump_derive
    ld de, bump_image
    ld ix,  bump_image_fake + bump_largeur_source
    ld iy,  bump_image_fake +bump_largeur_source + 2
    call bump_derive_x

    ld de, bump_image+1
    ld ix,  bump_image_fake + 1
    ld iy,  bump_image_fake + bump_largeur_source + bump_largeur_source + 1
    call bump_derive_x

; }}}



    
; {{{ plasma init
;}}}

    ld hl, VECTOR
    ld de, 0x38
 .3 ldi
    ei



;; Buffer init
    ld hl, CHUNKY_ARRAY_1
    ld de, CHUNKY_ARRAY_1 + 1
    ld bc, 0x4000
    ld (hl),0
    ldir

;; Music init {{{
init_music
    if 1 = AZ_MUSIC
        di
        azp_initPeriodTable
        ei
    else
    ld de, MUSIC
    call PLAYER ;PLY_Init
    endif
; }}}

 if ENABLE_NYAN_SHIT
     ld b, 50 + 10 + 10
nyan_shit_loop
    push bc
    call intro_display_nyan_shit
    call display_chunk_array_to_screen
    pop bc
    djnz nyan_shit_loop
 endif
/*
    ld hl, CHUNKY_ARRAY_1
    ld de, CHUNKY_ARRAY_1 + 1
    ld (hl), 0xff
    ld bc, 0x4000
    ldir
*/
demo_loop
.effect
 if DO_NOT_DISPLAY_INTRO
    call plasma_manage_new_step
 else
    call introduction_manage_the_introduction 
;    call water_fill_buffer
;    call manage_tunnel
 endif
    call display_chunk_array_to_screen
    jp demo_loop


; Jumping code for interruptions
VECTOR jp inter

;;
; Interrupted code
inter
    push af, bc

.place
    ld a, 0
    inc a : ld (.place+1), a
    sub 6
    jp nz, leave_inter
    ld (.place+1), a


    ;;vbl detected
    ;; launch interrupted code
    push hl

    push de
    exx
    push bc
    push de
    push hl
    ex af, af'
    push af
    push ix
    push iy

.screen_color
    ld hl, TEXT_COLORS
/**
 * Select the palette in hl
 */
    ld bc, 0x7f00
    dup 17
    ld a, (hl)
    out (c), c
    out (c), a
    inc hl
    inc c
    edup

    if 1 = AZ_MUSIC
        call azp_play
    else
        call PLAYER+3;PLY_Play
    endif

 ; Verify if we change of color {

.change_color_wait
    ld a, 1
    or a
    jr nz , .change_color_end

    ld a, 1
    ld (.change_color_wait+1), a

.change_color_lookup
    ld hl, COLOR_DATA
.change_color_lookup_go
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl

    ld a, d
    or a
    jp nz, .not_end_color
    or e
    jp nz, .not_end_color
    ld hl, COLOR_DATA_TUNNEL
    jr .change_color_lookup_go
.not_end_color
    ld (.change_color_lookup+1), hl
    ld (.screen_color+1), de
.change_color_end
 ;}

    pop iy
    pop ix
    pop af
    ex af, af'
    pop hl
    pop de
    pop bc
    exx
    pop de


    pop hl

leave_inter
    pop bc, af
    ret


bc26
     LD A,H      ; HL=adresse écran
     ADD A,8     ; On ajoute &800 à HL
     LD H,A
     RET NC      ; A-t-on débordé de l'écran ?
     LD BC,&C000 + 64 ; &C000+80
     ADD HL,BC
     RET

bc29
    ld a, h
    sub 8
    ld h, a
    and 0x38
    cp 0x38
    ret nz
    ld a, h
    add 0x40
    ld h,a
    ld a, l
    sub 64
    ld l,a 
    ret nc
    ld a, h
    dec h
    and 7
    ret nz
    ld a, h
    add 0x08
    ld h, a
    ret



    if 1 = AZ_MUSIC

    include data/music_az/4k3.data.asm
    include data/music_az/4k3.config.asm
    include data/music_az/azp.code.asm
    else
MUSIC
  if 0
     incbin data/EgoTrip17.bin
  else
     incbin data/music/4K3.bin
  endif
PLAYER
    include ArkosTrackerPlayer_CPC_MSX.asm
    endif



;    display  $-MUSIC

    include display_chunky.asm
    include src/intro.asm
    include src/bump/bump.asm
    include src/chunky_plasma.asm
    include src/fade.asm
;    include src/water.asm
    include src/tunnel.asm
 if not USE_PRECOMPUTED_SHADES
    include src/bayer_mode0.asm
 endif
    include src/data.asm
 

    assert $<0x8000
