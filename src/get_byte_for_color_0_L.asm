
;;;  Retourne la valeur de l'octet permettant
;;;  de coder la valeur de l'encre en mode 0
;;;  sur le pixel de gauche
;;;
;;; Entree :
;;;	B : numero de la couleur choisie
;;;
;;; Sortie :
;;;	C : valeur de l'octet
;;;
;;; http://www.kjthacker.f2s.com/docs/graphics.html
get_byte_for_color_0_L:	
	LD C, 0
	BIT 0, B
	JR Z, get_byte_for_color_0_L_no_bit_0
	SET 7, C
	
get_byte_for_color_0_L_no_bit_0:
	BIT 1, B
	JR Z, get_byte_for_color_0_L_no_bit_1
	SET 3, C
	
	
get_byte_for_color_0_L_no_bit_1:
	BIT 2, B
	JR Z, get_byte_for_color_0_L_no_bit_2
	SET 5, C

get_byte_for_color_0_L_no_bit_2:
	BIT 3, B
	JR Z, get_byte_for_color_0_L_no_bit_3
	SET 1, C

get_byte_for_color_0_L_no_bit_3:
	;; Maintenant A contient l'octet codant la couleur
	RET