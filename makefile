ERL_NIF_LOC=/usr/lib/erlang/erts-6.2/include
EBIN=./ebin
SRC_LOC=./src
NIF_LOC=$(SRC_LOC)/nif
C_NIF_LOC=$(SRC_LOC)/nif/c_src
PORTS_LOC=$(SRC_LOC)/ports
QS=$(SRC_LOC)/quicksort.c
SO_LOC=./c_so


all: test.beam

sort_nif.so: $(QS) $(C_NIF_LOC)/sort_nif.c c_so
	gcc -o $(SO_LOC)/sort_nif.so -I $(ERL_NIF_LOC) -fpic -shared $(QS) $(C_NIF_LOC)/sort_nif.c

sort_nif.beam: sort_nif.so $(NIF_LOC)/sort_nif.erl ebin
	erlc -o $(EBIN) $(NIF_LOC)/sort_nif.erl

ports.so: $(PORTS_LOC)/erl_comm.c $(PORTS_LOC)/port_driver.c $(QS) c_so
	gcc -o $(SO_LOC)/ports.so  $(PORTS_LOC)/erl_comm.c $(PORTS_LOC)/port_driver.c $(QS)

port_driver.beam: ebin ports.so $(PORTS_LOC)/port_driver.erl
	erlc -o $(EBIN) $(PORTS_LOC)/port_driver.erl

test.beam: sort_nif.beam port_driver.beam $(SRC_LOC)/test.erl
	erlc -o $(EBIN) $(SRC_LOC)/test.erl

clean:
	rm -r $(EBIN) $(SO_LOC)

ebin:
	mkdir -p $(EBIN)

c_so: 
	mkdir -p $(SO_LOC)

run_test: all
	erl -pa $(EBIN) -run test start -run test sort_test -run test stop -run init stop -noshell

run: all
	erl -pa $(EBIN)
