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

def get_third_quadrant_data(grayscale_img):
    """Extracts pixel data from the third quadrant (bottom-left) of a 400x400 grayscale image."""
    width, height = grayscale_img.size
    third_quadrant_data = []

    # Loop through the third quadrant (bottom-left), which is the lower half and left half of the image
    for y in range(height // 2, height):
        for x in range(0, width // 2):
            pixel = grayscale_img.getpixel((x, y))
            third_quadrant_data.append(pixel)
    
    return third_quadrant_data

def write_mif(pixel_data, third_quadrant_data, width, height, mif_file_path):
    """Writes the pixel data into a MIF file, including the third quadrant data at the end."""
    total_pixels = width * height
    depth = 524288  # Number of words in the memory (fixed for your case)
    
    # Start writing the MIF file
    with open(mif_file_path, 'w') as mif_file:
        mif_file.write(f"WIDTH=8;\n")
        mif_file.write(f"DEPTH={depth};\n\n")
        mif_file.write(f"ADDRESS_RADIX=HEX;\n")
        mif_file.write(f"DATA_RADIX=HEX;\n\n")
        mif_file.write("CONTENT BEGIN\n")

        # Write the whole image pixel data
        for address in range(min(total_pixels, depth)):
            pixel_value = pixel_data[address]
            pixel_hex = f'{pixel_value:02X}'  # Convert the value to 2-digit hex
            mif_file.write(f"    {address:05X}  :  {pixel_hex};\n")

        # Append third quadrant data
        for address, pixel_value in enumerate(third_quadrant_data, start=total_pixels):
            if address >= depth:
                break
            pixel_hex = f'{pixel_value:02X}'
            mif_file.write(f"    {address:05X}  :  {pixel_hex};\n")

        # Fill the rest of the memory with zeros if needed
        if total_pixels + len(third_quadrant_data) < depth:
            for address in range(total_pixels + len(third_quadrant_data), depth):
                mif_file.write(f"    {address:05X}  :  00;\n")

        mif_file.write("END;\n")

def main(image_path, mif_file_path):
    # Convert image to black and white and get pixel data
    pixel_data, (width, height) = image_to_black_and_white(image_path)
    
    # Open the image again to get the third quadrant data
    grayscale_img = Image.open(image_path).resize((400, 400)).convert('L')
    third_quadrant_data = get_third_quadrant_data(grayscale_img)

    # Write the data to the MIF file
    write_mif(pixel_data, third_quadrant_data, width, height, mif_file_path)

if __name__ == "__main__":
    # Path to the input image and output MIF file
    image_path = input()  # Replace with your image path
    mif_file_path = "pipelined_cpu/ram_init_data.mif"
    
    # Run the main function
    main(image_path, mif_file_path)
