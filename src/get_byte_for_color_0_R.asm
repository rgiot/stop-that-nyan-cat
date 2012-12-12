;;;  Retourne la valeur de l'octet permettant
;;;  de coder la valeur de l'encre en mode 0
;;;  sur le pixel de droite
;;;
;;; Entree :
;;;	B : numero de la couleur choisie
;;;
;;; Sortie :
;;;	C : valeur de l'octet
;;;
;;; http://www.kjthacker.f2s.com/docs/graphics.html
get_byte_for_color_0_R:	
	LD C, 0
	BIT 0, B
	JR Z, get_byte_for_color_0_R_no_bit_0
	SET 6, C
	
get_byte_for_color_0_R_no_bit_0:
	BIT 1, B
	JR Z, get_byte_for_color_0_R_no_bit_1
	SET 2, C
	
get_byte_for_color_0_R_no_bit_1:
	BIT 2, B
	JR Z, get_byte_for_color_0_R_no_bit_2
	SET 4, C

get_byte_for_color_0_R_no_bit_2:
	BIT 3, B
	JR Z, get_byte_for_color_0_R_no_bit_3
	SET 0, C

get_byte_for_color_0_R_no_bit_3:
	;; Maintenant A contient l'octet codant la couleur
	RET