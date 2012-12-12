; All data in the same file in order to improve compression

    defb "STOP THAT NYAN CAT!"
;  {
COLOR_DATA
    dw PLASMA_COLORS_1
    dw PLASMA_COLORS_2
    dw PLASMA_COLORS_3
    dw PLASMA_COLORS_4

    dw PLASMA_COLORS_4_END_1
    dw PLASMA_COLORS_4_END_2
    dw PLASMA_COLORS_4_END_3
    dw PLASMA_COLORS_4_END_4
    dw PLASMA_COLORS_4_END_5
    dw PLASMA_COLORS_4_END_6
    dw PLASMA_COLORS_4_END_7
    dw PLASMA_COLORS_4_END_8
    dw PLASMA_COLORS_4_END_9
    dw PLASMA_COLORS_4_END_10
    dw PLASMA_COLORS_4_END_11
    dw PLASMA_COLORS_4_END_12
    dw PLASMA_COLORS_4_END_13
    dw PLASMA_COLORS_4_END_14

    dw BUMP_COLORS_1
    dw BUMP_COLORS_2
    dw BUMP_COLORS_3
    dw BUMP_COLORS_4

    dw BUMP_COLORS_4_END_1
    dw BUMP_COLORS_4_END_2
    dw BUMP_COLORS_4_END_6
    dw BUMP_COLORS_4_END_4
    dw BUMP_COLORS_4_END_5
    dw BUMP_COLORS_4_END_6
    dw BUMP_COLORS_4_END_7
    dw BUMP_COLORS_4_END_8
    dw BUMP_COLORS_4_END_9
    dw BUMP_COLORS_4_END_10
    dw BUMP_COLORS_4_END_11
    dw BUMP_COLORS_4_END_12
    dw BUMP_COLORS_4_END_13
    dw BUMP_COLORS_4_END_14

COLOR_DATA_TUNNEL
    dw BUMP_COLORS_1
    dw BUMP_COLORS_2
    dw BUMP_COLORS_3
    dw PLASMA_COLORS_1
    dw PLASMA_COLORS_2
    dw PLASMA_COLORS_3
    dw PLASMA_COLORS_4
    dw BUMP_COLORS_4


    dw 00
 ;}

 ;;;;;;;;;;;;;;;;;;;;;; Bump data ;;;;;;;;;;;;;;;;;;;;
; {{{ Colors of the hades to display
BUMP_COLORS_1
;    db 0x40,0x54, 0x44, 0x55, 0x57, 0x5f, 0x53, 0x40
;    db 0x4c, 0x4e, 0x4a, 0x43, 0x4b
;    db 0x4b
;    db 0x4b
;    db 0x4b
;    db 0x40
;;}}}
;    db &5F,&54,&44,&55,&57,&5F,&53,&40,&4C,&4E,&4A,&43,&4B,&4B,&4B,&5D,&5F
    db &4E,&5C,&58,&45,&4D,&4F,&40,&5D,&57,&5F,&53,&5B,&4B,&4B,&4B,&43,&4E 

BUMP_COLORS_2
;    db 0x40
;    db 0x58, 0x56, 0x52, 0x5a, 0x42,0x53,0x5b
;    db 0x4c, 0x4e, 0x4a, 0x43, 0x4b
;    db 0x4b
;    db 0x4b
;    db 0x4b
;    db 0x40

;    db &54,&44,&58,&56,&46,&52,&5A,&59,&51,&4B,&5B,&53,&5F,&57,&5D,&55,&40
    db &4D,&54,&5C,&4C,&45,&4E,&47,&4F,&40,&52,&59,&43,&4B,&4B,&4B,&5D,&4D 

BUMP_COLORS_3
;    db &54,&44,&5C,&4C,&45,&4D,&5D,&58,&44,&55,&57,&53,&5A,&5B,&4B,&43,&40
    db &45,&54,&44,&55,&57,&5F,&53,&40,&4C,&4E,&4A,&43,&4B,&4B,&4B,&47,&45

