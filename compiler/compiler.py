'''

Compiler for our own assembly language

'''


import sys

program_filepath = sys.argv[1]

print("[CMD] Parsing")

program_lines = []

with open(program_filepath, "r") as program_file:
    program_lines = [
        line.strip()
            for line in program_file.readlines()]

program = []
for line in program_lines:
    parts = line.split(" ")
    opcode = parts[0]

    if opcode == "":
        continue

    program.append(opcode)


    # Arithmetic instructions
    if opcode in ["SUMA", "MULT", "REST", "DIVI"]:
        # Syntax: Opcode, Rd, R1, R2
        if len(parts) == 4:
            program.append(parts[1])  # Register destination (Rd)
            program.append(parts[2])  # Operand 1 (R1)
            program.append(parts[3])  # Operand 2 (R2)
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # Branching instructions
    elif opcode in ["SALT", "SMEI", "SMAI", "SYCA", "SYEN"]:
        # Syntax: Opcode, address/label
        if len(parts) == 2:
            program.append(parts[1])  # Address or label
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # Storage/Load instructions with immediate or direct addresses
    elif opcode in ["MOVE", "STOR", "LOAD"]:
        if len(parts) == 3:
            # Opcode, Rd, Imm or Opcode, Rd, Address
            program.append(parts[1])  # Destination register (Rd)
            program.append(parts[2])  # Immediate value or address
        elif len(parts) == 4:
            # Opcode, R1, R2, Offset
            program.append(parts[1])  # Source register (R1)
            program.append(parts[2])  # Destination register (R2)
            program.append(parts[3])  # Offset
        elif len(parts) == 5:
            # Opcode, R1, R2, Roffset
            program.append(parts[1])  # Source register (R1)
            program.append(parts[2])  # Destination register (R2)
            program.append(parts[3])  # Register offset (Roffset)
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # PUSH/REST instructions (with a list of registers)
    elif opcode in ["PUSH", "REST"]:
        if len(parts) > 1:
            for register in parts[1:]:
                program.append(register)  # Append each register
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")

    # Comparison instruction
    elif opcode == "COMP":
        if len(parts) == 3:
            # Syntax: COMP, R1, R2
            program.append(parts[1])  # Register 1 (R1)
            program.append(parts[2])  # Register 2 (R2) or Immediate value
        else:
            print(f"[ERROR] Invalid syntax in line: {line}")


print(program)