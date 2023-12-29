#include <stdio.h>
#include <xil_io.h>
#include <stdlib.h>
#include "platform.h"
#include "ps7_init.h"
#include "xscugic.h"	/*interrupt controller*/
#include "xparameters.h"
#include "xil_cache.h"
#include "sleep.h"


#define DRAM_SOURCE_DATA_ADDR		0x00A00000
#define DRAM_DESTINATION_DATA_ADDR	0x00B00000

volatile int* dram_src_addr = (volatile int*)(DRAM_SOURCE_DATA_ADDR);
volatile int* dram_dst_addr = (volatile int*)(DRAM_DESTINATION_DATA_ADDR);

/*GPIO data reg*/
volatile u32 *gpio_0_data_reg = (volatile u32 *)(XPAR_AXI_GPIO_0_BASEADDR);	/*output*/
volatile u32 *gpio_1_data_reg = (volatile u32 *)(XPAR_AXI_GPIO_1_BASEADDR);	/*input*/

#include "matrix.h"
#include "interrupts.h"
#include "dma.h"

int main()
{
	init_platform();

    /*enable the PS*/
    ps7_post_config();

    /*initialise AXI DMA*/
    xil_printf("Initialising AXI DMA...\n\r");
    initialise_axi_dma();

    /*initialise interrupt system*/
    xil_printf("Enabling interrupt handling...\n\r");
    InitializeInterruptSystem(XPAR_PS7_SCUGIC_0_DEVICE_ID);

    Xil_DCacheFlush();		/*Flush the Caches*/
   	Xil_DCacheDisable();	/*Disable Data Cache*/

   	int matrix[ROW_SIZE][COL_SIZE] = {{0,5,7,5,3,0,10,1},{2,9,9,10,1,0,3,9},{10,6,1,10,4,9,8,9},{3,5,4,2,3,2,8,6},{10,10,1,6,3,5,5,8},{0,4,5,9,3,0,2,4},{8,3,8,1,2,0,9,3},{2,3,0,2,2,7,0,9}};
   	int matrix_2[ROW_SIZE][COL_SIZE] = {{3,2,8,8,0,8,10,0},{2,4,6,7,0,8,6,8},{1,3,9,5,2,2,1,7},{2,2,6,5,4,2,1,5},{1,5,1,7,4,7,6,8},{1,1,4,4,0,10,7,10},{0,1,6,1,8,7,2,8},{10,2,3,10,1,6,8,5}};
	int result_matrix[ROW_SIZE][COL_SIZE] = {{40,78,189,136,127,161,88,223},{144,113,257,274,95,208,177,262},{166,122,300,339,131,378,322,336},{92,79,179,186,98,209,162,216},{151,116,262,311,86,328,294,271},{74,74,150,161,78,119,92,172},{72,79,225,183,103,201,161,188},{115,55,103,179,25,182,173,165}};
   	int transpose[COL_SIZE][ROW_SIZE];
	int read_val = 0;


	xil_printf("Matrix 1\n\r");
	printMatrix(ROW_SIZE, COL_SIZE, matrix);

	xil_printf("Matrix 2\n\r");
	printMatrix(ROW_SIZE, COL_SIZE, matrix_2);

	transposeMatrix(ROW_SIZE, COL_SIZE, matrix_2, transpose);

	xil_printf("Data length (2 matrices): %d\n\r", data_length);

    /*store matrix in DRAM*/
    store_matrix_in_dram(ROW_SIZE, COL_SIZE, matrix, dram_src_addr);
    store_matrix_in_dram(ROW_SIZE, COL_SIZE, transpose, dram_src_addr + ROW_SIZE*COL_SIZE);

    start_dram_read(DRAM_SOURCE_DATA_ADDR, data_length*4);

    usleep(100);

    while (1) {
    	read_val = *gpio_1_data_reg;

    	if (read_val == 1 && end_status == 0) {
    	    //Xil_DCacheFlush();		/*Flush the Caches*/
    	   	//Xil_DCacheDisable();	/*Disable Data Cache*/
    		xil_printf("Matrix multiplication completed (GPIO finish received)\n\r");
    		start_dram_write(DRAM_DESTINATION_DATA_ADDR, ROW_SIZE*COL_SIZE*4);
    		xil_printf("Exit Loop 1\n\r");
    		break;
    	}
    }

    while (1) {

    	if (read_val == 1 && end_status == 1) {
    		xil_printf("Exit Loop 2. Done.\n\r");
    		break;
    	}
    }

	int count = 0;
	int error_count = 0;
	for (int i = 0; i < ROW_SIZE; i++) {
		for (int j = 0; j < COL_SIZE; j++) {
			if (*(dram_dst_addr + count) != result_matrix[i][j]) {
				error_count++;
			}
			count++;
		}
	}

	if (error_count == 0) {
		xil_printf("Matrix multiplication successful.\n\r");
	} else {
		xil_printf("Errors in matrix multiplication: %d\n\r", error_count);
	}

    cleanup_platform();
    return 0;
}
