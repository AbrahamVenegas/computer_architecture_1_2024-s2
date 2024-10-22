 
all:
	arm-none-eabi-as src/bilinear_inerpolation.s -g -o  bilinear_interpolation.o
	arm-none-eabi-ld bilinear_interpolation.o -o build/bilinear_interpolation
	rm bilinear_interpolation.o
no_var:
	arm-none-eabi-as src/bilinear_interpolation_novar.s -g -o  bilinear_interpolation_novar.o
	arm-none-eabi-ld bilinear_interpolation_novar.o -o build/bilinear_interpolation_novar
	rm bilinear_interpolation_novar.o