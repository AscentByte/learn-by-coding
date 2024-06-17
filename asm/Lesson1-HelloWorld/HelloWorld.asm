    global _start
  
    section .text ; 定义代码段 
_start:
    mov     rax,    1;
    mov     rdi,    1;
    mov     rsi,    msg;
    mov     rdx,    12;
    syscall;

    xor     rbx,     rbx;
    mov     rax,     60;
    syscall;
  
     section .data ; 定义数据段
 msg db "Hello,World", 10;
