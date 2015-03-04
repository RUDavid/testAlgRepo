/*
 *   MIRACL compiler/hardware definitions - mirdef.h
 */
#define MR_LITTLE_ENDIAN
#define MIRACL 64
#define mr_utype long  //double, long?
#define MR_IBITS 32
#define MR_LBITS 64
#define mr_unsign32 unsigned int
#define mr_unsign64 unsigned long
#define MR_STRIPPED_DOWN
#define MR_ALWAYS_BINARY
#define MAXBASE ((mr_small)1<<(MIRACL-1))
#define MR_KCM 16
#define MR_BITSINCHAR 8
