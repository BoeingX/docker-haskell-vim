[![Build Status](https://travis-ci.org/BoeingX/docker-haskell-vim.svg?branch=master)](https://travis-ci.org/BoeingX/docker-haskell-vim)

# What is this?

Haskell-vim is a docker-based Haskell development environment with Vim. 
It comes with syntax highlighting and code completion (powered by [ghc-mod](https://github.com/DanielG/ghc-mod)).

# Why?

Vim is a highly configurable, light-weight editor extremely suitable for programming in Haskell. 
Compare to heavy IDEs like Eclipse, one does not need to create a project etc. before writing any code.
Since the release of version 8.0, it ships an embedded terminal emulator.

ghc-mod being one of the best Haskell completion backend, it is very difficult to get it right with Vim.
For example, it currently does not support GHC 8.2 and above. 
In many GNU/Linux distributions, one can not easily install an older version of GHC along with compatible cabal or stack.

With Haskell-vim, everything just works out of box: syntax highlighting, code completion etc, 
and one can thus concentrate on learning and developing in Haskell.

# How to launch?

Run

```bash
docker run -it --rm -v <local/path/to/workdir/>:/home/haskell/workspace boeingx/haskell-vim
```

> The above command maps a local folder `<local/path/to/workdir/>` to the default work directory `/home/haskell/workspace` 
    in order to have persistent data.

# Screenshots

## Code completion

![helloworld](./docs/screenshots/helloworld.gif)

## Terminal emulator

![terminal](./docs/screenshots/factorial.gif)
