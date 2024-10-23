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

# data processing intrucctions
data_instructions = {
    "SUMA": "0100",
    "COMP": "1010",
    "MOVE": "1101",
    "SUST": "0010",
    "DIVI": "1101"
}

# memory intrucctions
memory_instructions = {
    "sSTRtw": "00",
    "LDR": "01",
    "PUSH": "10",
    "POP": "11"
}

# branch intrucctions
branch_instructions = {
    "SALT": "1110",
    "SYCA": "1110",
    "SYEN": "1110",
    "SMEI": "1101",
    "SMAI": "1010"
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
        label = line.split(":")[0].strip()  # Extract label
        program.append(label)  # Save the label
        # Keep the rest of the line after the label (if there's code after the label)
        if ":" in line:
            line = line.split(":")[1].strip()

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

    # Iterate over the parsed instructions
    i = 0
    while i < len(parsed_program):
        instruction = parsed_program[i]

        if instruction in ["SUMA", "SUST", "COMP", "MOVE"]:
            # Next elements are registers/operands
            if len(parsed_program) > i + 3:
                operands = parsed_program[i + 1:i + 4]
                encoded_instruction = encode_instruction(instruction, operands)
                if encoded_instruction:
                    encoded_program.append(encoded_instruction)
                i += 4  # Move to the next instruction (opcode + 3 operands)
            else:
                print(f"[ERROR] Not enough operands for instruction {instruction}")
                i += 1  # Skip to the next instruction

        # Handle branch or other instructions similarly by adding cases here...
        
        else:
            # Unrecognized instruction
            print(f"[ERROR] Unsupported instruction: {instruction}")
            i += 1  # Move to the next item

    return encoded_program


def encode_instruction_from_parsed(parsed_program):
    encoded_program = []

    i = 0
    while i < len(parsed_program):
        instruction = parsed_program[i]

        if instruction in ["SUMA", "SUST", "COMP", "MOVE"]:
            if len(parsed_program) > i + 3:
                operands = parsed_program[i + 1:i + 4]

                # Handle Immediate values (starting with #)
                operands = [
                    operand[1:] if operand.startswith("#") else operand
                    for operand in operands
                ]

                # Check if operands are valid (either registers or immediates)
                valid_operands = [
                    operand in registers or operand.isdigit() for operand in operands
                ]

                if all(valid_operands):
                    encoded_instruction = encode_instruction(instruction, operands)
                    if encoded_instruction:
                        encoded_program.append(encoded_instruction)
                else:
                    print(f"[ERROR] Invalid operand in: {operands}")

                i += 4  # Move to the next instruction (opcode + 3 operands)
            else:
                print(f"[ERROR] Not enough operands for instruction {instruction}")
                i += 1  # Skip to the next instruction

        else:
            print(f"[ERROR] Unsupported instruction: {instruction}")
            i += 1  # Move to the next item

    return encoded_program


def encode_instruction_from_parsed(parsed_program):
    encoded_program = []

    i = 0
    while i < len(parsed_program):
        instruction = parsed_program[i]

        if instruction in ["SUMA", "SUST", "COMP", "MOVE"]:
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

            elif instruction == "COMP":
                # COMP expects 2 operands (Rn, #Immediate)
                operands = parsed_program[i + 1:i + 3]

            elif instruction == "SUST":
                # SUST expects 3 register operands (Rd, Rn, Rm)
                operands = parsed_program[i + 1:i + 4]

            # Handle Immediate values (convert them to integers for encoding)
            operands = [
                operand[1:] if operand.startswith("#") else operand
                for operand in operands
            ]

            # Check if operands are valid (either registers or immediates)
            valid_operands = [
                operand in registers or operand.isdigit() for operand in operands
            ]

            if all(valid_operands):
                encoded_instruction = encode_instruction(instruction, operands)
                if encoded_instruction:
                    encoded_program.append(encoded_instruction)
            else:
                print(f"[ERROR] Invalid operand in: {operands}")

            # Move to the next instruction (opcode + operands)
            if instruction == "MOVE":
                i += 3  # MOVE has 2 operands, so skip 3 (opcode + 2 operands)
            elif instruction == "COMP":
                i += 3 # COMP has 2 operands, so skip 2 (opcode + 1 operand)
            else:
                i += 4  # SUMA, SUST have 3 operands, so skip 4 (opcode + 3 operands)
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
        # SUMA and SUST expect 3 operands
        Operand2 = registers.get(operands[2], None) if len(operands) > 2 and operands[2] in registers else format(int(operands[2]), '08b')

    if None in [Rn, Rd]:
        print(f"[ERROR] Invalid register encoding in operands: {operands}")
        return None

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