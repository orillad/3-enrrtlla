; ---------------------------------------------------------------
; Nom alumne 1: Oriol Lladó Real
; Grup Pràctiques: PR-AVA(2)
; ---------------------------------------------------------------
PANTALLA    EQU     0A000h
TECLAT      EQU     0B000h

SCREEN_WIDTH  EQU 15
BASE_OFFSET   EQU 64
ORIGEN      100h
INICIO      INICI

.DATOS
fila1       VALOR   0, 0, 0
fila2       VALOR   0, 0, 0
fila3       VALOR   0, 0, 0

tauler_txt1   VALOR "COL 123", 0
tauler_txt2   VALOR "F 1", 0
tauler_txt3   VALOR "I 2", 0
tauler_txt4   VALOR "L 3", 0
tauler_color_fons VALOR "   ", 0


tornJugador1  VALOR "TORN JUGADOR 1", 0
tornJugador2  VALOR "TORN JUGADOR 2", 0

selectColumn  VALOR "ESCRIU COL", 0
selectFila    VALOR "ESCRIU FILA", 0

guanyJugador1 VALOR "GUANYADOR JUGADOR 1", 0
guanyJugador2 VALOR "GUANYADOR JUGADOR 2", 0

col_full_txt VALOR "COL. PLENA", 0
fila_full_txt VALOR "FILA PLENA", 0
casella_ocupada_txt VALOR "CAS. OCUPADA", 0

tauler_x VALOR "X", 0
tauler_o VALOR "O", 0
.CODIGO
INICI:                      ; Programa principal
    CALL    neteja_pantalla  ; Neteja pantalla
    CALL    neteja_teclat    ; Neteja teclat
    CALL    pintar_tauler    ; Pintar tauler
    CALL    tornJug1         ; Torn jugador 1

; Neteja pantalla
neteja_pantalla:
    PUSH    R0
    PUSH    R1

    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA

    MOVH    R1, 00h
    MOVL    R1, 120
    ADD     R0, R0, R1

    MOVH    R1, 11111111b
    MOVL    R1, 11111111b
    MOV     [R0], R1

    POP     R1
    POP     R0
    RET

; Neteja teclat
neteja_teclat:
    PUSH    R1
    PUSH    R2

    XOR     R0, R0, R0
    MOVH    R1, BYTEALTO TECLAT
    MOVL    R1, BYTEBAJO TECLAT
    INC     R1

    MOVH    R2, 00h
    MOVL    R2, 00000100b
    MOV     [R1], R2

    POP     R2
    POP     R1
    RET

; Pintar tauler amb desplaçament de 3 files
pintar_tauler:
    PUSH    R0
    PUSH    R1
    PUSH    R2

    ; --- Preparar punter de pantalla a PANTALLA[0] ---
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA

    ; Desplaçar el tauler 3 files cap avall (15 cols * 3 = 45 bytes = 2Dh)
    MOVH    R2, 00h
    MOVL    R2, 2Dh
    ADD     R0, R0, R2

    ; --- Línia 0: capçalera "COL 1 2 3" ---
    MOVH    R1, BYTEALTO DIRECCION tauler_txt1
    MOVL    R1, BYTEBAJO DIRECCION tauler_txt1
    CALL    print_string

    ; Salt a la següent línia
    MOVH    R2, 00h
    MOVL    R2, 09h
    ADD     R0, R0, R2

    ; --- Línia 1: fila F ---
    MOVH    R1, BYTEALTO DIRECCION tauler_txt2
    MOVL    R1, BYTEBAJO DIRECCION tauler_txt2
    CALL    print_string

    MOVH   R1, BYTEALTO DIRECCION tauler_color_fons
    MOVL   R1, BYTEBAJO DIRECCION tauler_color_fons
    CALL    print_fons

    ; Salt a la següent línia
    MOVH    R2, 00h
    MOVL    R2, 09h
    ADD     R0, R0, R2

    ; --- Línia 2: fila I ---
    MOVH    R1, BYTEALTO DIRECCION tauler_txt3
    MOVL    R1, BYTEBAJO DIRECCION tauler_txt3
    CALL    print_string

    MOVH   R1, BYTEALTO DIRECCION tauler_color_fons
    MOVL   R1, BYTEBAJO DIRECCION tauler_color_fons
    CALL    print_fons
    

    ; Salt a la següent línia
    MOVH    R2, 00h
    MOVL    R2, 09h
    ADD     R0, R0, R2

    ; --- Línia 3: fila L ---
    MOVH    R1, BYTEALTO DIRECCION tauler_txt4
    MOVL    R1, BYTEBAJO DIRECCION tauler_txt4
    CALL    print_string

    MOVH   R1, BYTEALTO DIRECCION tauler_color_fons
    MOVL   R1, BYTEBAJO DIRECCION tauler_color_fons
    CALL    print_fons

    POP     R2
    POP     R1
    POP     R0
    RET

