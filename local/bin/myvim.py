#!/usr/bin/python

import sys
from subprocess import call

fwdargs = []

for arg in sys.argv[1:]: # the leading argument will be myvim.py (the program name)
  if arg[0]=="-": # options will be forwarded. NB: heuristic, may fail if you use other arguments than I do
    fwdargs.append(arg)                  
  else:                                                       
    thelist = arg.split(":")
    thelist = [ x for x in thelist if x != '' ] # remove empty strings     
    fwdargs.append(thelist[0])         # forward filename
    try:
      s = int(thelist[1])
    except:
      pass
    else:
      if 3<=len(thelist): # two numbers, do the cumbersome call. no need to escape stuff with "
        try:
          s = int(thelist[2])
        except: # treat like only line number
          fwdargs.append("+"+thelist[1])
        else:
          fwdargs.append("+normal "+thelist[1]+"G"+thelist[2]+"|")
      if 2==len(thelist): # only one additional number, this will be the line
        fwdargs.append("+"+thelist[1])
    
call(['vim']+fwdargs)
