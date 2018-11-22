#!/bin/bash
for exp_code in 0 1
do
	for file in tests/validator/modules/$exp_code/*
	do
		echo "Testing module tests/validator/modules/$exp_code/$file ... "
		bin/validator-old $file
		code=$?
		if [ $code -ne $exp_code ]
		then
			echo "FAILED"
			exit 1
		fi
		echo "PASSED"
	done
done
exit 0
