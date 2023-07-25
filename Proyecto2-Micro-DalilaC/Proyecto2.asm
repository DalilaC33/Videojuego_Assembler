.model small
.data
;la bala
bala db "!",13,10,'$'
  
;extraterrestres
ex  db "('.')",13,10,'$' 
ex2 db "(".")",13,10,'$'
ex3 db "(O.O)",13,10,'$' 
ex4 db "(".")",13,10,'$'
ex5 db "('.')",13,10,'$' 
ex6 db "(*.*)",'$' 

;nave     
per db "|/\|",13,10,'$'
 
;indice nave
fil db 23
col db 3 
;indice de extraterrestres
fil1 db 2
col1 db 2 
estado1 db 0

fil2 db 2
col2 db 40  
estado2 db 0

fil3 db 4
col3 db 15 
estado3 db 0

fil4 db 4
col4 db 55
estado4 db 0

fil5 db 6
col5 db 30
estado5 db 0

fil6 db 6
col6 db 70
estado6 db 0

;indice de balas 
filBala db 23
colBala db 29

filBala1 db 23
colBala1 db 29

filBala2 db 23
colBala2 db 29

filBala3 db 23
colBala3 db 29

filBala4 db 23
colBala4 db 29

filBala5 db 23
colBala5 db 29 

contadorBala db 0  

;variable auxiliar
auxFilaB db 0
auxColB  db 0
auxFilEx db 0
auxColEx db 0
auxContaEx db 0 

;puntos

puntaje db 0 
puntosmsj  db "Puntaje: ",'$'
;mensaje de Fin
ganaste  db "*같같같같같같같같같같* Felicidades ganasteee :) *같같같같같같같같같�* ",13,10,'$'
perdiste  db "*같같같같같같같같같같* Has perdido :( *같같같같같같같같같같같�* ",13,10,'$'
.code 


;;; imprime el personaje
personaje proc near
    
    push ax
    push bx
    push cx
    push dx 
           
    mov ah, 2
    mov bh, 0
    mov dh, fil
    mov dl, col
    int 10h
    
    mov ah,9
    mov dx, offset per
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    
    personaje endp

;;; imprimir puntos
puntosFunc proc near
    push ax
    push bx
    push cx
    push dx 
    
    mov ah, 2
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    mov ah,9
    mov dx, offset puntosmsj
    int 21h
    
    mov bl,puntaje
    add bl,'0'             
    mov dl,bl
    mov ah,2
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax  
    ret
    
    puntosFunc endp
;;;disparar una bala
disparar proc near
    
    push ax
    push bx
    push cx
    push dx 
           
    subir:
    call compExtFin
    call puntosFunc    
    call dibujarBala 
    call personaje
    call dibujarExt          
    call limpiarPantalla
   
    mover1:  
    mov ah,0bh
    int 21h
    cmp al,0
    jne get_key_pressed              
    loop subir
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

disparar endp  


;;dibujar los extraterrestres
dibujarExt:
  push ax
    push bx
    push cx
    push dx
    mov AX,@data
    mov ds, ax
    mov es, ax
    
    call extrat1
    call extrat2 
    call extrat3 
    call extrat4 
    call extrat5
    call extrat6
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;; inicio del juego            
main proc        
    mov AX,@data
    mov DS,AX   
    mov BL,0      
      
    dibujar:
    call compExtFin
    call puntosFunc    
    call dibujarExt 
   
    mover:     
    call personaje
    call limpiarPantalla 
    
    
    mov ah,0bh
    int 21h
    cmp al,0
    jne get_key_pressed         
    loop dibujar 
   
    

    
