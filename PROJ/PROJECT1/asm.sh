clang -emit-llvm p1.c -c -o p1.bc
llc p1.bc -march=mipsel -relocation-model=static -o p1.s