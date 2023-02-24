.model small
.stack 100h
.data

	; fn db "Score.txt",0
	; handle dw ?
	
	outer_x_background dw 10
	outer_y_background dw 10
	
	
	display_0 db "Enter your Name : $"
	name_of_player db 10 dup('$')
	
	display_1 db "Brick Breaker Game $"
	display_2 db "1.New Game$"
	display_3 db "2.Instruction$"
	display_4 db "3.High Score$"
	display_5 db "4.Exit$"
	
	
	Pause_dis db "PAUSE.........$"
	Blanking  db "                 $"
	
	
	
	WInner_ db "Congradulations",0Ah
			db "You have won :) $"
	
	
	ending_game db "*-*-*-*-*-*-*-*GAME OVER*-*-*-*-*-*-*-*$"
	
	instruction db 0Ah,0Ah,"*-*-*-*-*-*-*-**-*-*-*-*-*-*-*INSTRUCTION*-*-*-*-*-*-*-**-*-*-*-*-*-**",0Ah
				db "              Welcome to brick breakers.",0Ah,0AH
				db "       1. There are 3 levels to the game.",0Ah,0AH
				db "       2. The speed of the ball increases on each level.",0Ah,0AH
				db "       3. White bricks can not be broken.",0Ah,0AH
				db "       4. Each brick when broken atributes to your total score.",0Ah,0AH
				db "       5. You can move the paddle using the arrow keys.",0Ah,0AH
				db "       6. Press Esc key to pause screen.",0Ah,0AH
				db "       7. If you drop the ball you lose a life.",0Ah,0AH
				db "       8. If you lose all your lives you lose the game.",0Ah,0AH,0AH
				db "Thank you for playing our game :) ",0Ah,0AH
				db "Creaters : M.Abdur Rafey    Abher Ahmed ",0Ah
				db "Press any Key to continue.......$"
	
	temp dw 0
	temp2 db 0
	
	input db 0
	
	bytes dw 85
	buffer db 85 dup (?)
	noofbytes dw 30
	
	
	
	black_Linr db "          $"
	
	Level_display db "LeveL$"
	level_number db 1

	Score_display db "Score $"
	score_count db 0

	heart_display db "Lives $"
	heart_count dw 3
	
	background_x dw 0
	background_y dw 0
	
	game_border_x dw 25	;; 25 to 300	===> Game border px axis
	game_border_y dw 25	;; 25 to 190	===> Game border py axis
	
	loop_temp db 0
	
	px dw 150
    py dw 180
    paddlecount db 0
	paddlecount2 db 0
	
	; ball variables
	ballx dw 160
	bally dw 140
	bvx db 0
	bvy db 1
	
	;hit_array db 9
	;hi db 1
	
	exitvar db 0
	
	brick_start_x dw 35
	brick_start_y dw 35
	;temp db 0
	brick_display_temp_rows db 0
	brick_display_temp_cols db 0
	
	brick_color db 1
	
	;;brick colision array parts
	hit_array db 20 dup(1)
	
	random_number_for_level_3 db 0
	 
	game_end_for_heart db 1
	
	;; max paddle length
	
	maxplength dw 0
	
	;; file handling variables
	
	filename db "score.txt", 0
	handle dw 0
	str2 db "No Highscore Currently saved.", "$"
	inputbuffer db 100 dup("$")
	
	num dw 0
	
.code

	jmp main
	

openfile Proc
		
		mov ah, 3Dh
		mov al, 0
		mov dx, offset filename
		int 21h
		
		mov handle, ax
		
		.if(handle == 2)
			
			lea dx, str2
			mov ah, 09h
			int 21h
			
			mov ah, 02h
			mov dl, 10
			int 21h
			
			mov ah, 3Ch
			mov cx, 0
			mov dx, offset filename
			int 21h
			
		
		.else
			mov ah, 03Fh
			mov cx, 100
			lea dx, offset inputbuffer
			mov bx, handle
			int 21h
			
			; lea dx, str3
			; mov ah, 09h
			; int 21h
			
			mov si, offset inputbuffer
			
			.while(byte PTR[si] != "$")
				
				.if(byte PTR [si] == '#')
					mov ah, 02h
					mov dl, 10
					int 21h
				.else
					mov ah, 02h
					mov dl, [si]
					int 21h
				.endif
				
				inc si

			.endw
			
		
		.endif
		
		mov ah, 03Eh
		mov bx, handle
		int 21h
		
		
		ret
	
openfile endP
	
writefile Proc
		
		mov si, offset name_of_player
		
		mov cx, 0
		
		.while(byte PTR[si] != "$")
			
			
			inc si		
			inc cx
		
		.endw
		
		mov num, cx
		
		inc num
		
		;sub si, 1
		
		mov byte PTR[si], "#"
		
		; inc si
		
		; mov byte PTR[si], "$"
		
		mov ah, 3dh
		mov al, 2
		mov dx, offset filename
		int 21h
		
		mov handle, ax
		
		mov cx, 0
		mov dx, 0
		mov bx, handle
		mov al, 2
		mov ah, 42h
		int 21h
		
		
		lea dx, name_of_player
		mov bx, handle
		mov cx, num
		mov ah, 40h
		int 21h
		
		mov ah, 03Eh
		mov bx, handle
		int 21h
		
		ret
		
	
