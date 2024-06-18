	global _start
	section	 .text 
_start:	
	mov ax, ss;
	mov [ss_value], ax;
	mov rdi, msg;
	mov rsi, msg_lenth;
	call _myPrint;

	mov rsi, ss_value_lenth;
	mov rdi, ss_value;
	call _myPrint;

	mov rsi, 1;
	mov rdi, newl;
	call _myPrint;

	xor rdi, rdi;
	mov rax, 60;
	syscall;	

_myPrint: ;这里使用的是寄存器进行传值
	mov rdx, rsi;
	mov rsi, rdi; 
	mov rax, 1;
	mov rdi, 1;
	syscall;
	ret;	
	

	section .data
msg:	db	"Segment selector SS: 0x", 0
msg_lenth: equ $-msg ;在汇编中$代表当前地址处的值, - msg正好得出msg的长度	
newl:	db	"",10
	section .bss
ss_value:	resw 1;
ss_value_lenth: equ $ - ss_value;
