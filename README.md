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

```bash
make MAIN=main-file-without-extension
```