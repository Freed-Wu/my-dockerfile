FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime
# FROM ubuntu:18.04
# https://hub.docker.com/r/nvidia/cuda
# bithuab's debug mode uses gtx1080ti
# cuda version which gtx1080ti supports <= 10.1
# torch version which cuda 10.1 supports <= 1.6.0

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

ARG user=wzy
ARG home=/home/$user
ARG github=https://hub.fastgit.org

# https://unix.stackexchange.com/questions/56765/creating-a-user-without-a-password/472968
RUN sed -i s/archive.ubuntu.com/mirrors.ustc.edu.cn/g /etc/apt/sources.list \
      && apt-get -y update \
      && apt-get -y install \
      openssh-server \
      sudo \
      nvidia-utils-470-server \
      zsh neovim tmux \
      git \
      && sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/' \
      /etc/ssh/sshd_config \
      && sed -i 's/^#PermitEmptyPasswords .*/PermitEmptyPasswords yes/' \
      /etc/ssh/sshd_config \
      && ssh-keygen -A \
      && useradd -ms/bin/zsh -k/dev/null -d$home -g65534 $user \
      && echo $user:U6aMy0wojraho | chpasswd -e \
      && echo root:root | chpasswd \
      && gpasswd -a$user sudo \
      && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
      && rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /var/tmp/*

USER $user
WORKDIR $home
# about zinit in docker, see <https://github.com/zdharma/zinit/issues/484>
RUN git clone --depth=1 $github/Freed-Wu/my-dotfiles . \
      && git clone --depth=1 $github/Freed-Wu/my-init.vim .config/nvim \
      && git clone --depth=1 $github/Shougo/dein.vim \
      .local/share/nvim/repos/github.com/Shougo/dein.vim \
      && git clone --depth=1 $github/zdharma-continuum/zinit \
      .zinit/plugins/zinit \
      && git clone --depth=1 $github/tmux-plugins/tpm \
      .config/tmux/plugins/tpm \
      && TERM=screen-256color TMUX= zsh -isc '@zinit-scheduler burst' \
      && .config/tmux/plugins/tpm/bin/install_plugins \
      && vi -c'call dein#update() | quit' \
      && pip install rich ptpython \
      && rm -rf .cache

# bitahub will create some directories which need root privilege
USER root
