# Hashing-with-Hash-Funktion-H3

## About H3
To map a larger value range to a smaller value range, hash functions are used. In this code I implemented the hash functions of the class H3. These consist of a single hash function whose behavior is changed by a parameter (seed, start value). Depending on the seed, an array q with randomly generated numbers is accessed. The seed specifies the starting position in q. By choosing 32 other numbers in q the behaviour can be further adjusted. For seed 0, the first 32 values are derived from q used, for seed 1 the next 32, etc. The second parameter key is considered in binary representation: Each bit from the key corresponds to an entry in q. If the key is 32 bit large, q has 32 entries. If a bit of the key is set to 1, the corresponding value from q is loaded. All loaded entries are now X-or'ed, so that a single hash value is created.

## Example for Calculation of the Hash Value
q := [110, 001, 111, 101, 011, 100, 001, 000]
hq(53) = hq(00110101)

= q(0) ⊕ q(2) ⊕ q(4) ⊕ q(5)

= 110 ⊕ 111 ⊕ 011 ⊕ 100

= 110 = 6 (decimal)
