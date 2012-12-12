;;*** Aero Zeppelin macros *****************************************************
;;
;; All the following macro, when used, will inline short routines in your program. 
;;
;; Note-Period generator routine. Should be used once before calling the player.
;; WARNING: This routine abuses the stack, thus should not be interrupted!
;; Output:
;;   HL,DE,B and flags are modified
 macro azp_initPeriodTable
            ld (._var_lutgen_sp),sp
            
            ld sp,_lut_note_periods
            ld hl,_lut_note_periods + 24
            ld b,9*12 + 4
._lutgen_periods
            pop de
            srl d
            rr  e
            ld (hl),e
            inc l
            ld (hl),d
            inc l
            djnz ._lutgen_periods
._var_lutgen_sp     equ $+1
            ld sp,0
 endm

;; Force the player to the next song-position
;; Output:
;;   HL is modified
 macro azp_forceNextPos
            ; Reset counters
            ld hl,&0100
            if _azp_cnf_ChA_tracker AND _azp_cnf_ChA_global
            ld (_var_chA_triggers),hl
            endif
            if _azp_cnf_ChB_tracker AND _azp_cnf_ChB_global
            ld (_var_chB_triggers),hl
            endif
            if _azp_cnf_ChC_tracker AND _azp_cnf_ChC_global
            ld (_var_chC_triggers),hl
            endif
 endm

;; Change the song's loop points (eg. you can let your tune loop until some event
;; triggers this routine and allow the song to continue)
;; Output:
;;   HL is modified
 macro azp_setLoop chA,chB,chC
            if _azp_cnf_ChA_tracker AND _azp_cnf_ChA_global
            ld hl,chA
            ld (_var_chA_pattern_loop),hl
            endif
            if _azp_cnf_ChB_tracker AND _azp_cnf_ChB_global
            ld hl,chB
            ld (_var_chB_pattern_loop),hl
            endif
            if _azp_cnf_ChC_tracker AND _azp_cnf_ChC_global
            ld hl,chc
            ld (_var_chC_pattern_loop),hl
            endif
 endm

;; Change the song position. Will be effective when the current tracks end (unless
;; you use the azp_forceNextPos)
;; Output:
;;   HL is modified
 macro azp_setPos chA,chB,chC
            if _azp_cnf_ChA_tracker AND _azp_cnf_ChA_global
            ld hl,chA
            ld (_var_chA_pattern_pos),hl
            endif
            if _azp_cnf_ChB_tracker AND _azp_cnf_ChB_global
            ld hl,chB
            ld (_var_chB_pattern_pos),hl
            endif
            if _azp_cnf_ChC_tracker AND _azp_cnf_ChC_global
            ld hl,chc
            ld (_var_chC_pattern_pos),hl
            endif
 endm
