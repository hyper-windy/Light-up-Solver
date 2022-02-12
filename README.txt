                            LIGHT UP SOLVER
                            ===============

AUTHOR: To Thanh Phong



REQUIREMENT: 

	- SWI-Prolog.
	- GCC Compile.



RUN STEP BY STEP
****************

	- Compile "input_helper.c" and "output_helper.c" into executable files 
	  by running Makefile (Ex: "input_helper.exe" and "output_helper.c").
	- Run "input_helper.exe <test_name>.txt" in your terminal and you will 
	  see file "run_<test_name>.pl".
	- Run "swipl < run_<test_name>.pl" and solution of test case will be 
	  in folder Solution.
	- Run "output_helper.exe <test_name>.txt" and visualize solution in
	  folder Output.

Example:

	$ input_helper.exe 1.txt
	$ swipl < run_1.pl
	$ output_helper.exe 1.txt



RUN WITH PIPELINE
*****************

Note: Requirement Bash Shell and change mode of file "agent.sh" into executable mode.

	- Run "./agent.sh <test_name>.txt".
	- Tracking solution in file "tracking.txt".

Example:

	$ ./agent.sh 1.txt






