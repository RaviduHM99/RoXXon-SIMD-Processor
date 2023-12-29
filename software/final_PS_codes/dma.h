#ifndef DMA
#define DMA

int initialise_axi_dma ()
{
	int temp_val;
	/*
	 * Initialise MM2S
	 * MM2S_DMACR.RS = 1, MM2S_DMACR.IOC_IrqEN = 1
	 */
	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR);
	temp_val = temp_val | 0x1001;
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR, temp_val);

	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR);
	xil_printf("Value for MM2S_DMACR reg : %x \n\r", temp_val);

	/*
	 * Initialise S2MM
	 * S2MM_DMACR.RS = 1, S2MM_DMACR.IOC_IrqEN = 1
	 */
	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR + 0x30);
	temp_val = temp_val | 0x1001;
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + 0x30, temp_val);

	temp_val = Xil_In32(XPAR_AXI_DMA_0_BASEADDR + 0x30);
	xil_printf("Value for MM2S_DMACR reg : %x \n\r", temp_val);

	return 0;
}

void start_dram_read(unsigned int src_addr, unsigned int len)
{
	/*use address in the range 0x0010_0000 to 0x3FFF_FFFF*/
	xil_printf("Starting DRAM read...\n\r");
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + 0x18, src_addr);

	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + 0x28, len);
}

void start_dram_write(unsigned int dst_addr, unsigned int len)
{
	/*use address in the range 0x0010_0000 to 0x3FFF_FFFF*/
	xil_printf("Starting DRAM write...\n\r");
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + 0x48, dst_addr);

	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + 0x58, len);
}

#endif
