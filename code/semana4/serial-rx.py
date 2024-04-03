import serial

# Define the serial port and parameters
ser = serial.Serial(
    port='/dev/tty15',  # Change this to your serial port
    baudrate=9600,
    bytesize=serial.EIGHTBITS,      # 8 data bits
    parity=serial.PARITY_NONE,      # No parity bit
    stopbits=serial.STOPBITS_ONE    # 1 stop bit
)

# Read data from the serial port
while True:
    data = ser.read(3)  # Read 3 bytes (24 bits)
    # Do something with the received data
    print(data)  
    print(1)       # Example: Print the data

# Close the serial port
ser.close()


