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

  return 0;
}
