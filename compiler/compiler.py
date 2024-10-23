import sys

# diccionario de registros
registers = {
    "G0": "0000",
    "G1": "0001",
    "G2": "0010",
    "G3": "0011",
    "G4": "0100",
    "G5": "0101",
    "G6": "0110",
    "G7": "0111",
    "G8": "1000",
    "G9": "1001",
    "G10": "1010",
    "G11": "1011",
    "G12": "1100",
    "SP": "1101",
    "SI": "1110", #LR
    "PC": "1111"
}

# conditional flags
cond = {
    "eq": "0000",
    "ne": "0001",
    "ge": "1010",
    "lt": "1011",
    "le": "1101",
    "al": "1110",
}

labels = {
"_start": "000000000",
"_loopImage" : "0000000004",
"_curr2x2row": "0000000008",
"_continueLoop" : "000000000C",
"_intrMatrixCalculation" : "0000000010",
"_sides"   : "0000000014",
"_interior" : "0000000018",
"_esquinas" : "000000001C",
"_matrixToImage" : "0000000020",
"_interpolationForNM" : "0000000024",
}

program_filepath = sys.argv[1]

print("[CMD] Parsing")

program_lines = []

# Leer el archivo de programa
with open(program_filepath, "r") as program_file:
    program_lines = [
        line.strip() for line in program_file.readlines()
    ]

program = []  # List to store the parsed program including labels

for line in program_lines:
    # Remove inline comments of the form //Internal documentation
    if "//" in line:
        line = line.split("//")[0].strip()

    # Skip empty lines
    if line == "":
        continue

    # Check if the line contains a label (starts with _)
    if line.startswith("_"):
        continue

    # Reemplazar comas con espacios para dividir correctamente
    line = line.replace(",", " ")
    parts = line.split()

    if len(parts) == 0:
        # Si la línea solo contiene espacios, la ignoramos
        continue

    opcode = parts[0]

    if opcode == "":
        continue

    program.append(opcode)

    # Instrucciones aritméticas
    if opcode in ["MULT", "SUST", "DIVI"]:
        # Sintaxis: Opcode, Rd, R1, R2
        if len(parts) == 4:
            program.append(parts[1])  # Registro destino (Rd)
            program.append(parts[2])  # Operando 1 (R1)
            program.append(parts[3])  # Operando 2 (R2)
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    elif opcode == "SUMA":
        # Sintaxis: Opcode, Rd, R1, R2
        if len(parts) == 4:
            program.append(parts[1])  # Registro destino (Rd)
            program.append(parts[2])  # Operando 1 (R1)
            program.append(parts[3])  # Operando 2 (R2)
        elif len(parts) == 3:
            # Opcode, Rd, Inmediato o Opcode, Rd, Dirección
            program.append(parts[1])  # Registro destino (Rd)
            program.append(parts[2])  # valor de suma
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # Instrucciones de salto
    elif opcode in ["SALT", "SMEI", "SMAI", "SYCA", "SYEN"]:
        # Sintaxis: Opcode, dirección/etiqueta
        if len(parts) == 2:
            program.append(parts[1])  # Dirección o etiqueta
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # Instrucciones de almacenamiento/carga con direcciones inmediatas o directas
    elif opcode in ["MOVE", "STOR", "LOAD"]:
        if len(parts) == 3:
            # Opcode, Rd, Inmediato o Opcode, Rd, Dirección
            program.append(parts[1])  # Registro destino (Rd)
            program.append(parts[2])  # Valor inmediato o dirección
        elif len(parts) == 4:
            # Opcode, R1, R2, Offset
            program.append(parts[1])  # Registro fuente (R1)
            program.append(parts[2])  # Registro destino (R2)
            program.append(parts[3])  # Offset
        elif len(parts) == 5:
            # Opcode, R1, R2, Registro offset
            program.append(parts[1])  # Registro fuente (R1)
            program.append(parts[2])  # Registro destino (R2)
            program.append(parts[3])  # Registro offset (Roffset)
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # Instrucciones PUSH/REST con lista de registros
    elif opcode in ["PUSH", "REST"]:
        if len(parts) > 1:
            for register in parts[1:]:
                program.append(register)  # Añadir cada registro
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # Instrucción de comparación
    elif opcode == "COMP":
        if len(parts) == 3:
            # Sintaxis: COMP, R1, R2
            program.append(parts[1])  # Registro 1 (R1)
            program.append(parts[2])  # Registro 2 (R2) o valor inmediato
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

