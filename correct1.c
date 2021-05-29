#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "pilib.h"



char* odd_even (int _input) {
char* ans = "Even";
char* ans2 = "Odd";
if (fmod(_input, 2) == 0) {
return ans;

} else {
return ans2;

}
};
int main() {
int ccount = 1;
int evencount = 0;
int oddcount = 0;
writeString("\nType a number : ");
int endnum = readInt();
while ( ccount <= endnum ) {
if (odd_even(ccount) == "Even") {
evencount = evencount + 1;

} else {
oddcount = oddcount + 1;

}
 ccount = ccount + 1;

}
writeString("\nEven Count : ");
writeInt(evencount);
writeString("\nOdd Count : ");
writeInt(oddcount);
}

/*Correct!*/
