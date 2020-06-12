
INCLUDE Irvine32.inc

.data
NewLine = 10
Maxsize = 100000
Stringlength dword ? 
SecondParameter equ [ebp + 8]
FirstParameter equ [ebp + 12]
MainString byte Maxsize dup(?) , 0
HelperString byte Maxsize dup(?), 0
msg1 byte "Welcome to Stringulation where string maipulation is valid" , Newline , 0 
msg2 byte "Enter the String to be manipulated: " , 0 
msg3 byte "Enter the starting index ( Zero Based ) : " , 0 
msg4 byte "Enter the number of elements to be removed: " , 0
msg5 byte "The New String: " , 0
msg6 byte "Enter the charater to be replaced: ",0
msg7 byte "Enter the character to replace: ", 0
msg8 byte "Enter the string you want to insert: " ,  0
msg9 byte "Enter the String you want to compare with: " , 0 
msg10 byte "Same" , NewLine , 0 
msg11 byte " is bigger" , Newline , 0
msg12 byte "Enter the string you want to search for: " , 0 
msg13 byte "Not found" , Newline, 0
msg14 byte "Found", NewLine, 0
msg15 byte "Press [1] to Remove" , Newline , "Press [2] to Compare", newLine , "Press [3] to Replace" , NewLine , "Press [4] to Insert" ,
                    NewLine  , "Press [5] to Search" , NewLine , "Press any other Key to close" , NewLine , 0
.code
main PROC

    beginWhile:
        Call CRLF
        mov edx, offset msg1
        call WriteString
        mov edx, offset msg15
        call WriteString
        call ReadDec
        cmp eax, 1
        je Erase
        cmp eax, 2
        je Comp
        cmp eax, 3
        je FindReplace
        cmp eax, 4
        je Insert
        cmp eax, 5
        je Search
        jmp next
        Erase:
            call StringRemove
            jmp beginWhile
        Comp:
            call StringCompare
            jmp beginwhile
        FindReplace:
            call StringReplace
            jmp beginwhile
        Insert:
            call StringInsertAt
            jmp beginwhile
        Search:
            call StringFind
            jmp beginwhile
        next:
exit
main ENDP

StringFind proc uses edx ecx 
    call TakeStringInput
    mov edx , offset msg12
    call WriteString
    mov edx,offset HelperString
    mov ecx, Maxsize
    call ReadString
    push eax
    call Find
    

    ret
StringFind endp

Find proc
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx
    
    
    mov ecx, StringLength
    sub ecx, SecondParameter
    inc ecx                                     ; iterator for the string ( StringLength - NewStringLength )
    cmp ecx, 0
            
    jle notequal                            ; jmp if the length of the new String is greater 
        mov edi, offset MainString
        
        mov al, HelperString[0]
        l1:
            
            push ecx
            cld
            scasb               ; compare each character with the first character of the new String
            jne next
                push edi
                mov esi, offset HelperString
                dec edi
                cld
                 
                mov ecx, SecondParameter
                
                repz cmpsb                  ; iterate to check for the rest of the new String
                
                dec esi
                dec edi
                cmpsb                       ; checks for the last character as cmpsb increments even though they are not equal
                jz isfound
                
                
                pop edi
            next:
            pop ecx
        loop l1
    
    notequal:
        mov edx, offset msg13
        jmp finished
    isfound:
        add esp, 8
        mov edx, offset msg14       
         
    
    finished:
    call WriteString
    
    pop ecx
    pop edi
    pop esi 
    pop ebp
    ret 4 
Find endp

StringCompare proc uses edx ecx 
    call TakeStringInput
    
    mov edx,offset msg9
    call WriteString
    mov edx, offset HelperString
    mov ecx, MaxSize
    call ReadString
    push eax
    call Compare
    
    
    ret
StringCompare endp

Compare proc
    push ebp
    mov ebp, esp
    push ecx
    push edx
    push edi 
    push esi
    
    push SecondParameter
    push StringLength
    call Minimuim                           ; return the miniuim string length 
    
    mov ecx, eax 
    
    mov esi, offset MainString
    mov edi, offset HelperString
    
    cld
    repz cmpsb                          ; loop while the two corresponding characters are equal
    jnz notequal                            ; when not equal then jump to compare between the last two characters 
        mov ecx, SecondParameter
        cmp ecx, StringLength               ; compare the lengths of the two strings
        jnz ll
            mov edx, offset msg10           ; ouput same if the lengths are equal 
            jmp next
        ll: 
            cmp ecx, StringLength
            jb first                            ; output first if greater 
            jmp second                      ; output second if greater
           
    notequal:
        mov al, [esi-1]
        cmp al, byte ptr [edi-1]                ; compare between the two last characters 
        ja first 
        second:
            mov edx, offset HelperString
            call WriteString
            mov edx, offset msg11               ; Second is bigger
            jmp next 
        first:
            mov edx, offset MainString
            call WriteString                        ; First is bigger
            mov edx, offset msg11
    next:
    call WriteString
    
    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebp
    ret 4
