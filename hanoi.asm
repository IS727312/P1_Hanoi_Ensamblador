# M. Alejandro Villalobos C. 	ISC 728135
# Miguel Mario Mendez A.	ISC 727312	

# int main() {
#     int n = 4;
#
#     int source[n] = {4, 3, 2, 1};
#     int auxiliary[n] = {0};
#     int destination[n] = {0};
# 
#     solveHanoi(n, source, auxiliary, destination);
#     
#     return 0;
# }
			
.text
main:
	addi a0, zero, 0	# movimientos
	addi a1, zero, 1	# CONST 1
	addi s0, zero, 7	# n = NUM_DISKS
	
	jal setup		# setup(...)
	
	jal solveHanoi		# solveHanoi(...)
	
	jal exit		# return 0
	
	
# void solveHanoi(int n, int source[], int auxiliary[], int destination[]) {
#     if (n == 1) {
#         moveDisk(source, destination);
#         return;
#     }
#     solveHanoi(n - 1, source, destination, auxiliary);
#     moveDisk(source, destination);
#     solveHanoi(n - 1, auxiliary, source, destination);
# }

solveHanoi:
	beq s0, a1, baseCase
	
	# push RA to stack
	addi sp, sp, -20	# stack pointer menos 20 bytes
	sw s0, 16(sp)		# guardar N en stack
	sw s1, 12(sp)		# guardar arreglo en stack
	sw s2, 8(sp)		# guardar arreglo en stack
	sw s3, 4(sp)		# guardar arreglo en stack
	sw ra, 0(sp)		# guardar RA en stack
	# recursion
	addi s0, s0, -1		# n -= 1
	addi t2, s2, 0		# temp = auxiliary
	addi s2, s3, 0		# auxiliary = destination
	addi s3, t2, 0		# destination = temp
	addi t2, zero, 0	# temp = null
	jal solveHanoi		# solveHanoi(...)
	# pop RA to stack
	lw ra, 0(sp)		# leer RA del stack
	lw s3, 4(sp)		# leer arreglo del stack
	lw s2, 8(sp)		# leer arreglo del stack
	lw s1, 12(sp)		# leer arreglo del stack
	lw s0, 16(sp)		# leer N del stack
	sw zero, 0(sp)		# limpiar RA del stack
	sw zero, 4(sp)		# limpiar arreglo del stack
	sw zero, 8(sp)		# limpiar arreglo del stack
	sw zero, 12(sp)		# limpiar arreglo del stack
	sw zero, 16(sp)		# limpiar N del stack
	addi sp, sp, 20		# stack pointer mas 20 bytes
	
	# move disk
	addi t6, ra, 0		# temp = ra
	jal moveDisk		# moveDisk(...)
	addi ra, t6, 0		# ra = temp
	addi t6, zero, 0	# temp = 0
	
	# push RA to stack
	addi sp, sp, -20	# stack pointer menos 20 bytes
	sw s0, 16(sp)		# guardar N en stack
	sw s1, 12(sp)		# guardar arreglo en stack
	sw s2, 8(sp)		# guardar arreglo en stack
	sw s3, 4(sp)		# guardar arreglo en stack
	sw ra, 0(sp)		# guardar RA en stack
	# recursion
	addi s0, s0, -1		# n -= 1
	addi t2, s1, 0		# temp = source
	addi s1, s2, 0		# source = auxiliary
	addi s2, t2, 0		# auxiliary = temp
	addi t2, zero, 0	# temp = null
	jal solveHanoi		# solveHanoi(...)
	# pop RA to stack
	lw ra, 0(sp)		# leer RA del stack
	lw s3, 4(sp)		# leer arreglo del stack
	lw s2, 8(sp)		# leer arreglo del stack
	lw s1, 12(sp)		# leer arreglo del stack
	lw s0, 16(sp)		# leer N del stack
	sw zero, 0(sp)		# limpiar RA del stack
	sw zero, 4(sp)		# limpiar arreglo del stack
	sw zero, 8(sp)		# limpiar arreglo del stack
	sw zero, 12(sp)		# limpiar arreglo del stack
	sw zero, 16(sp)		# limpiar N del stack
	addi sp, sp, 20		# stack pointer mas 20 bytes
	
	jalr ra
	
baseCase:	
	# move disk
	addi t6, ra, 0		# temp = ra
	jal moveDisk		# moveDisk(...)
	addi ra, t6, 0		# ra = temp
	addi t6, zero, 0	# temp = 0
	
	jalr ra			# return
	
moveDisk:
	lw t4, (s1)		# size = source.size
	slli t5, t4, 2		# bytes = size*4
	add s1, s1, t5		# source.top
	lw t3, (s1)		# temp = source
	sw zero, (s1)		# source = null
	sub s1, s1, t5		# source.bottom
	addi t4, t4, -1		# size--
	sw t4, (s1)		# guardar tamaño de source
	
	lw t4, (s3)		# size = destination.size
	addi t4, t4, 1		# size++
	slli t5, t4, 2		# bytes = size*4
	add s3, s3, t5		# destination.top
	sw t3, (s3)		# destination = temp
	sub s3, s3, t5		# destination.bottom
	sw t4, (s3)		# guardar tamaño de destination
	
	addi t3, zero, 0	# temp = 0
	addi t4, zero, 0	# size = 0
	addi t5, zero, 0	# bytes = 0
	addi a0, a0, 1		# movimientos++
	
	jalr ra			# return
	
setup:
	addi t1, s0, 1		# size = N + 1 	// to account for size in array
	slli t2, t1, 2		# bytes = size*4
	
	lui s1, 0x10010		# source = StartRAM
	add s2, s1, t2		# auxiliary = source + bytes
	add s3, s2, t2		# destiny = auxiliary + bytes
	
	addi t3, s1, 0		# temp = source
	addi t1, t1, -1		# size--
	sw t1, (t3)		# save size in source
	addi t3, t3, 4		# move to next space in array
	
setupLoop:
	beq t1, zero, endSetup	# while(size != 0)
	sw t1, (t3)		# save N in source
	addi t3, t3, 4		# move to next space in array
	addi t1, t1, -1		# N--
	jal x0, setupLoop	# loop
	
endSetup:
	addi t1, zero, 0	# limpiar t1
	addi t2, zero, 0	# limpiar t2
	addi t3, zero, 0	# limpiar t3
	
	jalr ra
	
exit:
	nop
