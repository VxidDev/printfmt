extern void printfmt(const char* fmt, ...); 

int main(int argc, char **argv) {
  printfmt("Raw string\n");
  printfmt("Hello, %s", "World!\n");
  printfmt("Fruits: %s, %s, %s, %s, %s, %s, %s\n", "apple", "banana", "mango", "orange", "pomegranate", "pineapple", "pear");
  
  printfmt("Integer: %d\n", 123456789);
  printfmt("Negative Integer: %d\n", -123);
  printfmt("Integer: %d | String: %s | Integer: %d\n", 123456789, "cool string", -987654321);
  
  printfmt("Char: %c\n", 'c');
  printfmt("Chars: %c%c%c%c\n", 'c', 'h', 'a', 'r');

  printfmt("Just a percent sign: %%\n");
  printfmt("Also a percent sign: %\n");

  printfmt("Long integer: %ld\n", 10000000000l);
  printfmt("Negative long integer: %ld\n", -10000000000l);

  printfmt("Long long integer: %lld\n", 1000000000000000ll);
  printfmt("Negative long long integer: %lld\n", -1000000000000000ll);
  
  printfmt("Unsigned integer: %ud\n", 100u);
  printfmt("Unsigned integer passed as negative: %ud\n", -100u);

  printfmt("Unsigned long: %ul\n", 100000000000ul);
  printfmt("Unsigned long passed as negative: %ul\n", -1000000000000ul);

  printfmt("Unsigned long long: %ull\n", 100000000000000ull);
  printfmt("Unsigned long long passed as negative: %ull\n", -1000000000000ull);

  return 0;
}
