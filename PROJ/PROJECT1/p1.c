#include<stdio.h>

int Pos(int x) {
    if(x>0) return 1;
    else return 0;
}

int Neg(int x) {
    if (x<0) return 1;
    else return 0;
}

int Zero(int x) {
    if (x==0) return 1;
    else return 0;
}
int countArray(int A[], int numElements, int cntType) {
    int i, cnt = 0;
    for (i = numElements - 1; i >= 0; i--)
    {
        switch (cntType) {
            case 1 : cnt += Pos(A[i]); break;
            case -1: cnt += Neg(A[i]); break;
            default: 
                cnt += Zero(A[i]);
                break;
        }
    }
    return cnt;
}


int main() 
{
    int size = 21; //determine the size of the array here
    int PosCnt, NegCnt, ZeroCnt;
    int testArray[21] = { 14,-15,0,-13,-8,16,30,-38,24,0,18,14,-30,-13,-2,17,0,-27,11,-30,25};
    PosCnt = countArray(testArray, size, 1);
    NegCnt = countArray(testArray, size, -1);
    ZeroCnt = countArray(testArray, size, 0);
}
