define NEWLINE

endef
make:
		flex mylexer.l
		@printf "\n===================================================\n"
		@printf "          LEXER COMPILATION SUCCESSFULL           \n"
		@printf "===================================================\n\n"
		@printf "\n"
		@printf "\n---------------------------------------------------\n\n"
		bison -d -v -r all myanalyzer.y
		@printf "\n===================================================\n"
		@printf "         ANALYZER COMPILATION SUCCESSFULL           \n"
		@printf "===================================================\n\n"
		@printf "\n"
	    gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -ll
		@printf "\n===================================================\n"
		@printf "          COMPILER CREATION SUCCESSFUL             \n"
		@printf "===================================================\n\n"
		@printf "\n---------------------------------------------------\n"

clean:
		@printf "\n---------------------------------------------------\n\n"
		rm lex.yy.c
		rm myanalyzer.output
		rm myanalyzer.tab.c
		rm myanalyzer.tab.h
		rm mycompiler
		@printf "\n===================================================\n"
		@printf "          FILES REMOVED SUCCESSFULLY                \n"
		@printf "===================================================\n\n"
		@printf "\n---------------------------------------------------\n"