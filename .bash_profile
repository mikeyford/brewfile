export EDITOR="emacs"

. /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate local

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

parse_conda_env() {
    echo $CONDA_DEFAULT_ENV
}
 
export PS1="\u@\h\[\033[96m\] [\$(parse_conda_env)] \[\033[33m\]\w\[\033[00m\]\[\033[91m\]\$(parse_git_branch)\[\033[00m\] \n$ "

