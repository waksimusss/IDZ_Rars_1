.include "array.s" #Импортируем данные макросов
.data
q1: .asciz "Необходимо ли вывести тесты? Да - 1 Нет - 0\n"
q2: .asciz "Хотите ввести данные еще раз? Да - 1 Нет - 0\n"
.align 2 #Инициализируем памать под два массива, элементы которых равны word
array_A: .space 40 
.align 2
array_B: .space 40
.text

main:
  	input_array_length 		#Ввод кол-во элементов в массиве. Сохраняет результат в регистр s1
  	input_array(array_A)		#Вводит поочредно элементы в массив А
  	clone(array_A,array_B)	#Клонирует массив А в массив В
 	sort(array_B)			#Сортирует массив по убыванию
 	print_array(array_A)		#Выводит массив А
 	print_array(array_B)		#Выводит массив В
 
	la	a0, q2		# Вопрос о повторении
      	li	a7, 4           # Системный вызов №4
      	ecall
      	li    	a7 5           	# Системный вызов №5 — ввести десятичное число
      	ecall	
 	beqz a0, no_rec
 	j main

end:	
  	li a7 10			#Завершение работы программы с кодом ноль
  	ecall

no_rec:
	la	a0, q1		# Вопрос о выводе тестов
      	li	a7, 4           # Системный вызов №4
      	ecall
      	li    	a7 5           	# Системный вызов №5 — ввести десятичное число
      	ecall
	beqz a0, end
 	test
 	j end