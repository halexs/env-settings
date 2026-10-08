# shellcheck shell=bash
# Copy to ~/.shellrc.local for machine-specific settings. It is sourced last
# by shell/rc.sh and is never tracked by git.
#
# These are the machine-specific bits that used to live in template_rc.

# pyenv
# if command -v pyenv >/dev/null 2>&1; then
#   eval "$(pyenv init -)"
#   eval "$(pyenv virtualenv-init - 2>/dev/null)"
# fi

# Vagrant based docker VM
# alias docker-ssh='cd ~/Work/docker && vagrant ssh && cd -'
# alias docker-up='cd ~/Work/docker && vagrant up && cd -'
# alias docker-halt='cd ~/Work/docker && vagrant halt && cd -'
# alias docker-suspend='cd ~/Work/docker && vagrant suspend && cd -'

# AWS
# alias daws='docker run --rm -it -v ~/.aws:/root/.aws -v "$PWD":/aws amazon/aws-cli'
# aws-reauth() { python ~/Work/docker/share/aws/aws_mfa.py --profile "$1"; }

# alias pycopy="~/.pyenv/versions/devops/bin/python ~/Work/docker/share/copy-paste.py"

# Homebrew should not see pyenv shims
# alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
