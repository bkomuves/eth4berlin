#!/bin/bash

EXE="whistle"
MESSAGE="tmp/message2.txt"
INPUT="music/CantinaBand60.wav"
#INPUT="music/music.wav"
#INPUT="music/anyshape_mono_44khz.wav"
#INPUT="music/anyshape_stereo_22khz.wav"
OUTPUT="tmp/output.wav"
STDOUT="tmp/stdout.txt"

echo "----- compile"
rm -f $EXE
gcc -O aes.c sha256.c rnd.c whistle.c -o $EXE || { echo "gcc failed!"; exit 99; }

echo "----- encrypt"
rm -f $STDOUT
./$EXE encrypt $MESSAGE $INPUT $OUTPUT >$STDOUT
cat $STDOUT

echo "----- extract key"
KEY=`cat $STDOUT | grep KEY | tail --bytes +7 | head --bytes 64` 
echo "KEY = $KEY"

echo "----- decrypt"
rm ${MESSAGE}.decrypted
./$EXE decrypt $KEY $OUTPUT

echo "----- compare"
diff $MESSAGE ${MESSAGE}.decrypted
echo "----- done"
