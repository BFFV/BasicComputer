DATA:

a 1
b 2
c 3
d 4
e 5

CODE:	

 MOV        A,B       
 MOV        B,A       
 MOV        A,b     
 MOV        B,Ch     
 MOV        A,(a)   
 MOV        B,(b)
 MOV A,(0)  
 MOV B,(1) 
 MOV        (b),A  
 MOV (0),A
 MOV (1),B 
 MOV        (a),B   
 MOV        A,(B)     
 MOV        B,(B)     
 MOV        (B),A     
 MOV        (B),00b   
 ADD        A,B       
 ADD        B,A       
 ADD        A,1000b     
 ADD        B,FFh     
 ADD        A,(c)  
 ADD A,(0)
 ADD B,(0)
ADD (1) 
 ADD        B,(d)   
 ADD        (e)     
 ADD        A,(B)     
 ADD        B,(B)     
 SUB        A,B       
 SUB        B,A       
 SUB        A,Fh     
 SUB        B,e     
 SUB        A,(a)   
 SUB        B,(b)   
 SUB        (c)     
 SUB        A,(B)     
 SUB        B,(B)     
 AND        A,B       
 AND        B,A       
 AND        A,0     
 AND        B,33d     
 AND        A,(a)   
 AND        B,(b)   
 AND        (c)     
 AND        A,(B)     
 AND        B,(B)     
 OR         A,B       
 OR         B,A       
 OR         A,e     
 OR         B,12h     
 OR         A,(d)   
 OR         B,(e)   
 OR         (d)     
 OR         A,(B)     
 OR         B,(B)     
 XOR        A,B       
 XOR        B,A       
 XOR        A,1111b     
 XOR        B,1111d     
 XOR        A,(c)   
 XOR        B,(d)   
 XOR        (a)     
 XOR        A,(B)     
 XOR        B,(B)     
 NOT        A         
 NOT        B,A       
 NOT        (c),A   
 NOT        (B),A     
 SHL        A         
 SHL        B,A       
 SHL        (a),A   
 SHL        (B),A  
 SHL (1),A   
 SHR        A         
 SHR        B,A       
 SHR        (c),A   
 SHR        (B),A     
 INC        A         
 INC        B         
 INC        (d)    
 INC (1) 
 INC        (B)       
 DEC        A 
		jump:        
 CMP        A,B       
 CMP        A,a     
 CMP        A,(a)  
 CMP A,(2) 
 CMP        A,(B)     
 JMP        jump       
 JEQ        jump       
 JNE        jump       
 JGT        jump       
 JGE        jump       
 JLT        jump       
 JLE        jump      
 JCR        jump       
PUSH       A         
 PUSH       B 
 CALL       none
 JMP xd    
none:   
  NOP
NOP
NOP
NOP     
 RET 
xd:      
POP	A
 POP	B 
      
//fin