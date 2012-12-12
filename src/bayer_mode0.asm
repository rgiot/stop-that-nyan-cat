;; Fonction permettant de genere le tramage
;; IY contient l'adresse du buffer de destination
;; IX contient l'adresse de la matrice
;; D contient la couleur 1
;; E contient la couleur 0
    ;; B => duree
bayer_mode0:
/*
    ld b, d
    CALL    get_byte_for_color_0_L
    ld a, c
    CALL    get_byte_for_color_0_R
    or c
    ld (iy+0), a
    ld (iy+1), a
 .2 inc iy
*/
    ld b, 4
bayer_mode0_boucle:
    PUSH    BC





    LD  A, 4
    SUB B       ; A contient le numero de l'etape
    PUSH    AF

    
;;;  Pixel1
    CP  (IX+0)
    JP  C, bayer_mode0_echec1 ; < 0
    ;; couleur 2
    LD  B, E
    JP  bayer_mode0_suite1
    
bayer_mode0_echec1:
    ;; couleur 1
    LD  B, D

bayer_mode0_suite1: 
    CALL    get_byte_for_color_0_L
    LD  (IY+0), C


    
;;; Pixel 2
    CP  (IX+1)
    JP  C, bayer_mode0_echec2 ; < 0
    ;; couleur 2
    LD  B, E
    JP  bayer_mode0_suite2
    
bayer_mode0_echec2:
    ;; couleur 1
    LD  B, D

bayer_mode0_suite2: 

    
    CALL    get_byte_for_color_0_R
    LD  A, C
    OR  (IY+0)
    LD  (IY+0), A



    POP AF
;;  Pixel 3
    CP  (IX+2)
    JP  C, bayer_mode0_echec3 ; < 0
    ;; couleur 2
    LD  B, E
    JP  bayer_mode0_suite3
    
bayer_mode0_echec3:
    ;; couleur 1
    LD  B, D

bayer_mode0_suite3: 
    CALL    get_byte_for_color_0_L
    LD  (IY+1), C
    

    
    
;;; Pixel 4
    CP  (IX+3)
    JP  C, bayer_mode0_echec4 ; < 0
    ;; couleur 2
    LD  B, E
    JP  bayer_mode0_suite4
    
bayer_mode0_echec4:
    ;; couleur 1
    LD  B, D

bayer_mode0_suite4: 

    
    CALL    get_byte_for_color_0_R
    LD  A, C
    OR  (IY+1)
    LD  (IY+1), A
    
    INC IY
    INC IY
    
    POP BC
    DJNZ    bayer_mode0_boucle
    
    RET

    
MASQUE_GAUCHE   EQU 10101010b ; tous les pixels gauche allumes
MASQUE_DROITE   EQU 01010101b ;  tous les pixels droits allume
        

MATRICE DB 0, 2
    DB 3, 1


 include mode0_byte_n_colors.asm