writefile endP




exit_screeen proc uses ax bx cx dx si di

		call background
		call border

		mov ah,02h
		mov bx,00h
		mov dh,10
		mov dl,0      ;ending_game
		int 10h

		lea dx,ending_game
		mov ah,09h
		int 21h
		
		call writefile
		
		mov ah,00h
		int 16h

		ret
exit_screeen endp	
	
defaulting proc
	
	mov level_number , 1
	mov score_count , 0
	mov heart_count , 3
	
	mov background_x , 0
	mov background_y , 0
	
	mov game_border_x , 25	;; 25 to 300	===> Game border px axis
	mov game_border_y , 25	;; 25 to 190	===> Game border py axis
	
	mov loop_temp , 0
	
	mov px , 150
    mov py , 180
    mov paddlecount , 0
	
	; ball variables
	mov ballx , 160
	mov bally , 140
	mov bvx , 0
	mov bvy , 1
	
	;hit_array db 9
	;hi db 1
	
	mov exitvar , 0
	
	mov brick_start_x , 35
	mov brick_start_y , 35
	;temp db 0
	mov brick_display_temp_rows , 0
	mov brick_display_temp_cols , 0
	
	mov brick_color, 1
	
	;;brick colision array parts
	mov cx,20
	mov si,0
	L1:
		mov hit_array[si],1
		inc si
	 loop L1
	 mov random_number_for_level_3,0
	
	 ret
defaulting endp	

background proc
			MOV AH, 06h 
			MOV AL, 0
			MOV CX, 0
			MOV DH, 80
			MOV DL, 80
			MOV BH, 2h
			INT 10h

	ret
background endp

line proc
		
		L1:
			inc cx
			int 10h
			dec temp2
		cmp temp2,0
		JNE L1
		mov temp2,0	
		ret
line endp	
	
border proc
		mov ah,0ch
		mov cx,outer_x_background
		mov dx,outer_y_background
		mov al,12
		L1:
			inc cx
			int 10h
		
			inc temp
		cmp temp,300
		JNE L1
		
		mov temp,00h
		
		L2:
			inc dx
			int 10h
		
			inc temp
		cmp temp,180
		JNE L2
		
		mov temp,00h
		
		L3:
			dec cx
			int 10h
		
			inc temp
		cmp temp,300
		JNE L3
		
		mov temp,00h
		
		L4:
			dec dx
			int 10h
		
			inc temp
		.if temp!=180
		JNE L4
		.endif
		
mov cx,00
mov dx,00		
	ret
border endp


border_12 proc
		mov ah,0ch
		mov cx,outer_x_background
		mov dx,outer_y_background
		mov al,12
		L1:
			inc cx
			int 10h
		
			inc temp
		cmp temp,600
		JNE L1
		
		mov temp,00h
		
		L2:
			inc dx
			int 10h
		
			inc temp
		cmp temp,380
		JNE L2
		
		mov temp,00h
		
		L3:
			dec cx
			int 10h
		
			inc temp
		cmp temp,600
		JNE L3
		
		mov temp,00h
		
		L4:
			dec dx
			int 10h
		
			inc temp
		.if temp!=380
		JNE L4
		.endif
		
mov cx,00
mov dx,00		
	ret
border_12 endp

printing_1 proc


	mov ah,02h
	mov bx,00h
	mov dh,0
	mov dl,30
	int 10h

	lea dx,name_of_player
	mov ah,09h
	int 21h
	
	; push si
	
	; mov si, offset name_of_player
	
	; .while(byte PTR[si] != "#")
		; mov ah, 02h
		; mov dl, [si]
		; int 21h
	
		; inc si
	
	; .endw
	
	; pop si
		
	mov ah,02h
	mov bx,00h
	mov dh,3
	mov dl,12
	int 10h

	lea dx,display_1
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,00h
	mov dh,8
	mov dl,14
	int 10h

	lea dx,display_2
	mov ah,09h
	int 21h
		
	mov ah,02h
	mov bx,00h
	mov dh,11
	mov dl,14
	int 10h

	lea dx,display_3
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,00h
	mov dh,14
	mov dl,14
	int 10h

	lea dx,display_4
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,00h
	mov dh,17
	mov dl,14
	int 10h

	lea dx,display_5
	mov ah,09h
	int 21h
	
		
	ret
printing_1 endp	

butify proc

mov temp,0
		mov ah,0ch
		
		L1:
			inc cx
			int 10h
		
			inc temp
		cmp temp,10
		JNE L1
		
		mov temp,00h
		
		L2:
			inc dx
			int 10h
		
			inc temp
		cmp temp,10
		JNE L2
		
		mov temp,00h
		
		L3:
			dec cx
			int 10h
		
			inc temp
		cmp temp,10
		JNE L3
		
		mov temp,00h
		
		L4:
			dec dx
			int 10h
		
			inc temp
		.if temp!=10
		JNE L4
		.endif
	
	ret
		
