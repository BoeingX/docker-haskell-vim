FROM haskell:8.0.1

# Vim
# Dependencies
RUN apt-get update && \
    apt-get install -yq \
        libncurses5-dev libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev \
        python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git curl && \
    rm -rf /var/lib/apt/lists/*

# Build from source
WORKDIR /tmp
RUN git clone --single-branch --depth 1 https://github.com/vim/vim.git
WORKDIR /tmp/vim
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
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim80 &&\
    make install && \
    rm -rf /vim

# Install Python 3 binding 
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    pip3 install neovim && \
    rm get-pip.py

# Create normal user
ENV USER=haskell-vim\
    UID=1000 \
    GID=100 \
    SHELL=/bin/bash

ENV HOME=/home/$USER

ENV WORKDIR=$HOME/workspace

ADD fix-permissions /usr/local/bin/fix-permissions

RUN useradd -m -s /bin/bash -N -u $UID $USER && \
    chmod g+w /etc/passwd /etc/group && \
    fix-permissions $HOME

USER $UID

# Setup work directory 
RUN mkdir $WORKDIR && fix-permissions $WORKDIR

# ghc-mod
RUN cabal update && cabal install ghc-mod && fix-permissions $HOME
ENV PATH=$HOME/.cabal/bin:$PATH

# vim-plug
RUN curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ADD vimrc $HOME/.vimrc
RUN vim +PlugInstall +qall

USER root
RUN fix-permissions $HOME

USER $USER
WORKDIR $WORKDIR
CMD ["/bin/bash"]
