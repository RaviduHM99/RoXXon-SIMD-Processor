#ifndef MATRIX
#define MATRIX

#define ROW_SIZE    8
#define COL_SIZE    8
const int data_length = ROW_SIZE*COL_SIZE*2;	/*both matrices*/

// Function to calculate the transpose of a matrix
void transposeMatrix(int rows, int cols, int matrix[rows][cols], int result[cols][rows])
{
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result[j][i] = matrix[i][j];
        }
    }
}

// Function to print a matrix
void printMatrix(int rows, int cols, int matrix[rows][cols]) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            xil_printf("%d\t", matrix[i][j]);
        }
        xil_printf("\n");
    }
}

/*function to store a matrix in DRAM*/
void store_matrix_in_dram(unsigned int rows, unsigned int cols, int matrix[rows][cols], volatile int* addr)
{
	int count = 0;
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			*(addr + count) = matrix[i][j];
			count++;
		}
	}
	xil_printf("Data stored in DRAM...\n\r");
}

#endif
