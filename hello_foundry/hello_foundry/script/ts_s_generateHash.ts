// Define the SHA-256 hashing function
function sha256(ascii: string): string {
    function rightRotate(value: number, amount: number): number {
        return (value >>> amount) | (value << (32 - amount));
    }

    let words: number[] = [];
    let asciiBitLength = ascii.length * 8;

    // Convert ASCII string to array of words
    for (let i = 0; i < ascii.length; i++) {
        words[i >>> 2] |= (ascii.charCodeAt(i) & 0xff) << (24 - (i % 4) * 8);
    }

    words[ascii.length >>> 2] |= 0x80 << (24 - (ascii.length % 4) * 8);
    words[(((ascii.length + 64) >>> 9) << 4) + 15] = asciiBitLength;

    let hash: number[] = [];
    let h0 = 0x6a09e667;
    let h1 = 0xbb67ae85;
    let h2 = 0x3c6ef372;
    let h3 = 0xa54ff53a;
    let h4 = 0x510e527f;
    let h5 = 0x9b05688c;
    let h6 = 0x1f83d9ab;
    let h7 = 0x5be0cd19;

    for (let i = 0; i < words.length; i += 16) {
        let a = h0;
        let b = h1;
        let c = h2;
        let d = h3;
        let e = h4;
        let f = h5;
        let g = h6;
        let h = h7;

        for (let j = 0; j < 64; j++) {
            let temp1 = h + (rightRotate(e, 6) ^ rightRotate(e, 11) ^ rightRotate(e, 25)) + ((e & f) ^ (~e & g)) + 0x428a2f98 + words[i + (j % 16)];
            let temp2 = (rightRotate(a, 2) ^ rightRotate(a, 13) ^ rightRotate(a, 22)) + ((a & b) ^ (a & c) ^ (b & c));

            h = g;
            g = f;
            f = e;
            e = d + temp1;
            d = c;
            c = b;
            b = a;
            a = temp1 + temp2;
        }

        h0 += a;
        h1 += b;
        h2 += c;
        h3 += d;
        h4 += e;
        h5 += f;
        h6 += g;
        h7 += h;
    }

    hash.push(h0);
    hash.push(h1);
    hash.push(h2);
    hash.push(h3);
    hash.push(h4);
    hash.push(h5);
    hash.push(h6);
    hash.push(h7);

    // Convert hash to hex string
    let result = '';
    for (let i = 0; i < hash.length; i++) {
        result += ('00000000' + hash[i].toString(16)).slice(-8);
    }
    return result;
}

// Example document content
const documentContent: string = 'Hello, world!';

// Hash the document using SHA-256
const documentHash: string = sha256(documentContent);

console.log('Document Hash:', documentHash);
