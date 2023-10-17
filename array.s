.macro input_array_length
.data
prompt: .asciz  "n =  "   	# ��������� ��� ����� �����
.text
      la	a0, prompt	# ��������� ��� ����� ����� ��������� �������
      li	a7, 4           # ��������� ����� �4
      ecall
      li    	a7 5           	# ��������� ����� �5 � ������ ���������� �����
      ecall
      mv   	s1, a0    	#C�������� ��������� ������ � s1
      
.end_macro

.macro check_count(%n)
.data
error:  .asciz  "������������ ����\n"  # ��������� � ������������ ����  
.text
  	ble   %n zero fail_with_length # �� ������, ���� ������ 1
      	li    t0 10			# ������ �������
      	bgt   %n t0 fail_with_length   # �� ������, ���� ������ 10
   	j exit
fail_with_length:    
      	la   a0, error       # ��������� �� ������
	li   a7, 4           # ��������� ����� �4
     	ecall
      	li      a7 10           # �������
        ecall    
exit:  
.end_macro

.macro input_array (%array)
.data         
prompt: .asciz  "n[i] =  " 
.text
  	la   	t0 %array	#��������� ����� ������� � t0 
  	add   	a1 s1 zero
fill:  
      	la  	a0, prompt      # ��������� ��� ����� �����
        li   	a7, 4           # ��������� ����� �4
        ecall
        li      a7 5            # ��������� ����� �5 � ������ ���������� �����
        ecall
        mv   	 t1 a0
        sw      t1 (t0)         # ������ ����� �� ������ � t0
        addi    t0 t0 4         # �������� ����� �� ������ ����� � ������
        addi    a1 a1 -1        # �������� ���������� ���������� ��������� �� 1
        bnez    a1 fill         # ���� �������� ����� 0
        
        add   	a1 s1 a1      
        li  	a1 0        
.end_macro

.macro clone(%array, %cloned_array)

.text

        # ������������� ���������
        li t0, 0  # ������� ��� �������     
        la t6, %cloned_array  # ����� ������ �������������� �������
        la t5, %array
clone_loop:
        # ���������, �� �������� �� ����� �������
        blt t0, s1, continue_clone

        j end_clone  # ��������� ������������, ���� �������� ����� �������

continue_clone:
        # �������� ������� �� ��������� ������� � �������������
        lw t3, 0(t5)  # ��������� �������� �������� �� ��������� �������
        sw t3, 0(t6)  # ��������� �������� �������� � ������������� �������

        # ����������� ��������� �� �������
        addi t0, t0, 1  # ����������� �������
        addi t5, t5, 4  # ����������� ��������� �� �������� ������ �� ������ �������� (4 �����)
        addi t6, t6, 4  # ����������� ��������� �� ������������� ������ �� ������ �������� (4 �����)

  
        j clone_loop  # ���������� ������������
end_clone:
.end_macro

# ���������� ����������
# ������������ �������� ���������� ���������

# ������ ���������� �����
.macro sort (%array)
    # ��������
    li t0, 1 # ������ �������� �����
    li t1, 1 # ������ ����������� ����a

outer_loop:
    bge t0, s1, done # ���� ������� ���� ����������, �� ��������� � ����������
    li t1, 1 # ���������� ������ ����������� �����
    la t3, %array # ������� ����� �������
inner_loop:
    bge t1, s1, outer_loop_end # ���� ���������� ���� ����������, �� ��������� � ��������� �������� �������� �����

    # ��������� ���������
    lw t4, 0(t3) # �������� �������� �������� �������
    lw t5, 4(t3) # �������� ���������� �������� �������
    bge t4, t5, no_swap # ���� ������� ������� ������ ����������, �� ���������� �����
swap:
    sw t5, 0(t3) # ���������� ��������� ������� �� ����� ��������
    sw t4, 4(t3) # ���������� ������� ������� �� ����� ����������
no_swap:
    addi t1, t1, 1 # ����������� ������ ����������� ����� �� 1
    addi t3, t3, 4 # ��������� � ��������� ���� ��������� �������
    j inner_loop # ��������� � ��������� �������� ����������� �����
outer_loop_end:
    addi t0, t0, 1 # ����������� ������ �������� ����� �� 1
    j outer_loop # ��������� � ��������� �������� �������� �����
done:
.end_macro

.macro print_array(%array)
.data
dev: .asciz  "\n"         # ����������� ��� ������
space: .asciz  " "  	  # ����������� ��� �������
.text
  	li t0, 0
  	la t1, %array
loop:
  	blt t0, s1, continue_print
  
  	j end_print
continue_print:
	
  	lw a0, (t1)
  	li a7, 1
  	ecall
  	li a7, 4
  	la a0, space
  	ecall
  
  	addi t0, t0 ,1
  	addi t1, t1,4
  
  	j loop
end_print:
	la a0, dev
	li a7, 4
	ecall
.end_macro

.macro test

.data 

mes1: .asciz "���� 1\n"
mes2: .asciz "���� 2\n"
mes3: .asciz "���� 3\n"
mes4: .asciz "���� 4\n"
mes5: .asciz "���� 5\n"
array_1: .word 1,2,3,4,5
array_2: .word -5,-4,-3,-2,-1
array_3: .word 2,-2,2,-2
array_4: .word 0,0,0
array_5: .word 10,-3,4,-1,0

.text

  addi s1, zero, 5
  li a7, 4
  la a0, mes1
  ecall 
  print_array(array_1)
  sort(array_1)		
  print_array(array_1)
  
  addi s1, zero, 5
  li a7, 4
  la a0, mes2
  ecall
  print_array(array_2)
  sort(array_2)
  print_array(array_2)
  
  addi s1, zero, 4
  li a7, 4
  la a0, mes3
  ecall
  print_array(array_3)
  sort(array_3)
  print_array(array_3)
  
  addi s1, zero, 3
  li a7, 4
  la a0, mes4
  ecall
  print_array(array_4)
  sort(array_4)
  print_array(array_4)
  
  addi s1, zero, 5
  li a7, 4
  la a0, mes5
  ecall
  print_array(array_5)
  sort(array_5)
  print_array(array_5)
.end_macro