print_string:
repeteix:
    MOV     R2, [R1]        ; R2 = byte ASCII
    OR      R2, R2, R2      ; comprova zero
    BRZ     fi_string       ; si és zero, sortim

    MOVH    R2, 00000111b   ; color fons/text
    MOV     [R0], R2        ; escric a pantalla
    INC     R0
    INC     R1
    JMP     repeteix

print_fons:
repeteix_fons:
    MOV     R2, [R1]        ; R2 = byte ASCII
    OR      R2, R2, R2      ; comprova zero
    BRZ     fi_string       ; si és zero, sortim

    MOVH    R2, 01111111b         ; color fons/text
    MOV     [R0], R2        ; escric a pantalla
    INC     R0
    INC     R1
    JMP     repeteix_fons



end_place:
    ; Pintar missatge "TORN JUGADOR 2"
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 00h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION tornJugador2
    MOVL    R1, BYTEBAJO DIRECCION tornJugador2
    CALL    print_string

    ; Pintar tauler
    CALL    pintar_tauler


fi_string:
    RET


read_teclat:
    PUSH    R1              ; salvar R1

    ; carregar adreça base del teclat
    MOVH    R1, BYTEALTO TECLAT
    MOVL    R1, BYTEBAJO TECLAT

wait_key:
    ; poll del registre de dades
    MOV     R2, [R1]        ; R2 = scancode<<8 | ASCII
    OR      R2, R2, R2      
    BRZ     wait_key        ; cap tecla, continuar esperant

    ; aislar només el byte baix (codi ASCII)
    MOVH    R2, 0           ; ara R2 = 0<<8 | ASCII

    ; comparar amb '1'
    MOVH    R3, 0
    MOVL    R3, '1'
    COMP    R2, R3
    BRZ     got_key

    ; comparar amb '2'
    MOVL    R3, '2'
    COMP    R2, R3
    BRZ     got_key

    ; comparar amb '3'
    MOVL    R3, '3'
    COMP    R2, R3
    BRZ     got_key

    ; no és 1,2 ni 3 → tornar a esperar
    JMP     wait_key

got_key:
    ; R2 conté ara el codi ASCII de '1'/'2'/'3'
    POP     R1              ; restaurar R1
    RET                     ; retornar amb R2 = tecla vàlida






tornJug1:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    MOVL    R0, 0           ; inicialitza R0 a 0 des del principi
    
    ; pinta prompt "Torn del jugador 1"
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 00h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION tornJugador1
    MOVL    R1, BYTEBAJO DIRECCION tornJugador1
    CALL    print_string

    ; demana columna
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 10h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION selectColumn
    MOVL    R1, BYTEBAJO DIRECCION selectColumn
    CALL    print_string
    CALL    read_teclat       ; retorna ASCII a R2
    MOV     R5, R2            ; columna ASCII

    ; demana fila
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 10h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION selectFila
    MOVL    R1, BYTEBAJO DIRECCION selectFila
    CALL    print_string
    CALL    read_teclat       ; retorna ASCII a R2
    MOV     R4, R2            ; fila ASCII


        MOVL  R1, '1'                 ; R1 ← 1
        COMP  R4, R1                ; compara R4 amb 1
        BRNZ   p1_base_fila1            ; si R4=1, salta a p1_base_fila1
        MOVL  R1, '2'                 ; R1 ← 2
        COMP  R4, R1                ; compara R4 amb 2
        BRNZ   p1_base_fila2            ; si R4=2, salta a p1_base_fila2
p1_base_fila3:
        MOVH  R6, BYTEALTO DIRECCION fila3
        MOVL  R6, BYTEBAJO DIRECCION fila3
        JMP   after_p1_base
p1_base_fila1:
        MOVH  R6, BYTEALTO DIRECCION fila1
        MOVL  R6, BYTEBAJO DIRECCION fila1

        JMP   after_p1_base
