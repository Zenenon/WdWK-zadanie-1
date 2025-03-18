.data
message: .asciz "Podaj n: "
input: .asciz "%d"
output: .asciz "Wynik: %d\n"
error:  .asciz "Blad: Niepoprawne dane wejsciowe.\n"
overflow_error: .asciz "Blad: Przepelnienie!\n"
num: .long 0
result:  .long 0

.text
.global main
.extern scanf, printf

main:
    # Przygotowanie stosu
    pushq %rbp
    movq %rsp, %rbp

    # Wyswietlenie w konsoli "Podaj n: "
    leaq message(%rip), %rdi
    movq $0, %rax
    call printf

    # Pobranie n od użytkownika
    leaq input(%rip), %rdi
    leaq num(%rip), %rsi  # Adres zmiennej num
    movq $0, %rax
    call scanf

    # Sprawdzenie, czy dane poprawne
    cmpl $1, %eax
    jne error_handler

    # Wczytane wartosci
    movl num(%rip), %eax   # n
    movl %eax, %ebx            # ebx = n
    movl %eax, %ecx            # ecx = n

    # Obliczanie n^3
    imull %eax, %eax
    jo overflow_handler        # Sprawdzenie overflow

    imull %ebx, %eax           # n^3
    jo overflow_handler        # Sprawdzenie overflow

    # Obliczanie n^2
    imull %ecx, %ecx           # n * n
    jo overflow_handler        # Sprawdzenie overflow

    imull $3, %ecx             # 3 * n^2
    jo overflow_handler        # Sprawdzenie overflow

    addl %ecx, %eax            # n^3 + 3n^2
    jo overflow_handler        # Sprawdzenie overflow

    # Obliczanie  (2 * n)
    imull $2, %ebx             # 2 * n
    jo overflow_handler        # Sprawdzenie overflow

    subl %ebx, %eax            # n^3 + 3n^2 - 2n
    jo overflow_handler        # Sprawdzenie overflow

    # Wypisanie wyniku
    leaq output(%rip), %rdi
    movl %eax, %esi
    movq $0, %rax
    call printf

    # Zakonczenie programu
    movq $0, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

error_handler:
    # Wypisanie komunikatu o bledzie
    leaq error(%rip), %rdi
    movq $0, %rax
    call printf

    # Zakonczenie programu z kodem bledu 1
    movq $1, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

overflow_handler:
    # Wypisanie komunikatu o bledzie przepelnienia
    leaq overflow_error(%rip), %rdi
    movq $0, %rax
    call printf

    # Zakonczenie programu z kodem bledu 2
    movq $2, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

