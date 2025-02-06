This is highly customized and includes e.g. my zshrc. If you don't like my defaults, I recommend forking.

# How to use

## "Install"
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

## Makefile

first make a relative symlink into the target directory:

```bash
ln -rs .devcontainer/misc/Makefile path/to/target/Makefile
```

then run make:

By default the following structure is expected:
```
.
├── figures/*.{pdf,tex}
├── main.tex
├── Makefile
├── frontmatter.tex
├── sections/*.tex
├── latex.out/
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
make sub MAIN=figure-file-without-extension WHERE=figures/tikz/example
```
