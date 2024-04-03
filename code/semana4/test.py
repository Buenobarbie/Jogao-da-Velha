import serial
import time
import random

# Specify the port name
port_name = '/dev/tty15'  # Change this to the port you want to use

# Define a function to simulate generating serial data
def generate_serial_data():
    # Simulate generating a 10-bit data
    data = random.randint(0, 1023)  # 10 bits data
    # Convert the data to bytes
    data_bytes = data.to_bytes(2, byteorder='big')  # Assuming 2 bytes (16 bits)
    return data_bytes

# Define the serial port and parameters
ser = serial.Serial(
    port=port_name,
    baudrate=9600,
    bytesize=serial.EIGHTBITS,      # 8 data bits
    parity=serial.PARITY_NONE,      # No parity bit
    stopbits=serial.STOPBITS_ONE    # 1 stop bit
)

# Simulate sending serial data
try:
    while True:
        # Generate simulated serial data
        data = generate_serial_data()
        # Send the data
        ser.write(data)
        # print(data)
        # Wait for a short time (simulating delay between data)
        time.sleep(1)
except KeyboardInterrupt:
    pass

# Close the serial port
ser.close()
