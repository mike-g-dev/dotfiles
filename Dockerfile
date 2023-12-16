FROM debian:latest 

RUN apt-get update && apt-get install -y git ninja-build gettext cmake unzip curl nodejs fzf npm python3-pip
RUN git clone https://github.com/neovim/neovim.git /neovim
WORKDIR /neovim
RUN git checkout stable
RUN make CMAKE_BUILD_TYPE=Release
RUN make install

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m -s /bin/bash testuser
USER testuser

WORKDIR /home/testuser

RUN mkdir -p /home/testuser/.config/nvim

COPY nvim/.config/nvim /home/testuser/.config/nvim
