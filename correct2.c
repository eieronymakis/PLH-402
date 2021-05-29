#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "pilib.h"



const double pi = 3.14;
int i , j = 9;
int z = 0;
void sort (int* _inp) {
int counter;
int counter2;
int tmp1;
int tmp2;
for (counter = z ; counter < 9 ; counter = counter + 1) {
for (counter2 = z ; counter2 < 8 ; counter2 = counter2 + 1) {
if (_inp[counter2] > _inp[counter2 + 1]) {
tmp1 = _inp[counter2];
 tmp2 = _inp[counter2 + 1];
 _inp[counter2] = tmp2;
 _inp[counter2 + 1] = tmp1;

}

}

}
writeInt(_inp[0]);
writeString(" ");
writeInt(_inp[1]);
writeString(" ");
writeInt(_inp[2]);
writeString(" ");
writeInt(_inp[3]);
writeString(" ");
writeInt(_inp[4]);
writeString(" ");
writeInt(_inp[5]);
writeString(" ");
writeInt(_inp[6]);
writeString(" ");
writeInt(_inp[7]);
writeString(" ");
writeInt(_inp[8]);
};
int main() {
int table[9];
table[0] = 1;
table[1] = 4;
table[2] = 5;
table[3] = 2;
table[4] = 7;
table[5] = 9;
table[6] = 3;
table[7] = 6;
table[8] = 24;
sort(table);
}

/*Correct!*/
