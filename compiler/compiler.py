import sys

program_filepath = sys.argv[1]

print("[CMD] Parsing")

program_lines = []

# Leer el archivo de programa
with open(program_filepath, "r") as program_file:
    program_lines = [
        line.strip()
        for line in program_file.readlines()]

program = []
for line in program_lines:
    # Ignorar líneas vacías o comentarios
    if line == "" or line.startswith(";"):
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
    if opcode in ["SUMA", "MULT", "REST", "DIVI"]:
        # Sintaxis: Opcode, Rd, R1, R2
        if len(parts) == 4:
            program.append(parts[1])  # Registro destino (Rd)
            program.append(parts[2])  # Operando 1 (R1)
            program.append(parts[3])  # Operando 2 (R2)
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

print(program)