;;; entrada del teclado   
get_key_pressed:
    
 mov ah,0
 int 16h
 
 cmp ah,48h
 je up
 
 cmp ah,50h
 je down
 
 cmp ah,4Dh
 je right
 
 cmp ah,4Bh
 je left
 ret 
  
 up:
    ; posicionamos la bala donde se encuentra el personaje   
    inc contadorBala
    
    mov ah,1
    cmp ah,contadorBala
    je  pbala1
     
    
    mov ah,2
    cmp ah,contadorBala
    je  pbala2
     
    
    mov ah,3
    cmp ah,contadorBala
    je  pbala3
    
    
    mov ah,4
    cmp ah,contadorBala
    je  pbala4
    
    mov ah,5
    cmp ah,contadorBala
    je  pbala5
   
    jmp disparar
             
 down:
    inc fil
    jmp mover 
    
 right: 
    mov ah,74
    cmp ah,col
    jne sumarCol
    jmp alertaPared
 left:
    mov ah,0
    cmp ah,col
    jne restarCol
    jmp alertaPared
    
    
sumarCol:
 inc col
 inc col
 inc col 
 jmp mover1

restarCol:
 sub col,3
 jmp mover1 
 
alertaPared:
 call alerta
 jmp mover

 
;dibuja las 5 balas   
dibujarBala:
   
    mov ah,1
    cmp contadorBala, ah
    jae dibujarBala1 
    comparar2:
    mov ah,2
    cmp contadorBala, ah
    jae dibujarBala2
    comparar3:
    mov ah,3
    cmp contadorBala, ah
    jae dibujarBala3
    comparar4:
    mov ah,4
    cmp contadorBala, ah
    jae dibujarBala4
    comparar5:
    mov ah,5
    cmp contadorBala, ah
    jae dibujarBala5
    finBalas:
    ret
   
  dibujarBala1:
       
    sub filBala,1
     
    mov AH,2H           
    mov BH,0            
    mov DH,filBala
    mov DL,colBala
    INT 10H 
        
    mov AH,9H
    mov DX,offset bala      
    INT 21H

    ; comprobar si colisiono alguna bala
    call moverBalaAux1
    call colisionoBala
    
    jmp comparar2
   
  dibujarBala2:
 
    sub filBala2,1
     
    mov AH,2H          
    mov BH,0            
    mov DH,filBala2
    mov DL,colBala2
    INT 10H
    
    mov AH,9H
    mov DX,offset bala     
    INT 21H
    
    ; comprobar si colisiono alguna bala
    call moverBalaAux2
    call colisionoBala
    
    jmp comparar3
    
  dibujarBala3:
  
    sub filBala3,1
   
    mov AH,2H           
    mov BH,0            
    mov DH,filBala3
    mov DL,colBala3
    INT 10H
    
    mov AH,9H
    mov DX,offset bala      
    INT 21H
    
    ; comprobar si colisiono alguna bala
    call moverBalaAux3
    call colisionoBala
    jmp comparar4
    
  dibujarBala4: 
  
    sub filBala4,1 
    
    mov AH,2H           
    mov BH,0            
    mov DH,filBala4
    mov DL,colBala4
    INT 10H
    
    mov AH,9H
    mov DX,offset bala      
    INT 21H
    
    ; comprobar si colisiono alguna bala
    call moverBalaAux4
    call colisionoBala 
    
    jmp comparar5
     
  dibujarBala5:
    
    sub filBala5,1 
    mov AH,2H           
    mov BH,0            
    mov DH,filBala5
    mov DL,colBala5
    INT 10H
    
    mov AH,9H
    mov DX,offset bala      
    INT 21H
    
    ; comprobar si colisiono alguna bala
    call moverBalaAux5
    call colisionoBala
    ret
        
    
    pbala1:
    mov ah,fil
    mov filBala, ah
    mov ah, col
    mov colBala, ah 
    jmp disparar
    
    pbala2:
    mov ah,fil
    mov filBala2, ah
    mov ah, col
    mov colBala2, ah
    jmp disparar
    
    pbala3:
    mov ah,fil
    mov filBala3, ah
    mov ah, col
    mov colBala3, ah
    jmp disparar
    
    pbala4:
    mov ah,fil
    mov filBala4, ah
    mov ah, col
    mov colBala4, ah
    jmp disparar
    
    pbala5:
    mov ah,fil
    mov filBala5, ah
    mov ah, col
    mov colBala5, ah
    jmp disparar 

