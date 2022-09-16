#!/usr/bin/env bash
reset

echo " "
echo "- Compilando"

make
if [ $? -ne 0 ]; then
  echo "  - Error de compilacion"
  exit 1
fi

echo " "
echo "- Corriendo diferencias versión C vs ASM"

DIFFER="diff -d"
ERRORDIFF=0

for filter in impulse lowpass highpass bandpass deepspace
do
    ./oppenheim -f $filter -o outputs/${filter}_c.wav wavs/muestra.wav
	./oppenheim -s -f $filter -o outputs/${filter}_simd.wav wavs/muestra.wav
	
	$DIFFER outputs/${filter}_c.wav outputs/${filter}_simd.wav > /tmp/diff1
	if [ $? -ne 0 ]; then
	  echo "  - Discrepancia con el filtro ${filter}"
	  ERRORDIFF=1
	fi
done

echo " "
if [ $ERRORDIFF -eq 0 ]; then
  echo "- Todos los tests pasan"
fi
echo " "

