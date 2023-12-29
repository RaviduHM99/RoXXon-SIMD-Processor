#ifndef INTERRUPTS
#define INTERRUPTS

XScuGic InterruptController;
static XScuGic_Config *GicConfig;

int status = 1;		/*1 after DMA read is complete*/
int end_status = 0;

void InterruptHandler_MM2S (void)
{
	xil_printf("READ_INTR : Completed data reading.\n");

	/*Interrupt for read completion from DDR*/
	u32 temp_val;

	/*clear interrupt*/
	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR + 0x04);
	temp_val = temp_val | 0x1000;
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + 0x04, temp_val);

	/*Disable read interrupt*/
	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR);
	temp_val &= ~0x1000;
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR, temp_val);

	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR);
	xil_printf("READ_INTR : Interrupt disabled (MM2S_DMACR): %x \n\r", temp_val);

	usleep(1000);

	*gpio_0_data_reg = 0x00000001;

	xil_printf("READ_INTR : Start matrix multiplication (GPIO enable sent).\n\r");
}

void InterruptHandler_S2MM (void)
{
	/*Interrupt for write completion to DDR*/
	u32 temp_val;

	/*clear interrupt*/
	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR + 0x34);
	temp_val = temp_val | 0x1000;
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + 0x34, temp_val);

	xil_printf("WRITE_INTR : Completed data writing.\n\r");

//	for (int j = 0; j < ROW_SIZE*COL_SIZE*3; j++){
//		xil_printf("%d\n", *(dram_dst_addr + j));
//	}
	xil_printf("WRITE_INTR : Result Matrix.\n\r");
	int count = 0;
	for (int i = 0; i < ROW_SIZE; i++) {
		for (int j = 0; j < COL_SIZE; j++) {
			xil_printf("%d\t", *(dram_dst_addr + count));
			count++;
		}
		xil_printf("\n");
	}
	end_status = 1;
}

int SetUpInterruptSystem(XScuGic *XScuGicInstancePtr)
{
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler,
			XScuGicInstancePtr);

	Xil_ExceptionEnable();
	return XST_SUCCESS;
}

int InitializeInterruptSystem (unsigned int deviceID) {

	int Status;

	GicConfig = XScuGic_LookupConfig(deviceID);

	if (NULL == GicConfig) {
		xil_printf("XScuGic_LookupConfig failed\n\r");
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize( &InterruptController, GicConfig, GicConfig->CpuBaseAddress);

	if (Status != XST_SUCCESS) {
		xil_printf("XScuGic_CfgInitialize failed\n\r");
		return XST_FAILURE;
	}

	Status = SetUpInterruptSystem( &InterruptController);

	if (Status != XST_SUCCESS) {
		xil_printf("SetUpInterruptSystem failed\n\r");
		return XST_FAILURE;
	}

	/*interrupt handler for S2MM. Write data to memory*/
	Status = XScuGic_Connect( &InterruptController,
		XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR,
		(Xil_ExceptionHandler) InterruptHandler_S2MM,
		NULL);

	if ( Status != XST_SUCCESS) {
		xil_printf("XScuGic_Connect failed for S2MM\n\r");
		return XST_FAILURE;
	}

	/*interrupt handler for MM2S. Read data from memory*/
	Status = XScuGic_Connect( &InterruptController,
		XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR,
		(Xil_ExceptionHandler) InterruptHandler_MM2S,
		NULL);

	if ( Status != XST_SUCCESS) {
		xil_printf("XScuGic_Connect failed for MM2S\n\r");
		return XST_FAILURE;
	}

	XScuGic_Enable( &InterruptController, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);
	XScuGic_Enable( &InterruptController, XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR);

	xil_printf("Interrupt enabling success.\n\r");

	return XST_SUCCESS;
}

#endif
