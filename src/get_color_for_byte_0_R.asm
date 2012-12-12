;; Retourne le numero de la couleur du pixel droit
;; depuis un octet en mode 0
;; Entree :
;;	Registre B : valeur de l'octet dans lequel recuperer la couleur
;;
;; Sortie :
;;	Registre C : Code de la couleur (0-15) 
;;; http://www.kjthacker.f2s.com/docs/graphics.html
get_color_for_byte_0_R:	
	LD C, 0
	BIT 6, B
	JP Z, get_color_for_byte_0_R_no_bit_0
	SET 0, C
	
get_color_for_byte_0_R_no_bit_0:
	BIT 2, B
	JP Z, get_color_for_byte_0_R_no_bit_1
	SET 1, C
	
get_color_for_byte_0_R_no_bit_1:
	BIT 4, B
	JP Z, get_color_for_byte_0_R_no_bit_2
	SET 2, C

get_color_for_byte_0_R_no_bit_2:
	BIT 0, B
	JP Z, get_color_for_byte_0_R_no_bit_3
	SET 3, C

get_color_for_byte_0_R_no_bit_3:
	;; Maintenant C contient le numero de la couleur
	RET