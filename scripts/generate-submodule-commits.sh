#!/bin/sh

SUBMODULES="ocaml-sodium rpc_parallel ocaml-extlib digestif ocaml-extlib ocaml-rocksdb ppx_optcomp async_kernel coda_base58 graphql_ppx"

git submodule sync && git submodule update --init --recursive

for submod in $SUBMODULES; do
    echo "Generating commit file for" $submod
    git submodule status src/external/$submod | awk '{print $1}' > $submod.commit
done
