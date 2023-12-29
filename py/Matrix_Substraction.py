import numpy as np

def write_matrix_to_file(matrix, filename):
    with open(filename, 'w') as file:
        for row in matrix:
            row_str = ' '.join(map(str, row))
            file.write(row_str + '\n')
            
def read_matrix_from_file(filename):
    matrix = np.loadtxt(filename)
    return matrix

def matrix_subtract(matrix1, matrix2):
    result = np.subtract(matrix1, matrix2)
    return result

def print_matrix(matrix, label):
    print(f"{label} matrix:")
    print(matrix)

def main():
    # File names
    MatrixA_filename = 'MatrixA_data.txt'
    MatrixB_filename = 'MatrixB_data.txt'
    Result_Matrix_filename = 'Result_Matrix_Subtract_data.txt'

    # Read matrices from files
    MatrixA = read_matrix_from_file(MatrixA_filename)
    MatrixB = read_matrix_from_file(MatrixB_filename)

    # Print original and transposed matrices
    print_matrix(MatrixA, "Matrix A")
    print_matrix(MatrixB, "Matrix B")

    # Perform matrix multiplication
    result_matrix = matrix_subtract(MatrixA, MatrixB)

    # Print the result
    print_matrix(result_matrix, "Result")
    
    # Write matrix to file
    write_matrix_to_file(result_matrix, Result_Matrix_filename)

    print(f"Result Matrix has been generated and written to '{Result_Matrix_filename}'.")
    
if __name__ == "__main__":
    main()
