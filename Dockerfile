FROM haskell:8.0.1

# ghc-mod
RUN cabal update && cabal install ghc-mod

# Neovim
RUN apt-get update && \
    apt-get install -yq \
        python3 \
        curl \
        git \
        libicu-dev \
        ninja-build \
        libtool \
        libtool-bin \
        autoconf \
        automake \
        cmake \
        g++ \
        pkg-config \
        unzip \
        texinfo && \
    apt-get clean
RUN git clone https://github.com/neovim/neovim.git
WORKDIR /neovim
RUN make CMAKE_BUILD_TYPE=Release && make install && rm -rf /neovim

WORKDIR /
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    pip3 install neovim && \
    rm get-pip.py
# neco-ghc
ENV HOME=/root/
RUN curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN mkdir -p $HOME/.config/nvim/
ADD init.vim $HOME/.config/nvim/init.vim
RUN nvim +PlugInstall +qall

WORKDIR /workspace
RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim
CMD ["/bin/bash"]
