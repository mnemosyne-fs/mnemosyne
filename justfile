alias b := build
alias d := dbuild
alias r := drun
alias sh := dsh

init:
    git clone git@github.com:mnemosyne-fs/syne.git
    git clone git@github.com:mnemosyne-fs/mnemo.git

build:
    go build -C syne -o ../out/ .
    go build -C mnemo -o ../out/ .

dbuild:
    docker build -t mnemosyne .

drun:
    docker run -it --rm --net="host" mnemosyne

dsh:
    docker run -it --rm --net="host" mnemosyne zellij
    
