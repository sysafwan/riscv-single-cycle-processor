int main() {
    int a = 15;     // I type instruction -- addi
    int b = 3;      // I type instruction -- addi
    int c = a + b;  // R type instruction -- add

    
    while(1) {
        // This forces the CPU to stay in a safe loop
        // so it doesn't fetch 'x' from empty memory
    }
    return c;   // jalr instruction 
}