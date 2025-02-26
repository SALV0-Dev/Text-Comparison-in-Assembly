# Text Comparison in Assembly

This project is an assembly program that compares two input text strings line by line. It checks for differences in characters and formats the output accordingly. The program demonstrates low-level string manipulation, memory addressing, and system calls in assembly language.

## Features

- Compares two text files or strings.
- Handles line-by-line comparison and identifies character-level differences.
- Supports basic string operations like checking for empty lines, case-insensitivity, and printing the result in a formatted manner.
- Utilizes system calls for output formatting and printing.
- Example of stack manipulation and register usage in assembly.

## How it Works

1. The program takes two input text strings (`file1` and `file2`).
2. It compares each character in both strings.
3. If the characters are equal, the program continues to the next character.
4. If the characters are different, the program prints out the lines where the difference occurs and outputs the result in a formatted way.

## Setup

### Prerequisites

- An assembler to compile the assembly code (e.g., [NASM](https://www.nasm.us/), [GAS](https://sourceware.org/binutils/docs/as/)).
- A Linux or macOS system for running the assembly code (since it's using system calls like `syscall`).
- Basic knowledge of x86-64 assembly and system calls.

### How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/assembly-diff-project.git
   cd assembly-diff-project
