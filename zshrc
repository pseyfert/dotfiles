# prompt
#
# * If I open a shell in a shell in a shell, I want to see how deep I'm in.
#
# * the prompt should indicate if the previous command failed (status code)
#
# * the prompt should show the current directory in a copy&pastable manner
#   (with double click in most terminals)
#   -> white space after the end of the path
#
# currently I have it set up to:
# pseyfert@robusta ~/Downloads > ls
# <username>@<hostname> <cwd> > <commandline>
#
# the greater sign grows with $SHLVL after some offset (the topmost shell in
# the callstack defines an environment variable)

# if TOPSHLVL is not set, set it to SHLVL              
if [ ! -v TOPSHLVL ] ; then                            
  export TOPSHLVL=${SHLVL}
fi

PROMPT="%(?..%? )%(!.ROOT.%n)@%m %~ "         
for (( indent = ${TOPSHLVL} ; indent <= ${SHLVL} ; ++indent )); do PROMPT="${PROMPT}>"; done
PROMPT="${PROMPT} "       

# display time at the right end of the command line
RPROMPT="%*"
