export EDITOR="emacs"

. /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate local

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

get_conda_env() {
    echo $CONDA_DEFAULT_ENV
}
 
export PS1="\[\033[38;5;4m\]\u@\h \[\033[38;5;12m\][\$(get_conda_env)] \[\033[38;5;13m\]\w\[\033[00m\]\[\033[38;5;9m\]\$(parse_git_branch)\[\033[00m\] \n$ "

