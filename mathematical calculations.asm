.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

sir DB 50 dup(0)
v_ap DB 50 dup(0)
n DD ?
l EQU $ - v_ap
format DB "%d",0
format_d DB "%d",0
formatp DB "%d, ", 0
formatp1 DB "Scrie cate numere citesti ", 0
min DB 0
max DB 0
msj_medie db "Ai ales media",10, 13, 0
msj_min_max db "Ai ales min_max", 10, 13, 0
msj_max db "Maximul este %d",10, 13, 0
msj_min db "Minimul este %d",10, 13, 0
msj_op db 13,10,"Alege operatia ", 10, 13, 0
msj_histograma db 10, 13,"Ai ales histograma", 10, 13, 0
msj_elimina_sir db "Ai ales eliminarea sirului.", 10, 13, 0
operatia db "%d", 10, 13, 0
.code
start:
	;aici se scrie codul
	
	mov esi, 0
  
     pusha
	push offset formatp1
	call printf
	add esp, 4
	popa
	
	pusha
	push offset n
	push offset format
	call scanf
	add esp, 8
	popa
	
	mov ecx, 0
	mov ecx, n
	mov esi, 0
	mov eax, 0
	
	; push n
	; push offset formatp
	; call printf
	; add esp, 8
	
	l1:
	
	lea eax, sir
	add eax, esi
	
	pusha
	push eax
	push offset format
	call scanf
	add esp, 8
	popa
	
	inc esi
	loop l1
	
	mov ecx, 0
	mov ecx, n
	mov esi, 0
	mov eax, 0
	
	l2:
	
	mov al, [sir + esi]
	; add eax, esi
	
	pusha
	push eax
	push offset formatp
	call printf
	add esp, 8
	popa
	
	inc esi
	loop l2

	

 pusha
 push offset msj_op
 call printf
 add esp, 4
 popa
 
 pusha
 push offset operatia
 push offset format_d
 call scanf
 add esp, 8
 popa
 
cmp operatia, 1
je minim_maxim

cmp operatia, 2
je histograma

cmp operatia, 3
je media

cmp operatia, 4
je deviatia_standard

cmp operatia, 5
je elimina_sir

minim_maxim:
pusha
push offset msj_min_max
call printf
add esp, 4
jmp minim__max
popa

minim__max:
    xor eax, eax
    mov ax, 0 ; al-minim, ah-maxim
    mov esi, 0
	
    mov al, sir[esi]
    mov ah, sir[esi]
	
 et_loop:
    cmp al, sir[esi]
    JB cmp_max
	mov al, sir[esi]
	cmp_max:
	cmp ah, sir[esi]
	ja urmator
	mov ah, sir[esi]
	urmator:
	inc esi
	mov cl, sir[esi]	
    cmp cl,0
	jne et_loop
	mov max, ah ;pt ca e un byte
    mov min, al 
	
	mov eax, 0
	mov ebx, 0
	
    mov al, max
	
    
	
	
	; pusha
    push eax
	push offset msj_max
	call printf
	add esp, 8
	; popa
	mov bl, min
	pusha
    push ebx 
	push offset msj_min
	call printf
	add esp, 8
	popa

histograma:
pusha
push offset msj_histograma
call printf
add esp, 4
jmp histograma_
popa

histograma_:
	mov eax, 0
	mov ecx, n
	mov ESI, 0
	l21:
	mov eax, 0
	mov al,  sir[ESI]
	
	inc byte ptr [v_ap + eax] 
	
	inc esi
	mov al, sir[esi]
	loop l21
	
	mov ecx, 50
	mov esi, 0
	l51:
	pusha
	mov eax, 0
	mov al, v_ap[esi]
	push eax
	push offset formatp
	call printf
	add esp, 8
	popa
	inc esi
	loop l51
	
	
	
media:
pusha
push offset msj_medie
call printf
add esp, 4
jmp media_
popa
media_:

    mov esi,0
    mov edx,0
    mov edx, n
    mov eax,0
	
    eticheta:
    add al, sir[esi]
	mov ebx, eax
    inc esi
    cmp esi,edx
    JB eticheta
	
	
	push ebx
	push offset format
	call printf
	add esp, 8
	
    

deviatia_standard:
    
    mov esi, 0        
    mov eax, 0       
    mov edx, n        

    ds_calc_loop:
        movzx ebx, byte ptr [sir + esi] 
        add eax, ebx                     

        inc esi
        cmp esi, edx
        jb ds_calc_loop

   
    mov ebx, n
    cdq               
    idiv ebx           

    mov esi, 0        
    mov ecx, 0        

    ds_dev_loop:
        movzx ebx, byte ptr [sir + esi] 
        sub ebx, eax                     
        imul ebx, ebx                   
        add ecx, ebx                    
        inc esi
        cmp esi, edx
        jb ds_dev_loop

    mov ebx, n
    cdq
    idiv ebx           

    fsqrt              

    push eax
    push offset format_d
    call printf
    add esp, 8

    jmp exiit          
elimina_sir:
    mov n, 0 
    pusha
    push offset 

    call printf
    add esp, 4
    popa
exiit:
    
	push 0
	call exit
end start