p1_base_fila2:
        MOVH  R6, BYTEALTO DIRECCION fila2
        MOVL  R6, BYTEBAJO DIRECCION fila2
        
after_p1_base:
        ; -------- 2) Desplaçament fins a la columna --------
    ; ---- 2) Desplaçament fins a la columna (version millorada) ----

    ; suposem que R5 conté l’ASCII de la columna ('1'..'3')
    MOV    R2, R5        ; R2 ← ASCII de columna
    MOVH   R1, 00h
    MOVL   R1, 30h       ; R1 ← 0x30
    SUB    R2, R2, R1    ; R2 ← R2 - R1 = columna_num (1..3)
    DEC    R2            ; R2 = columna_num - 1 (0..2)

   ; ara R2 = columna-1 (0..2)
    col_loop_p1:

        BRZ   col_done_p1  ; si R2==0 hem avançat prou
        INC   R6           ; passem a la següent cel·la
        DEC   R2           ; R2--
        BRNZ  col_loop_p1  ; mentre R2≠0 seguim
    col_done_p1:

        ; -------- 3) Comprovació i escriptura d'un 1 ja que es el jugador 1 qui ha marcat -------
    ; -------- 3) COMPROVACIÓ I ESCRIPTURA DE LA MARCA --------
    
        ; 3.1) Carregar 0 a R1
        MOVL   R1, 0          ; ara R1 = 0

        ; 3.2) Llegir contingut de la casella
        MOV    R3, [R6]       ; R3 = valor memòria

        ; 3.3) Comparar amb 0
        COMP   R3, R1         ; R3–R1
        BRNZ   casella_ocupada ; si R3≠0 → ocupada

        ; 3.4) Si som aquí, la casella està lliure
        MOVL   R1, 1          ; R1 = 1
        MOV    [R6], R1       ; escrivim la marca del jugador

        CALL   pintar_x
        CALL   tornJug2       ; passem al següent torn




casella_ocupada:
    ; Pintar missatge "COL. PLENA"
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 10h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION casella_ocupada_txt
    MOVL    R1, BYTEBAJO DIRECCION casella_ocupada_txt
    CALL    print_string



    POP R1
    POP R2
    POP R0
    JMP    tornJug1  
    RET

         ; ----------------------------------------
         ; Funció: pintar_x
         ; Entrades: R4 = ASCII fila, R5 = ASCII columna
         ;            tauler_x → cadena amb la “X” acabada en 0
         ; ----------------------------------------

pintar_x:
        PUSH    R0
        PUSH    R1
        PUSH    R2
        PUSH    R6

        ;--- 1) Convertir ASCII → número (fila i columna) ---
        MOVH    R1, 00h
        MOVL    R1, 30h       ; R1 ← 0x0030
        SUB     R4, R4, R1    ; R4 ← fila_num = fila_ascii - '0'
        SUB     R5, R5, R1    ; R5 ← col_num  = col_ascii - '0'

        ;--- 2) Carregar base de memòria de pantalla en R6 ---
        MOVH    R6, BYTEALTO PANTALLA
        MOVL    R6, BYTEBAJO PANTALLA

        ;--- 3) Calcular offset de fila: fila_num * amplada ---
        MOVH    R1, 00h
        MOVL    R1, 15       ; R1 ← 21 (amplada de la pantalla)
        MOV     R2, R4        ; R2 ← fila_num
        CALL    multiplicar   ; R0 ← fila_num * 21

        ;--- 4) Construir adreça final: base + row_offset + col_num ---
        ADD     R0, R6, R0    ; R0 ← base + row_offset
        ADD     R0, R0, R5    ; R0 ← + col_num → adreça on pintar
        MOVH    R1, 00h
        MOVL    R1, 30h       ; R1 ← 0
        ADD     R0, R0, R1 ; R0 ← + 30h (desplaçament de 3 files)

        ;--- 5) Preparar apuntador a la cadena “X” i cridar print_x ---
        MOVH    R1, BYTEALTO DIRECCION tauler_x
        MOVL    R1, BYTEBAJO DIRECCION tauler_x
        CALL    print_x

        ;--- 6) Restaurar registres i tornar ---
        POP     R6
        POP     R2
        POP     R1
        POP     R0
        RET