;;; fin de dibujar las balas 


 
;limpio la pantalla    
limpiarPantalla:
    mov AH, 6H 
    mov AL, 0    
    mov BH, 7          
    mov CX, 0
    mov DL, 79
    mov DH, 24
    int 10H
    ret
 
    
;; dibuja los extraterrestres 
extrat1 proc near
    ;si estado esta en 1 no se pinta
    mov ah,0
    cmp ah,estado1
    jne salir1
    mov ah, 13h
    mov bp, offset ex
    mov bh,0
    mov bl,4
    mov cx,5
    mov dh,fil1
    mov dl,col1
    int 10h
    
    inc fil1
    salir1:   
    ret
    extrat1 endp 

extrat2 proc near
    ;si estado esta en 1 no se pinta
    mov ah,0
    cmp ah,estado2
    jne salir2  
    mov ah, 13h
    mov bp, offset ex2
    mov bh,0
    mov bl,2
    mov cx,5
    mov dh,fil2
    mov dl,col2
    int 10h
    inc fil2
    salir2:  
      
    ret
    extrat2 endp 
     
     
extrat3 proc near
    mov ah,0
    cmp ah,estado3
    jne salir3   
    mov ah, 13h
    mov bp, offset ex3
    mov bh,0
    mov bl,2
    mov cx,5
    mov dh,fil3
    mov dl,col3
    int 10h 
    inc fil3  
    salir3:
    ret
    extrat3 endp
    
    
extrat4 proc near
    mov ah,0
    cmp ah,estado4
    jne salir4  
    mov ah, 13h
    mov bp, offset ex4
    mov bh,0
    mov bl,4
    mov cx,5
    mov dh,fil4
    mov dl,col4
    int 10h 
    inc fil4
    salir4:
    ret
    extrat4 endp  
   
   
extrat5 proc near
    mov ah,0
    cmp ah,estado5
    jne salir5   
    mov ah, 13h
    mov bp, offset ex5
    mov bh,0
    mov bl,4
    mov cx,5
    mov dh,fil5
    mov dl,col5
    int 10h 
    inc fil5
    salir5:
    ret
    extrat5 endp 


extrat6 proc near
    mov ah,0
    cmp ah,estado6
    jne salir6  
    mov ah, 13h
    mov bp, offset ex6
    mov bh,0
    mov bl,4
    mov cx,5
    mov dh,fil6
    mov dl,col6
    int 10h 
    inc fil6
    salir6:
    ret
    extrat6 endp

colisionoBala:
    
    ;acelera la comprobacion
    mov ah,filBala
    cmp fil6,ah
    jb saltarComprobacion
    
    
    ;extr 1
    cmp  estado1,1
    je comp2
    mov  auxContaEx,1
    call moverExtAux1    
    call cmpBalaYExt1
    ;extr 2 
    comp2:
    cmp  estado2,1
    je comp3 
    mov  auxContaEx,2
    call moverExtAux2    
    call cmpBalaYExt1 
    ;extr 3
    comp3:
    cmp  estado3,1
    je comp4
    mov  auxContaEx,3
    call moverExtAux3    
    call cmpBalaYExt1
    ;extr 4 
    comp4:
    cmp  estado4,1
    je comp5
    mov  auxContaEx,4
    call moverExtAux4    
    call cmpBalaYExt1
    ;extr 5 
    comp5:
    cmp  estado5,1
    je comp6
    mov  auxContaEx,5
    call moverExtAux5    
    call cmpBalaYExt1
    ;extr 6
    comp6:
    cmp  estado6,1
    je saltarComprobacion
    mov  auxContaEx,6
    call moverExtAux6    
    call cmpBalaYExt1
    
    saltarComprobacion:
    ret


