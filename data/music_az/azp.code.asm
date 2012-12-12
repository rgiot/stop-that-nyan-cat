;;Maxam/WinAPE assembler dialect @tab(4)
;;  _________               __ __                                     __          
;; /   _____/ ____   _____ |__|  | _____    ____   ____  ____ _____ _/  |______   
;; \_____  \_/ __ \ /     \|  |  | \__  \  /    \_/ ___\/ __ \\__  \\   __\__  \  
;; /        \  ___/|  Y Y  \  |  |__/ __ \|   |  \  \__\  ___/ / __ \|  |  / __ \_
;;/_______  /\___  >__|_|  /__|____(____  /___|  /\___  >___  >____  /__| (____  /
;;        \/     \/      \/             \/     \/     \/    \/     \/      Ltd.\/ 
;;Aero Zeppelin Player (AZP) v0.7beta (201201) - CPC30YMD stripped down version.
;;
;; This is a cutting edge CPC sound-chip music player for whom speed matters.
;; Because, quite frankly,  all existing players so far sucked balls, in one way
;; or many others  (too slow, too big,  feature-creeps, feature-less,  no source
;; code, bugged,...), so we wrote our own.  And we  pity  you so much that we're
;; willing to share (some of) it with you, mere mortal. (kneel now)
;;
;; Despite it was not originally intended to replay Arkos Tracker (AT) music, it
;; shared enough features to do so quite well and... much faster!     So AT song
;; support has been added to the AZ song-compiler,  but keep in mind this player
;; DOES NOT support the following AT instrument features:
;;
;; - Arpeggio on the hardware enveloppe
;; - "Independant" and "Hardware" modes
;; - Absolute periods (for tone & hardware env.)
;;
;; See AT webpage for all the gory details:
;; http://www.grimware.org/doku.php/documentations/software/arkos.tracker/
;;
;; Since this player  automatically  optimizes  itself (ie. removing all of it's
;; useless parts)  to replay a specific music,  it's speed and size  can greatly
;; vary from one music to another.  The  theoretic  maximum  execution time of a
;; generic player (without any optimizations) should be around 17 rasterlines.
;; However, if you ever need that much CPU-time to play a music...
;;
;;   Do the multiverses a favor...
;;                                ...kill the musician who composed that shit!
;;
;; The maximum observed CPU-Time is about 15 rasterlines. That is as fast as the
;; 12yo famous KitAY streamer (and without the king-size memory footprint).
;;
;; This player heavily abuses the stack pointer. You'd be well advised to make
;; sure NO fucking interrupt kicks in while it's running... OR ELSE!
;;
;; Finally, this piece of code is aimed at bearded assembly coders. If you can't
;; figure out how to use it,  that's just because you're not smart enough!  Stop
;; confusing yourself any further and try something else, something simpler!
;;
;; If you have any question, please,  do not hesitate to ask someone else first.
;;
;;                                               Grim/Arkos^Semilanceata
;;
;; THIS SOFTWARE IS DISTRIBUTED UNDER THE GRIMWARE-BEERWARE LICENSE AND PROVIDED
;; "AS IS" WITHOUT WARRANTY OF ANY KIND EXPRESS OR IMPLIED.    IN NO EVENT SHALL
;; THE AUTHOR BE LIABLE FOR ANY DIRECT,  INDIRECT,  INCIDENTAL  OR CONSEQUENTIAL
;; DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE.
;;
;;*** Data *********************************************************************
                        align 256
;list
;;[AZ Player] Begin
;nolist
_lut_note_periods
                        ;    C-0 C#0 D-0 D#0 E-0 F-0 F#0 G-0 G#0 A-0 A#0 B-0
                        defw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025
                        
                        ; Using the precalculated table below will provide 100%
                        ; accuracy with Arkos Tracker but will be much less
                        ; packer-friendly.
                        ;
                        ; Using the AZ macro to generate this table will pack
                        ; much better but in some cases might produce slightly
                        ; off-tune hardware envelope sound.
                        ;
                        ; Choose your friend, compression or accuracy.
                        if _azp_cnf_precalcPeriodsTable
                            ;    C-1 C#1 D-1 D#1 E-1 F-1 F#1 G-1 G#1 A-1 A#1 B-1
                            defw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012
                            ;    C-2 C#2 D-2 D#2 E-2 F-2 F#2 G-2 G#2 A-2 A#2 B-2
                            defw 956,902,851,804,758,716,676,638,602,568,536,506
                            ;    C-3 C#3 D-3 D#3 E-3 F-3 F#3 G-3 G#3 A-3 A#3 B-3
                            defw 478,451,426,402,379,358,338,319,301,284,268,253
                            ;    C-4 C#4 D-4 D#4 E-4 F-4 F#4 G-4 G#4 A-4 A#4 B-4
                            defw 239,225,213,201,190,179,169,159,150,142,134,127
                            ;    C-5 C#5 D-5 D#5 E-5 F-5 F#5 G-5 G#5 A-5 A#5 B-5
                            defw 119,113,106,100,95,89,84,80,75,71,67,63
                            ;    C-6 C#6 D-6 D#6 E-6 F-6 F#6 G-6 G#6 A-6 A#6 B-6
                            defw 60,56,53,50,47,45,42,40,38,36,34,32
                            
                            ; From now on, the precision of the period gets really bad.
                            ;    C-7,C#7,D-7,D#7,E-7,F-7,F#7,G-7,G#7,A-7,A#7,B-7
                            defw 30,28,27,25,24,22,21,20,19,18,17,16
                            ;    C-8,C#8,D-8,D#8,E-8,F-8,F#8,G-8,G#8,A-8,A#8,B-8
                            defw 15,14,13,13,12,11,11,10,9,9,8,8
                            ;    C-9,C#9,D-9,D#9,E-9,F-9,F#9,G-9,G#9,A-9,A#9,B-9
                            defw 7,7,7,6,6,6,5,5,5,4,4,4
                            ;    C-10,C#10,D-10,D#10
                            defw 4,4,3,3
                        endif
                        
                        align 256
_var_psg                ; AY3 register-values buffer
                        if _azp_cnf_ChA_global
_var_psg_ChA_tonePeriod     dw 0    ; R0-R1
                        endif
                        if _azp_cnf_ChB_global
_var_psg_ChB_tonePeriod     dw 0    ; R2-R3
                        endif
                        if _azp_cnf_ChC_global
_var_psg_ChC_tonePeriod     dw 0    ; R4-R5
                        endif
            
_var_psg_r6r7
_var_psg_noisePeriod    db 0    ; R6
_var_psg_mixer          db &3f  ; R7
            
                        if _azp_cnf_ChA_global
_var_psg_ChA_amplitude      db 0    ; R8
                        endif
                        if _azp_cnf_ChB_global
_var_psg_ChB_amplitude      db 0    ; R9
                        endif
                        if _azp_cnf_ChC_global
_var_psg_ChC_amplitude      db 0    ; R10
                        endif
            
                        if _azp_cnf_ChA_env + _azp_cnf_ChB_env + _azp_cnf_ChC_env
_var_psg_envPeriod          dw 0    ; R11-R12
_var_psg_env_shape          db 0    ; R13
                        endif

;;*** Player code **************************************************************
            
                        if _azp_cnf_mute
;; Mute all sounds.
;; Clear all 3 amplitude values and call the player.
azp_mute:
                            ; Set all enabled channels with a null amplitude
                            xor a
                            ifdef _var_psg_ChA_amplitude
                                ld hl,_var_psg_ChA_amplitude
                                ld (hl),a
                                ifdef _var_psg_ChB_amplitude
                                    inc hl
                                    ld (hl),a
                                endif
                                ifdef _var_psg_ChC_amplitude
                                    inc hl
                                    ld (hl),a
                                endif
                            else
                                ifdef _var_psg_ChB_amplitude
                                    ld hl,_var_psg_ChB_amplitude
                                    ld (hl),a
                                    ifdef _var_psg_ChC_amplitude
                                        inc hl
                                        ld (hl),a
                                    endif
                                else
                                    ifdef _var_psg_ChC_amplitude
                                        ld hl,_var_psg_ChC_amplitude
                                        ld (hl),a
                                    else
                                        print "Compiling a music player without a single active channel eh?"
                                        print "Are you fucking stupid?"
                                    endif
                                endif
                            endif
                        endif

;; Play one tick of music
;; WARNING: Ye who interrupts me shall hear the wrath of the mighty glitchip!
azp_play:
                        ; Update AY3-8912
                        ld a,&E6
                        ld hl,_var_psg
                        ld de,&F480
                        
                        if _azp_cnf_ChA_global
                            ld bc,&F401
                            ; Tone Period A
                            ;R0 with AY-standby
                            out (&FF),a ; selectReg
                            dw &71ED    ; data=regNumber
                            ld b,a
                            dw &71ED    ; standby
                            dec b
                            outi        ; data=regValue
                            ld b,a
                            out (c),e   ; writeReg
                            ;R1 with AY-standby
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                        endif
            
                        if _azp_cnf_ChB_global
                            if _azp_cnf_ChA_global
                                inc c
                            else
                                ld bc,&F402
                            endif
                            ; Tone Period B
                            ;R2 with AY-standby
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                            ; R3 with AY-standby
                            inc c
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                        endif
            
                        if _azp_cnf_ChC_global
                            if _azp_cnf_ChB_global
                                inc c
                            else
                                if _azp_cnf_ChA_global
                                    ld c,4
                                else
                                    ld bc,&F404
                                endif
                            endif
                        
                            ; Tone Period C
                            ; R4 with AY-standby
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                            ; R5 with AY-standby
                            inc c
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                        endif

                        if _azp_cnf_ChA_noise OR _azp_cnf_ChB_noise OR _azp_cnf_ChC_noise
                            if _azp_cnf_ChC_global
                                inc c
                            else
                                if _azp_cnf_ChB_global OR _azp_cnf_ChA_global
                                    ld c,6
                                else
                                    ld bc,&F406
                                endif
                            endif
                            ; Noise period
                            ; R6 without AY-standby (~10us glitch in the period value)
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            out (c),e
                            dec b
                            outi
                            inc c
                        else
                            inc l
                            if _azp_cnf_ChA_global OR _azp_cnf_ChB_global OR _azp_cnf_ChC_global
                                ld c,7
                            else
                                ld bc,&F407
                            endif
                        endif
            
                        ; Mixer control
                        ; R7 with AY-standby
                        out (&FF),a
                        ld b,d
                        out (c),c
                        ld b,a
                        dw &71ED
                        dec b
                        outi
                        ld b,a
                        out (c),e
                        
                        if _azp_cnf_ChA_global
                            ; Amplitude registers
                            ; R8 with AY-standby
                            inc c
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                        endif

                        if _azp_cnf_ChB_global
                            if _azp_cnf_ChA_global
                                inc c
                            else
                                ld c,9
                            endif
                            ; R9 with AY-standby
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                        endif
                        
                        if _azp_cnf_ChC_global
                            if _azp_cnf_ChB_global
                                inc c
                            else
                                ld c,10
                            endif
                            ; R10 with AY-standby
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                        endif

                        ; Enveloppe period
                        if _azp_cnf_ChA_env + _azp_cnf_ChB_env + _azp_cnf_ChC_env
                            if _azp_cnf_ChC_global
                                inc c
                            else
                                ld c,11
                            endif
                            ;R11 with AY-standby
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                            ; R12 with AY-standby
                            inc c
                            out (&FF),a
                            ld b,d
                            out (c),c
                            ld b,a
                            dw &71ED
                            dec b
                            outi
                            ld b,a
                            out (c),e
                            dw &71ED
            
                            ; Enveloppe Shape
                            ; R13 with AY-standby
                            ld a,(hl)
_var_retrig_env_shape       equ $+1
                            cp 255
                            jr nz,$+3
                                inc c
                            inc c
                            and &1F
                            ld (_var_retrig_env_shape),a
                            out (c),b
                            ld b,d
                            out (c),c
                            ld b,&F6
                            out (c),e
                            ld b,d
                            out (c),a
                            ld b,&F6
                            dw &71ED
_psg_noretrig
                        else
                            dw &71ED
                        endif
            
                        if _azp_cnf_split
                            ret
;; Process one tick of sound.
;; WARNING: Ye who interupts me shall suffer eternal memory corruption.
azp_tick:
                        else
                            ifdef _azp_cnf_debug
                                ; Fancy debug-raster shit!
                                ld bc,&7f4b
                                out (c),c
                            endif
                        endif
                        ; Save current stack pointer
                        ld (_var_env_sp),sp

;*** CHANNEL C *****************************************************************
                        if _azp_cnf_ChC_global

_var_ChC_sound_pos          equ $+2
                            ld ix,_azm_instrument0

                            if _azp_cnf_ChC_trackPitch
_var_ChC_pitch_level            equ $+1
                                ld de,0
                            endif
            
                            if _azp_cnf_ChC_tracker
            
_var_ChC_data_pos                   equ $+1
                                    ld hl,0

_var_ChC_triggers                   equ $+1
                                    ld bc,&0100
            
                                    ;Preset next track
                                    xor a
                                    or c
                                    jr nz,_ChC_readTrack
                                        if _azp_cnf_ChC_transpose
_var_ChC_pattern_pos                        equ $+1
                                            ld sp,song_chC_trackList
                                            pop hl
                                            inc l
                                            jr nz,_ChC_pattern_noloop
_var_ChC_pattern_loop                           equ $+1
                                                ld sp,song_chC_trackList_loop
                                                pop hl
                                                inc l
_ChC_pattern_noloop
                                            ld a,h
                                            ld (_var_ChC_transpose),a
                                            ld c,l
                                        else
_var_ChC_pattern_pos                        equ $+1
                                            ld hl,song_ChC_trackList
                                            ld c,(hl)
                                            inc c
                                            jr nz,_ChC_pattern_noloop
_var_ChC_pattern_loop                           equ $+1
                                                ld hl,song_ChC_trackList_loop
                                                ld c,(hl)
                                                inc c
_ChC_pattern_noloop
                                        inc hl
                                        ld sp,hl
                                    endif
                                    pop hl
                                    ld (_var_ChC_pattern_pos),sp
                                    ld (_var_ChC_data_pos),hl
_ChC_readTrack
                                djnz _ChC_trackWait
                                    dec c
                                    ld b,(hl)
                                    inc hl
                                    ld sp,hl
                                    srl b
                                    jr c,_ChC_trackSave
    
                                        srl b
                                        jr nc,_ChC_readTrack_noNote
                                            inc sp
                                            ld a,(hl)
                                            add a,a
                                            jr nc,_var_ChC_noInstrument
                                                pop hl
                                                ld (_var_ChC_lastIntrument),hl
_var_ChC_noInstrument
_var_ChC_lastIntrument                      equ $+2
                                            ld ix,_azm_instrument0
                                            if _azp_cnf_ChC_transpose
_var_ChC_transpose                              equ $+1
                                                add a,0
                                            endif
                                            ld (_var_ChC_note),a
                                            if _azp_cnf_ChC_trackPitch
                                                ld de,0 ; reset trackPitch
                                            endif
_ChC_readTrack_noNote
                                        srl b
                                        if _azp_cnf_ChC_trackPitch
                                            jr nc,_ChC_readTrack_noPitch
                                                pop hl
                                                ld (_var_ChC_pitch_step),hl
_ChC_readTrack_noPitch
                                        endif
                                        if _azp_cnf_ChC_trackVolume
                                            srl b
                                            jr nc,_ChC_readtrack_noVolume
                                                ld a,b
                                                ld (_var_ChC_volume),a
_ChC_readtrack_noVolume
                                        endif
                                        ld b,2  ; wait one tick until next track read 
_ChC_trackSave
                                        ld (_var_ChC_data_pos),sp
_ChC_trackWait
                                    ld (_var_ChC_triggers),bc
                                endif
                                
;;*** Play instrument **********************************************************
;; Input
;;  IX = Instrument data pointer
;;  DE = Track Pitch level
;;
;; Instrument format
;;  Arp.8
;;  Amplitude.6|LOOP|TP
;;  @TP[Pitch.12]
;;  Mixer.4
;;  Noise.5|ENV
;;  @ENV[EP|0|0|0|waveDiv.3|0]
;;  @EP[wavePitch.16]
                                
                                ld sp,ix
                                pop bc
                                ; B = Amplitude|LOOP|TP
                                ; C = Arp
            
                                if _azp_cnf_ChC_trackPitch
                                    ; With Track Pitch
_var_ChC_pitch_step                 equ $+1
                                    ld hl,0
                                    add hl,de
                                    ld (_var_ChC_pitch_level),hl
                                    if _azp_cnf_ChC_trackPitchFP and 1
                                        sra h:rr l
                                    endif
                                    if _azp_cnf_ChC_trackPitchFP and 2
                                        sra h:rr l
                                    endif
                                
_var_ChC_note                       equ $+1
                                    if _azp_cnf_ChC_arpeggio
                                        ld a,0  ; Current note key
                                        add a,c ; Add arpeggio
                                        ld d,_lut_note_periods / 256
                                        ld e,a
                                    else
                                        ld de,_lut_note_periods
                                    endif
                                    ld a,(de)   ; Lookup the note period
                                    add a,l     ; and add Track Pitch
                                    ld l,a
                                    inc e
                                    ld a,(de)
                                    adc a,h
                                    ld h,a
                                else
                                    ; Without Track Pitch
_var_ChC_note                       equ $+1
                                    if _azp_cnf_ChC_arpeggio
                                        ld a,0  ; Current note key
                                        add a,c ; Add arpeggio
                                        ld h,_lut_note_periods / 256
                                        ld l,a
                                    else
                                        ld hl,_lut_note_periods
                                    endif
                                    ld e,(hl)   ; And lookup the note period
                                    inc l
                                    ld d,(hl)
                                    ex de,hl  
                                endif
                                ; TP
                                srl b
                                if _azp_cnf_ChC_tonePitch
                                    jr nc,_ChC_sound_noTonePitch
                                        pop de
                                        add hl,de
_ChC_sound_noTonePitch
                                endif
                                ld (_var_psg_ChC_tonePeriod),hl

                                exx
                                pop bc
                                ; B = Mixer.4
                                ; C = Noise.5|ENV
                                if _azp_cnf_ChB_global
                                    ld h,b
                                else
                                    if _azp_cnf_ChA_global
                                        ld a,b
                                        add a,a
                                        or %1001
                                    else
                                        ld a,b
                                        add a,a
                                        add a,a
                                        or %11011
                                    endif
                                    ld h,a
                                endif
                                srl c
                                if _azp_cnf_ChC_noise
                                    jr z,$+3
                                        ld l,c
                                endif
                                exx
                                if _azp_cnf_ChC_env
                                    jr c,_ChC_sound_enveloppe
                                endif
                                    ; Sound with fixed 4bit amplitude
                                    ld a,b
                                    sra a
                                    if _azp_cnf_ChC_trackVolume
_var_ChC_volume                         equ $+1
                                        sub 0
                                        jr nc,$+3
                                            xor a
                                        ; LOOP
                                        rr b
                                    endif
                                if _azp_cnf_ChC_env
                                    jr _ChC_soundtick_done

_ChC_sound_enveloppe                ; Sound with hardware envelope
                                    dec sp
                                    pop af
                                    add a,a ;EP
                                    if _azp_cnf_ChC_envPitch
                                        ld de,0
                                        jr nc,$+3
                                            pop de
                                    endif
                                    ld (_ChC_var_envDiv),a
_ChC_var_envDiv                     equ $+1
                                    jr $
                                    srl h:rr l  ; /128
                                    srl h:rr l  ; /64
                                    srl h:rr l  ; /32
                                    srl h:rr l  ; /16
                                    srl h:rr l  ; /8
                                    srl h:rr l  ; /4
                                    srl h:rr l  ; /2
                                    jr nc,$+3   ; Fucking rounding!
                                      inc hl
                                    
                                    if _azp_cnf_ChC_envPitch
                                        add hl,de
                                    endif
                                    ld (_var_psg_envPeriod),hl
                                    ld a,b
                                    sra a
                                    ld (_var_psg_env_shape),a
                                endif
_ChC_soundtick_done
                                ld (_var_psg_ChC_amplitude),a
                                jr nc,$+2+1+1
                                    pop hl
                                    ld sp,hl
                                
                                ld (_var_ChC_sound_pos),sp
                        endif
                            
;*** CHANNEL B *****************************************************************

                        if _azp_cnf_ChB_global
        
_var_ChB_sound_pos          equ $+2
                            ld ix,_azm_instrument0

                            if _azp_cnf_ChB_trackPitch
_var_ChB_pitch_level            equ $+1
                                ld de,0
                            endif
            
                            if _azp_cnf_ChB_tracker
            
_var_ChB_data_pos                   equ $+1
                                    ld hl,0

_var_ChB_triggers                   equ $+1
                                    ld bc,&0100
            
                                    ;Preset next track
                                    xor a
                                    or c
                                    jr nz,_ChB_readTrack
                                        if _azp_cnf_ChB_transpose
_var_ChB_pattern_pos                        equ $+1
                                            ld sp,song_chB_trackList
                                            pop hl
                                            inc l
                                            jr nz,_ChB_pattern_noloop
_var_ChB_pattern_loop                           equ $+1
                                                ld sp,song_chB_trackList_loop
                                                pop hl
                                                inc l
_ChB_pattern_noloop
                                            ld a,h
                                            ld (_var_ChB_transpose),a
                                            ld c,l
                                        else
_var_ChB_pattern_pos                        equ $+1
                                            ld hl,song_ChB_trackList
                                            ld c,(hl)
                                            inc c
                                            jr nz,_ChB_pattern_noloop
_var_ChB_pattern_loop                           equ $+1
                                                ld hl,song_ChB_trackList_loop
                                                ld c,(hl)
                                                inc c
_ChB_pattern_noloop
                                        inc hl
                                        ld sp,hl
                                    endif
                                    pop hl
                                    ld (_var_ChB_pattern_pos),sp
                                    ld (_var_ChB_data_pos),hl
_ChB_readTrack
                                djnz _ChB_trackWait
                                    dec c
                                    ld b,(hl)
                                    inc hl
                                    ld sp,hl
                                    srl b
                                    jr c,_ChB_trackSave
    
                                        srl b
                                        jr nc,_ChB_readTrack_noNote
                                            inc sp
                                            ld a,(hl)
                                            add a,a
                                            jr nc,_var_ChB_noInstrument
                                                pop hl
                                                ld (_var_ChB_lastIntrument),hl
_var_ChB_noInstrument
_var_ChB_lastIntrument                      equ $+2
                                            ld ix,_azm_instrument0
                                            if _azp_cnf_ChB_transpose
_var_ChB_transpose                              equ $+1
                                                add a,0
                                            endif
                                            ld (_var_ChB_note),a
                                            if _azp_cnf_ChB_trackPitch
                                                ld de,0 ; reset trackPitch
                                            endif
_ChB_readTrack_noNote
                                        srl b
                                        if _azp_cnf_ChB_trackPitch
                                            jr nc,_ChB_readTrack_noPitch
                                                pop hl
                                                ld (_var_ChB_pitch_step),hl
_ChB_readTrack_noPitch
                                        endif
                                        if _azp_cnf_ChB_trackVolume
                                            srl b
                                            jr nc,_ChB_readtrack_noVolume
                                                ld a,b
                                                ld (_var_ChB_volume),a
_ChB_readtrack_noVolume
                                        endif
                                        ld b,2  ; wait one tick until next track read 
_ChB_trackSave
                                        ld (_var_ChB_data_pos),sp
_ChB_trackWait
                                    ld (_var_ChB_triggers),bc
                                endif
;;*** Play instrument **********************************************************
                                ld sp,ix
                                pop bc
                                ; B = Amplitude|LOOP|TP
                                ; C = Arp
            
                                if _azp_cnf_ChB_trackPitch
                                    ; With Track Pitch
_var_ChB_pitch_step                 equ $+1
                                    ld hl,0
                                    add hl,de
                                    ld (_var_ChB_pitch_level),hl
                                    if _azp_cnf_ChB_trackPitchFP and 1
                                        sra h:rr l
                                    endif
                                    if _azp_cnf_ChB_trackPitchFP and 2
                                        sra h:rr l
                                    endif
                                
_var_ChB_note                       equ $+1
                                    if _azp_cnf_ChB_arpeggio
                                        ld a,0  ; Current note key
                                        add a,c ; Add arpeggio
                                        ld d,_lut_note_periods / 256
                                        ld e,a
                                    else
                                        ld de,_lut_note_periods
                                    endif
                                    ld a,(de)   ; Lookup the note period
                                    add a,l     ; and add Track Pitch
                                    ld l,a
                                    inc e
                                    ld a,(de)
                                    adc a,h
                                    ld h,a
                                else
                                    ; Without Track Pitch
_var_ChB_note                       equ $+1
                                    if _azp_cnf_ChB_arpeggio
                                        ld a,0  ; Current note key
                                        add a,c ; Add arpeggio
                                        ld h,_lut_note_periods / 256
                                        ld l,a
                                    else
                                        ld hl,_lut_note_periods
                                    endif
                                    ld e,(hl)   ; And lookup the note period
                                    inc l
                                    ld d,(hl)
                                    ex de,hl  
                                endif
                                ; TP
                                srl b
                                if _azp_cnf_ChB_tonePitch
                                    jr nc,_ChB_sound_noTonePitch
                                        pop de
                                        add hl,de
_ChB_sound_noTonePitch
                                endif
                                ld (_var_psg_ChB_tonePeriod),hl

                                exx
                                pop bc
                                ; B = Mixer.4
                                ; C = Noise.5|ENV
                                if _azp_cnf_ChC_global
                                    if _azp_cnf_ChA_global
                                        ld a,h
                                        add a,a
                                        or b
                                    else
                                        ld a,h
                                        add a,a
                                        or b
                                        add a,a
                                        or %1001
                                    endif
                                else
                                    if _azp_cnf_ChA_global
                                        ld a,%10010
                                        or b
                                    else
                                        ld a,b
                                        add a,a
                                        or %101101
                                    endif
                                endif
                                ld h,a
                                srl c
                                if _azp_cnf_ChB_noise
                                    jr z,$+3
                                        ld l,c
                                endif
                                exx
                                if _azp_cnf_ChB_env
                                    jr c,_ChB_sound_enveloppe
                                endif
                                    ; Sound with fixed 4bit amplitude
                                    ld a,b
                                    sra a
                                    if _azp_cnf_ChB_trackVolume
_var_ChB_volume                         equ $+1
                                        sub 0
                                        jr nc,$+3
                                            xor a
                                        ; LOOP
                                        rr b
                                    endif
                                if _azp_cnf_ChB_env
                                    jr _ChB_soundtick_done

_ChB_sound_enveloppe
                                    dec sp
                                    pop af
                                    add a,a ;EP
                                    if _azp_cnf_ChB_envPitch
                                        ld de,0
                                        jr nc,$+3
                                            pop de
                                    endif
                                    ld (_ChB_var_envDiv),a
_ChB_var_envDiv                     equ $+1
                                    jr $
                                    srl h:rr l  ; /128
                                    srl h:rr l  ; /64
                                    srl h:rr l  ; /32
                                    srl h:rr l  ; /16
                                    srl h:rr l  ; /8
                                    srl h:rr l  ; /4
                                    srl h:rr l  ; /2
                                    jr nc,$+3
                                      inc hl
                                    
                                    if _azp_cnf_ChB_envPitch
                                        add hl,de
                                    endif
                                    ld (_var_psg_envPeriod),hl
                                    ld a,b
                                    sra a
                                    ld (_var_psg_env_shape),a
                                endif
_ChB_soundtick_done
                                ld (_var_psg_ChB_amplitude),a
                                jr nc,$+2+1+1
                                    pop hl
                                    ld sp,hl
                                
                                ld (_var_ChB_sound_pos),sp
                            endif
                        
;*** CHANNEL A *****************************************************************

                        if _azp_cnf_ChA_global
        
_var_ChA_sound_pos          equ $+2
                            ld ix,_azm_instrument0

                            if _azp_cnf_ChA_trackPitch
_var_ChA_pitch_level            equ $+1
                                ld de,0
                            endif
            
                            if _azp_cnf_ChA_tracker
            
_var_ChA_data_pos                   equ $+1
                                    ld hl,0

_var_ChA_triggers                   equ $+1
                                    ld bc,&0100
            
                                    ;Preset next track
                                    xor a
                                    or c
                                    jr nz,_ChA_readTrack
                                        if _azp_cnf_ChA_transpose
_var_ChA_pattern_pos                        equ $+1
                                            ld sp,song_chA_trackList
                                            pop hl
                                            inc l
                                            jr nz,_ChA_pattern_noloop
_var_ChA_pattern_loop                           equ $+1
                                                ld sp,song_chA_trackList_loop
                                                pop hl
                                                inc l
_ChA_pattern_noloop
                                            ld a,h
                                            ld (_var_ChA_transpose),a
                                            ld c,l
                                        else
_var_ChA_pattern_pos                        equ $+1
                                            ld hl,song_ChA_trackList
                                            ld c,(hl)
                                            inc c
                                            jr nz,_ChA_pattern_noloop
_var_ChA_pattern_loop                           equ $+1
                                                ld hl,song_ChA_trackList_loop
                                                ld c,(hl)
                                                inc c
_ChA_pattern_noloop
                                        inc hl
                                        ld sp,hl
                                    endif
                                    pop hl
                                    ld (_var_ChA_pattern_pos),sp
                                    ld (_var_ChA_data_pos),hl
_ChA_readTrack
                                djnz _ChA_trackWait
                                    dec c
                                    ld b,(hl)
                                    inc hl
                                    ld sp,hl
                                    srl b
                                    jr c,_ChA_trackSave
    
                                        srl b
                                        jr nc,_ChA_readTrack_noNote
                                            inc sp
                                            ld a,(hl)
                                            add a,a
                                            jr nc,_var_ChA_noInstrument
                                                pop hl
                                                ld (_var_ChA_lastIntrument),hl
_var_ChA_noInstrument
_var_ChA_lastIntrument                      equ $+2
                                            ld ix,_azm_instrument0
                                            if _azp_cnf_ChA_transpose
_var_ChA_transpose                              equ $+1
                                                add a,0
                                            endif
                                            ld (_var_ChA_note),a
                                            if _azp_cnf_ChA_trackPitch
                                                ld de,0 ; reset trackPitch
                                            endif
_ChA_readTrack_noNote
                                        srl b
                                        if _azp_cnf_ChA_trackPitch
                                            jr nc,_ChA_readTrack_noPitch
                                                pop hl
                                                ld (_var_ChA_pitch_step),hl
_ChA_readTrack_noPitch
                                        endif
                                        if _azp_cnf_ChA_trackVolume
                                            srl b
                                            jr nc,_ChA_readtrack_noVolume
                                                ld a,b
                                                ld (_var_ChA_volume),a
_ChA_readtrack_noVolume
                                        endif
                                        ld b,2  ; wait one tick until next track read 
_ChA_trackSave
                                        ld (_var_ChA_data_pos),sp
_ChA_trackWait
                                    ld (_var_ChA_triggers),bc
                                endif
;;*** Play instrument **********************************************************
                                ld sp,ix
                                pop bc
                                ; B = Amplitude|LOOP|TP
                                ; C = Arp
            
                                if _azp_cnf_ChA_trackPitch
                                    ; With Track Pitch
_var_ChA_pitch_step                 equ $+1
                                    ld hl,0
                                    add hl,de
                                    ld (_var_ChA_pitch_level),hl
                                    if _azp_cnf_ChA_trackPitchFP and 1
                                        sra h:rr l
                                    endif
                                    if _azp_cnf_ChA_trackPitchFP and 2
                                        sra h:rr l
                                    endif
                                
_var_ChA_note                       equ $+1
                                    if _azp_cnf_ChA_arpeggio
                                        ld a,0  ; Current note key
                                        add a,c ; Add arpeggio
                                        ld d,_lut_note_periods / 256
                                        ld e,a
                                    else
                                        ld de,_lut_note_periods
                                    endif
                                    ld a,(de)   ; Lookup the note period
                                    add a,l     ; and add Track Pitch
                                    ld l,a
                                    inc e
                                    ld a,(de)
                                    adc a,h
                                    ld h,a
                                else
                                    ; Without Track Pitch
_var_ChA_note                       equ $+1
                                    if _azp_cnf_ChA_arpeggio
                                        ld a,0  ; Current note key
                                        add a,c ; Add arpeggio
                                        ld h,_lut_note_periods / 256
                                        ld l,a
                                    else
                                        ld hl,_lut_note_periods
                                    endif
                                    ld e,(hl)   ; And lookup the note period
                                    inc l
                                    ld d,(hl)
                                    ex de,hl  
                                endif
                                ; TP
                                srl b
                                if _azp_cnf_ChA_tonePitch
                                    jr nc,_ChA_sound_noTonePitch
                                        pop de
                                        add hl,de
_ChA_sound_noTonePitch
                                endif
                                ld (_var_psg_ChA_tonePeriod),hl

                                exx
                                pop bc
                                ; B = Mixer.4
                                ; C = Noise.5|ENV
                                if _azp_cnf_ChB_global OR _azp_cnf_ChC_global
                                    ld a,h
                                    add a,a
                                    or b
                                else
                                    ld a,%110110
                                    or b
                                endif
                                ld h,a
                                srl c
                                if _azp_cnf_ChA_noise
                                    jr z,$+3
                                        ld l,c
                                endif
                                exx
                                if _azp_cnf_ChA_env
                                    jr c,_ChA_sound_enveloppe
                                endif
                                    ; Sound with fixed 4bit amplitude
                                    ld a,b
                                    sra a
                                    if _azp_cnf_ChA_trackVolume
_var_ChA_volume                         equ $+1
                                        sub 0
                                        jr nc,$+3
                                            xor a
                                        ; LOOP
                                        rr b
                                    endif
                                if _azp_cnf_ChA_env
                                    jr _ChA_soundtick_done

_ChA_sound_enveloppe
                                    dec sp
                                    pop af
                                    add a,a ;EP
                                    if _azp_cnf_ChA_envPitch
                                        ld de,0
                                        jr nc,$+3
                                            pop de
                                    endif
                                    ld (_ChA_var_envDiv),a
_ChA_var_envDiv                     equ $+1
                                    jr $
                                    srl h:rr l  ; /128
                                    srl h:rr l  ; /64
                                    srl h:rr l  ; /32
                                    srl h:rr l  ; /16
                                    srl h:rr l  ; /8
                                    srl h:rr l  ; /4
                                    srl h:rr l  ; /2
                                    jr nc,$+3
                                      inc hl
                                    
                                    if _azp_cnf_ChA_envPitch
                                        add hl,de
                                    endif
                                    ld (_var_psg_envPeriod),hl
                                    ld a,b
                                    sra a
                                    ld (_var_psg_env_shape),a
                                endif
_ChA_soundtick_done
                                ld (_var_psg_ChA_amplitude),a
                                jr nc,$+2+1+1
                                    pop hl
                                    ld sp,hl
                                
                                ld (_var_ChA_sound_pos),sp
                            endif
                            
;;******************************************************************************

                            ; Set Mixer and Noise period values
                            exx
                            ld (_var_psg_r6r7),hl
                            ; Restore regular stack pointer
_var_env_sp                 equ $+1
                            ld sp,0
                            ret
;        list
;;[AZ Player] End
;        nolist
;; I'm really swearing and cursing fucking too much lately... I should take a
;; break and watch a few more George Carlin shows.
