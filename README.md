1. [Latex-Devcontainer](#latex-devcontainer)
2. [What is a Dev Container?](#what-is-a-dev-container)
3. [How to Use](#how-to-use)
   - [Install](#install)
   - [File/Folder Structure](#filefolder-structure)
   - [Makefile](#makefile)
   - [Set Up](#set-up)
   - [Overrides](#overrides)

# Latex-Devcontainer

This dev container is a one-stop-shop to how I personally prefer to work with Latex. It uses a slightly modified version of [aclements/latexrun](https://github.com/aclements/latexrun) and uses biber and lualatex by default. It also sets up zsh, with my personal zsh config based on [romkatv/zsh4humans](https://github.com/romkatv/zsh4humans). It installs both toolchains and my frequently used cli tools. It also includes a Makefile (based on [gist/alexjohnj/Makefile](https://gist.github.com/alexjohnj/35fa1617ed6a21fe11f126fb906d6001)) with a watch feature that recompiles on save and optional .env-file overrides for default values. To use this add it into your latex documents workspace as .devcontainer, see below on how.  

For a full list of what this does, just look at the files, it's not a lot of code and the Dockerfile has comments, so it should be easy to understand. I may clean up the settings and extensions at some point, since I switched from using purely [Latex Workshop](https://github.com/James-Yu/LaTeX-Workshop) to a mixed approach with make. The addons should still mostly be what I want, but the settings.json contains a lot of unused configs now.

Fair warning, this is a highly customized environment. You may ask for changes or open pull requests, but chances are that I will want to keep it how I like it. Feel free to fork to your hearts content and customize however.

## What is a Dev Container?
https://code.visualstudio.com/docs/devcontainers/containers

In short, it's a Docker Image and some confiuguration for vscode to set up a container, that contains a dev environment including configurations, extensions and toolchains.

## How to use

### Install 
to set this up, if you are not using git in your Latex Project (you should to not loose your work and have versioning), just clone the repo
```bash
cd /path/to/workspace
git clone https://github.com/Alistair1231/Latex-Devcontainer.git .devcontainer
```

Otherwise, add this as a submodule:
```bash
cd /path/to/workspace-repo
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

### File/Folder structure
By default the following structure is expected, missing files and folders shouldn't cause issues but if in doubt, use per-project overrides (see below):
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
Most of these are only used for checking if the file needs to be rebuilt. So technically, as long as you set the `MAIN` value, it should re-build if you hit `Ctrl+s` (`Cmd+s` on Mac) while in your main file to update the modification time of the main file, this will always trigger a rebuild if running `make` afterwards (or while using `make watch`) even if all other files have different names. If you use this structure and change something in `partials/intro.tex` it will rebuild without you having to modify you main file first though.

### Makefile

the main `make` commands are:
- `make clean` to delete intermediary files
- `make` to compile MAIN
- `make watch` to watch for changes and auto-recompile
- `make sub` to one-off compile a sub-file like a standalone tikz diagram, this requires to specify a relative path with `WHERE`, see below

Once inside of the dev container, make a relative symlink of the Makefile into the target directory (where your main.tex lies):

When not using overrides, but changing `main.tex` to what the PDF should be called you can also run make directly like this and append all overrides.

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

#### Set up

```bash
cd /workspace
# the Makefile should be in the folder with your main.tex
ln -rs .devcontainer/misc/Makefile path/to/target/Makefile
```
I use symlinks, to always keep my Makefile up-to-date and have a single, centralized Makefile for all my projects. For project-specific changes I use variable overrides (see below)


#### Overrides
You can use a `.env` file to override the default values of the Makefile, e.g.
```bash
# create a file `.env` with two values: MAIN and BIB_FILE 
cat <<EOF > .env
MAIN=my-document
BIB_FILE=my-document.bib
EOF
```
the Makefile will source this file if it exists and override the defaults. So afterwards `make` will be equivalent to `make MAIN=my-document BIB_FILE=my-document.bib`.
