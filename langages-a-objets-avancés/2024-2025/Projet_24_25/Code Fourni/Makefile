CPP=g++ --std=c++11 -Wall

all :  
	@echo "Vous pouvez lancer"
	@echo " make ebaucheModel"
	@echo " make ebaucheVue (mais il faut avoir préalablement installé SFML)"
	@echo " make clean"

ebaucheModel : ebaucheModel.cpp
	$(CPP) ebaucheModel.cpp

ebaucheVue : ebaucheVue.cpp
	$(CPP) -c ebaucheVue.cpp
	g++ -o ebaucheVue ebaucheVue.o -lsfml-system -lsfml-graphics -lsfml-window
	./ebaucheVue

clean :
	rm *.o ebaucheVue a.out