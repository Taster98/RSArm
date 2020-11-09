# RSA Assembly
This is an ARMv7 ASM implementation of the well known RSA cryptography algorithm. The only purpose of this project is to better learn the asm language.

## Pseudo-code
RSA is asymmetric cryptography algorithm, so it means that it works with the usage of two different keys: a <b>private key</b> which is the secret key of who wants to decrypt a received messsage, and a <b>public key</b> that is the key of the person to which we want to send the message, and it is known by everyone. Here it is the pseudocode of what i want to implement:

```
// Returns gcd of a and b 
gcd(int a, int h){ 
    while (true){ 
        temp = a%h; 
        if(temp == 0) 
          return h; 
        a = h; 
        h = temp; 
    } 
} 
  
// Code to demonstrate RSA algorithm 
main() { 
    // Two random prime numbers 
    p = 3; 
    q = 7; 
  
    // First part of public key: 
    n = p*q; 
  
    // Finding other part of public key. 
    // e stands for encrypt 
    e = 2; 
    phi = (p-1)*(q-1); 
    while (e < phi){ 
        // e must be co-prime to phi and 
        // smaller than phi. 
        if (gcd(e, phi)==1) 
            break; 
        else
            e++; 
    } 
  
    // Private key (d stands for decrypt) 
    // choosing d such that it satisfies 
    // d*e = 1 + k * totient 
    k = 2;  // A constant value 
    d = (1 + (k*phi))/e; 
  
    // Message to be encrypted 
    msg = 20; 
  
    print("Original message = " msg); 
  
    // Encryption c = (msg ^ e) % n 
    c = pow(msg, e); 
    c = fmod(c, n); 
    print("Encrypted message = " c); 
  
    // Decryption m = (c ^ d) % n 
    m = pow(c, d); 
    m = fmod(m, n); 
    print("Original Message Decrypted = " m); 
} 
```

# LICENSE

This software is completely free; <a href="LICENSE" alt="LICENSE" >see GNU General Public License.</a>