# printfmt
A minimal implementation of a printf-like formatted output function written in x86-64 assembly.

## Usage:

```c 
extern void printfmt(const char* fmt, ...); 

int main(int argc, char **argv) {
  printfmt("Raw string\n");
  printfmt("Hello, %s", "World!\n");
  printfmt("Fruits: %s, %s, %s, %s, %s, %s, %s\n", "apple", "banana", "mango", "orange", "pomegranate", "pineapple", "pear");

  return 0;
}
```

## License:
MIT license 