# Print the parsed program including labels
print("Parsed Program:", program)

def encode_instruction_from_parsed(parsed_program):
    encoded_program = []

    i = 0
    while i < len(parsed_program):
        instruction = parsed_program[i]

        if instruction in ["SUMA", "SUST", "COMP", "MOVE", "DIVI", "MULT",
                           "SALT", "SYCA", "SYEN", "SMEI", "SMAI", "STOR", "LOAD", "PUSH", "REST"]:
            if instruction == "SUMA":
                # Check whether it's an immediate or register-based SUMA
                if "#" in parsed_program[i + 3]:
                    # Immediate SUMA case, e.g., SUMA G3, G3, #1
                    operands = parsed_program[i + 1:i + 4]  # Rd, Rn, #immediate
                else:
                    # Register-based SUMA, e.g., SUMA G3, G1, G4
                    operands = parsed_program[i + 1:i + 4]  # Rd, Rn, Rm

            elif instruction == "MOVE":
                # MOVE expects 2 operands (Rd, Immediate)
                operands = parsed_program[i + 1:i + 3]

            elif instruction == "COMP" or instruction == "STOR" or instruction == "LOAD":
                # COMP expects 2 operands (Rn, #Immediate)
                operands = parsed_program[i + 1:i + 3]

            elif instruction == "SUST" or instruction == "DIVI" or instruction == "MULT":
                # SUST expects 3 register operands (Rd, Rn, Rm)
                operands = parsed_program[i + 1:i + 4]

            elif instruction == "SALT" or instruction == "SYCA" or instruction == "SYEN" or instruction == "SMEI" or instruction == "SMAI":
                # Branches expects 1 operand (label or immediate)
                operands = [parsed_program[i + 1]]

            elif instruction == "PUSH" or instruction == "REST":
                # PUSH and REST expect a list of registers
                operands = parsed_program[i + 1:]
            # Handle Immediate values (convert them to integers for encoding)
            operands = [
                operand[1:] if operand.startswith("#") else operand
                for operand in operands
            ]

            # Check if operands are valid (either registers or immediates)
            valid_operands = [
                operand in registers or operand.isdigit() for operand in operands
            ]

            
            #valid_labels = [
            #    operand in labels or operand.isdigit() for operand in operands
            #]
            
            if all(valid_operands):
                encoded_instruction = encode_instruction(instruction, operands)
                if encoded_instruction:
                    encoded_program.append(encoded_instruction)
            #elif all(valid_labels):
            #    encoded_instruction = encode_instruction(instruction, operands)
            #    if encoded_instruction:
            #        encoded_program.append(encoded_instruction)
            else:
                print(f"[ERROR] Invalid operand in: {operands}")

            # Move to the next instruction (opcode + operands)
            if instruction == "MOVE":
                i += 3  # MOVE has 2 operands, so skip 3 (opcode + 2 operands)
            elif instruction == "COMP":
                i += 3 # COMP has 2 operands, so skip 2 (opcode + 1 operand)
            elif instruction == "COMP" or instruction == "STOR" or instruction == "LOAD":
                i += 3 # COMP has 2 operands, so skip 2 (opcode + 1 operand)
            elif instruction == "SALT" or instruction == "SYCA" or instruction == "SYEN" or instruction == "SMEI" or instruction == "SMAI" or instruction == "PUSH" or instruction == "REST":
                i += 2  # Branches have 1 operand, so skip 2 (opcode + 1 operand)
            else:
                i += 4  # SUMA, SUST, DIVI, MULT have 3 operands, so skip 4 (opcode + 3 operands)
        else:
            print(f"[ERROR] Unsupported instruction: {instruction}")
            i += 1  # Move to the next item

    return encoded_program


