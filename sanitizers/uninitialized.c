#include <stdio.h>

void func1() {
	int x = 123;
	printf("x=%d\n", x);
}

void func2() {
	int y;
	printf("y=%d\n", y);
}

int main() {
	func1();
	func2();
}
