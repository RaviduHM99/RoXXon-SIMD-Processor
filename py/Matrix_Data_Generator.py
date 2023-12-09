import random

def generate_matrix(rows, columns, min_value, max_value):
    matrix = [[random.randint(min_value, max_value) for _ in range(columns)] for _ in range(rows)]
    return matrix

def write_matrix_to_file(matrix, filename):
    with open(filename, 'w') as file:
        for row in matrix:
            row_str = ' '.join(map(str, row))
            file.write(row_str + '\n')

def transpose_matrix(matrix):
    return [[matrix[j][i] for j in range(len(matrix))] for i in range(len(matrix[0]))]

def python_matrix_to_c(matrix):
    c_representation = "{\n"
    for row in matrix:
        c_representation += "  {"
        c_representation += ", ".join(map(str, row))
        c_representation += "},\n"
    c_representation += "};"
    return c_representation

def main():
    # Set parameters
    rows = 4
    columns = 4
    min_value = 1
    max_value = 100
    MatrixA_filename = 'MatrixA_data.txt'
    MatrixB_filename = 'MatrixB_data.txt'
    MatrixB_trans_filename = 'MatrixB_tr_data.txt'

    # Generate matrix
    matrixA = generate_matrix(rows, columns, min_value, max_value)

    # Write matrix to file
    write_matrix_to_file(matrixA, MatrixA_filename)

    print(f"Matrix A has been generated and written to '{MatrixA_filename}'.")

    # Generate matrix
    matrixB = generate_matrix(rows, columns, min_value, max_value)

    # Write matrix to file
    write_matrix_to_file(matrixB, MatrixB_filename)

    print(f"Matrix A has been generated and written to '{MatrixA_filename}'.")

    # Transpose the matrix
    transposed_matrixB = transpose_matrix(matrixB)

    # Write transposed matrix to file
    write_matrix_to_file(transposed_matrixB, MatrixB_trans_filename)
    
    print(f"Transposed Matrix B has been written to '{MatrixB_trans_filename}'.")

    c_MatrixA = python_matrix_to_c(matrixA)
    print("C Representation of Matrix A")
    print(c_MatrixA)

    c_MatrixB = python_matrix_to_c(matrixB)
    print("C Representation of Matrix B")
    print(c_MatrixB)

if __name__ == "__main__":
    main()

