# printfmt
A minimal implementation of a printf-like formatted output function written in x86-64 assembly.

## Available Specifiers
| Format              | Meaning     | Argument type    | Notes                 |
| ------------------- | ----------- | ---------------- | --------------------- |
| `%s`                  | string      | `char *`           | null-terminated       |
| `%c`                  | character   | `int` (promoted)   | only low byte used    |
| `%%`                  | literal `%`   | none             | escape                |
| `%`                   | undefined   | none             | works alone           |

| Format | Meaning   | Argument type        | Notes                      |
| ------ | --------- | -------------------- | -------------------------- |
| `%d`   | int       | `int` (32-bit)       | signed                         |
| `%ld`  | long      | `long` (64-bit)      | signed                         |
| `%lld` | long long | `long long` (64-bit) | same size as long on Linux     |

| Format                           | Meaning            | Argument type        | Notes                           |
| -------------------------------- | ------------------ | -------------------- | ------------------------------- |
| `%u`                             | unsigned int       | `unsigned int`       | 32-bit                          |
| `%ud`                            | unsigned int       | `unsigned int`       | should NOT exist in real printf |
| `%ul`                            | unsigned long      | `unsigned long`      | 64-bit                          |
| `%ull`                           | unsigned long long | `unsigned long long` | 64-bit                          |

## Usage:

```c
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
```

## License:
MIT license 
