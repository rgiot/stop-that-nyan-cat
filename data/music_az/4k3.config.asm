;;*** Aero Zeppelin player optimization profile ********************************
;;
;;     Music: 4K3
;;    Author: 
;; Generated: 2012/02/05
;;
;;     Songs: 1
;;  Channels: 3
;;    Tracks: 3
;;
;; Enable (1) or disable (0) compilation of various AZ Player features.
;; (The more 0, the faster/shorter the player)

_azp_cnf_ChA_global             equ 1
_azp_cnf_ChA_tracker            equ 1
_azp_cnf_ChA_transpose          equ 1
_azp_cnf_ChA_trackPitch         equ 0
_azp_cnf_ChA_trackPitchFP       equ 3
_azp_cnf_ChA_trackVolume        equ 1
_azp_cnf_ChA_tonePitch          equ 0
_azp_cnf_ChA_env                equ 0
_azp_cnf_ChA_envPitch           equ 0
_azp_cnf_ChA_arpeggio           equ 1
_azp_cnf_ChA_noise              equ 1
_azp_cnf_ChA_sample             equ 0

_azp_cnf_ChB_global             equ 1
_azp_cnf_ChB_tracker            equ 1
_azp_cnf_ChB_transpose          equ 1
_azp_cnf_ChB_trackPitch         equ 0
_azp_cnf_ChB_trackPitchFP       equ 3
_azp_cnf_ChB_trackVolume        equ 0
_azp_cnf_ChB_tonePitch          equ 1
_azp_cnf_ChB_env                equ 1
_azp_cnf_ChB_envPitch           equ 0
_azp_cnf_ChB_arpeggio           equ 1
_azp_cnf_ChB_noise              equ 1
_azp_cnf_ChB_sample             equ 0

_azp_cnf_ChC_global             equ 1
_azp_cnf_ChC_tracker            equ 1
_azp_cnf_ChC_transpose          equ 1
_azp_cnf_ChC_trackPitch         equ 0
_azp_cnf_ChC_trackPitchFP       equ 3
_azp_cnf_ChC_trackVolume        equ 1
_azp_cnf_ChC_tonePitch          equ 0
_azp_cnf_ChC_env                equ 1
_azp_cnf_ChC_envPitch           equ 0
_azp_cnf_ChC_arpeggio           equ 0
_azp_cnf_ChC_noise              equ 0
_azp_cnf_ChC_sample             equ 0


;; Set this switch to compile a small mute-all-sound routine
_azp_cnf_mute                   equ 0

;; Set this switch to split the player routine in two:
;; call azp_play : to update AY3 registers (has constant CPU-time)
;; call azp_tick : to process one tick of music (has variable CPU-Time)
_azp_cnf_split                  equ 0

;; Set this switch to compile the player with a precalculated and AT-accurate
;; note periods table.
_azp_cnf_precalcPeriodsTable    equ 0

;; Default song initialized at compile time
song_chA_trackList              equ _azm_song0_ChC_list
song_chA_trackList_loop         equ _azm_song0_ChC_loop
song_chB_trackList              equ _azm_song0_ChB_list
song_chB_trackList_loop         equ _azm_song0_ChB_loop
song_chC_trackList              equ _azm_song0_ChA_list
song_chC_trackList_loop         equ _azm_song0_ChA_loop

;; Meta-Macro to initialize any subsongs of the music
;; Usage:
;;  azp_initSong <subsong number>
;;
 macro azp_initSong song
    if  song=0
            azp_forceNextPos
            azp_setPos  _azm_song0_ChC_list,_azm_song0_ChB_list,_azm_song0_ChA_list
            azp_setLoop _azm_song0_ChC_loop,_azm_song0_ChB_loop,_azm_song0_ChA_loop
    endif
 endm
