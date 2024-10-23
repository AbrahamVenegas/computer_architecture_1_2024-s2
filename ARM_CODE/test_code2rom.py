def bin_to_hex(input_file, output_file):
    try:
        # Open the binary file in read mode
        with open(input_file, "rb") as binary_file:
            # Read the entire binary file
            binary_data = binary_file.read()

        # Convert binary data to hexadecimal format
        hex_data = binary_data.hex()

        # Write the hexadecimal data to the output file
        with open(output_file, "w") as text_file:
            for i in range(0, len(hex_data), 2):
                text_file.write(hex_data[i:i+2] )  # Format hex as pairs of bytes
                #text_file.write("\n")  # New line after 16 bytes (32 hex digits)
        
        print(f"Hexadecimal content written to {output_file}")

    except FileNotFoundError:
        print(f"Error: The file {input_file} does not exist.")
    except IOError as e:
        print(f"Error: {e}")

# Example usage
input_file = "test"  # Replace with your compiled ARM file name
output_file = "output.text"      # Output file with hex content
bin_to_hex(input_file, output_file)
