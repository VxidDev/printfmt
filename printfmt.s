global printfmt

strlen: ; rdi = string 
  xor rax, rax

  .loop:
    cmp byte [rdi + rax], 0 
    je .end

    inc rax 
    jmp .loop 

  .end:
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

      cmp byte [rbx + r13], 's'
      je .printstr
      
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
