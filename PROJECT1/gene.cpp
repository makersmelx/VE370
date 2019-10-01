#include <iostream>
using namespace std;
int main()
{
    int n;
    cin >> n;
    for (int i = 0; i < n; i++)
    {
        int tmp;
        cin >> tmp;
        cout << "addi $t0, $0, " << tmp << " # store " << i + 1 << "th temporarily in $t0"
             << "\n"
             << "sw $t0, " << 4 * i << "($sp) #store in testArray[" << i << "]\n";
    }
}