BUMP_COLORS_4
    db &58,&44,&58,&56,&46,&51,&59,&5B,&43,&4B,&5B,&53,&5F,&57,&5D,&57,&58


BUMP_COLORS_4_END_1 db &58,&44,&44,&58,&56,&46,&51,&59,&5B,&43,&4B,&5B,&53,&5F,&57,&5D,&58
BUMP_COLORS_4_END_2 db &58,&44,&44,&44,&58,&56,&46,&51,&59,&5B,&43,&4B,&5B,&53,&5F,&5D,&58
BUMP_COLORS_4_END_3 db &58,&44,&44,&44,&44,&58,&56,&46,&51,&59,&5B,&43,&4B,&5B,&53,&5D,&58
BUMP_COLORS_4_END_4 db &58,&44,&44,&44,&44,&44,&58,&56,&46,&51,&59,&5B,&43,&4B,&5B,&5D,&58
BUMP_COLORS_4_END_5 db &58,&44,&44,&44,&44,&44,&44,&58,&56,&46,&51,&59,&5B,&43,&4B,&5D,&58
BUMP_COLORS_4_END_6 db &58,&44,&44,&44,&44,&44,&44,&44,&58,&56,&46,&51,&59,&5B,&43,&5D,&58
BUMP_COLORS_4_END_7 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&58,&56,&46,&51,&59,&5B,&5D,&58
BUMP_COLORS_4_END_8 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&44,&58,&56,&46,&51,&59,&5D,&58
BUMP_COLORS_4_END_9 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&58,&56,&46,&51,&5D,&58
BUMP_COLORS_4_END_10 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&58,&56,&46,&5D,&58
BUMP_COLORS_4_END_11 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&58,&56,&5D,&58
BUMP_COLORS_4_END_12 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&58,&5D,&58
BUMP_COLORS_4_END_13 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&5D,&58
BUMP_COLORS_4_END_14 db &58,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&44,&5D,&58


PLASMA_COLORS_1
;    defb 0x40,64,71,67,69,92,86,82,91,81
;    defb 70,68,88,77,79,75
;    db &40,&47,&43,&4E,&45,&5C,&56,&52,&5B,&51,&46,&44,&58,&4D,&4F,&5F
    db &5D,&4C,&45,&4E,&47,&4F,&5F,&40,&5B,&4B,&53,&57,&55,&44,&58,&58,&5D 

PLASMA_COLORS_2
;    db 0x40 ; background
;    defb 84,93,68,85,88,93,87,95,91,67,71,78
;    defb 77,69
;    db 0x4b ; border
;    ; db 0x40 ; Use next byte
;    db &40,&45,&5C,&44,&55,&58,&5D,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&4B
    db &5F,&47,&43,&4E,&45,&5C,&56,&52,&5B,&51,&46,&44,&58,&4D,&4F,&40,&5F


PLASMA_COLORS_3
;    db 0x40 ;background
;    defb 69,77,79,67,71,69,76
;    defb 88,87,95,91,75,91,95
;    db 0x4b ; border
;    ; db 0x40 ; Use next byte
;    db &40,&5C,&56,&52,&5A,&4A,&43,&4B,&5B,&46,&5F,&4F,&47,&4E,&4C,&4B
    db &53,&5D,&40,&5F,&4D,&4F,&5B,&4B,&43,&59,&52,&56,&5C,&44,&58,&46,&53 

PLASMA_COLORS_4
;    db 0x40 ; Background
;    defb 64,86,82,90,74,67,75,67,74,67
;    defb 79,71,78,76
;    db 0x4b ; border
;    ; db 0x40 ; Use next byte

;    db 0x40 ;background
;    defb 69,77,79,67,71,69,76
;    defb 88,87,95,91,75,91,95
;    db 0x4b ; border
;    ; db 0x40 ; Use next byte
    db &4F,&45,&5C,&44,&55,&58,&5D,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F

