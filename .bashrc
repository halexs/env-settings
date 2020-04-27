add_dir () {
    comm=${1}
    # this has to be updated for every new shell, use $SHELL variable.
    # For now though, just manually change it.
    echo "alias $comm='cd $PWD'" >> ~/.bashrc
    source ~/.bashrc
}

# Custom commands

#  vim alias are v[description of file]
alias vssh='vim ~/.ssh/config'
alias vvrc='vim ~/.vimrc'
alias vbrc='vim ~/.bashrc'

# Source files to overcome terminal
alias src='source ~/.bashrc'
#alias spy3='source ~/Work/python_env/bin/activate'

#  cd alias are in format c-[first letter]
#alias c-pl='cd /Users/ashsu/Work/playground'
#alias c-jup='cd /Users/ashsu/Work/playground/jupyter'


# Other helpful commands
alias dump_history='history >> ~/history.txt'
alias dc='docker-compose'

# Helpful commands not portable to new installs.
# alias quick_jup='docker run --rm --name jup -d -v ~/Work/playground/jupyter/data:/app/notebooks -p 20300:8888 [image name]'
#alias ui-up='c-sa; vagrant up; cd -'
#alias ui-sus='c-sa; vagrant suspend; cd -'
#alias ui-ssh='c-sa; vagrant ssh'

#export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
