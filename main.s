.global main

.text
    null1: .asciz "x"    # null character follows
    file1: .asciz "hello there\n\nHow are you?\n"
    file1end: .equ len1, file1end - file1

    null2: .asciz "x"   # null character follows
    file2: .asciz "Hello there\nHow are you?\n"
    file2end: .equ len2, file2end - file2

    space: .asciz " " 
    newLine: .asciz "\n" 

    resultFrmt1: .asciz "< "
    resultFrmt2: .asciz "---\n> "

    debugString: .asciz "entered here"

    frmt: .asciz "%ld"


main:                     
    pushq %rbp              # Save address of previous stack frame, store the caller’s basepointer. stack pointer is decreased by 8.       
    movq %rsp, %rbp         # re-initialize the base pointer.  This saves the current stack pointer in %rbp

    pushq $file2            # memory location of first char in text1 pushed as param on stack 
    pushq $file1            # memory location of first char in text2 pushed as param on stack
    call diff

    movq $0, %rdi
    call exit

diff:
    movq 8(%rsp), %rsi      # text1 memory location first char
    movq 16(%rsp), %rdi     # text2 memory location first char

    movq $space, %r12
    movb (%r12), %r14b       # 8-bit space char in %r14b 8-bit register
    movq $newLine, %r12
    movb (%r12), %r15b   	# 8-bit newLine char "\n" in %r15b 8-bit register

    movq $1, %rdx           # initiate file1 lines counter to 1
    movq $1, %r12           # initiate file2 lines counter to 1
loop1:
    movb (%rsi), %al        # store content at memory location %rsi(text1) in 8-bit register (%rax)
    movb (%rdi), %bl        # store content at memory location %rdi(text2) in 8-bit register (%rbx)

    cmpb $0x0, %al
    je text1Ended
    cmpb $0x0, %bl
    je text2Ended

    cmpb %al, %bl        
    je ifEqual

##########
FLAGS:
    movb $1, %cl           # -B flag
    movb $1, %ah           # -i flag
IsBlankEnabled:
    cmpb $1, %cl
    je  checkEmptyLines1
IsIgnCaseEnbled:
    cmpb $1, %ah
    je checkCase
    jmp checkEnd1Char
##########

checkEmptyLines1:
    cmpb %al, %r15b
    jne checkEmptyLines2
    decq %rsi
    movb (%rsi), %al
    cmpb %al, %r15b
    jne restoreRSI
    incq %rdx
    addq $2, %rsi
    jmp loop1
checkEmptyLines2:
    cmpb %bl, %r15b
    jne IsIgnCaseEnbled
    decq %rdi
    movb (%rdi), %bl
    cmpb %bl, %r15b
    jne restoreRDI
    incq %r12
    addq $2, %rdi
    jmp loop1
restoreRSI:
    incq %rsi
    movb (%rsi), %al
    jmp checkEmptyLines2
restoreRDI:
    incq %rdi
    movb (%rdi), %bl
    jmp IsIgnCaseEnbled


#############


#############
checkCase:
    addb $32, %al
    cmpb %al, %bl
    je sameLetter
    subb $32, %al
    addb $32, %bl
    cmpb %al, %bl 
    je sameLetter
    subb $32, %bl 
    jmp checkEnd1Char
sameLetter:
    incq %rsi
    incq %rdi

    jmp loop1


#############

ifEqual:
    incq %rsi               # point to next char in text1
    incq %rdi               # point to next char in text2

    cmpb %al, %r15b
    je incLinesCount    
    jmp loop1
incLinesCount:
    incq %rdx
    incq %r12
    jmp loop1

###### check for end ######

text1Ended:
    ret
text2Ended:                 
    ret


# # # # # # # # The program has officially detected differences in the two lines # # # # # # # # #


############# print Text1 Line #############

checkEnd1Char:              # increase %rsi until it reaches end of line char and store it in %al
    cmpb %al, %r15b
    je pushText1Chars
    
    incq %rsi
    movb (%rsi), %al    
    jmp checkEnd1Char

pushText1Chars:             # push text1 chars and decb %rsi until %al is previous "\n" or a null byte
    cmpb $0x0, %al          
    je PrintText1Chars      

    pushq %rax              # last character pushed on stack is the first of the line
    
    decq %rsi               # %rsi will eventually point to the null char or Previous newLineChar
    movb (%rsi), %al

    cmpb %al, %r15b
    je PrintText1Chars
    jmp pushText1Chars

