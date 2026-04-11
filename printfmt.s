default rel

global printfmt

section .data
  longFlag db 0 
  unsignedFlag db 0

section .bss
  intBuf resb 32
  charBuf resb 1 

section .text 

strlen: ; rdi = string 
  xor rax, rax

  .loop:
    cmp byte [rdi + rax], 0 
    je .end

    inc rax 
    jmp .loop 

  .end:
    ret

itoa: ; rdi = integer, rsi = buffer | rax = length
    push rbx

    xor rcx, rcx ; index
    xor r8, r8 ; length
    xor r9, r9 ; sign flag

    cmp rdi, 0
    jne .check_sign

    mov byte [rsi], '0'
    mov byte [rsi+1], 0
    mov rax, 1
    pop rbx
    ret

  .check_sign:
    cmp rdi, 0
    jge .convert

    mov r9, 1
    neg rdi

  .convert:
  .loop:
    mov rax, rdi
    xor rdx, rdx
    mov rbx, 10
    div rbx

    add dl, '0'
    mov [rsi + rcx], dl

    inc rcx
    inc r8

    mov rdi, rax
    cmp rdi, 0
    jne .loop

    cmp r9, 0
    je .reverse

    mov byte [rsi + rcx], '-'
    inc rcx
    inc r8

  .reverse:
    xor rbx, rbx
    dec rcx

  .rev_loop:
    cmp rbx, rcx
    jge .done

    mov al, [rsi + rbx]
    mov dl, [rsi + rcx]

    mov [rsi + rbx], dl
    mov [rsi + rcx], al

    inc rbx
    dec rcx
    jmp .rev_loop

  .done:
    mov byte [rsi + r8], 0   
    mov rax, r8           

    pop rbx
    ret

utoa: ; rdi = unsigned integer, rsi = buffer | rax = length
    push rbx

    xor rcx, rcx ; index
    xor r8, r8   ; length

    cmp rdi, 0
    jne .loop

    mov byte [rsi], '0'
    mov byte [rsi+1], 0
    mov rax, 1
    pop rbx
    ret

  .loop:
    mov rax, rdi
    xor rdx, rdx
    mov rbx, 10
    div rbx       

    add dl, '0'
    mov [rsi + rcx], dl

    inc rcx
    inc r8

    mov rdi, rax
    test rdi, rdi
    jnz .loop

  .reverse: 
    xor rbx, rbx
    dec rcx

  .rev_loop:
    cmp rbx, rcx
    jge .done

    mov al, [rsi + rbx]
    mov dl, [rsi + rcx]

    mov [rsi + rbx], dl
    mov [rsi + rcx], al

    inc rbx
    dec rcx
    jmp .rev_loop

  .done:
    mov byte [rsi + r8], 0
    mov rax, r8

    pop rbx
    ret

load_arg: ; rdi = argument index | rax = value 
  cmp rdi, 4 
  jg .takeFromStack
  
  neg rdi 
  lea rax, [r15 - 48 + rdi * 8]
  neg rdi

  mov rax, [rax]
  ret 

  .takeFromStack:
    sub rdi, 5
    lea rax, [r15 + 16 + rdi * 8]
    mov rax, [rax]

    ret 

printfmt: ; rdi = fmtString , ...
  ; %s = string
  push rbp 
  mov rbp, rsp 
  
  push rbx 
  push r12
  push r13 
  push r14
  push r15

  push rsi
  push rdx 
  push rcx 
  push r8
  push r9 

  mov r15, rbp 
  
  mov rbx, rdi 
  xor r12, r12 ; counter 
  xor r13, r13 ; current char 

  .loop:
    cmp byte [rbx + r13], 0 
    je .end 
    
    cmp byte [rbx + r13], '%'
    je .fmtchk

    jmp .printchar 

    .fmtchk:
      inc r13

      cmp byte [rbx + r13], '%'
      je .printchar 

      mov byte [longFlag], 0
      mov byte [unsignedFlag], 0
      
      cmp byte [rbx + r13], 'u'
      je .setUnsignedFlag 

      jmp .checkLongFlag 
      
      .setUnsignedFlag:
        mov byte [unsignedFlag], 1 
        inc r13 

      .checkLongFlag:

      cmp byte [rbx + r13], 'l'
      je .setLongFlag 

      jmp .continueCheck
      
      .setLongFlag:
        mov byte [longFlag], 1
        inc r13 

        cmp byte [rbx + r13], 'l'
        je .inc 

        jmp .continueCheck

        .inc:
          inc r13

      .continueCheck:
        
      cmp byte [rbx + r13], 's'
      je .printstr

      cmp byte [rbx + r13], 'd'
      je .int

      cmp byte [rbx + r13 - 1], 'l'
      je .int 
      
      jmp .continue 

      .int:
        cmp byte [unsignedFlag], 1 
        je .uint

        jmp .printint

        .uint:
          cmp byte [longFlag], 1 
          je .printuint

          inc r13
          jmp .printuint

      .continue:
        cmp byte [rbx + r13], 'c'
        je .printcharArg 
      

      dec r13
      jmp .printchar
      
    .printstr:  
      mov rdi, r12 
      call load_arg
      inc r12 
      
      push rax 
      mov rdi, rax 
      call strlen

      pop rsi 

      mov rdx, rax
      mov rax, 1 
      mov rdi, 1 
 
      syscall
      
      inc r13  

      jmp .loop

    .printint:
      mov rdi, r12 
      call load_arg 
      inc r12 
      
      cmp byte [longFlag], 1
      je .long

      movsxd rdi, eax
      jmp .convert 

      .long:
        mov rdi, rax
      
      .convert:
        mov rsi, intBuf   
        call itoa 

      mov rdx, rax
      mov rsi, intBuf
      mov rdi, 1 
      mov rax, 1 

      syscall 
      
      inc r13

      jmp .loop

    .printuint:
      mov rdi, r12 
      call load_arg 
      inc r12 

      cmp byte [longFlag], 1 
      je .ulong 

      mov edi, eax 
      mov rdi, rax 
      jmp .uconvert

      .ulong:
        mov rdi, rax 

      .uconvert:
        mov rsi, intBuf
        call utoa 

      mov rdx, rax 
      mov rsi, intBuf
      mov rdi, 1 
      mov rax, 1 

      syscall 

      jmp .loop 

    .printcharArg:
      mov rdi, r12 
      call load_arg 
      inc r12 
      
      mov byte [charBuf], al 
      
      mov rax, 1 
      mov rdi, 1 
      mov rsi, charBuf 
      mov rdx, 1 

      syscall

      inc r13 

      jmp .loop

    .printchar:
      lea r14, [rbx + r13] 
      mov rax, 1 
      mov rdi, 1 
      mov rsi, r14 
      mov rdx, 1 

      syscall

      inc r13 

      jmp .loop

  .end:
    add rsp, 40
    pop r15 
    pop r14 
    pop r13 
    pop r12 
    pop rbx  
    pop rbp

    ret 

sys_exit: ; rdi = exit code 
  mov rax, 60 
  syscall 
