# Latex-Devcontainer
This dev container is a one-stop-shop to how I personally prefer to work with Latex. It uses a slightly modified version of [aclements/latexrun](https://github.com/aclements/latexrun) and uses biber and lualatex by default. It also sets up zsh, with my personal zsh config based on [romkatv/zsh4humans](https://github.com/romkatv/zsh4humans). It installs both toolchains and my frequently used cli tools. It also includes a Makefile (based on [gist/alexjohnj/Makefile](https://gist.github.com/alexjohnj/35fa1617ed6a21fe11f126fb906d6001) with an added watch feature that recompiles on save and .env file overrides for default values. To use this add it into your latex documents workspace as .devcontainer, see below on how.  

For a full list of what this does, just look at the files, it's not a lot of code and the Dockerfile has comments, so it should be easy to understand.

Fair warning, this is a highly customized environment. You may ask for changes or open pull requests, but chances are that I will want to keep it how I like it. Feel free to fork to your hearts content and customize however.

## What is a Dev Container?
https://code.visualstudio.com/docs/devcontainers/containers

In short, it's a Docker Image and some confiuguration for vscode to set up a container, that contains a dev environment including configurations, extensions and toolchains.

## How to use

to set this up, if you are not using git in your Latex Project (you should), just 
```bash
git clone https://github.com/Alistair1231/Latex-Devcontainer.git .devcontainer
```

Otherwise, add this as a submodule:
```bash
git submodule add https://github.com/Alistair1231/Latex-Devcontainer.git .devcontainer
```

when cloning your project, init all submodules:
```bash
git submodule update --init --recursive
```
to update all submodules:
```bash
git submodule foreach git pull
```

### Makefile

first make a relative symlink into the target directory:

```bash
cd /workspace
ln -rs .devcontainer/misc/Makefile path/to/target/Makefile
```

By default the following structure is expected, missing files and folders shouldn't cause issues but if in doubt use per-project overrides (see below):
```
/workspace
├── figures/*.{pdf,tex}
├── main.tex
├── Makefile
├── frontmatter.tex
├── sections/*.tex
├── latex.out/
├── .env
└── sources.bib
```

I tend to rename my main.tex to what I want the PDF to be called and then run like this.
That way I have a single, centralized Makefile for all my projects.
```bash
make MAIN=main-file-without-extension
```
to watch for changes and compile automatically:
```bash
make watch MAIN=main-file-without-extension
```

I also added `make sub` to run on a single figure file:
```bash
# this will compile
#   `./figures/tikz/example/figure-file-without-extension.tex`
#   to `./figures/tikz/example/figure-file-without-extension.pdf`
make sub MAIN=figure-file-without-extension WHERE=figures/tikz/example
```

## .env
alternatively, you can use a `.env` file to override the defaults, e.g.
```bash
# create a file `.env` with two values: MAIN and BIB_FILE 
cat <<EOF > .env
MAIN=my-document
BIB_FILE=my-document.bib
EOF
```
the Makefile will source this file if it exists and override the defaults. So afterwards `make` will be equivalent to `make MAIN=my-document BIB_FILE=my-document.bib`.
