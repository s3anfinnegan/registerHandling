# RISC-V assembly program
# x5(0) = x3(x4) 
# Seán Finnegan and Cormac O'Léime, Oct 2022
# 
# Using a range of approaches, which impact 
#   no of instructions
#   no of cycles to execute
#
# Function setup initialises x3 and x5 registers
# 
# Register 		Use
# x3			0xd00d5
# x4			adding 3 to choose digit 3
# x5			0xb4dd1
# x6			addign 5 to choose didgit 5
# x7			counter in mask functions
# x8			copy of x3
# x9			copy of x5
# x10			stores digit 3 
# x11			stores digit 5 
# x12			stores increment of 12
# x13			stores increment of 20			
# x15			moves 3 spaces left (12/4 increments) to enable swap
# x16			moves 5 spaces left (20/4 incements) to enable swap


main: 
 	jal  x1, setup #set up
    jal x1, srli_mask_3 #jump to mask functions for x3 and x5
    jal x1, srli_mask_5 
    jal x1, increment #incrementing registers
    jal x1, moveSpaces #moving digit 4 bits at a time to desired location
    jal x1, takeDigits #isolating digits
 	jal x1, swapDigits #swapping digits

srli_mask_3:        
 	addi x7, x0, 0 #x7 used as a counter
 srliLoop_3:
  	srli x8, x8, 4  #shifting x8 right 4 bits/1 space
  	addi x7, x7, 1 #increment counter +1
  	bne  x7, x4, srliLoop_3 #if x7 and x4 not equal run loop
  	andi x10, x8, 0xf 
    jalr x0, 0(x1)  
 	 
 
srli_mask_5:         
 	addi x7, x0, 0   
 srliLoop_5:
  	srli x9, x9, 4  #shift x9 4 bits right/1 space
  	addi x7, x7, 1   #increment counter +1
  	bne  x7, x6, srliLoop_5 #if not equal, loop
 	andi x11, x9, 0xf 
 	jalr x0, 0(x1)    


increment:
    add x12, x0,  x4 #+3 = 3
    add x12, x12, x4 #+3 = 6
    add x12, x12, x4 #+3 = 9
    add x12, x12, x4 #+3 = 12
    
    add x13, x0,  x6 #5
    add x13, x13, x6 #10
    add x13, x13, x6 #15
    add x13, x13, x6 #20
    jalr x0, 0(x1)
    
moveSpaces:
    sll x15, x10, x12 #move spaces 12/4 = 3
    sll x16, x11, x13 #move spaces 20/4 = 5  
    sll x11, x11, x12 #move spaces opposite direction to allow swap
    sll x10, x10, x13 #e.g |[][][here][][and here]|
    jalr x0, 0(x1)

takeDigits:
	sub x3, x3, x15 #isolate '5' in space 5
    sub x5, x5, x16 #isolate 'd' in space 3
    jalr x0, 0(x1)

swapDigits:
    or x3, x3, x11 #using OR logic swap '5' and 'd' if '5' OR 'd' are present
    or x5, x5, x10 #otherwise don't change the register
    jalr x0, 0(x1)

setup:
 	lui  x3, 0xd00d5 #initialise x3 as 0xd00d5
 	lui x5, 0xb4dd1 #initialise x5 as 0xb4dd1
 	addi x4, x0, 3 #adding '3' to x4 
 	addi x6, x0, 5 #adding '5' to x6
    add  x8, x0, x3 #copying x3 to x8 and x5 to x9
    add  x9, x0, x5 
 	jalr x0, 0(x1)   # ret