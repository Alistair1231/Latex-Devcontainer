# for new image tags check: "https://gitlab.com/islandoftex/images/texlive/container_registry/573747?orderBy=PUBLISHED_AT&sort=desc&search[]=2025&search[]=full-doc"
FROM registry.gitlab.com/islandoftex/images/texlive:TL2024-2025-01-26-full-doc

# create a non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && \
  apt-get install -y man sudo openssh-client \
  # brew deps
  build-essential procps curl file git \ 
  # svg stuff for latex
  inkscape \
  # for make watch
  inotify-tools \
  neovim zsh tmux eza zoxide && \
  rm -rf /var/lib/apt/lists/* 

RUN groupadd --gid $USER_GID $USERNAME && \
  useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \  
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME

# gh/devmatteini/dra for easier install from github
RUN curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/devmatteini/dra/refs/heads/main/install.sh | bash -s -- --to /usr/bin/dra

# tex-fmt install from latest github release
RUN dra download --install -a WGUNDERWOOD/tex-fmt -o /usr/bin/tex-fmt

# "install" latexrun
RUN ln -s ./misc/latexrun /usr/bin/latexrun

USER $USERNAME

# uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# pygments
RUN uv tool install pygments

# set zsh as default shell
RUN sudo chsh -s $(which zsh) $USERNAME