butify endp


box_display proc
		mov cx,10
		mov dx,10
		mov al,1
		hehe:
			call butify
			add cx,10
			add dx,10
			inc al
		cmp cx,100
		jne hehe
		
		mov al,9
		mov cx,90
		mov dx,100
		call butify
		
		hehe2:
			call butify
			sub cx,10
			add dx,10
			dec al
		cmp cx,00
		jne hehe2
		
		;;---------------------------------
		
		mov al,9
		mov cx,220
		mov dx,90
		
		hehe3:
			call butify
			add cx,10
			sub dx,10
			dec al
		cmp dx,00
		jne hehe3
		
		mov al,1
		mov cx,220
		mov dx,100
		call butify
		
		hehe4:
			call butify
			add cx,10
			add dx,10
			inc al
		cmp dx,190
		jne hehe4

		mov cx,95
		mov dx,33
		mov al,06
		mov temp2,140
		call line
	ret
box_display endp

beep proc
        push ax
        push bx
        push cx
        push dx
        mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 400        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 2          ; Pause for duration of note.
pause1:
        mov     cx, 65535
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.

        pop dx
        pop cx
        pop bx
        pop ax

ret
beep endp


begining proc
		
		mov ah,00h
		mov al,13h
		int 10h
		
		call border
		
		
		mov ah,02h
		mov bx,00h
		mov dh,3
		mov dl,12
		int 10h

		lea dx,display_0
		mov ah,09h
		int 21h
		
		mov si,offset name_of_player
here:		
		mov ah,00h
		int 16h
		cmp al,'.'
		je	bas
		
		mov [si],al
		
		mov ah,02h
		mov bx,00h
		mov dh,9
		mov dl,15
		int 10h
		
		
		lea dx,name_of_player
		mov ah,09h
		int 21h
		
		inc si
		jmp here
		
		bas:
		
		;call writefile
		;call openfile
		
		ret
begining endp


instruction_screeen proc
			mov dl,10
			mov ah,02
			int 21h
			
			mov ah,02h
			mov bx,00h
			mov dh,4
			mov dl,20
			int 10h
			
			mov ah,00h
			mov al,12h
			int 10h

			mov outer_x_background,10
			mov outer_y_background,10
			
			call border_12
			
			call background
			
			mov dh,100
			mov dl,50
			int 10h
			
			lea dx,instruction
			mov ah,09
			int 21h
			
			mov ah,00h
			int 16h
	ret
instruction_screeen endp

file_reading proc
	
	mov ah,00h
	mov al,12h
	int 10h
	
	; mov ah, 3dh
	; mov al, 2;/1/2
	; lea dx, fn		;file opened
	; int 21h
	; mov handle, ax
		
	; mov ah, 03fh
	; mov cx, noofbytes		
	; lea dx, buffer			;length of buffer(size of array)
	; mov bx, handle
	; int 21h

	; mov ah, 09h
	; lea dx, buffer
	; int 21h
	
	; mov ah, 3eh
	; mov bx, handle
	; int 21h
	
	call openfile
	
	mov ah,00h
	int 16h
	
	ret
file_reading endp


;;Proc to display lives
;;heart_count controls how many hearts will be displayed
heart proc

	mov ah, 02h
	mov dl, 0		;px-axis
	mov dh, 1		;py-axis
	int 10h
	
	lea dx,heart_display
	mov ah,09
	int 21h

	mov ah, 02h
	mov dl, 7		;px-axis
	mov dh, 1		;py-axis
	int 10h
	
	lea dx,black_Linr
	mov ah,09
	int 21h

	mov ah, 02h
	mov dl, 6		;px-axis
	mov dh, 1		;py-axis
	int 10h
	
	
	
	mov ah, 09h
	mov al, 03h		;ascii of heart
	mov bx, 04h		;colour of heart
	mov cx, heart_count	;no of hearts being printed
	int 10h
	
ret
heart endp	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Lives_check proc

	   .if( heart_count == 0)
			   mov game_end_for_heart,0
	   .endif

	ret
Lives_check endp