PrintText1Chars:
    ######## Print changes format ########
    
    ##### n ####
    addq $48, %rdx
    pushq %rdx
    subq $48, %rdx
    pushq %rdx
    pushq %rsi
    movq %rsp, %rsi
    addq $16, %rsi
    pushq %rax
    pushq %rdi 
    
    movq $1, %rax
    movq $1, %rdi
    movq $1, %rdx
    syscall

    popq %rdi
    popq %rax
    popq %rsi
    popq %rdx
    addq $8, %rsp

    ######## c ########
    pushq $99
    pushq %rdx
    pushq %rsi
    movq %rsp, %rsi
    addq $16, %rsi
    pushq %rax
    pushq %rdi

    movq $1, %rax
    movq $1, %rdi
    movq $1, %rdx
    syscall

    popq %rdi
    popq %rax
    popq %rsi
    popq %rdx
    addq $8, %rsp

    #### n ####
    addq $48, %r12
    pushq %r12
    subq $48, %r12
    pushq %rdx
    pushq %rsi
    movq %rsp, %rsi
    addq $16, %rsi
    pushq %rax
    pushq %rdi 
    
    movq $1, %rax
    movq $1, %rdi
    movq $1, %rdx
    syscall

    popq %rdi
    popq %rax
    popq %rsi
    popq %rdx
    addq $8, %rsp

    ######## \n ########
    pushq $10
    pushq %rdx
    pushq %rsi
    movq %rsp, %rsi
    addq $16, %rsi
    pushq %rax
    pushq %rdi

    movq $1, %rax
    movq $1, %rdi
    movq $1, %rdx
    syscall

    popq %rdi
    popq %rax
    popq %rsi
    popq %rdx
    addq $8, %rsp

    ######################################

    movq $0x0, %r13             # reset %13 register
    pushq %rsi
    pushq %rax
    pushq %rdi
    pushq %rdx

    movq $resultFrmt1, %rsi
    movq $1, %rax
    movq $1, %rdi
    movq $2, %rdx
    syscall

    popq %rdx
    popq %rdi
    popq %rax
    popq %rsi
loopPrint1:
    cmpb %r15b, %r13b        # when r13b contains the newLine character just printed (line 110) print text2
    je checkEnd2Char
    
    pushq %rsi
    movq %rsp, %rsi          
    addq $8, %rsi            #store contents of %rsp pointing at char in the stack into %rsi

    pushq %rax
    pushq %rdi
    pushq %rdx

    movq $1, %rax
    movq $1, %rdi
    movq $1, %rdx
    syscall

    popq %rdx
    popq %rdi
    popq %rax
    popq %rsi 

    popq %r13               # pop contents of stack into temporary registers to compare its contents with %r15
    incq %rsi               # increment back %rsi to reach newLine character
    jmp loopPrint1


############ Print Text2 Line ############

checkEnd2Char:              # increase %rdi until it reaches end of line char and store it in %bl
    cmpb %bl, %r15b
    je pushText2Chars
    
    incq %rdi
    movb (%rdi), %bl    
    jmp checkEnd2Char

pushText2Chars:             # push text2 chars and decb %rdi until %bl is previous "\n" or a null byte
    cmpb $0x0, %bl          
    je PrintText2Chars      

    pushq %rbx              # last character pushed on stack is the first of the line
    
    decq %rdi               # %rsi will eventually point to the null char or Previous newLineChar
    movb (%rdi), %bl

    cmpb %bl, %r15b
    je PrintText2Chars
    jmp pushText2Chars

PrintText2Chars:
    movq $0x0, %r13         # reset r13 as r13b is currently holding newline value
    pushq %rsi
    pushq %rax
    pushq %rdi
    pushq %rdx

    movq $resultFrmt2, %rsi
    movq $1, %rax
    movq $1, %rdi
    movq $7, %rdx
    syscall

    popq %rdx
    popq %rdi
    popq %rax
    popq %rsi
loopPrint2:
    cmpb %r15b, %r13b
    je endPrint
    
    pushq %rsi
    movq %rsp, %rsi          
    addq $8, %rsi            #store contents of %rsp + 8 pointing at char in the stack into %rsi

    pushq %rax
    pushq %rdi
    pushq %rdx

    movq $1, %rax
    movq $1, %rdi
    movq $1, %rdx
    syscall

    popq %rdx
    popq %rdi
    popq %rax
    popq %rsi 

    popq %r13               # pop contents of stack into temporary registers
    incq %rdi               # increment back %rdi to reach newLine character
    jmp loopPrint2

endPrint:
    jmp loop1






    

   


        


