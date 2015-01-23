#include <stdlib.h>

void quicksorthybrid(int array[], int first, int last)
{
	if (last-first>9){
		int i = first;
		int j = last;
		int pivot = array[(first+last)>>1];
		while (i<j)
		{
			while ( array[i] < pivot ) ++i;
			while ( array[j] > pivot ) --j;
			if (i<j)
			{
				int temp = array[i];
				array[i] = array[j];
				array[j] = temp;
				++i;
				--j;
			}
		}

		if (first < j) quicksorthybrid(array, first, j);
		if (i < last) quicksorthybrid(array, i, last);
	} else {
		int i;
		for ( i=first; i<=last; i++ )
		{
			int j, key;
			j = i;
			key = array[j];
			while ( j>first && key<array[j-1] )
			{
				array[j] = array[j-1];
				j--;
			}
			array[j] = key;
		}
		}
}
