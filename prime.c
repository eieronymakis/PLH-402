#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "pilib.h"



int limit , num , counter;
int prime (int n) {
int i;
int result , isPrime;
if (n < 0) {
result = prime(-n);

} else {
if (n < 2) {
result = 0;

} else {
if (n == 2) {
result = 1;

} else {
if (fmod(n, 2) == 0) {
result = 0;

} else {
i = 3;
 isPrime = 1;
 while ( isPrime && (i < n / 2) ) {
isPrime = fmod(n, i) != 0;
 i = i + 2;

}
 result = isPrime;

}

}

}

}
return result;
};
int main() {
limit = readInt();
counter = 0;
num = 2;
while ( num <= limit ) {
if (prime(num)) {
counter = counter + 1;
 writeInt(num);
 writeString(" ");

}
 num = num + 1;

}
writeString("\n");
writeInt(counter);
}

/*Correct!*/
