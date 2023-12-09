def instruction_binary(instruction, num_bits):
    binary_strings = [format(inst, f'0{num_bits}b') for inst in instruction] 
    ins_binary = ''.join(binary_strings)
    return ins_binary

def main():
    # Set parameters
    while (1):
        Instruction_Type = int(input("Input Instruction Type : "))
        Dimension = int(input("Input Dimension : "))
        Reset = int(input("Input Reset : "))
        PE_SEL = int(input("Input PE_SEL : "))
        PE_SEL_2x2 = int(input("Input PE_SEL_2x2 : "))
        PE_SEL_4 = int(input("Input PE_SEL_4 : "))
        ADDRESS = int(input("Input ADDRESS : "))

        Instruction1 = [ADDRESS, PE_SEL_4, PE_SEL_2x2]
        Instruction2 = [PE_SEL]
        Instruction3 = [Reset, Dimension, Instruction_Type]

        FULL_Instruction = instruction_binary([ADDRESS],17) + instruction_binary([PE_SEL_4],1) +instruction_binary([PE_SEL_2x2],1) +"0000"+ instruction_binary([PE_SEL],2) +"0"+ instruction_binary([Reset],1) + instruction_binary([Dimension],2) + instruction_binary([Instruction_Type],3)
        
        print("Full Instruction :", FULL_Instruction)

if __name__ == "__main__":
    main()
