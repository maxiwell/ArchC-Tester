ArchC Tester Repository
==========================

Generating and compiling the MIPS simulator:

```bash
git submodule update --init --recursive
make
make mips
```

Running the MIPS simulator:

```bash
source env.sh
./mips.x -- /path/to/mips/binary/hello
```