;;Proc to display socre of player                                                                                                                          =
Score proc

	mov ah, 02h
	mov dl, 15		;px-axis
	mov dh, 1		;py-axis
	int 10h
	
	lea dx,Score_display
	mov ah,09
	int 21h

	mov ax,00
	mov cx,00
	mov bx,00
	mov dx,00
	
	mov bl,0Ah
	
	;;seperating the tenths place number and ones place numebr
	mov al,score_count
	div bl
	
	mov cl,ah
	mov ch,al
	
	mov ax,00
	mov al,ch
	div bl
	
	
	mov ah, 02h
	mov dl, 21		;px-axis
	mov dh, 1		;py-axis
	int 10h
	
	;display hundreth palce numebr
	mov dl,al
	add dl,'0'
	mov ah,02
	int 21h
	
	
	mov ah, 02h
	mov dl, 22		;px-axis
	mov dh, 1		;py-axis
	int 10h
	
	;display tens palce numebr
	mov dl,ch
	add dl,'0'
	mov ah,02
	int 21h
	
	mov ah, 02h
	mov dl, 23		;px-axis
	mov dh, 1		;py-axis
	int 10h
	
	;display ones palce numebr
	mov dl,cl
	add dl,'0'
	mov ah,02
	int 21h
	
	
	;;just freeing all values so no inter dependency
	mov ax,00
	mov cx,00
	mov bx,00
	mov dx,00
	
ret
Score endp	

;;Level number display proc
LEVEL proc

	mov ah, 02h
	mov dl, 33		;px-axis
	mov dh, 2		;py-axis
	int 10h
	
	lea dx,Level_display
	mov ah,09
	int 21h

	mov ax,00
	mov cx,00
	mov bx,00
	mov dx,00
	
	mov ah, 02h
	mov dl, 33		;px-axis
	mov dh, 0		;py-axis
	int 10h
	
	;display tens palce numebr
	lea dx,name_of_player
	mov ah,09
	int 21h
	
	; push si
	
	; mov si, offset name_of_player
	
	; .while(byte PTR[si] != "#")
		; mov ah, 02h
		; mov dl, [si]
		; int 21h
	
		; inc si
	
	; .endw
	
	; pop si
	
	
	
	mov ah, 02h
	mov dl, 39		;px-axis
	mov dh, 2		;py-axis
	int 10h
	
	;display tens palce numebr
	mov dl,level_number
	add dl,'0'
	mov ah,02
	int 21h
	
	
	
	
	
ret
LEVEL endp

;; code for making color background for game due to issue with
;; heart having a black background
bc proc	
		;saving values 
		push background_x
		push background_y
		
		mov ah,00h
		mov bx,00
		mov al,13h
		int 10h
		
		pop background_y
		pop background_x
	
	ret
bc endp

Game_border proc
	
	push game_border_x
	push game_border_y
 .while( loop_temp != 2)
	mov ah,0ch	
	mov cx,game_border_x
	mov dx,game_border_y
	mov al,2			;color of boarder

	L1:
			inc cx
			int 10h
	.if cx != 300
		JNE L1
	.endif	
		
	L2:
		 inc dx
		 int 10h
	.if dx != 190
	 JNE L2
	.endif	

	L3:
		dec cx
		int 10h
		
	.if cx != game_border_x
		JNE L3
	.endif

	L4:
		dec dx
		int 10h
		
	.if dx != game_border_y
		JNE L4
	.endif
		
	dec game_border_x
	dec game_border_y
	inc loop_temp
.endw	
	
	mov loop_temp,0	
	pop game_border_y
	pop game_border_x
	ret
Game_border endp

drawpaddle Proc
        
        mov ax, 0
        mov cx, 0
        mov bx, 0
        mov dx, 0
        
        mov ah, 0Ch
        mov al, 0Fh
        mov cx, px
        mov dx, py
        int 10h
		
		.if(level_number == 1)
			
			mov paddlecount, 20
			mov paddlecount2, 20
			
		
		.elseif(level_number == 2)
			mov paddlecount, 15
			mov paddlecount2, 15
		
		.elseif(level_number == 3)
			mov paddlecount, 10
			mov paddlecount2, 10
		
		.endif
		
    
        ;mov paddlecount, 20
        
        .while(paddlecount > 0)
            
            inc cx
           
            int 10h
                
            dec paddlecount
        
        .endw
        
        mov cx, px
        
		
		
		
        ;mov paddlecount, 20
        
        .while(paddlecount2 > 0)
            
            dec cx
            
            int 10h
                
            dec paddlecount2
        
        .endw
		
		

        ret    
drawpaddle endP

deletepaddle Proc
        mov ax, 0
        mov cx, 0
        mov bx, 0
        mov dx, 0
    
        mov ah, 0Ch
        mov al, 0h
        mov cx, px
        mov dx, py
        int 10h
		
		.if(level_number == 1)
			
			mov paddlecount, 20
			mov paddlecount2, 20
			
		
		.elseif(level_number == 2)
			mov paddlecount, 15
			mov paddlecount2, 15
		
		.elseif(level_number == 3)
			mov paddlecount, 10
			mov paddlecount2, 10
		
		.endif

        ;mov paddlecount, 20
        
        .while(paddlecount > 0)
            
            inc cx
			
            int 10h
                
            dec paddlecount
        
        .endw
        
        mov cx, px
		
		
        
        ;mov paddlecount, 20
        
        .while(paddlecount2 > 0)
            
            dec cx
            
            int 10h
                
            dec paddlecount2
        
        .endw

        ret
    
deletepaddle endP