Compare endp
    
      
Minimuim proc
    push ebp
    mov ebp, esp
    push edx
    push ecx
    
    
    mov edx, FirstParameter
    mov ecx, SecondParameter    
    
    cmp edx, ecx
    jnb bigger_edx
        mov eax, edx 
        jmp next
    bigger_edx: 
        mov eax, ecx     
    next:
    
    pop ecx 
    pop edx 
    pop ebp
    ret 8
Minimuim endp

StringInsertAt proc uses edx ecx 
    call TakeStringInput
    
    mov edx, offset msg3
    call WriteString
    call ReadInt
    push eax
    mov edx, offset msg8
    call WriteString
    mov ecx, Maxsize
    mov edx, offset HelperString
    call ReadString
    push eax

    call InsertAt
    call DisplayString



    ret
StringInsertAt endp


InsertAt proc
    push ebp
    mov ebp, esp
    push ecx
    push esi
    push edi
    
    mov ecx, StringLength
    sub ecx, FirstParameter         ; iterator for the first loop ( ecx = StringLength - NewStringLength ) 
    
    mov eax, SecondParameter
    add eax, StringLength               ; eax = the last position after adding the new String
    sub eax, 1 
    
    mov edi, offset MainString          
    add edi, eax                                ; edi points to the last place in the String after inserting
    
    mov esi, offset MainString
    add esi, StringLength
    dec esi                                         ; esi points to the last place in the MainString
    
    mov eax, SecondParameter
    add StringLength, eax               ; updating the MainStringLength
       
    std
    rep movsb
     
    mov ecx, SecondParameter        ; iterator for the second loop ( ecx = NewStringLength )
        
    mov edi, offset MainString          ; edi points to the index of insertion of the new string
    add edi, FirstParameter 
    
    mov esi, offset HelperString            ;esi points to the new String
    
    cld
    
    rep movsb        
        
    
    pop edi
    pop esi
    pop ecx 
    pop ebp
    ret 8 
InsertAt endp


StringRemove proc uses edx  
    
    call TakeStringInput
    mov edx, offset msg3
    call WriteString
    call ReadInt
    push eax                    ; pushing to the stack frame the first parameter ( starting index )
    mov edx, offset msg4
    call WriteString
    call ReadInt                ; pushing the stack frame the second parameter ( the number of elements to be removed )
    push eax 
    call Remove                 ; performs the actual process of removal
    call DisplayString          ; displays the string 
    
    ret 
StringRemove endp


Remove proc 
    push ebp
    mov ebp , esp               ; ebp points now the top of the stack frame 
    push edi 
    push esi
    push ecx
    
    mov edi, offset MainString          
    mov esi, offset MainString
    mov ecx, FirstParameter             ; storing the first parameter 
    add edi, ecx                                ; makes edi points to the first element in the string which will be removed ( copied to the rest of the String )  
    add ecx, SecondParameter
    add esi, ecx                                ; esi now point the rest part of the string after the removed number of character 
    mov ecx, StringLength                  ; iterator for the rep loop
    sub ecx, SecondParameter            ; fit the iterator to the size of the characters which will be copied 
    mov StringLength, ecx                   ; update the StringLength with the new length after removal 
    cld                                                 ; forward direction ( increment ) 
    rep movsb                                   ; while ( ecx > 0) copy from esi to edi 
    
    mov ecx, StringLength
    mov byte ptr MainString[ecx], 0     ; adds a null nerminator character at the end of the new String 
     
    pop ecx  
    pop edi 
    pop esi
    pop ebp
    ret 8 
Remove endp


StringReplace proc uses edx
    call TakeStringInput
    
    mov edx, offset msg6
    call WriteString
    call ReadChar
    push eax
    call WriteChar
    call CRLf
    
    
    mov edx, offset msg7
    call WriteString
    call ReadChar
    push eax
    call WriteChar
    call CRLf
    
    call Replace
    call DisplayString
    
    ret
StringReplace endp

Replace proc
    push ebp
    mov ebp , esp               ; ebp points now the top of the stack frame 
    push edi 
    push ecx
    push ebx
    
    mov eax, FirstParameter             ; to be used for comparison "scansb"
    mov ecx, StringLength               ; iterator for the loop 
    mov ebx, SecondParameter        ; the character to replace 
    mov edi, offset MainString          
    cld                                             ; forward Direction
    l1:
        scasb                                       ; compare the current char ( [edi] ) with "al" ( first parameter ) 
        jne l1                                          ; if no equal then continue 
        mov byte ptr[edi-1] , bl              ; if equal change the character to the new one  ( "edi - 1" because scansb increments the value of edi )
    loop l1

    pop ebx 
    pop ecx  
    pop edi 
    pop ebp
    ret 8
Replace endp



TakeStringInput proc uses edx ecx
    mov edx, offset msg2
    call WriteString
    
    mov ecx , Maxsize                     ; Max size which can be entered by the user 
    mov edx , offset MainString      ; points to the array of byte of the string 
    call ReadString
    mov Stringlength, eax                 ; eax carries the size of the string entered 


    ret
TakeStringInput endp


DisplayString proc uses edx 
    mov edx ,offset msg5 
    call WriteString
    
    mov edx, offset MainString
    call WriteString
    call CRLF
    ret
DisplayString endp 

END main