PLASMA_COLORS_4_END_1  db &4F,&45,&5C,&44,&55,&58,&5D,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_2  db &4F,&45,&45,&44,&55,&58,&5D,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_3  db &4F,&45,&45,&45,&55,&58,&5D,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_4  db &4F,&45,&45,&45,&45,&58,&5D,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_5  db &4F,&45,&45,&45,&45,&45,&5D,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_6  db &4F,&45,&45,&45,&45,&45,&45,&57,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_7  db &4F,&45,&45,&45,&45,&45,&45,&45,&5F,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_8  db &4F,&45,&45,&45,&45,&45,&45,&45,&45,&5B,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_9  db &4F,&45,&45,&45,&45,&45,&45,&45,&45,&45,&4B,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_10 db &4F,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&43,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_11 db &4F,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&47,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_12 db &4F,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&4E,&4D,&40,&4F
PLASMA_COLORS_4_END_13 db &4F,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&4D,&40,&4F
PLASMA_COLORS_4_END_14 db &4F,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&45,&40,&4F


TEXT_COLORS
;    defb 0x40
;    db 0x58, 67,69,92,86,82,91,81
;    defb 70,68,88,77,79,0x4b
;    db 0x4b
;    db 0x40

    db &58,&5C,&4C,&45,&4D,&4E,&47,&4F,&43,&4B,&4B,&4B,&4B,&4B,&5E,&5D,&58

    if USE_PRECOMPUTED_SHADES
precomputed_shades
    ;incbin data/shades_precomputed2.bin
    incbin data/shades_precomputed_voxy2.bin
    endif

; {{{ Data
  if USE_PRECOMPUTED_SINES
eau_sin
      ;incbin "data/sin_precomputed.bin"
      include "data/sin_precomputed.asm"

  else
MATHS_INDEX         defs 5
MATHS_FACTOR        defs 5
MATHS_AMPLITUDE     defs 5
  endif



    align 256
; TODO compute it again or compute it from the system
bump_light
 include src/bump/bump_light.asm


; TODO compute it again
 align 256
bump_image_fake
    include src/bump/bump_image.asm
bump_image_fake_end


 ;}}}

TUNNEL_DATA_PRECOMPUTED
 include data/tunnelmap.asm

;;;;;;;;;;;;;;;;;;;;; Plasma data ;;;;;;;;;;;;;;;;;;

/**
 * Lookup table for delta code
 * for each value, give a inc a, dec a or nop
 */
 align 256
LOOKUP_DELTA_OPCODE
  nop
 dup 126
  inc a
 edup
 dup 256-126
  dec a
 edup

  align 256
fade_div_table
I=0
MAX=60
DIV=4
 dup MAX*DIV
        db I/DIV - 1
I=I+1
 edup
 dup 256 - MAX*DIV
    db MAX
 edup

; Curves are the same than in the bump


;bump_image
 ;   defs (bump_image_fake_end- bump_image_fake)*2 * 2

; Space for constructed data
  ; a bit of space for the false stack
FALSE_STACK equ 0x100

;; TODO remove this align
    align 256

bump_image

TUNNEL_DATA equ $+((bump_image_fake_end- bump_image_fake)*2 * 2 +256)/256 * 256


SCREEN1_ADDRESSES  equ TUNNEL_DATA+((bump_image_fake_end- bump_image_fake)*2 * 2 +256)/256 * 256

SCREEN2_ADDRESSES               equ SCREEN1_ADDRESSES + 256
CHUNKY_PALETTE_1                equ SCREEN2_ADDRESSES + 256
;;; Tableau de conversion pour faire *16
table_div_and_check_and_mul16   equ CHUNKY_PALETTE_1 + 256
;;; Tableau permettant de faire la division des valeurs et la verification du non depassement
table_div_and_check             equ table_div_and_check_and_mul16 + 256
realsin                         equ table_div_and_check + 256
sintab1                         equ realsin + 256
PLASMA_CURVE1 equ sintab1
PLASMA_CURVE2 equ PLASMA_CURVE1

CHUNKY_ARRAY_1 equ sintab1 +  512
CHUNKY_ARRAY_2 equ CHUNKY_ARRAY_1 + CHUNKY_DISPLAY_WIDTH + 20