;compara si colisionaron la bala y el extraterrestre
;si estan en la misma posicion colisiona
cmpBalaYExt1:
    push ax
    push bx
    push cx
    push dx 
         
    mov ah,auxFilaB
    cmp auxFilEx,ah
    jae cmpCol1
    jmp salir        
    cmpCol1:
    mov bh,5
    add bh,auxColEx
    mov ah,auxColB
    cmp ah,auxColEx
    je elimExtr:
    jb salir 
    cmp auxColB,bh
    jb elimExtr
    jmp salir
    salir:
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;; para eliminar un extraterrestre    
elimExtr:
    call alerta    
    mov ah,auxContaEx
    cmp ah,2
    je elim2
    cmp ah,1
    je elim1
    cmp ah,3
    je elim3
    cmp ah,4
    je elim4
    cmp ah,5
    je elim5
    cmp ah,6
    je elim6
    elim1:
    mov ah,1
    mov estado1,ah
    inc puntaje
    jmp salir
    elim2:
    mov ah,1
    mov estado2,ah 
    inc puntaje
    jmp salir
    elim3:
    mov ah,1
    mov estado3,ah
    inc puntaje
    jmp salir
    elim4:
    mov ah,1
    mov estado4,ah 
    inc puntaje
    jmp salir
    elim5:
    mov ah,1
    mov estado5,ah
    call ganasteFunc
    jmp salir
    elim6:
    mov ah,1
    mov estado6,ah
    inc puntaje
    jmp salir
;; fin de metodo que elimina

      
moverBalaAux1:
    mov ah, filBala
    mov auxFilaB,ah    
    mov ah, colBala
    mov auxColB,ah
    ret
    
moverBalaAux2:
    mov ah, filBala2
    mov auxFilaB,ah    
    mov ah, colBala2
    mov auxColB,ah
    ret
    
moverBalaAux3:
    mov ah, filBala3
    mov auxFilaB,ah    
    mov ah, colBala3
    mov auxColB,ah
    ret
    
moverBalaAux4:
    mov ah, filBala4
    mov auxFilaB,ah    
    mov ah, colBala4
    mov auxColB,ah
    ret
    
moverBalaAux5:
    mov ah, filBala5
    mov auxFilaB,ah    
    mov ah, colBala5
    mov auxColB,ah
    ret

moverExtAux1:
    mov ah, fil1
    mov auxFilEx,ah    
    mov ah, col1
    mov auxColEx,ah
    ret
moverExtAux2:    
    mov ah, fil2
    mov auxFilEx,ah    
    mov ah, col2
    mov auxColEx,ah 
    ret
moverExtAux3:
    mov ah, fil3
    mov auxFilEx,ah    
    mov ah, col3
    mov auxColEx,ah 
    ret
moverExtAux4:    
    mov ah, fil4
    mov auxFilEx,ah    
    mov ah, col4
    mov auxColEx,ah 
    ret 
    
moverExtAux5:    
    mov ah, fil5
    mov auxFilEx,ah    
    mov ah, col5
    mov auxColEx,ah     
    ret
    
moverExtAux6:    
    mov ah, fil6
    mov auxFilEx,ah    
    mov ah, col6
    mov auxColEx,ah     
    ret
;; fin de comparacion

    

;condicion de fin
compExtFin:         
    mov ah,22        
    cmp ah,fil6
    je perdisteFunc:
    ret
    
     
; alerta    
alerta:
mov ah, 02h		
mov dl, 07h		
int 21h
ret
             
             
;; funcion para aparecer el mensaje de perdiste o ganaste             
perdisteFunc:
call limpiarPantalla
    mov ah, 2
    mov bh, 0
    mov bl, 4
    mov dh, 10
    mov dl, 10
    int 10h
    mov ah,9
    mov dx, offset perdiste
    int 21h
    call alerta
    jmp exit
    
    
ganasteFunc:
call limpiarPantalla
    mov ah, 2
    mov bh, 0
    mov bl, 4
    mov dh, 10
    mov dl, 10
    int 10h
    mov ah,9
    mov dx, offset ganaste  
    int 21h
    call alerta
    jmp exit

;; final 
exit:
  mov AX,4c00h
  INT 21H 

    
end main  

