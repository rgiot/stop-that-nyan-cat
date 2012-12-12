; File: firmware_tunnel.asm
; Author: Krusty/Benediction
; Description: Firmware way to compute the tunnel maps


TUNNEL_DATA_ADDRESSES equ 0xc000
TUNNEL_WIDTH equ 52
TUNNEL_HEIGHT equ 38

    org 0x4000
    output firmware_tunnel.o


tunnel_build_data
    

    ; Loop among all the lines
    ld a, TUNNEL_HEIGHT
tunnel_build_data_vertical_loop
        push af

        ; Loop among all the columns
        dup TUNNEL_WIDTH
        edup



        pop af
        dec a
        jp nz, tunnel_build_data_vertical_loop

    ret



; Pointer to the data to store
tunnel_build_data_buffer_address dw TUNNEL_DATA_ADDRESSES


