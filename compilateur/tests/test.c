int main() {
	int a;
	a = 5e0 + 10.0;
	int b = 12;
	const int c = -1;
	a = -a + b + 1;
	if(c >= -2) {
		if(b != 12) {
			printf(b);
		} else {
		}
		a = 42;
	} else {
		a = a;
	}
	printf(a);
	printf(3+5/2);
	return a*c;
}

