def bytes_to_mif(byte_str, width=32, depth=1024):
    # Convert byte string into a list of integers
    byte_data = list(byte_str)
    
    # Ensure the data length is divisible by 4 (32 bits)
    if len(byte_data) % 4 != 0:
        byte_data += [0] * (4 - len(byte_data) % 4)
    
    mif_content = []
    
    # MIF file header
    mif_content.append("-- Copyright (C) 2020  Intel Corporation. All rights reserved.")
    mif_content.append("-- Your use of Intel Corporation's design tools, logic functions")
    mif_content.append("-- and other software and tools, and any partner logic")
    mif_content.append("-- functions, and any output files from any of the foregoing")
    mif_content.append("-- (including device programming or simulation files), and any")
    mif_content.append("-- associated documentation or information are expressly subject")
    mif_content.append("-- to the terms and conditions of the Intel Program License")
    mif_content.append("-- Subscription Agreement, the Intel Quartus Prime License Agreement,")
    mif_content.append("-- the Intel FPGA IP License Agreement, or other applicable license")
    mif_content.append("-- agreement, including, without limitation, that your use is for")
    mif_content.append("-- the sole purpose of programming logic devices manufactured by")
    mif_content.append("-- Intel and sold by Intel or its authorized distributors.  Please")
    mif_content.append("-- refer to the applicable agreement for further details, at")
    mif_content.append("-- https://fpgasoftware.intel.com/eula.\n")
    
    mif_content.append("-- Quartus Prime generated Memory Initialization File (.mif)\n")
    mif_content.append(f"WIDTH={width};")
    mif_content.append(f"DEPTH={depth};\n")
    mif_content.append("ADDRESS_RADIX=HEX;")
    mif_content.append("DATA_RADIX=HEX;\n")
    mif_content.append("CONTENT BEGIN")
    
    # Process the byte array 4 bytes at a time and convert to hex
    address = 0
    for i in range(0, len(byte_data), 4):
        # Convert 4 bytes to a 32-bit word
        word = (byte_data[i] << 24) | (byte_data[i+1] << 16) | (byte_data[i+2] << 8) | byte_data[i+3]
        # Format the address and word into a MIF line
        mif_content.append(f"\t{address:05X}  :  {word:08X};")
        address += 1
    
    mif_content.append("END;")
    
    # Write the content to a .mif file
    with open("../pipelined_cpu/rom_init_data.mif", "w") as f:
        f.write("\n".join(mif_content))

# Example byte string
byte_string = b"\xe5\x80\x10\x00\xe5\x90\x20\x00\xe5\xc0\x30\x00\xe5\xd0\x40\x00\xe5\x80\x50\x04\xe5\x90\x60\x04\xe5\xc0\x70\x01\xe5\xd0\x80\x01\xea\xff\xff\xfe" 

# Convert the byte string into a MIF file
bytes_to_mif(byte_string)
