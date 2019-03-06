# The buggy version will have error message, but the fixed version will not show any error message

wget https://raw.githubusercontent.com/Programming-Systems-Lab/bug-collection/reproduce-curl-bug-script/Bugs/C/MuplayBugs/idat_too_large.png?token=Aovwu6joVwL8k2-im36A8ZMfXVvup7FXks5ciIA4wA%3D%3D -O idat_too_large.png 

git clone https://github.com/glennrp/libpng.git libpng-buggy
cd libpng-buggy/
git checkout 47aa798
autoreconf -f -i
./configure
make
./pngimage ../idat_too_large.png &> ../result_buggy.txt
cd ..

git clone https://github.com/glennrp/libpng.git libpng-fixed
cd libpng-fixed/
git checkout eb2f42a
autoreconf -f -i
./configure
make
./pngimage ../idat_too_large.png &> ../result_fixed.txt
