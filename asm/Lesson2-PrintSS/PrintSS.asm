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
	mov rdi, 1000
	call alloc_heap_space
	mov rdi, 20000
	call alloc_heap_space

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
	
; 根据传入参数申请指定长度的堆内存空间，但是最大长度受常量LIMIT_HEAP_SIZE限制。
; 输入：rdi - 申请堆的大小（单位byte）
; 返回：rax - 堆空间开始地址
alloc_heap_space:
	cmp rdi, LIMIT_HEAP_SIZE
	jb .aloc
	mov rsi, msg_failed_len
	mov rdi, msg_failed
	call _myPrint	
	ret

	.aloc:
		mov r8, rdi ; 先将申请堆的大小进行保存
		mov rax, 12; 12 是sys_brk的系统调用号
		mov rdi, 0
		syscall
		mov rbx, rax
		
		add rbx, LIMIT_HEAP_SIZE
		mov rax, 12
		mov rdi, rbx
		syscall

		cmp rax, rdi
		je print_successful
		mov rsi, msg_failed_len
		mov rdi, msg_failed
		call _myPrint
   		ret

print_successful:
	mov rsi, msg_successful_len
	mov rdi, msg_successful
	call _myPrint
	ret

; 子程序：将十六进制数字转换为十六进制字符串
; 输入： rdi -存储十六进制的地址、rsi - 存储要转换的二进制
; 输出:	 rax - 字符串长度
binary_to_hexstring:
	mov rcx, 8
	mov rax, rdi
	mov rbx, rsi 
.loop:
	shr rbx, cl;
	and bl, 0xf
	add bl, '0' ; 这里加单引号代表是取0这个字符串对应的ascii码值
	cmp bl, '9'
	jbe .store_char
	add bl, 'a' - '9' - 1

	.store_char:
		mov [rax], bl
		inc rsi
		dec rcx
	jnz .loop 	

	section .data
msg:	db	"Segment selector SS: 0x", 0
msg_lenth: equ $-msg ;在汇编中$代表当前地址处的值, - msg正好得出msg的长度	
newl:	db	"",10
msg_failed:	db	"Memory allocation failed",10
msg_failed_len equ $ - msg_failed
msg_successful:	db	"Memory allocation successful",10
msg_successful_len equ $ - msg_successful

	section .bss
ss_value:	resw 1;
ss_value_lenth: equ $ - ss_value;
buffer: resb 3 ;申请三个字节空间用于存储转换后的选择子十六进制字符。
LIMIT_HEAP_SIZE equ 1024 ;限制申请的堆大小不能超过1024个字节
