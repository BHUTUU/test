#!/bin/python3
from googletrans import Translator, constants
from pprint import pprint
import sys
import getopt
source = None
lang = None
argv = sys.argv[1:]
try:
    opts, args = getopt.getopt(argv, "H:P:")
except:
    print("Error")
for opt, arg in opts:
    counter = 1
    if opt in ['-H']:
        source = arg
    elif opt in ['-P']:
        lang = arg
translator = Translator()
#source=input("Enter msg: ")
#lang=input("Enter language: ")
if (lang=='hindi'):
    outlang="hi"
elif (lang=='english'):
    outlang="en"
elif (lang=='malayalam'):
    outlang="ml"
elif (lang=="bengali" or lang=="bengoli" or lang=="bangla"):
    outlang="bn"
elif (lang=="nepali"):
    outlang="ne"
else:
    print("Undefined output language!!")
    exit()
translation = translator.translate(source, dest=outlang)
print(f"source_language: ({translation.src})\n Result:{translation.text} ({translation.dest})")
#print(f"{translation.text} ({translation.dest})")