def encode_instruction(instruction, operands):
    condition = cond.get("al", "1110")

    if instruction == "SUMA":
        opcode = "0100"
        s_bit = "0"
    elif instruction == "SUST":
        opcode = "0010"
        s_bit = "0"
    elif instruction == "COMP":
        opcode = "1010"
        s_bit = "1"
    elif instruction == "MOVE":
        opcode = "1101"
        s_bit = "0"
    elif instruction == "DIVI":
        opcode = "11111011011"  # Based on UDIV encoding
        s_bit = "0"
    elif instruction == "MULT":
        opcode = "11111011011"  # Based on UDIV encoding
        s_bit = "0"
    elif instruction == "SALT":
        opcode = "11101010"
        offset = "000000000000000000000000"
    elif instruction == "SYCA":
        opcode = "11101011"
        offset = "000000000000000000000000"
    elif instruction == "SYEN":
        opcode = "11100001"
        offset = "00101111111111110001"
    elif instruction == "SMEI":
        opcode = "11011010"
        offset = "000000000000000000000000"
    elif instruction == "SMAI":
        opcode = "10101010"
        offset = "000000000000000000000000"
    elif instruction == "STOR":
        offset = "000000000000"
        ccode = "0"
    elif instruction == "LOAD":
        offset = "000000000000"
        ccode = "1"
    elif instruction == "PUSH":
        ccode = "0"
    elif instruction == "REST":
        ccode = "1"
    else:
        print(f"[ERROR] Unsupported instruction: {instruction}")
        return None

    i_bit = "0"

    # Handle operand-based instruction encoding
    Rn = registers.get(operands[0], None) if operands[0] in registers else format(int(operands[0]), '04b')
    Rd = registers.get(operands[1], None) if operands[1] in registers else format(int(operands[1]), '04b')

    if instruction == "MOVE" or instruction == "COMP":
        # MOVE and COMP have only 2 operands
        Operand2 = format(int(operands[1]), '08b') if operands[1].isdigit() else registers.get(operands[1], None)
    else:
        # SUMA, SUST, and DIVI expect 3 operands
        Operand2 = registers.get(operands[2], None) if len(operands) > 2 and operands[2] in registers else format(int(operands[2]), '08b')

    if None in [Rn, Rd]:
        print(f"[ERROR] Invalid register encoding in operands: {operands}")
        return None

    if instruction == "DIVI":
        # DIVI specific encoding (UDIV pattern)
        binary_instruction = (
            opcode + Rn + "1111" + Rd  + "1111"+ (Operand2 or "0000")# Construct the binary string for UDIV
        )
    elif instruction == "MULT":
        # DIVI specific encoding (UDIV pattern)
        binary_instruction = (
            condition + "0000000" +  s_bit + Rn + Rd  + (Operand2 or "0000") + "10010000"# Construct the binary string for UDIV
        )
    elif instruction in ["SALT", "SYCA", "SMEI", "SMAI"]:
        # Branch instructions
        binary_instruction = (
            opcode + offset
        )
    elif instruction == "SYEN":
        # Branch instructions
        binary_instruction = (
            opcode + offset + "0000"
        )
    elif instruction in ["PUSH", "REST"]:
        # PUSH and REST instructions
        binary_instruction = (
            condition + "100" + "0" + "0" + "0" + "0" + ccode + "0000" + Rn
        )
    elif instruction == "STOR" or instruction == "LOAD":
        # STOR and LOAD instructions
        binary_instruction = (
            condition + "01"  + "0" + "0" + "0" + "0" + ccode+ Rn + Rd + offset 
        )
    else:
        # For other instructions
        binary_instruction = (
            condition + "00" + i_bit + opcode + s_bit + Rn + Rd + (Operand2 or "0000")
        )

    hex_instruction = hex(int(binary_instruction, 2))[2:].zfill(8)
    
    big_endian_hex = "".join(
        reversed([hex_instruction[i:i+2] for i in range(0, len(hex_instruction), 2)])
    )
    
    return big_endian_hex



# Encode the entire parsed program
encoded_program = encode_instruction_from_parsed(program)
print("Encoded Program:", encoded_program)