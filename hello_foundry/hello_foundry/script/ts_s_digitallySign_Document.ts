import { ethers } from 'ethers';

// Example document content
const documentContent: string = 'Hello, world!';

// Hash the document using SHA-256
const documentHash: string = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(documentContent));

console.log('Document Hash:', documentHash);
