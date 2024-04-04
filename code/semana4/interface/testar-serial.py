import serial

# Define the serial port and parameters
ser = serial.Serial(
    port='COM19',  # Change this to your serial port
    baudrate=9600,
    bytesize=serial.EIGHTBITS,      # 8 data bits
    parity=serial.PARITY_NONE,      # No parity bit
    stopbits=serial.STOPBITS_ONE    # 1 stop bit
)
print("start")
# Read data from the serial port
while True:
    data = ser.read(1)  # Read 3 bytes (24 bits)
    # Do something with the received data
    data_int = int.from_bytes(data, byteorder='big')
    # data_bin = bin(data_int)
    data_bin = "{:08b}".format(data_int)
    print(data_int)  
    print(data_bin)

# Close the serial port
ser.close()
