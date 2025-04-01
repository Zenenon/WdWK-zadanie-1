all: l

l: l.o
	gcc -no-pie -o l l.s

run: l
	./l

clean:
	rm -f l.o l
