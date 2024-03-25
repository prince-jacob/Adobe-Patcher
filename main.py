import binascii

file_name = input("Enter the file name: ")

print(f"Processing '{file_name}'")
print("- Reading 'AutoItSC.bin'")
with open('AutoItSC.bin', 'rb') as f:
    a = f.read()

print(f"- Reading '{file_name}'")
with open(file_name, 'rb') as f:
    d = f.read()

print("Looking for the script")
pattern = binascii.unhexlify(b'A3484BBE986C4AA9994C530A86D6487D')
result = d.find(pattern)

if result != -1:
    pd = result - 16
    print(f"- Script found @ {pd:08X}")
    output_file_name = f"{file_name}.a32.exe"
    print(f"- Creating 32-bit version '{output_file_name}'")
    with open(output_file_name, 'wb') as f:
        f.write(a + d[pd:])
else:
    print("- Script not found!")
