#NAME: Robert Griffith
#EMAIL: rwgriffithv@gmail.com
#ID: XXXXXXXXX

default: lab1b-client lab1b-server

lab1b-client: lab1b-client.c
	gcc lab1b-client.c -o $@ -lz -Wall -Wextra

lab1b-server: lab1b-server.c
	gcc lab1b-server.c -o $@ -lz -Wall -Wextra

clean:
	rm -f *.tar.gz lab1b-client lab1b-server

dist: lab1b-XXXXXXXXX.tar.gz
submission_files = README Makefile lab1b-client.c lab1b-server.c

lab1b-XXXXXXXXX.tar.gz: $(submission_files)
	tar -cvzf $@ $(submission_files)
