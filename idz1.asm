.include "array.s" #����������� ������ ��������
.data
q1: .asciz "���������� �� ������� �����? �� - 1 ��� - 0\n"
q2: .asciz "������ ������ ������ ��� ���? �� - 1 ��� - 0\n"
.align 2 #�������������� ������ ��� ��� �������, �������� ������� ����� word
array_A: .space 40 
.align 2
array_B: .space 40
.text

main:
  	input_array_length 		#���� ���-�� ��������� � �������. ��������� ��������� � ������� s1
  	input_array(array_A)		#������ ��������� �������� � ������ �
  	clone(array_A,array_B)	#��������� ������ � � ������ �
 	sort(array_B)			#��������� ������ �� ��������
 	print_array(array_A)		#������� ������ �
 	print_array(array_B)		#������� ������ �
 
	la	a0, q2		# ������ � ����������
      	li	a7, 4           # ��������� ����� �4
      	ecall
      	li    	a7 5           	# ��������� ����� �5 � ������ ���������� �����
      	ecall	
 	beqz a0, no_rec
 	j main

end:	
  	li a7 10			#���������� ������ ��������� � ����� ����
  	ecall

no_rec:
	la	a0, q1		# ������ � ������ ������
      	li	a7, 4           # ��������� ����� �4
      	ecall
      	li    	a7 5           	# ��������� ����� �5 � ������ ���������� �����
      	ecall
	beqz a0, end
 	test
 	j end