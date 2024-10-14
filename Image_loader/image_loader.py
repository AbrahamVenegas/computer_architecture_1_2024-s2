from PIL import Image

def image_to_black_and_white(image_path):
    """Converts a fixed-size image to black and white and returns the pixel data."""
    # Open the image (assuming it's JPEG)
    img = Image.open(image_path)

    # Ensure the image is 400x400 pixels
    img = img.resize((400, 400))

    # Convert the image to grayscale (0-255 range)
    grayscale_img = img.convert('L')

    pixel_data = []

    # Process each pixel
    for pixel in grayscale_img.getdata():
        pixel_data.append(pixel)  # White
    
    return pixel_data, grayscale_img.size

def write_mif(pixel_data, width, height, mif_file_path):
    """Writes the pixel data into a MIF file."""
    total_pixels = width * height
    depth = 524288  # Number of words in the memory (fixed for your case)
    
    # Start writing the MIF file
    with open(mif_file_path, 'w') as mif_file:
        mif_file.write(f"WIDTH=8;\n")
        mif_file.write(f"DEPTH={depth};\n\n")
        mif_file.write(f"ADDRESS_RADIX=HEX;\n")
        mif_file.write(f"DATA_RADIX=HEX;\n\n")
        mif_file.write("CONTENT BEGIN\n")

        for address in range(min(total_pixels, depth)):
            # For each pixel, write the corresponding data value to the MIF file
            pixel_value = pixel_data[address]  # 0 or 1
            pixel_hex = f'{pixel_value:02X}'   # Convert the value to 2-digit hex
            
            mif_file.write(f"    {address:05X}  :  {pixel_hex};\n")
        
        # Fill the rest of the memory with zeros if there are not enough pixels
        if total_pixels < depth:
            for address in range(total_pixels, depth):
                mif_file.write(f"    {address:05X}  :  00;\n")

        mif_file.write("END;\n")

def main(image_path, mif_file_path):
    # Convert image to black and white and get pixel data
    pixel_data, (width, height) = image_to_black_and_white(image_path)

    # Write the data to the MIF file
    write_mif(pixel_data, width, height, mif_file_path)
if __name__ == "__main__":
    # Path to the input image and output MIF file
    image_path = input()  # Replace with your image path
    mif_file_path = "pipelined_cpu/ram_init_data.mif"
    
    # Run the main function
    main(image_path, mif_file_path)