updatepaddle Proc
		
		mov ah, 00h
		int 16h
		
		;CMP al, 27
		;JE exit
		
		mov exitvar, 0
		
		.if(al == 27)
			mov exitvar, 1
		
		.endif
		
		mov bl, ah
			
		CMP bl, 4Bh
		JNE p3
			
			call deletepaddle
		
			.if(cx > 25)
				sub px, 5
			.endif
		
		p3:
		
		CMP bl, 4Dh
		JNE p4
			
			.if(level_number == 1)
				
				mov maxplength, 260
			
			.elseif(level_number == 2)
				mov maxplength, 268
			
			.elseif(level_number == 3)
				mov maxplength, 272
			
			.endif
			
			
			
			call deletepaddle
			
			.if(cx < maxplength)
			
				add px, 5
			.endif
			
		p4:
	
		ret
		
updatepaddle endP
	
drawball Proc 
	
		mov ax, 0
		mov cx, 0
		mov bx, 0
		mov dx, 0
	
		mov ah, 0Ch
		mov al, 0Fh
		mov cx, ballx
		mov dx, bally
		int 10h
	
	
	
		ret
	
	
drawball endP
	
deleteball Proc
		
		mov ax, 0
		mov cx, 0
		mov bx, 0
		mov dx, 0
	
		mov ah, 0Ch
		mov al, 0h
		mov cx, ballx
		mov dx, bally
		int 10h


		ret
	
deleteball endP
	
updateball Proc
		
		.if(ballx > 30)
			
			.if(ballx < 300 && bvx == 0)			; collision of ball with border x max e.g 300
				inc ballx
	
			.elseif(ballx < 300 && bvx == 1)
			
				dec ballx
	
	
			.elseif(ballx == 300)
			
				mov bvx, 1
				dec ballx
	
			.endif
		
		.elseif(ballx == 30)						; collision of ball with border x min e.g 30			
		
			mov bvx, 0
			inc ballx
	
	
		.endif
		
		.if(bally > 30)
			
			.if(bally < 185 && bvy == 0)			; collision of ball with border y max e.g 185
				inc bally
	
			.elseif(bally < 185 && bvy == 1)
			
				dec bally
	
	
			.elseif(bally == 185)
			
				mov bvy, 1
				;dec bally
				dec heart_count
				mov ballx, 160
				mov bally, 140
	
			.endif
		
		.elseif(bally == 30)						; collision of ball with border y min e.g 30
			mov bvy, 0
			inc bally
		
		.endif
		
		.if(bally >= 175)
				
				push ax									; DO NOT TOUCH THIS CODE AT ANY COST
				push bx
				
				
				
				mov ax, px
				;add ax, paddlecount
				
				mov bx, px
				;sub bx, paddlecount
				
				.if(level_number == 1)
			
					add ax, 20
					sub bx, 20
				
				.elseif(level_number == 2)
					add ax, 15
					sub bx, 15
					
				
				.elseif(level_number == 3)
					add ax, 10
					sub bx, 10
					
				.endif
				
				
				.if((ax >= ballx) && ( ballx >= bx))	; ESPECIALLY THIS
				
					mov bvy, 1
					
					
				.endif
				
				pop bx
				pop ax
				
			
		.endif
		
			
		;;;;;;;;;;;;;;;;;;;;;;;;
		
		
		push si
		push cx
		push ax
		push bx
		push dx
		
		;; code to reflect from bottom of all bricks
		
		mov cx, 4
		
		mov ax, 35  	;;starting x
		
		mov dx, 43		;;starting y
		
		mov si, offset hit_array
		
		mov di, 0
			
		L6:
			push cx
			
			mov cx, 5
			
			L7:
				
				mov bx, ax
				
				add bx, 40
				
				.if(byte PTR[si] != 0)
				
					.if(bally == dx)
						
						.if(ballx >= ax && ballx <= bx)
							
							.if(bvy == 1)
								mov bvy, 0
								.if(byte PTR[si] !=11)
								sub byte PTR[si], 1
								call beep
								inc score_count
								.endif
							.elseif(bvy == 0)
								mov bvy, 1
								.if(byte PTR[si] !=11)
								sub byte PTR[si], 1
								call beep
								inc score_count
								.endif
							.endif	
							
							
						
						.endif
					
					.endif
					
				.endif
				
				add ax, 54
				
				add si, 4
		
		
			LOOP L7
			
			mov ax, 35
			
			add dx, 20
			
			inc di
			
			mov si, offset hit_array
			
			add si, di
			
			pop cx
		
		LOOP L6
		
		;;code to reflect from top 
		
		mov cx, 4
		
		mov ax, 35 ;43		;starting x
		
		mov dx, 35			;starting y
		
		mov si, offset hit_array
		
		mov di, 0
			
		L8:
			push cx
			
			mov cx, 5
			
			L9:
				
				mov bx, ax
				
				add bx, 40
				
				.if(byte PTR[si] != 0 )
				
					.if(bally == dx)
						
						.if(ballx >= ax && ballx <= bx)
							
							dec bally						; dont touch this
							
							.if(bvy == 1)
								mov bvy, 0
								
								.if(byte PTR[si] !=11)
								sub byte PTR[si], 1
								call beep
								inc score_count
								.endif
							
							.elseif(bvy == 0)
								mov bvy, 1
								
								.if(byte PTR[si] !=11)
								sub byte PTR[si], 1
								call beep
								inc score_count
								.endif
							.endif	
							
							
						
						.endif
					
					.endif
				
				.endif
				
				add ax, 54
		
				add si, 4
		
			LOOP L9
			
			mov ax, 35
			
			add dx, 20
			
			inc di
			
			mov si, offset hit_array
			
			add si, di
			
			pop cx
		
		LOOP L8
		
		
		; code to check left side of each brick
	
		mov cx, 5
		
		mov ax, 35   		;;starting x
		
		mov dx, 35			;;starting y
		
		mov si, offset hit_array
		
			
		L10:
			push cx
			
			mov cx, 4
			
			L11:
				
				mov bx, ax
				
				add bx, 8
				
				.if(byte PTR[si] != 0)
				
					.if(ballx == dx)
						
						.if(bally >= ax && bally <= bx)
							
							dec ballx						;; dont touch this
							
								
							.if(bvx == 0)
							
								mov bvx, 1
								.if(byte PTR [si] !=11)
								sub byte PTR[si], 1
								call beep
								inc score_count
								.endif
								
							.endif		
							
							
						
						.endif
					
					.endif
				
				.endif
				
				add ax, 20
				
				inc si
		
			LOOP L11
			
			add dx, 54
			
			mov ax, 35
			
			
			
			
			
			pop cx
		
		LOOP L10
		
		
		; jmp skip
		
		; midofloop:
			; jmp outerloop
		
		; skip:
		
		; code to check right side of each brick
		
		
		
		mov cx, 5
		
		mov ax, 35   		;;starting x
		
		mov dx, 75			;;starting y
		
		mov si, offset hit_array
			
		L12:
			push cx
			
			mov cx, 4
			
			L13:
				
				mov bx, ax
				
				add bx, 8
				
				.if(byte PTR[si] != 0)
				
					.if(ballx == dx)
						
						.if(bally >= ax && bally <= bx)
							
							inc ballx						;; dont touch this
							
							.if(bvx == 1)
								mov bvx, 0
								
								.if(byte PTR[si] !=11)
								sub byte PTR[si], 1
								inc score_count
								.endif
									
							.endif	
							
							
						
						.endif
					
					.endif
					
				.endif
				
				add ax, 20
				
				; mov ah, 02h
				; mov dl, [si]
				; add dl, 48
				; int 21h
				
				
				inc si
				
	
		
			LOOP L13
			
			add dx, 54
			
			mov ax, 35
			
			
			
			
			
			pop cx
		
		LOOP L12
		
		
		
		
		pop dx
		pop bx
		pop ax
		pop cx
		pop si
		
		

		ret
	
