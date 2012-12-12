 output bootstrap.o

BOOTLOADER = 0x8000
DEMO = 0x200

    org BOOTLOADER
 
 
    ld hl, 0xc9fb
    ld (0x38), hl
    ;di ;: ld sp, 0x100

   ; push  iy
    ld hl, data
    ld de, DEMO
    call deexo
  ;  pop iy

blabla
    call DEMO



    include src/deexo.asm
data
    incbin revision.exo


;    assert $<0xa000
;    assert $-BOOTLOADER <= 3968