torn_jug1_tramp:
; Torn del jugador 1
call   tornJug1
; ----------------------------------------
; Multiplicació per suma repetida:
;   Arguments: R1 = multiplicand, R2 = copes
;   Retorn:    R0 = R1 * R2
; ----------------------------------------
multiplicar:
        XOR     R0, R0, R0    ; R0 ← 0
mult:
        ADD     R0, R0, R1    ; R0 += R1
        DEC     R2            ; R2--
        BRNZ    mult          ; si R2 ≠ 0, repetir
        RET



print_string2:
repeteix2:
    MOV     R2, [R1]        ; R2 = byte ASCII
    OR      R2, R2, R2      ; comprova zero
    BRZ     fi_string2       ; si és zero, sortim

    MOVH    R2, 00000111b   ; color fons/text
    MOV     [R0], R2        ; escric a pantalla
    INC     R0
    INC     R1
    JMP     repeteix2

fi_string2:
    RET

print_x:
repeteix_x:
    MOV     R2, [R1]        ; R2 = byte ASCII
    OR      R2, R2, R2      ; comprova si és zero
    BRZ     fi_x       ; si és zero, sortim

    MOVH    R2, 01111100b   ; munta el byte alt amb color fons/text
    MOV     [R0], R2        ; escric a pantalla
    INC     R0              ; avanço columna
    INC     R1              ; avanço byte de text
    JMP     repeteix_x

fi_x:
    RET        


print_o:
repeteix_o:
    MOV     R2, [R1]        ; R2 = byte ASCII
    OR      R2, R2, R2      ; comprova si és zero
    BRZ     fi_o       ; si és zero, sortim

    MOVH    R2, 01111001b   ; munta el byte alt amb color fons/text
    MOV     [R0], R2        ; escric a pantalla
    INC     R0              ; avanço columna
    INC     R1              ; avanço byte de text
    JMP     repeteix_o

fi_o:
    RET    







tornJug2:
    PUSH    R0
    PUSH    R1
    PUSH    R2

    ; pinta prompt
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 00h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION tornJugador2
    MOVL    R1, BYTEBAJO DIRECCION tornJugador2
    CALL    print_string2

    ; demana columna
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 10h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION selectColumn
    MOVL    R1, BYTEBAJO DIRECCION selectColumn
    CALL    print_string2
    CALL    read_teclat2       ; retorna ASCII a R2
    MOV     R5, R2           ; columna ASCII

    ; demana fila
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 10h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION selectFila
    MOVL    R1, BYTEBAJO DIRECCION selectFila
    CALL    print_string2
    CALL    read_teclat2       ; retorna ASCII a R2
    MOV     R4, R2           ; fila ASCII


        MOVL  R1, '1'                 ; R1 ← 1
        COMP  R4, R1                ; compara R4 amb 1
        BRZ   P2_base_fila1            ; si R4=1, salta a P2_base_fila1
        MOVL  R1, '2'                 ; R1 ← 2
        COMP  R4, R1                ; compara R4 amb 2
        BRZ   P2_base_fila2            ; si R4=2, salta a P2_base_fila2
P2_base_fila3:
        MOVH  R6, BYTEALTO DIRECCION fila3
        MOVL  R6, BYTEBAJO DIRECCION fila3
        JMP   after_P2_base
P2_base_fila1:
        MOVH  R6, BYTEALTO DIRECCION fila1
        MOVL  R6, BYTEBAJO DIRECCION fila1

        JMP   after_P2_base
P2_base_fila2:
        MOVH  R6, BYTEALTO DIRECCION fila2
        MOVL  R6, BYTEBAJO DIRECCION fila2
        
after_P2_base:
        ; -------- 2) Desplaçament fins a la columna --------
    ; ---- 2) Desplaçament fins a la columna (version millorada) ----

    ; suposem que R5 conté l’ASCII de la columna ('1'..'3')
    MOV    R2, R5        ; R2 ← ASCII de columna
    MOVH   R1, 00h
    MOVL   R1, 30h       ; R1 ← 0x30
    SUB    R2, R2, R1    ; R2 ← R2 - R1 = columna_num (1..3)
    DEC    R2            ; R2 = columna_num - 1 (0..2)

   ; ara R2 = columna-1 (0..2)
    col_loop_P2:

        BRZ   col_done_P2  ; si R2==0 hem avançat prou
        INC   R6           ; passem a la següent cel·la
        DEC   R2           ; R2--
        BRNZ  col_loop_P2  ; mentre R2≠0 seguim
    col_done_P2:

        ; -------- 3) Comprovació i escriptura d'un 1 ja que es el jugador 1 qui ha marcat -------
    ; -------- 3) COMPROVACIÓ I ESCRIPTURA DE LA MARCA --------
    
        ; 3.1) Carregar 0 a R1
        MOVL   R1, 0          ; ara R1 = 0

        ; 3.2) Llegir contingut de la casella
        MOV    R3, [R6]       ; R3 = valor memòria

        ; 3.3) Comparar amb 0
        COMP   R3, R1         ; R3–R1
        BRNZ   casella_ocupada2 ; si R3≠0 → ocupada

        ; 3.4) Si som aquí, la casella està lliure
        MOVL   R1, 2          ; R1 = 1
        MOV    [R6], R1       ; escrivim la marca del jugador

        CALL   pintar_o
        CALL   torn_jug1_tramp       ; passem al següent torn






