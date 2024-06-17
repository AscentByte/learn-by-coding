section .data
  msg db "Hello,World", 10;

section .text
  global _start

_start:
  mov rax, 1;
  mov rdi, 1;
  mov rsi, msg;
  mov rdx, 12;
  syscall;
  
  xor rbx, rbx;
  mov rax, 60;
  syscall;