updateball endP
	

bricks proc ;uses ax bx cx dx

		push ax
		push bx
		push cx
		push dx

		
		mov ah, 0Ch
		mov al, brick_color
		push brick_start_x
		mov cx, brick_start_x
		mov dx, brick_start_y
		int 10h



	.if(byte PTR[si] <= 3)
				L2:
					L1:
						int 10h
						inc cx
						inc temp
					.if ( temp != 40)	;;length of each brick
						jmp L1
					.endif

					mov temp,0
					inc dx
					inc bx
					mov cx,brick_start_x
				.if bx != 8				;; height of each brick
				jmp L2
				.endif
	.else
	
	
		mov al,15
			 L4:
					L3:
						int 10h
						inc cx
						inc temp
					.if ( temp != 40)	;;length of each brick
						jmp L3
					.endif

					mov temp,0
					inc dx
					inc bx
					mov cx,brick_start_x
				.if bx != 8				;; height of each brick
				jmp L4
				.endif
	.endif
		
		pop brick_start_x
		mov temp,0
		mov bx,0
		mov cx,00
		mov dx,00
		
		pop dx
		pop cx
		pop bx
		pop ax
		
		
		
		
		
		
	
	ret
bricks endp

deletebricks proc ;uses ax bx cx dx

		push ax
		push bx
		push cx
		push dx
	
		mov ah, 0Ch
		mov al, 0h
		push brick_start_x
		mov cx, brick_start_x
		mov dx, brick_start_y
		int 10h

		L2:
			L1:
				int 10h
				inc cx
				inc temp
			.if ( temp != 40)	;;length of each brick
				jmp L1
			.endif

			mov temp,0
			inc dx
			inc bx
			mov cx,brick_start_x
		.if(bx != 8)				;; height of each brick
		jmp L2
		.endif
		
		pop brick_start_x
		mov temp,0
		mov bx,0
		mov cx,00
		mov dx,00
		
		pop dx
		pop cx
		pop bx
		pop ax
	
	ret