pintar_o:
        PUSH    R0
        PUSH    R1
        PUSH    R2
        PUSH    R6

        ;--- 1) Convertir ASCII → número (fila i columna) ---
        MOVH    R1, 00h
        MOVL    R1, 30h       ; R1 ← 0x0030
        SUB     R4, R4, R1    ; R4 ← fila_num = fila_ascii - '0'
        SUB     R5, R5, R1    ; R5 ← col_num  = col_ascii - '0'

        ;--- 2) Carregar base de memòria de pantalla en R6 ---
        MOVH    R6, BYTEALTO PANTALLA
        MOVL    R6, BYTEBAJO PANTALLA

        ;--- 3) Calcular offset de fila: fila_num * amplada ---
        MOVH    R1, 00h
        MOVL    R1, 15       ; R1 ← 21 (amplada de la pantalla)
        MOV     R2, R4        ; R2 ← fila_num
        CALL    multiplicar   ; R0 ← fila_num * 21

        ;--- 4) Construir adreça final: base + row_offset + col_num ---
        ADD     R0, R6, R0    ; R0 ← base + row_offset
        ADD     R0, R0, R5    ; R0 ← + col_num → adreça on pintar
        MOVH    R1, 00h
        MOVL    R1, 30h       ; R1 ← 0
        ADD     R0, R0, R1 ; R0 ← + 30h (desplaçament de 3 files)

        ;--- 5) Preparar apuntador a la cadena “X” i cridar print_x ---
        MOVH    R1, BYTEALTO DIRECCION tauler_o
        MOVL    R1, BYTEBAJO DIRECCION tauler_o
        CALL    print_o
        

        ;--- 6) Restaurar registres i tornar ---
        POP     R6
        POP     R2
        POP     R1
        POP     R0
        RET

casella_ocupada2:
    ; Pintar missatge "COL. PLENA"
    MOVH    R0, BYTEALTO PANTALLA
    MOVL    R0, BYTEBAJO PANTALLA
    MOVH    R2, 00h
    MOVL    R2, 10h
    ADD     R0, R0, R2
    MOVH    R1, BYTEALTO DIRECCION casella_ocupada_txt
    MOVL    R1, BYTEBAJO DIRECCION casella_ocupada_txt
    CALL    print_string2
    JMP    tornJug2

read_teclat2:
    PUSH    R1              ; salvar R1

    ; carregar adreça base del teclat
    MOVH    R1, BYTEALTO TECLAT
    MOVL    R1, BYTEBAJO TECLAT

wait_key2:
    ; poll del registre de dades
    MOV     R2, [R1]        ; R2 = scancode<<8 | ASCII
    OR      R2, R2, R2      
    BRZ     wait_key2        ; cap tecla, continuar esperant

    ; aislar només el byte baix (codi ASCII)
    MOVH    R2, 0           ; ara R2 = 0<<8 | ASCII

    ; comparar amb '1'
    MOVH    R3, 0
    MOVL    R3, '1'
    COMP    R2, R3
    BRZ     got_key2

    ; comparar amb '2'
    MOVL    R3, '2'
    COMP    R2, R3
    BRZ     got_key2

    ; comparar amb '3'
    MOVL    R3, '3'
    COMP    R2, R3
    BRZ     got_key2

    ; no és 1,2 ni 3 → tornar a esperar
    JMP     wait_key2

got_key2:
    ; R2 conté ara el codi ASCII de '1'/'2'/'3'
    POP     R1              ; restaurar R1
    RET                     ; retornar amb R2 = tecla vàlida






FIN
