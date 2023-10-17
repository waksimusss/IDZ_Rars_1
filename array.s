.macro input_array_length
.data
prompt: .asciz  "n =  "   	# Подсказка для ввода числа
.text
      la	a0, prompt	# Подсказка для ввода числа элементов массива
      li	a7, 4           # Системный вызов №4
      ecall
      li    	a7 5           	# Системный вызов №5 — ввести десятичное число
      ecall
      mv   	s1, a0    	#Cохраняем результат работы в s1
      
.end_macro

.macro check_count(%n)
.data
error:  .asciz  "Некорректный ввод\n"  # Сообщение о некорректном ввод  
.text
  	ble   %n zero fail_with_length # На ошибку, если меньше 1
      	li    t0 10			# Размер массива
      	bgt   %n t0 fail_with_length   # На ошибку, если больше 10
   	j exit
fail_with_length:    
      	la   a0, error       # Сообщение об ошибке
	li   a7, 4           # Системный вызов №4
     	ecall
      	li      a7 10           # Останов
        ecall    
exit:  
.end_macro

.macro input_array (%array)
.data         
prompt: .asciz  "n[i] =  " 
.text
  	la   	t0 %array	#Сохраняем адрес масиива в t0 
  	add   	a1 s1 zero
fill:  
      	la  	a0, prompt      # Подсказка для ввода числа
        li   	a7, 4           # Системный вызов №4
        ecall
        li      a7 5            # Системный вызов №5 — ввести десятичное число
        ecall
        mv   	 t1 a0
        sw      t1 (t0)         # Запись числа по адресу в t0
        addi    t0 t0 4         # Увеличим адрес на размер слова в байтах
        addi    a1 a1 -1        # Уменьшим количество оставшихся элементов на 1
        bnez    a1 fill         # Если осталось больш 0
        
        add   	a1 s1 a1      
        li  	a1 0        
.end_macro

.macro clone(%array, %cloned_array)

.text

        # Инициализация регистров
        li t0, 0  # Счетчик для массива     
        la t6, %cloned_array  # Адрес начала клонированного массива
        la t5, %array
clone_loop:
        # Проверяем, не достигли ли конца массива
        blt t0, s1, continue_clone

        j end_clone  # Завершаем клонирование, если достигли конца массива

continue_clone:
        # Копируем элемент из исходного массива в клонированный
        lw t3, 0(t5)  # Загружаем значение элемента из исходного массива
        sw t3, 0(t6)  # Сохраняем значение элемента в клонированном массиве

        # Увеличиваем указатели на массивы
        addi t0, t0, 1  # Увеличиваем счетчик
        addi t5, t5, 4  # Увеличиваем указатель на исходный массив на размер элемента (4 байта)
        addi t6, t6, 4  # Увеличиваем указатель на клонированный массив на размер элемента (4 байта)

  
        j clone_loop  # Продолжаем клонирование
end_clone:
.end_macro

# Реализация сортировки
# Используется алгоритм сортировки пузырьком

# Макрос начинается здесь
.macro sort (%array)
    # Регистры
    li t0, 1 # Индекс внешнего цикла
    li t1, 1 # Индекс внутреннего циклa

outer_loop:
    bge t0, s1, done # Если внешний цикл закончился, то переходим к завершению
    li t1, 1 # Сбрасываем индекс внутреннего цикла
    la t3, %array # Базовый адрес массива
inner_loop:
    bge t1, s1, outer_loop_end # Если внутренний цикл закончился, то переходим к следующей итерации внешнего цикла

    # Сравнение элементов
    lw t4, 0(t3) # Загрузка текущего элемента массива
    lw t5, 4(t3) # Загрузка следующего элемента массива
    bge t4, t5, no_swap # Если текущий элемент меньше следующего, то пропускаем обмен
swap:
    sw t5, 0(t3) # Записываем следующий элемент на место текущего
    sw t4, 4(t3) # Записываем текущий элемент на место следующего
no_swap:
    addi t1, t1, 1 # Увеличиваем индекс внутреннего цикла на 1
    addi t3, t3, 4 # Переходим к следующим двум элементам массива
    j inner_loop # Переходим к следующей итерации внутреннего цикла
outer_loop_end:
    addi t0, t0, 1 # Увеличиваем индекс внешнего цикла на 1
    j outer_loop # Переходим к следующей итерации внешнего цикла
done:
.end_macro

.macro print_array(%array)
.data
dev: .asciz  "\n"         # Разделитель для строки
space: .asciz  " "  	  # Разделитель для массива
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

mes1: .asciz "Тест 1\n"
mes2: .asciz "Тест 2\n"
mes3: .asciz "Тест 3\n"
mes4: .asciz "Тест 4\n"
mes5: .asciz "Тест 5\n"
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
