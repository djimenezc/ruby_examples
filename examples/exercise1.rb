
# Write a program in either Ruby or JavaScript that prints out, in reverse order, every multiple of 3 between 1 and 200.

200.downto(1) { |i| puts i if i % 3 == 0 }