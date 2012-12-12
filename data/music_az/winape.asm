			read "azp.macros.asm"	; Player macros
			read "4k3.config.asm"	; Music configuration/settings

; Delete/Comment this symbol to compile the player without debug stuff (raster)
_azp_cnf_debug		equ 1


			org &1000
			run $,_snapshot

			; Prep the screen display
			ld bc,&BC01
			out (c),c
			inc b
			out (c),c
			xor a
			ld bc,0
			call &BC32
			ld a,1
			ld bc,13*256 + 13
			call &BC32
			ld a,1
			call &BC0E
			ld a,220
			ld b,20
			call &BB5A
			djnz $-3

			di
_snapshot
			; Dummy interrupt service routine
			ld hl,&c9fb
			ld (&38),hl
			; 
			; Expand the note-periods table
			azp_initPeriodTable
			; Init a particular song number
			;azp_initSong 0
			ei
			
			; 50Hz loop
play50Hz		ld b,&F5
			in a,(c)
			rra
			jr nc,$-3
			djnz $
			halt
			halt
			halt
			; rastertime to update the AY3 register shown in red
			; rastertime to process one tick of music shown in white
			ds 32,0
			ld bc,&7f10
			out (c),c
			ld c,&4c
			out (c),c
			call azp_play
			ld bc,&7f54
			out (c),c

			jr play50Hz
			

			org &2000
			nolist
			; Note that the player will automatically align itself on a 256 bytes boundary
			read "azp.code.asm"	; Player code
			; Music data can be located anywhere, even scattered all around the memory
			read "4k3.data.asm"	; Music data