deletebricks endp
	
	
building_level proc

	push brick_start_x
	push brick_start_y
	
	mov si, offset hit_array
	
	mov brick_color, 9
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-------------------------DO not touch at all	
	push cx
	
	mov cx,5
		
		L39:
			push brick_start_y
			push cx
			mov cx,4
			
			L38:
			
			  .if(byte ptr [si] == 0)
			  call deletebricks
					
			  .endif
			  
			  inc si
			  
			  add brick_start_y,20
				  
			loop L38
			
			pop cx	
			inc brick_color
			add brick_start_x,54
			pop brick_start_y
		
		loop L39
		
	pop cx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-------------------------DO not touch at all	
		
		pop brick_start_y
		pop brick_start_x

	ret
building_level endp	




building_levelonce proc

	push brick_start_x
	push brick_start_y
	
	
	mov si, offset hit_array
	
	mov brick_color, 9
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-------------------------DO not touch at all	
	push cx
	
	mov cx,5
		
		L40:
			push brick_start_y
			push cx
			mov cx,4
			
			L41:
				call bricks
					
			  inc si
			  
			  add brick_start_y,20
				  
			loop L41
			
			pop cx	
			inc brick_color
			add brick_start_x,54
			pop brick_start_y
		
		loop L40
		
	pop cx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-------------------------DO not touch at all	
		
		pop brick_start_y
		pop brick_start_x

	ret
building_levelonce endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pause_Screen proc


		mov ah, 02h
		mov dl, 10		;px-axis
		mov dh, 17		;py-axis
		int 10h
	
		
		lea dx,Pause_dis
		mov ah,09
		int 21h
		
		
		mov ah,00
		int 16h
		
		
		mov ah, 02h
		mov dl, 10		;px-axis
		mov dh, 17		;py-axis
		int 10h
	
		
		lea dx,Blanking
		mov ah,09
		int 21h
		
		
	   ret
pause_Screen endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

checkecking_level_clearence proc  uses ax bx cx dx si di
		mov cx,20
		mov ax,0
		mov bx,0
		mov si,offset hit_array
		
		L1: 
					 mov bx,[si]
				.if(  bx==0 ) 
					   inc ax
				.endif
		loop L1
		
		.if( ax==22)
			inc level_number
		.endif
		
		 mov si,0
		 mov cx,0
		mov ax,0
		mov bx,0
		   ret
checkecking_level_clearence endp

Level_01 proc   uses ax bx cx dx si di
			   	
		call bc
		
		call building_levelonce
		
	 start:
		
			
		call heart
	
		call Score
		
		call LEVEL
		
		call Game_border
		
		call drawpaddle
		
		call drawball
		
		mov ah, 01h
		int 16h
		
		JZ	keyjump
		
		call updatepaddle
		
		
		
		
		keyjump:
		
		.if(exitvar == 1)
			call pause_Screen
			mov exitvar,0
		.endif
		
		
		
		mov cx, 01FFFh				; delay necessary to make ball refresh at a rate visible to naked eye
				
			.while(cx != 0)
				nop
				dec cx
			
			.endw
		
		
		call deleteball
		
		
		call updateball
		
		
		call building_level
		
		call checkecking_level_clearence
		
		
		call Lives_check
		
		.if ( game_end_for_heart == 0)
			jmp exit
		.endif
		
		.if( level_number == 2  || score_count == 20)
		  jmp exit
		 .endif
    JMP start
 
exit: 
	ret
Level_01 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Level_02 proc   uses ax bx cx dx si di
			   	
		call bc
		
		call building_levelonce
		
	 start:
		
			
		call heart
	
		call Score
		
		call LEVEL
		
		call Game_border
		
		call drawpaddle
		
		call drawball
		
		mov ah, 01h
		int 16h
		
		JZ	keyjump
		
		call updatepaddle
		
		
		
		
		keyjump:
		
		.if(exitvar == 1)
			call pause_Screen
			mov exitvar,0
		.endif
		
		
		
		.if(score_count < 42)
		
			mov cx, 01FFFh				; delay necessary to make ball refresh at a rate visible to naked eye
				
			.while(cx != 0)
				nop
				dec cx
			
			.endw
		
		.elseif(score_count >= 42)
			
			mov cx, 01555h				; delay necessary to make ball refresh at a rate visible to naked eye
				
			.while(cx != 0)
				nop
				dec cx
			
			.endw
			
		.endif
		
		
		call deleteball
		
		
		call updateball
		
		
		call building_level
		
		call checkecking_level_clearence
		
		call Lives_check
		
		.if ( game_end_for_heart == 0)
			jmp exit
		.endif
		
		.if( level_number == 3 || score_count == 60)
		  jmp exit
		 .endif
    JMP start
 
exit: 
	ret
Level_02 endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RandomNumber proc  uses ax bx cx dx si di
    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

	   mov  ax, dx
	   xor  dx, dx
	   mov  cx, 10    
	   div  cx       ; here dx contains the remainder of the division - from 0 to 9

	mov random_number_for_level_3 ,dl
	
	ret
