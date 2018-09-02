FROM haskell:8.4.3

# Create normal user
ENV USER=debian \
    UID=1000 \
    GID=100 \
    SHELL=/bin/bash

ENV HOME=/home/$USER

ADD fix-permissions /usr/local/bin/fix-permissions

RUN useradd -m -s /bin/bash -N -u $UID $USER && \
    chmod g+w /etc/passwd /etc/group && \
    fix-permissions $HOME

# Haskell IDE engine
RUN apt-get update && \
    apt-get install git

USER $USER
WORKDIR /tmp
RUN git clone https://github.com/haskell/haskell-ide-engine --recursive

# Use system ghc
RUN stack config set system-ghc --global true

WORKDIR /tmp/haskell-ide-engine
RUN stack build
ENV PATH=$HOME/.local/bin:$PATH
USER root

# Vim
WORKDIR /tmp

ARG VIM_VERSION=8.1.0042

RUN apt-get update && \
    apt-get install -yq \
        libncurses5-dev libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev \
        python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev \
        curl

RUN curl -L https://github.com/vim/vim/archive/v${VIM_VERSION}.tar.gz \
        --output vim-${VIM_VERSION}.tar.gz \
    && tar xvf vim-${VIM_VERSION}.tar.gz \
    && rm vim-${VIM_VERSION}.tar.gz

WORKDIR /tmp/vim-${VIM_VERSION}

RUN ./configure --with-features=huge \
			--enable-multibyte \
			--enable-rubyinterp=yes \
			--enable-python3interp=yes \
			--with-python3-config-dir="$(find /usr/lib -type d | grep 'python3.*/config')" \
			--enable-perlinterp=yes \
			--enable-luainterp=yes \
			--enable-gui=gtk2 \
			--enable-cscope \
			--prefix=/usr/local && \
    make install

# Install Python 3 binding 
WORKDIR /tmp
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    pip3 install neovim


USER $USER
# vim-plug
WORKDIR $HOME
RUN curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ADD vimrc $HOME/.vimrc
RUN vim +PlugInstall +qall >/dev/null

# Custom packages
RUN stack install hspec

# Clean up
USER root
RUN rm -rf /var/lib/apt/lists/*

# Final fix of permission
RUN fix-permissions $HOME

USER $USER

WORKDIR /workspace

CMD ["/bin/bash"]
