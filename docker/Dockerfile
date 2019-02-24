FROM haskell:8.6.3

# Create normal user
ENV USER=haskell \
    UID=1000 \
    GID=100 \
    SHELL=/bin/bash

ENV HOME=/home/$USER

ADD fix-permissions /usr/local/bin/fix-permissions

RUN useradd -m -s /bin/bash -N -u $UID $USER \
    && chmod g+w /etc/passwd /etc/group \
    && fix-permissions $HOME

RUN apt-get update \
    && apt-get install -yq \
        libncurses5-dev libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev \
        python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev \
        curl git \
    && rm -rf /var/lib/apt/lists/* 

# Vim
USER root
WORKDIR /tmp

ARG VIM_VERSION=8.1.0042

RUN curl -L https://github.com/vim/vim/archive/v${VIM_VERSION}.tar.gz \
        --output vim-${VIM_VERSION}.tar.gz \
    && tar xvf vim-${VIM_VERSION}.tar.gz \
    && rm vim-${VIM_VERSION}.tar.gz

WORKDIR /tmp/vim-${VIM_VERSION}

RUN ./configure \
        --with-features=huge \
	    --enable-multibyte \
	    --enable-python3interp=yes \
	    --with-python3-config-dir="$(find /usr/lib -type d | grep 'python3.*/config')" \
	    --enable-gui=gtk2 \
	    --enable-cscope \
	    --prefix=/usr/local \
    && make install

# Haskell IDE engine
USER $USER
WORKDIR /tmp
RUN git clone https://github.com/haskell/haskell-ide-engine --recursive \
    && cd /tmp/haskell-ide-engine \
    && git checkout ba4882488c12c77ce06230d71db46e10170e017a \
    && stack config set system-ghc --global true \
    && make hie-8.6.3

ENV PATH=$HOME/.local/bin:$PATH

# Vim plugins
USER root
WORKDIR /tmp
COPY requirements.txt .
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    pip3 install -r requirements.txt

USER $USER
WORKDIR $HOME
ADD vimrc $HOME/.vimrc
RUN curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim +PlugInstall +qall >/dev/null

# Final fix of permission
USER root
RUN rm -rf $HOME/.stack && rm -rf $HOME/.cabal && rm -rf /tmp/vim-${VIM_VERSION} \
    && mkdir -p $HOME/workspace && fix-permissions $HOME

USER $USER
WORKDIR $HOME/workspace

CMD ["/bin/bash"]