RandomNumber endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Level_03 proc   uses ax bx cx dx si di
			   	
		call bc
		
		call building_levelonce
		
	 start:
		
			
		call heart
	
		call Score
		
		call LEVEL
		
		call Game_border
		
		call drawpaddle
		
		call drawball
		
		mov ah, 01h
		int 16h
		
		JZ	keyjump
		
		call updatepaddle
		
		
		
		
		keyjump:
		
		.if(exitvar == 1)
			call pause_Screen
			mov exitvar,0
		.endif
		
		
		
		.if(score_count < 98)
		
			mov cx, 01FFFh				; delay necessary to make ball refresh at a rate visible to naked eye
				
			.while(cx != 0)
				nop
				dec cx
			
			.endw
			
		.elseif(score_count >= 98)
			
			mov cx, 01555h				; delay necessary to make ball refresh at a rate visible to naked eye
				
			.while(cx != 0)
				nop
				dec cx
			
			.endw
			
		.endif
		
		
		call deleteball
		
		
		call updateball
		
		
		call building_level
		
		call checkecking_level_clearence
		
		
		call Lives_check
		
		.if ( game_end_for_heart == 0)
			jmp exit
		.endif	
			
		
		.if( level_number == 4 || score_count >= 105)
		  jmp exit
		 .endif
    JMP start
 
exit: 
	ret
Level_03 endp



Winner proc uses ax bx cx dx si di 

mov  al, 0Bh   ; select display page 1
		mov  ah, 05h   ; function 05h: select active display page
		int  10h

	call background
	call border

		mov ah,02h
		mov bx,00h
		mov dh,10
		mov dl,5      ;ending_game
		int 10h

		lea dx,WInner_
		mov ah,09h
		int 21h
		
		
		mov ah,02h
		mov bx,00h
		mov dh,10
		mov dl,7      ;ending_game
		int 10h

		lea dx,name_of_player
		mov ah,09h
		int 21h
		
		call writefile
		
		mov ah,00h
		int 16h

		


	ret
Winner endp
;;;;;;;;;;;;;;;;;;;;;;;;*-*-*-*-*--*-*-*-*-

Actual_Game proc
		mov  al, 01h   ; select display page 1
		mov  ah, 05h   ; function 05h: select active display page
		int  10h
		
		mov level_number, 1
		
		call Level_01
		
		
		mov cx,20
		
		mov si,offset hit_array
		mov bx,2
		
		L1:
			 mov [si],bx
			 inc si
		loop L1
		
		
		.if ( game_end_for_heart == 1)
				mov level_number,2
				
				
				mov px , 150
				mov py , 180
				
				mov ballx , 160
				mov bally , 140
				mov bvx , 0
				mov bvy , 1
			
				;inc heart_count
				
				mov  al, 02h   ; select display page 1
				mov  ah, 05h   ; function 05h: select active display page
				int  10h
				
			
				call Level_02
		
		
		  .endif
		
		
		.if ( game_end_for_heart == 1)
				
				mov  al, 03h   ; select display page 1
				mov  ah, 05h   ; function 05h: select active display page
				int  10h
				
				
				mov px , 150
				mov py , 180
				
				;inc heart_count
				
				
				mov level_number,3
				
				mov ballx , 160
				mov bally , 140
				mov bvx , 0
				mov bvy , 1
			
				
				mov cx,20
				
				mov si,offset hit_array
				mov bx,3
				
				L2:
					 mov [si],bx
					 inc si
				loop L2
				
				
				mov cx,5
				
				L3:
				
					call RandomNumber
					mov si,0
					push cx
					mov cx,0
					mov cl,random_number_for_level_3
					L10:
					   inc si
					loop L10
							 
					pop cx		   
					mov hit_array[si],11
					
					
					push cx
					
					mov cx, 0FF5Fh				; delay necessary to make ball refresh at a rate visible to naked eye
						
					.while(cx != 0)
						nop
						dec cx
					
					.endw
					
					pop cx
					
				loop L3
			
			
			
				call Level_03
				
				 .if ( game_end_for_heart!=0)
						call Winner
				.endif
				
		   .endif
		   
		   .if ( game_end_for_heart==0)
				 call exit_screeen
		   .endif
	ret
Actual_Game endp



main proc
	mov ax,@data
	mov ds,ax
	mov ax,00
	
	call begining
	
start:	mov ah,00h
		mov al,13h
		int 10h
	
		mov dx,00
		call border
		
		call printing_1
		
		call box_display
		
		mov ah,00h
		int 16h
		
		mov input,al
		
		.if input=='1'
		
				   call Actual_Game
				   
				   call defaulting
		
		.elseif input=='2'
			
		call instruction_screeen
		
		.elseif input=='3'
			call file_reading
			
		.elseif input=='4'
			jmp exit
		.else
			call beep
		.endif
		
		mov outer_x_background,10
		mov outer_y_background,10
		mov temp,0
		
		jmp start
		
exit:	
mov ah,4ch
int 21h
main endp
end main
end main