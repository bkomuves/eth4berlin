#!/bin/bash

echo "----- compile"
rm a.out
gcc -O aes.c sha256.c rnd.c whistle.c || { echo "gcc failed!"; exit 99; }

echo "----- encrypt"
rm tmp/stdout.txt
./a.out encrypt tmp/message.dat music/01\ Any\ Shape\ -\ Tarapoto.wav tmp/encoded.wav >tmp/stdout.txt
cat tmp/stdout.txt

echo "----- extract key"
KEY=`cat tmp/stdout.txt | grep KEY | tail --bytes +7 | head --bytes 64` 
echo "KEY = $KEY"

echo "----- decrypt"
rm tmp/message.dat.decrypted
./a.out decrypt $KEY tmp/encoded.wav

echo "----- compare"
diff tmp/message.dat tmp/message.dat.decrypted
echo "----- done"
