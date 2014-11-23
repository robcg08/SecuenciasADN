section .data
	msg_cantidad: db "Ingrese la cantidad de bases de ADN a crear: ",0
	msg_cantidad_len: equ $ - msg_cantidad
	msg_nombre_arc: db "Ingrese el nombre del archivo:  ",0
	string: db "%s",0
	int: db "%d",0
	extension: db ".adn",0
	new_line : db "",10,0
	
section .bss
	cantidad: resb 1000	
	nombre: resb 200
	cadena: resb 1000000
	
section .text
	extern printf
	extern srand
	extern time
	extern rand
	extern scanf
	global main

main:
	push msg_cantidad
	call printf
	add esp,4

	push cantidad
	push int
	call scanf
	add esp,8

	push msg_nombre_arc
	call printf
	add esp,4
	
	push nombre
	push string
	call scanf
	add esp,8
	
	xor edx,edx
	xor ecx,ecx
	mov ecx,10

generar_adn:
	xor ecx,ecx
	push 0
	call time
	add esp,4
	
	push eax
	call srand
	add esp,4
	
	.ciclo:
		
		cmp esi,[cantidad]
		je .imprimir
		
		.random:
			push ebp
			mov ebp,esp
			
			mov ecx,29
			push ecx
			call rand
			pop ecx
			shr eax,cl
			
			mov esp, ebp
			pop ebp
			
		.agregar_cadena:
			cmp eax,0
			je .agregar_A
			
			cmp eax,1
			je .agregar_C
			
			cmp eax,2
			je .agregar_G
			
			cmp eax,3
			je .agregar_T
			
			.seguir:
				inc esi 	
				loop .ciclo
			
			.agregar_A:
				mov byte [cadena+esi],"A"
				jmp .seguir
			
			.agregar_C:
				mov byte [cadena+esi],"C"
				jmp .seguir
				
			.agregar_G:
				mov byte [cadena+esi],"G"
				jmp .seguir
				
			.agregar_T:
				mov byte [cadena+esi],"T"
				jmp .seguir
		
		.imprimir:
		
			mov eax,4
			mov ebx,1
			mov ecx,cadena
			mov edx,1000000
			int 80h
			
			push new_line
			call printf
			add esp,4
			
crear_archivo: 	
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	
	.ciclo2:
		mov al, byte[nombre+ecx]
		cmp al,0
		je .agregar_extension
		jne .seguir
	
	.agregar_extension:
		mov edx,[extension]
		mov [nombre+ecx],edx
		
		jmp .guardar_archivo
		
	.seguir:
		inc ecx
		jmp .ciclo2
	
	.guardar_archivo:
		mov eax, 8
		mov ebx, nombre
		mov ecx, 0x0777
		int 80h
		
		mov ebx, eax
		mov eax, 4
		mov ecx, cadena
		mov edx, [cantidad]
		int 80h
		
		mov eax, 6
		int 80h

salir:
	mov eax,1
	mov ebx,0
	int 80h

