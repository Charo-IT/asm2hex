# asm2hex
This tool assembles a file using nasm, and prints its opcode in hex.

## Usage
```
$ ./asm2hex.rb [options] filename
options:
  -e: print escaped shellcode
  -b bit: 32 or 64 (default is 64bit)
```

## Sample
```
$ cat shellcode.s
; push "/bin/sh"
push 0x0068732f
push 0x6e69622f

; syscall execve
mov ebx, esp
xor edx, edx
push edx
push ebx
mov ecx, esp
mov eax, 11
int 0x80

$ ./asm2hex.rb -b 32 shellcode.s
     1                                  ; push "/bin/sh"
     2 00000000 682F736800              push 0x0068732f
     3 00000005 682F62696E              push 0x6e69622f
     4
     5                                  ; syscall execve
     6 0000000A 89E3                    mov ebx, esp
     7 0000000C 31D2                    xor edx, edx
     8 0000000E 52                      push edx
     9 0000000F 53                      push ebx
    10 00000010 89E1                    mov ecx, esp
    11 00000012 B80B000000              mov eax, 11
    12 00000017 CD80                    int 0x80

code length: 25
[!] contains null byte
682f736800682f62696e89e331d2525389e1b80b000000cd80
```

